##IOS学习笔记之NSZone
####From JiaYing.Cheng

---
---

文章未尾是对NSZone的作用的原文解释。在此作一些阅读理解：   
 
- 大意上是说NSZone是Apple用来分配和释放内存的一种方式，它不是一个对象，而是使用C结构存储了关于对象的内存管理的信息。基本上开发者是不需要去理会这个东西的，cocoa Application使用一个系统默认的NSZone来对应用的对象进行管理。那么在什么时候你会想要有一个自己控制的NSZone呢？当默认的NSZone里面管理了大量的对象的时候。这种时候，大量对象的释放可能会导致内存严重碎片化，cocoa本身有做过优化，每次alloc的时候会试图去填满内存的空隙，但是这样做的话时间的开销很大。于是乎，你可以自己创建一个NSZone，这样当你有大量的alloc请求的时候就全部转移到指定的NSZone里面去，减少了大量的时间开销。而且，使用NSZone还可以一口气把你创建的zone里面的东西都清除掉，省掉了大量的时间去一个个dealloc对象。 
    
- 简单来说，可以想象成一个内存池，alloc或是dealloc这些操作，都是在这个内存池中操作的。cocoa总是会配置一个默认的NSZone，任何默认的内存操作都是在这个“zone”上操作的。默认的NSZone的缺陷在于，它是全局范围的，时间一长，必然会导致内存的碎片化，如果你需要大量的alloc一些object，那么性能就会受到一些影响。

- 或者说，NSZone决定了对象开辟在哪个空间，并没有包含对象结构之类的特殊信息。使用得当的话，它能帮助你节省一部分分配和销毁内存的时间。所有cocoa提供方法，你可以自己生成一个NSZone，并将alloc, copy全部限制在这个”zone“之内。

不过另一篇2002年的文章就说开发者已经不能创建一个真正的NSZone了（看来也许这就是历史原因了），只能创建main zone的一个child zone。文章在这里：http://www.cocoabuilder.com/archive/cocoa/65056-what-an-nszone.html#65056 Timothy J.wood 的回答。

---
不过，另一篇2002年的文章就说开发者已经不能创建一个真正的NSZone了（看来也许这就是历史原因了），只能创建main zone的一个child zone。文章在这里：[Timothy J.wood 的回答](http://www.cocoabuilder.com/archive/cocoa/65056-what-an-nszone.html#65056)。

Timothy还讲到如果可以使用NSZone的话，多个对象在同一时间alloc可以减少分页使用，而且在同一个时间dealloc可以减少内存碎片。想必后来Apple在这方面是做了处理了，对开发者透明，无需开发者自己去做。

---
---
原文：

```
NSZone is Apple's way of optimizing object allocation and freeing. NSZone is not an object; it is an opaque C-struct storing information about how memory should be handled for a set of objects.
One rarely needs to worry about handling your own zones in applications; Cocoa handles it transparently. A default NSZone is created on startup and all objects default to being allocated there. So why would you want to use your own?
If you are mass-allocating hundreds of cheap objects, you may find the cost of actually allocating space for them becomes significant. Because the standard zone is used all the time, it can become very patchy; deleted objects can leave awkward gaps throughout memory. The allocator for the standard NSZone knows this, and it tries to fill these gaps in preference to grabbing more memory off the system, but this can be costly in time if the zone has grown quite large.
If you want to mass-allocate objects, then, you can create your own zone and tell it not to bother with finding gaps to put new objects in. The allocator can now jump to the end of its allotted memory each time and quickly assign memory to your new objects, saving a lot of effort.
Allocators can save you time elsewhere, too, as asking the OS for more memory, which a zone needs to do whenever it fills up, is another costly operation if it's done a lot. Much quicker is to ask for huge chunks of memory at a time, and you can tell your NSZone what to do here as well.
Rumor has it that NSZone could save you deallocation time in the Good Old Days, too, with a method that simply chucks away all the allotted memory without bothering to call deallocators. If a set of objects is self-contained, this could save a lot of time, as you can chuck them all away at once without tediously deallocating them all. Alas, there appears to be no sign of this godsend in the current documentation; the single NSZone method (NSRecycleZone) carefully puts all the objects in a zone neatly on the default NSZone. Not exactly a huge time-saver.
So, in summary, zones save you time in mass allocations. But only if programmers know how to use them!NSZone is Apple's way of optimizing object allocation and freeing. NSZone is not an object; it is an opaque C-struct storing information about how memory should be handled for a set of objects.
One rarely needs to worry about handling your own zones in applications; Cocoa handles it transparently. A default NSZone is created on startup and all objects default to being allocated there. So why would you want to use your own?
If you are mass-allocating hundreds of cheap objects, you may find the cost of actually allocating space for them becomes significant. Because the standard zone is used all the time, it can become very patchy; deleted objects can leave awkward gaps throughout memory. The allocator for the standard NSZone knows this, and it tries to fill these gaps in preference to grabbing more memory off the system, but this can be costly in time if the zone has grown quite large.
If you want to mass-allocate objects, then, you can create your own zone and tell it not to bother with finding gaps to put new objects in. The allocator can now jump to the end of its allotted memory each time and quickly assign memory to your new objects, saving a lot of effort.
Allocators can save you time elsewhere, too, as asking the OS for more memory, which a zone needs to do whenever it fills up, is another costly operation if it's done a lot. Much quicker is to ask for huge chunks of memory at a time, and you can tell your NSZone what to do here as well.
Rumor has it that NSZone could save you deallocation time in the Good Old Days, too, with a method that simply chucks away all the allotted memory without bothering to call deallocators. If a set of objects is self-contained, this could save a lot of time, as you can chuck them all away at once without tediously deallocating them all. Alas, there appears to be no sign of this godsend in the current documentation; the single NSZone method (NSRecycleZone) carefully puts all the objects in a zone neatly on the default NSZone. Not exactly a huge time-saver.
So, in summary, zones save you time in mass allocations. But only if programmers know how to use them!
```

