# 1、通信常用API

~~~c++
C中发送消息的三个函数：send、sendto、wirte
write (int fd, void *buf, int len);
send  (int fd, void *buf, int len, int flags);
send和write的唯一区别是最后一个参数，当设置flags为0时，send和wirte是同等的。

sendto(int fd, void *buf, int len, int flags, struct sockaddr *dst, socklen_t dstLen);
sendto一般用于UDP通信，因为UDP是无连接的，需要知道对方地址和端口号。如果需要面向连接，只需把最后两个参数设置为NULL。

C中接收消息的函数：recv、recv_from
read (int fd, void *buf, int len);
recv (int fd, void *buf, int len, int flags);
recv和read的唯一区别是最后一个参数，当设置flags为0时，recv和read是同等的。

recvfrom(int fd, void *buf, int len, int flags, struct sockaddr *src, socklen_t *srcLen);
recvfrom一般用于UDP通信，因为UDP是无连接的，需要知道对方地址和端口号。如果需要面向连接，只需把最后两个参数设置为NULL。
~~~

# 2、IO多路复用

~~~c++
void FD_SET  (int fd, fd_set* set);   // 设置文件描述符fd
void FD_CLR  (int fd, fd_set* set);   // 清除集合中的fd位，只清除一个
void FD_ISSET(int fd, fd_set* set);   // 判断文件描述符fd的设置状态
void FD_ZERO (fd_set *set);           // 清空所有文件描述符的状态

int setsockopt(int __fd, int __level, int __optname, const void *__optval, socklen_t __optlen);
~~~

# 3、win下的socket通信

~~~c++
// 地址信息
struct sockaddr_in {
	short	        sin_family;
	u_short	        sin_port;
	struct in_addr	sin_addr;
	char	        sin_zero[8];
};
// 启动win sock api
int WSAStartup(WORD wVersionRequested,LPWSADATA lpWSAData);
// 初始化socket
SOCKET socket(int af,int type,int protocol);
// 将socket与地址端口号绑定
int bind(SOCKET s,const struct sockaddr *name,int namelen);
// 使socket具备监听功能，并设置最大监听队列数量
int listen(SOCKET s,int backlog);
// 向指定socket发送数据
int send(SOCKET s,const char *buf,int len,int flags);
// 接收一个来自客户端的socket，便于服务端想客户端发送数据
SOCKET accept(SOCKET s,struct sockaddr *addr,int *addrlen);
// 第一个为文件描述符的数量，通常为最大描述符数+1,
int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, const struct timeval *timeout);
大于0，有事件发生；
等于0，timeout超时
小于0，出错
// 关闭socket
int closesocket(SOCKET s);
参考split_send模块实现多客户端连接
~~~

# 4、异步编程

~~~txt
C++11引入异步编程的三种方法，分别是std::async、std::promise、std::packaged_task
共同点：
返回值都是future，必须通过future获取异步操作的返回值。
异同点：
1、async
async简单好用，允许创建一个新线程，并可获取返回值。是一个函数模板，接受一个可调用对象，如函数、lambda表达式、函数对象等作为参数，并返回一个std::future对象。
async有三种启动策略，分别是launch::deferred(不开辟主线程)、launch::async(开辟新线程)、deferred|async(默认，由编译器决定)

2、promise
promise比较复杂，是一种更底层的机制，需要手动设置异步操作返回结果。

3、packaged_task
packaged_task处于中间，适合高度灵活的任务管理，封装任务并手动控制任务的执行场景。

*future:
future常用API接口：
std::future::get,等待异步操作完成，并获取其结果。如果异步操作未完成，调用get的线程将进入阻塞状态，且只能被调用一次。
std::future::wait,等待异步操作完成，并不获取其结果。执行该接口会阻塞当前线程，直到异步操作完成。调用wait后，future对象仍有效，且可以继续调用get获取结果。
std::future::wait_for,
std::future::wait_until
share
valid
future_status,枚举类,{ready,timeout,deferred}
~~~

# 5、Linux的socket通信

~~~c++
struct sockaddr_in
{
    __SOCKADDR_COMMON (sin_); // 这是一个宏，可组装成sin_
    in_port_t sin_port;
    struct in_addr sin_addr;
};
typedef uint32_t in_addr_t;
struct in_addr
{
    in_addr_t s_addr;
};

int main(int argc, char **argv)
{
    int lfd = socket(AF_INET, SOCK_STREAM, 0);
    int opt = 1;
    setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(int));

    struct sockaddr_in server;
    memset(&server, 0, sizeof(struct sockaddr_in));
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = htonl(INADDR_ANY);
    server.sin_port = htons(4444);

    bind(lfd, (struct sockaddr *)&server, sizeof(struct sockaddr_in));
    listen(lfd, 128);
    printf("TCP server is listening port: 4444\n");

    fd_set fdSet;
    FD_ZERO(&fdSet);
    FD_SET(lfd, &fdSet);

    while (1)
    {
        fd_set tmpSet = fdSet;
        // 监听有数据的描述符
        select(1024, &tmpSet, NULL, NULL, NULL);
        // 判断服务端套接字是否接收请求
        if (FD_ISSET(lfd, &tmpSet)) {
            struct sockaddr_in client;
            socklen_t len = sizeof(client);
            int clientfd = accept(lfd, (struct sockaddr *)&client, &len);
            // 将收到的客户端套接字加入至集合
            FD_SET(clientfd, &readfds);
            printf("[%s:%d] client fd %d connected successfully\n", inet_ntoa(client.sin_addr), ntohs(client.sin_port), clientfd);
        }

        // 遍历客户端的所有套接字
        for (int fd = lfd + 1; fd < 1024; fd++) {
            if (FD_ISSET(fd, &tmpSet)) {
                char buf[4096];
                bzero(buf, sizeof(buf));
                int ret = recv(fd, buf, sizeof(buf), 0);
                if (ret <= 0) {
                    close(fd);
                    FD_CLR(fd, &readfds);
                    printf("client fd %d has been disconnected.\n", fd);
                    continue;
                }
                // 处理接受到的数据
                handerClient(buf);
            }
        }
    }
    close(lfd);
    return 0;
}
~~~

# 6、线程

~~~txt
# 阻塞
pthread_cond_wait()
用于阻塞当前线程，等待别的线程使用pthread_cond_signal()或pthread_cond_broadcast来唤醒它。通常与pthread_mutex配套使用。
pthread_cond_wait()函数一进入wait状态就会自动release mutex

# 创建线程
pthread_create(&ptid, NULL, producer, NULL);
# 等待线程结束，并对线程资源回收
pthread_join(ptid, NULL);

pthread_mutex_init
pthread_mutex_lock
pthread_mutex_trylock
pthread_mutex_unlock
pthread_mutex_destroy
pthread_mutexattr_init
pthread_mutexattr_setpshared

pthread_attr_init
pthread_attr_setdetachstate
pthread_create
pthread_cancel
pthread_join
pthread_deatch

pthread_mutex_t
pthread_mutexattr_t
pthread_t
~~~

