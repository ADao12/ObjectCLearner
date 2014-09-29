##IOS学习笔记之消息、Category、Protocol
####From JiaYing.Cheng

---
---

这篇笔记中的核心就是，面向对象思想中除了对象的状态、行为，还应该关注其并发机制、消息机制，后者更为重要。
 
Ojbective-C的语法设计主要基于Smalltalk，除了提供传统的面向对象编程特性之外，还增加了很多类似动态语言Ruby、Python才具有的特性，例如动态类型、动态加载、动态绑定等等，同时强化了消息传递机制和表意（Intention Revealing Interface）接口的概念。

---

1. 消息
---
消息传递模型（Message Passing）是Objective-C语言的核心机制。在Objective-C中，没有方法调用这种说法，只有消息传递。在C++或Java中调用某个类的方法，在Objective-C中是给该类发送一个消息。在C++或Java里，类与类的行为方法之间的关系非常紧密，一个方法必定属于一个类，且于编译时就已经绑定在一起，所以你不可能调用一个类里没有的方法。而在Objective-C中就比较简单了，类和消息之间是松耦合的，方法调用只是向某个类发送一个消息，该类可以在运行时再确定怎么处理接受到的消息。也就是说，一个类不保证一定会响应接收到的消息，如果收到了一个无法处理的消息，那么程序就是简单报一个错。甚至你可以向一个值为nil的空对象发送消息，系统都不会出错或宕掉。这种设计本身也比较符合软件的隐喻。

在表意接口（Intention Revealing Interface）方面，Objective-C也是设计的比较出色的语言。面向对象语言的特性之一就是通过API把实现封装起来，为上层建筑提供服务。但是需要注意的一点就是，你封装的API最好能够让调用者看到接口描述就知道怎么使用。如果为了使用一个API必须要去研究它的实现，那么就失去了封装的意义。Objective-C通过显式的API描述，让开发者不自觉的写出满足表意接口的API，比如下图中的API描述。

