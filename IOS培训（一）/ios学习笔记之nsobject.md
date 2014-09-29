##IOS学习笔记之NSObject
####From JiaYing.Cheng

---
---
NSObject是大多数Objective-C类的继承的根类；它没有父类。通过NSObject，其它类继承了一些基础的与Objective-C语言编译器系统之间的接口，并且获得了在它的实例中表现为一个对象的能力。

尽管NSObject不是一个严格的抽象类，实际上它已经是一个类。但是通过它自己一个除了表现为一个简单类之外，NSObject实际上几乎无法完成任何有用的操作。为你的程序添加任何属性（attributes）并制定实现逻辑，你必须创建一个或者多个从NSObject继承或者父类从NSObject继承的类（class）。

NSObject采用（adopts，或者说是继承实现）了NSObject协议（protocol）（见 [Root Class—and Protocol](https://www.mikeash.com/pyblog/friday-qa-2013-10-25-nsobject-the-class-and-the-protocol.html) ）。NSObject协议（protocol）允许被多个根类（root class）采用，比如NSProxy另一根类（root class），并不是从NSObject继承，但却也采用了NSObject协议（protocol）所以它在Objective-C中便有了和NSObject类相似部分的类的定义（interface）和功能。

 

NSObject根类，和采用了NSObject协议或者其它根类协议（“root” protocols）一道，为所有的非代理（non-proxy）Cocoa对象指定了以下的定义（interface）和特有的事件：

■Allocation, initialization, 和 duplication。一些NSObject方法（包括一些采用的协议）用来处理创建（creation），初始化（initialization）和复制（duplication）对象。

❏alloc和allocWithZone:方法在内存中为一个对象分配了内存空间并且设置它指向的对象的编译器类定义（即是告诉编译器定义了一个类，译者注）。

❏init方法为对象的属性初始化（prototype），一个让实例变量初始化状态的进程。类方法中的initialize和load让一个类有机会初始化它们自己。

❏new一种方便的结合分配内存和初始化的方法。

❏copy和copyWithZone:方法复制任意对象的内存的实现方法；mutableCopy和mutableCopyWithZone:将被应用于（mplemented by）该类来完成不定的对象拷贝（make mutable copies of their objects）。


■Object retention and disposa（对象的保留和释放）。接下来的方法对于面向对象的程序尤其的重要，那就是如何传统的，明确的，形式化的（traditional, and explicit, form）实现内存管理。

❏retain方法，增加对象的计数器。

❏release方法，减少对象的计数器

❏autorelease方法，自动减少对象的计数器，但是以推迟的方式来实现。

❏retainCount方法，返回一个对象当前的计数器

❏ dealloc方法应用于类来释放对象实例变量并释放动态内存。


■ Introspection 和 comparison（反省机制和对比机制）.许多NSObject方法使你能够让编译器查询一个对象。反省方法（introspection methods）帮助你探查一个对象在类继承机制中的位置，决定是否实现一些方法，并测试它是否遵循一些协议。而一些类仅是有一些方法。

❏superclass和class方法（类和实例(class and instance)）分别返回接收器的父类和类，作为一个Class对象。

❏ isKindOfClass:和isMemberOfClass:，通过这两种方法可以确定一个类的从属关系。后者测试一个接收器是否是一个指定类的实例；而后者可以测试类的从属关系。isKindOfClass判断是否是这个类或者这个类的子类的实例。isMemberOfClass判断是否是这个类的实例。

❏ respondsToSelector: 方法测试一个接收器是否通过selector实现（implements）了一个标志符话的方法。**判读实例是否有这样方法**。而instancesRespondToSelector:测试了一个给定的类实例化之后（这个消息的接收方法为**静态方法**，译者注）是否实现了一个指定的方法。判断类是否有这个方法。**此方法是类方法，不能用在类的对象**。

❏conformsToProtocol:方法，测试接收器（对象或者类）符合一个给定的协议（protocol）。

❏ isEqual: 和 hash方法，用于对象比较。

❏ description方法，允许一个对象返回一个字符串来描述它的内容；这个常用于调试debugging (“print  object”命令 ) 。通过“%@”以字符串输出特殊的指定对象。（即是以NSLog的形式输出，译者注）

■ Object encoding and decoding（对象的编码和解码）.接下来的方法将与对象的编码和解码方式有关 （作为一个归档处理的一部分）：

❏encodeWithCoder: 和 initWithCoder:方法，NSCoding协议中仅有的组成成员。第一个允许对象编译它的实例变量，第二个允许一个对象初始化它自身的解码实例变量。

❏NSObject类声明了一些与对象编码相关的其它方法，有：classForCoder，replacementObjectForCoder:，和awakeAfterUsingCoder:。

参阅Archives and Serializations Programming Guide for Cocoa来获取更多的信息。

■ Message forwarding（消息转发）. forwardInvocation:允许一个对象把消息转发给另一个对象。

■ Message dispatch（消息配送）. 一个以performSelector...为开头的方法允许你配送消息（message）直到指定的延迟后，并且可以从二级线程（(synchronously or asynchronously)同步或者不同步地）配送消息到主线程。

NSObject拥有许多其它的方法，比如版本和传递的类方法（class methods for versioning and posing）。它既包括了方法让你访问编译器数据结构的类，比如selector方法和函数指针形式的方法实现。