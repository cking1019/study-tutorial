# 1、全局API

## 1.1、应用实例

~~~vue
createApp()
createSSRApp()
app.mount()
app.unmount()
app.provide()
app.component()
app.directive()
app.use()
app.mixin()
app.version
app.config
app.config.errorHandler
app.config.warnHandler
app.config.performance
app.config.compilerOptions
app.config.globalProperties
app.config.optionMergeStrategies
~~~

## 1.2、通用

~~~vue
version
nextTick()
defineComponent()
defineAsyncComponent()
defineCustiomElement()
~~~

# 2、组合式API

## 2.1、setup()

## 2.2、响应式：核心

~~~vue
ref()
computed()
reactive()
readonly()
watchEffect()
watchPostEffect()
watchSyncEffect()
watch()
~~~

## 2.3、响应式：工具

~~~vue
isRef()
unref()
toRef()
toRefs()
isProxy()
isReactive()
isReadonly()
~~~

## 2.4、响应式：进阶

~~~vue
shallowRef()
triggerRef()
customRef()
shallowReactive()
shallowReadonly()
toRaw()
markRaw()
effectScope()
getCurrentScope()
onScopeDispose()
~~~

## 2.5、生命周期钩子

~~~vue
onMounted()
onUpdated()
onUnmounted()
onBeforeMount()
onBeforeUpdate()
onBeforeUnmount()
onErrorCaptured()
onRenderTracked()
onRenderTriggered()
onActivated()
onDeactivated()
onServerPrefetch()
~~~

## 2.6、依赖注入

~~~vue
provide()
inject()
~~~

# 3、选项式API

## 3.1、状态选项

~~~vue
data()
props
computed
methods
watch
emits
expose
~~~

## 3.2、渲染选项

~~~vue
template
render
compilerOptions
~~~

## 3.3、生命周期选项

~~~vue
beforeCreate
created
beforeMount
mounted()
beforeUpdate
updated
beforeUnmount
unmounted
errorCaptured
renderTracker
renderTriggered
activated
deactivated
serverPrefetch
~~~

## 3.4、其他选项

~~~vue
name
inheritAttrs
components
directives
~~~

## 3.5、组件实例

~~~vue
$data
$props
$el
$options
$parent
$root
$slots
$refs
$attrs
$watch()
$emit()
$forceUpdate()
$nextTick()  # 和全局版本的 nextTick() 的唯一区别就是组件传递给 this.$nextTick() 的回调函数会带上 this 上下文，其绑定了当前组件实例。
~~~

# 4、内置内容

## 4.1、指令

~~~vue
v-text
v-html
v-show
v-if: 判断指令
v-else
v-else-if
v-for: 循环指令
v-on: 可使用'@'表示
v-bind: 可使用':'表示
v-model
v-slot
v-once
v-memo
v-cloak
~~~

## 4.2、组件

~~~vue
<Transition>
<TransitionGroup>
<KeepAlive>
<Teleport>
<Suspense>
~~~

## 4.3、特殊元素

~~~vue
<compenent>
<slot>
<template>
~~~

## 4.4、特殊Attributes

~~~vue
key
ref
is
~~~

# 5、单文件组件


# 6、进阶API

## 6.1、渲染函数

~~~vue
h()
mergeProps()
cloneVNode()
isVNode()
resolveComponent()
resolveDirective()
withDirectives()
withModifiers()
~~~

## 6.2、服务端渲染

~~~vue
renderToString()
renderToNodeStream()
pipeToNodeWritable()
renderToWebStream()
pipeToWebWritable()
renderToSimpleStream()
useSSRContext()
~~~

## 6.3、TypeScript工具类型

~~~vue
PropType
ComponentCustomProperties
ComponentCustomOptions
ComponentCustomProps
CSSProperties
~~~

## 6.4、自定义渲染

~~~vue
createRenderer()
~~~

