##IOS学习笔记之了解CoreFoundation和Foundation的区别

---
---
Core Foundation框架 (CoreFoundation.framework) 是一组C语言接口，它们为iOS应用程序提供基本数据管理和服务功能。

群体数据类型 (数组、集合等)   
程序包   
字符串管理    
日期和时间管理    
原始数据块管理    
偏好管理   
URL及数据流操作   
线程和RunLoop   
端口和soket通讯    

Core Foundation框架和Foundation框架紧密相关，它们为相同功能提供接口，但Foundation框架提供Objective-C接口。如果您将Foundation对象和Core Foundation类型掺杂使用，则可利用两个框架之间的 “toll-free bridging”。所谓的Toll-free bridging是说您可以在某个框架的方法或函数同时使用Core Foundatio和Foundation 框架中的某些类型。很多数据类型支持这一特性，其中包括群体和字符串数据类型。每个框架的类和类型描述都会对某个对象是否为 toll-free bridged，应和什么对象桥接进行说明。