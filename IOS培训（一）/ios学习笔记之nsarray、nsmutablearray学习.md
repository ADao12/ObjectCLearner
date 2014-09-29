##IOS学习笔记之NSArray、NSMutableArray学习
####From JiaYing.Cheng

---
---

**Objective-C的数组比C++，Java的数组强大在于，NSArray保存的对象可以是不同的对象。但只能保存对象，int ,char,double等基本数据类型不能直接保存，需要通过转换成对象才能加入数组。**

**性质概述：**

* NSArray是静态的数组，就是它所指向的内容是不可改变的，它指向一段内存区域，一旦初始化，不能通过它对该内存区域的数据进行修改操作，但是它可以读数据。
* NSMutableArray是动态的是NSArray的子类，可以对所指向的内存区域内容进行更改，并可以增加数组内容
* NSArray和NSmutableArray的第一个数据的下标为0。

###NSArray（不可变数组）

- [array count] : 数组的长度。
- [array objectAtIndex 0]: 传入数组脚标的id 得到数据对象。
- [arrayWithObjects; ...] :向数组对象初始化赋值。这里可以写任意对象的指针,结尾必须使用nil。


###NSMutableArray（可变对象数组）
- [NSMutableArray arrayWithCapacity:6] :初始化可变数组对象的长度，如果后面代码继续添加数组超过长度6以后NSMutableArray的长度会自动扩充，6是自己可以设置的颗粒度。
- [array addObject:...] : 向可变数组尾部添加数据对象。
- [array addObjectsFromArray:..] :向可变数组尾部添加一个数组对象。


###使用总结

```
// 初始化方法：
1. init返回一个空数组
2. initWithArray从已有数组初始化
3. initWithContentsOfFile//从plist文件加载
4. initWithContentsOfUrl//从网络地址上获取
5. initWithObject用一个对象初始化
6. initWithObjects从多对象初始化
```

```
NSMutableArray *MutableArray = ［NSMutableArray alloc] arrayWithArray:array] //创建可变数组（从现有的数组上建立）
[MutableArray removeObjectAtIndex:1] //删除数组中指定位置的的元素
[MutableArray replaceObjectAtIndex:1 withObject:@"tihuan"] //在相应位置
for(NSString *string in MutableArray)
{ NSLog(@"string:%@",string);} //快速枚举数组中的值

//创建数组 
//NSArray *array = [[NSArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",nil];


//从一个数组拷贝数据到另一数组(可变数级)

//arrayWithArray:
//NSArray *array1 = [[NSArray alloc] init];
NSMutableArray *MutableArray = [[NSMutableArray alloc] init];
NSArray *array = [NSArray arrayWithObjects:@"a",@"b",@"c",nil];
NSLog(@"array:%@",array);
MutableArray = [NSMutableArray arrayWithArray:array];
NSLog(@"MutableArray:%@",MutableArray);
array1 = [NSArray arrayWithArray:array];
NSLog(@"array1:%@",array1);

//Copy

//id obj;
NSMutableArray *newArray = [[NSMutableArray alloc] init];
NSArray *oldArray = [NSArray arrayWithObjects: @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",nil];

NSLog(@"oldArray:%@",oldArray);
for(int i = 0; i < [oldArray count]; i++)
{ 
obj = [[oldArray objectAtIndex:i] copy];
[newArray addObject: obj];
}
// 
NSLog(@"newArray:%@", newArray);
[newArray release];


//快速枚举

//NSMutableArray *newArray = [[NSMutableArray alloc] init];
NSArray *oldArray = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",nil]; 
NSLog(@"oldArray:%@",oldArray);

for(id obj in oldArray)
{
[newArray addObject: obj];
}
// 
NSLog(@"newArray:%@", newArray);
[newArray release];


//Deep copy

//NSMutableArray *newArray = [[NSMutableArray alloc] init];
NSArray *oldArray = [NSArray arrayWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",nil]; 
NSLog(@"oldArray:%@",oldArray); 
newArray = (NSMutableArray*)CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (CFPropertyListRef)oldArray, kCFPropertyListMutableContainers);
NSLog(@"newArray:%@", newArray);
[newArray release];


//Copy and sort

//NSMutableArray *newArray = [[NSMutableArray alloc] init];
NSArray *oldArray = [NSArray arrayWithObjects: @"b",@"a",@"e",@"d",@"c",@"f",@"h",@"g",nil]; 
NSLog(@"oldArray:%@",oldArray);
NSEnumerator *enumerator;
enumerator = [oldArray objectEnumerator];
id obj;
while(obj = [enumerator nextObject])
{
[newArray addObject: obj];
}
[newArray sortUsingSelector:@selector(compare:)];
NSLog(@"newArray:%@", newArray);
[newArray release];

 

/*--------------------------- 切分数组------------------------------*/

//从字符串分割到数组－ componentsSeparatedByString:
NSString *string = [[NSString alloc] initWithString:@"One,Two,Three,Four"];
NSLog(@"string:%@",string); 
NSArray *array = [string componentsSeparatedByString:@","];
NSLog(@"array:%@",array);
[string release];


//从数组合并元素到字符串- componentsJoinedByString:
NSArray *array = [[NSArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",nil];
NSString *string = [array componentsJoinedByString:@","];
NSLog(@"string:%@",string);

 

/*******************************************************************************************
NSMutableArray
*******************************************************************************************/
/*--------------- 给数组分配容量----------------*/
//NSArray *array;
array = [NSMutableArray arrayWithCapacity:20];

 

/*-------------- 在数组末尾添加对象----------------*/
//- (void) addObject: (id) anObject;
//NSMutableArray *array = [NSMutableArray arrayWithObjects: @"One",@"Two",@"Three",nil];
[array addObject:@"Four"];
NSLog(@"array:%@",array);

 

/*-------------- 删除数组中指定索引处对象----------------*/ 
//-(void) removeObjectAtIndex: (unsigned) index; 
//NSMutableArray *array = [NSMutableArray arrayWithObjects:@"One",@"Two",@"Three",nil];
[array removeObjectAtIndex:1];
NSLog(@"array:%@",array);

 

/*------------- 数组枚举---------------*/ 
//- (NSEnumerator *)objectEnumerator;从前向后
//NSMutableArray *array = [NSMutableArray arrayWithObjects:@"One",@"Two",@"Three",nil];
NSEnumerator *enumerator;
enumerator = [array objectEnumerator];

id thingie;
while (thingie = [enumerator nextObject]) {
NSLog(@"thingie:%@",thingie);
}


//- (NSEnumerator *)reverseObjectEnumerator;从后向前
//NSMutableArray *array = [NSMutableArray arrayWithObjects:@"One",@"Two",@"Three",nil];
NSEnumerator *enumerator;
enumerator = [array reverseObjectEnumerator];

id object;
while (object = [enumerator nextObject]) {
NSLog(@"object:%@",object);
}


//快速枚举
//NSMutableArray *array = [NSMutableArray arrayWithObjects:@"One",@"Two",@"Three",nil];
for(NSString *string in array)
{
NSLog(@"string:%@",string);
}
```