#runtime

[TOC]



#### runtime介绍

Objective-C是基于 C 的，它为 C 添加了面向对象的特性。它将很多静态语言在编译和链接时期做的事放到了 runtime 运行时来处理，可以说runtime是我们 Objective-C 幕后工作者。对于 C 语言，函数的调用在编译的时候会决定调用哪个函数。

OC的函数调用成为消息发送，属于**动态调用**过程。在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。

事实证明：在编译阶段，OC 可以调用任何函数，即使这个函数并未实现，只要声明过就不会报错，只有当运行的时候才会报错，这是因为OC是运行时动态调用的。而 C 语言调用未实现的函数就会报错。

#### runtime 消息机制

我们写 OC 代码，它在运行的时候也是转换成了runtime方式运行的。任何方法调用本质：就是发送一个消息（用runtime发送消息，OC 底层实现通过runtime实现）。

消息机制原理：对象根据方法编号SEL去映射表查找对应的方法实现。

每一个 OC 的方法，底层必然有一个与之对应的runtime方法。

####runtime 常见作用

- 动态交换两个方法的实现

- 动态添加属性

- 实现字典转模型的自动转换

- 发送消息

- 动态添加方法

- 拦截并替换方法

- 实现 NSCoding 的自动归档和解档

- runtime 常用开发应用场景「工作掌握」

- runtime 交换方法



####了解几个常用函数

1. `id object_getIvar(id obj, Ivar ivar)`

   分析： **Ivar**，即**InstanceVariable**（实例变量）。runtime对该函数的说明为：即获取一个对象**obj**的实例变量**ivar**的值。要使用这个函数，首先需要一个**Ivar**，我们使用**class_copyIvarList**函数获取一个**Ivar**数组从而获取一个**Ivar**

2. `Ivar * class_copyIvarList(Class cls, unsigned int *outCount)`

   说明：该函数的作用是获取传入类的所有实例变量，返回的是实例变量数组以UITextField类为例，代码示例如下

```objective-c
unsigned int outCount;
Ivar *ivars = class_copyIvarList([UITextField class], &outCount);

for (int i = 0; i < outCount; i++) {
    Ivar ivar = ivars[i];
}

free(ivars);
```
说明：由于ARC只适用于Foundation等框架，对于Core Foundation 和 runtime 等并不适用，所以在使用带有copy、retain等字样的函数或方法时需要手动释放free()。
获取到Ivar后可以利用 ivar_getName 函数获取 Ivar 的名称，用 ivar_getTypeEncoding 函数获取 Ivar 的类型编码，通过类型编码就可以知道该 Ivar 是何种类型的。
关于类型编码。


####成员变量(ivars)及属性

在objc_class中，所有的成员变量、属性的信息是放在链表ivars中的。ivars是一个数组，数组中每个元素是指向Ivar(变量信息)的指针。runtime提供了丰富的函数来操作这一字段。大体上可以分为以下几类

- 成员变量操作函数，主要包含以下函数：

```objective-c
// 获取类中指定名称实例成员变量的信息

Ivar class_getInstanceVariable ( Class cls, const char *name );

// 获取类成员变量的信息

Ivar class_getClassVariable ( Class cls, const char *name );

// 添加成员变量

BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types );

// 获取整个成员变量列表

Ivar * class_copyIvarList ( Class cls, unsigned int *outCount );
```

**class_getInstanceVariable**函数，它返回一个指向包含name指定的成员变量信息的objc_ivar结构体的指针(Ivar)。

**class_getClassVariable**函数，目前没有找到关于Objective-C中类变量的信息，一般认为Objective-C不支持类变量。注意，返回的列表不包含父类的成员变量和属性。

Objective-C不支持往已存在的类中添加实例变量，因此不管是系统库提供的提供的类，还是我们自定义的类，都无法动态添加成员变量。但如果我们通过运行时来创建一个类的话，又应该如何给它添加成员变量呢？这时我们就可以使用**class_addIvar**函数了。不过需要注意的是，这个方法只能在**objc_allocateClassPair**函数与**objc_registerClassPair**之间调用。另外，这个类也不能是元类。成员变量的按字节最小对齐量是1<<alignment。这取决于ivar的类型和机器的架构。如果变量的类型是指针类型，则传递log2(sizeof(pointer_type))。

**class_copyIvarList**函数，它返回一个指向成员变量信息的数组，数组中每个元素是指向该成员变量信息的objc_ivar结构体的指针。这个数组不包含在父类中声明的变量。outCount指针返回数组的大小。需要注意的是，我们必须使用free()来释放这个数组。


- 属性操作函数，主要包含以下函数：

```objective-c
// 获取指定的属性

objc_property_t class_getProperty ( Class cls, const char *name );

// 获取属性列表

objc_property_t * class_copyPropertyList ( Class cls, unsigned int *outCount );

// 为类添加属性

BOOL class_addProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );

// 替换类的属性

void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
```


####方法的操作

方法操作主要有以下函数

```objective-c
// 添加方法
BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types );

// 获取实例方法
Method class_getInstanceMethod ( Class cls, SEL name );

// 获取类方法
Method class_getClassMethod ( Class cls, SEL name );

// 获取所有方法的数组
Method * class_copyMethodList ( Class cls, unsigned int *outCount );

// 替代方法的实现
IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );

// 返回方法的具体实现
IMP class_getMethodImplementation ( Class cls, SEL name );
IMP class_getMethodImplementation_stret ( Class cls, SEL name );

// 类实例是否响应指定的selector
BOOL class_respondsToSelector ( Class cls, SEL sel );
```

解释一下SEL 和 IMP的区别
SEL : 类成员方法的指针，但不同于C语言中的函数指针，函数指针直接保存了方法的地址，但SEL只是方法编号。`SEL methodSel = @selector(eat)`

IMP:一个函数指针,保存了方法的地址

这里有两种方法获取IMP：

- `method_getImplementation(Method)`

- `methodForSelector(SEL)`

```objective-c
#import <objc/runtime.h>
- (void) temp
{
    // 第一种方法
    SEL sel = @selector(eat:);
    Method method = class_getInstanceMethod([self class], sel);
    IMP imp = method_getImplementation(method);

    // 第二种方法
    SEL sel = @selector(eat:);
    IMP imp = [self methodForSelector:sel];
}
```

####成员变量、属性的操作方法

成员变量操作包含以下函数：

```objective-c
// 获取成员变量名
const char * ivar_getName ( Ivar v );

// 获取成员变量类型编码
const char * ivar_getTypeEncoding ( Ivar v );
// 获取成员变量列表
Ivar *class_copyIvarList(Class cls, unsigned int *outCount);

```

关联对象操作函数包括以下：

```objective-c
// 设置关联对象
void objc_setAssociatedObject ( id object, const void *key, id value, objc_AssociationPolicy policy );

// 获取关联对象
id objc_getAssociatedObject ( id object, const void *key );

// 移除关联对象
void objc_removeAssociatedObjects ( id object );
```

属性操作相关函数包括以下：

```objective-c
// 获取属性名
const char * property_getName ( objc_property_t property );

// 获取属性特性描述字符串
const char * property_getAttributes ( objc_property_t property );

// 获取属性中指定的特性
char * property_copyAttributeValue ( objc_property_t property, const char *attributeName );

//获得属性列表
objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)

// 获取属性的特性列表
objc_property_attribute_t * property_copyAttributeList ( objc_property_t property, unsigned int *outCount );
```

[苹果官方文档](https://developer.apple.com/documentation/objectivec/objective_c_runtime?language=objc)

[参考简书](http://www.jianshu.com/p/6b905584f536)