![Alt text](http://pic002.cnblogs.com/images/2012/292351/2012062123321244.jpg)

上图中描述了一个传统意义的实例方法，但和Java或C++不同的是，其方法关键字由多个字符串组成，在这个例子是insertObject和atIndex，(id)anObject和(NSUInterger)index分别表示参数类型和参数名称。整个方法看上去就像一个英语句子，我们可以很容易的知道，这个方法就是在索引为index处插入一个对象。如果你是从其他语言转到Objective-C，那么开始的时候会感觉这种写法有些繁复，但是一旦理解并习惯了你会感受到其巨大的好处，这种写法会强制你写出优美易读的代码和API，而且有了XCode强大的提示功能，再长的方法也是一蹴而就。

---

下面说说多态和继承。
 与Java一样，Objective-C一样不支持多重继承，但是通过类别（Category）和协议（Protocol）可以很好的实现代码复用和扩展。

2.Category
---
Objective-C提供了一种与众不同的方式——Category，可以动态的为已经存在的类添加新的行为。这样可以保证类的原始设计规模较小，功能增加时再逐步扩展。使用Category对类进行扩展时，不需要访问其源代码，也不需要创建子类。Category使用简单的方式，实现了类的相关方法的模块化，把不同的类方法分配到不同的分类文件中。
___
实现起来很简单，我们举例说明。

```
SomeClass.h
@interface SomeClass : NSObject{
}
-(void) print;
@end 
```
这是类`SomeClass`的声明文件，其中包含一个实例方法`print`。如果我们想在不修改原始类、不增加子类的情况下，为该类增加一个hello的方法，只需要简单的定义两个文件SomeClass+Hello.h和SomeClass+Hello.m，在声明文件和实现文件中用“()”把Category的名称括起来即可。声明文件代码如下：

```
 #import "SomeClass.h"
 
@interface SomeClass (Hello)
-(void)hello;
@end
```
实现文件代码如下

```
#import "SomeClass+Hello.h"
@implementation SomeClass (Hello)
-(void)hello{
    NSLog (@"name：%@ ", @"Jacky");
}
@end 
```
其中Hello是Category的名称，如果你用XCode创建Category，那么需要填写的内容包括名称和要扩展的类的名称。这里还有一个约定成俗的习惯，将声明文件和实现文件名称统一采用“原类名+Category”的方式命名。
调用也非常简单，毫无压力，如下：
首先引入Category的声明文件，然后正常调用即可。

```
 #import "SomeClass+Hello.h"
 
SomeClass * sc =[[SomeClass alloc] init];
[sc hello] 
```
执行结果是：

```
name：Jacky 
```
Category的使用场景：

1. 当你在定义类的时候，在某些情况下（例如需求变更），你可能想要为其中的某个或几个类中添加方法。
2. 一个类中包含了许多不同的方法需要实现，而这些方法需要不同团队的成员实现
3. 当你在使用基础类库中的类时，你可能希望这些类实现一些你需要的方法。
___
遇到以上这些需求，Category可以帮助你解决问题。当然，使用Category也有些问题需要注意:

1.  Category可以访问原始类的实例变量，但不能添加变量，如果想添加变量，可以考虑通过继承创建子类。
2. Category可以重载原始类的方法，但不推荐这么做，这么做的后果是你再也不能访问原来的方法。如果确实要重载，正确的选择是创建子类。
3. 和普通接口有所区别的是，在分类的实现文件中可以不必实现所有声明的方法，只要你不去调用它。
___
用好Category可以充分利用Objective-C的动态特性，编写出灵活简洁的代码。

---

3. Protocol
---
Protocol，简单来说就是一系列不属于任何类的方法列表，其中声明的方法可以被任何类实现。这种模式一般称为代理（delegation）模式。你通过Protocol定义各种行为，在不同的场景采用不同的实现方式。在iOS和OS X开发中，Apple采用了大量的代理模式来实现MVC中View和Controller的解耦。
 
定义Protocol很简单，在声明文件（h文件）中通过关键字@protocol定义，然后给出Protocol的名称，方法列表，然后用@end表示Protocol结束。在@end指令结束之前定义的方法，都属于这个Protocol。例如：

```
@protocol ProcessDataDelegate <NSObject>
@required
- (void) processSuccessful: (BOOL)success;

@optional
- (id) submitOrder: (NSNumber *) orderid;
@end
```

以上代码可以单独放在一个h文件中，也可以写在相关类的h文件中，可以视具体情况而定。该Protocol包含两个方法，`processSuccessful`和`submitOrder`。这里还有两个关键字，`@required`和`@optional`，表示如果要实现这个协议，那么`processSuccessful`方法是必须要实现的，`submitOrder`则是可选的，这两个注解关键字是在Objective-C 2.0之后加入的语法特性。**如果不注明**，那么方法默认是`@required`的，**必须实现**。
 
那么如何实现这个Protocol呢，很简单，创建一个普通的Objective-C类，取名为TestAppDelegate，这时会生成一个h文件和m文件。在h文件中引入包含Protocol的h文件，之后声明采用这个Protocol即可，如下：

```
@interface TestAppDelegate : NSObject<ProcessDataDelegate>;

@end
```
用尖括号（<...>）括起来的ProcessDataDelegate就是我们创建的Protocol。如果要采用多个Protocol，可以在尖括号内引入多个Protocol名称，并用逗号隔开即可。例如<ProcessDataDelegate,xxxDelegate>

m文件如下：

```
@implementation TestAppDelegate

- (void) processSuccessful: (BOOL)success{
    if (success) {
        NSLog(@"成功");
    }else {
        NSLog(@"失败");
    }
}

@end
```
由于submitOrder方法是可选的，所以我们可以只实现processSuccessful。
___
Protocol一般使用在哪些场景呢？Objective-C里的Protocol和Java语言中的接口很类似，如果一些类之间没有继承关系，但是又具备某些相同的行为，则可以使用Protocol来描述它们的关系。不同的类，可以遵守同一个Protocol，在不同的场景下注入不同的实例，实现不同的功能。其中**最常用的就是委托代理模式，Cocoa框架中大量采用了这种模式实现数据和UI的分离**。例如UIView产生的所有事件，都是通过委托的方式交给Controller完成。根据约定，框架中后缀为Delegate的都是Protocol，例如UIApplicationDelegate，UIWebViewDelegate等，使用时大家可以留意一下，体会其用法。
 
使用Protocol时还需要注意的是：

1. Protocol本身是可以继承的，比如：

	```
	@protocol A
    	 -(void)methodA;
	@end
	@protocol B <A>
    	 -(void)methodB;
	@end
	```
	如果你要实现B，那么methodA和methodB都需要实现。 
2. Protocol是类无关的，任何类都可以实现定义好的Protocol。如果我们想知道某个类是否实现了某个Protocol，还可以使用conformsToProtocol进行判断，如下：
	
	```
	[obj conformsToProtocol:@protocol(ProcessDataDelegate)] 
	```

---

4. Category和Protocol区别
---
这两个都是mac下的协议，用法有点像C++中的函数重载和虚函数。
___
* Category: 
	1. 它可以给原有的类增加新的方法，而不用重新建一个类，然后在原有的类的基础上使用这个方法，但是不能给类增加新的数据成员。
	2. 每一个Category都有自己新增的方法，但是你只需要实现你自己要用的方法。
* Protocol:
	1. 一系列不属于任何类的方法列表.
	2. 相当于C++中父类定义的纯虚函数，子类必须实现这些纯虚函数。但是protocol机制不需要继承，只需要声明某个协议，再实现它。
___
此外，

```
Category机制被称为非正式协议(informal)，而Protocol机制被称为正式协议(formal)。
```