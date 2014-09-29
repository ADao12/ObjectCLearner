##IOS学习笔记之NSDictionary、NSMutableDictionary学习
####From JiaYing.Cheng

---
---

`Java`语言或者`C`语言中的关键字`map`，它可以将数据以键值对儿的形式储存起来，取值的时候通过KEY就可以直接拿到对应的值，非常方便。在`Objective-C`语言中 词典对象就是做这个事情的，不过在同一个词典对象中可以保存多个不同类型的数据，不像`Java`与`C` 只能保存声明的相同类型的数据，它的关键字为`NSDictionary`与`NSMutableDictionary`。阅读过我之前文章的朋友应该从关键字的 结构就可以看出这两个的区别。很明显前者为不可变词典，或者为可变词典。
___

###不可变词典NSDictionary

```
- [NSDictionary dictionaryWithObjectsAndKeys:..] : 使用键值对儿直接创建词典对象，结尾必需使用nil标志结束。
- 
- [NSDictionary initWithObjectsAndKeys:..] :使用键值对儿初始化词典对象，结尾必需使用nil标志结束。
- 
- [dictionary count]: 得到词典的长度单位。
- 
- [dictionary keyEnumerator]: 将词典的所有KEY储存在NSEnumerator中，NSEnumerator很像Java语言 中的迭代器，使用快速枚举可以遍历词典中所有储存KEY值。
- 
- [dictionary  objectEnumerator]: 将词典的所有value储存在NSEnumerator中,用法和上面差不多可用来遍历KEY对应储存的Value值。
- 
- [dictionary objectForKey:key]: 通过传入KEY对象可以拿到当前KEY对应储存的值。
```


```
字典初始化

NSNumber *numObj = [NSNumber numberWithInt:100];

以一个元素初始化

NSDictionary *dic = [NSDictionary dictionaryWithObject:numObj forKey:@"key"];

初始化两个元素

NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:numObj, @"valueKey", numObj2, @"value2",nil];

初始化新字典，新字典包含otherDic

NSDictionary *dic = [NSDictionary dictionaryWithDictionary:otherDic];

以文件内容初始化字典

NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
```
常用方法

```
获取字典数量

NSInteger count = [dic count];

通过key获取对应的value对象

NSObject *valueObj = [dic objectForKey:@"key"];

将字典的key转成枚举对象，用于遍历

NSEnumerator *enumerator = [dic keyEnumerator];

获取所有键的集合

NSArray *keys = [dic allKeys];

获取所有值的集合

NSArray *values = [dic allValues];
```

###可变数组NSMutableDictionary

```
NSMutableDictionary 是NSDictionary的子类，所以继承了NSDictionary的方法。

[NSMutableDictionary dictionaryWithCapacity:10] : 创建一个可变词典初始指定它的长度为10.，动态的添加数据如果超过10这个词典长度会自动增加，所以不用担心数组越界。推荐用这种方式

[NSMutableDictionary initWithCapacity:10]  :只是初始化一个词典的长度为10。

[dictionary setObject:@"雨松MOMO" forKey:@"name"] :向可变的词典动态的添加数据 ，这里的key是name ，值是雨松MOMO。如果词典中存在这个KEY的数据则直接替换这个KEY的值。（易混的地方，慎重！）

[dictionary removeAllObjects..] : 删除掉词典中的所有数据。

[dictionary removeObjectForKey..] :删除掉词典中指定KEY的数据 。
```

```
初始化一个空的可变字典

NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"v1",@"key1",@"v2",@"key2",nil];

NSDictionary *dic3 = [NSDictionary dictionaryWithObject:@"v3" forKey:@"key3"];

向字典2对象中添加整个字典对象3

[dic2 addEntriesFromDictionary:dic3];

向字典2对象中最佳一个新的key3和value3

[dic2 setValue:@"value3" forKey:@"key3"];

初始化一个空的可变字典

NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];

将空字典1对象内容设置与字典2对象相同

[dic1 setDictionary:dic2];

将字典中key1对应的值删除

[dic1 removeObjectForKey@"key1"];

NSArray *array = [NSArray arrayWithObjects:@"key1", nil];

根据指定的数组（key）移除字典1的内容

[dic2 removeObjectsForKeys:array];

移除字典所有对象

[dic1 removeAllObjects];
```

遍历字典

```
快速枚举

for (id key in dic){

     id obj = [dic objectForKey:key];

     NSLog(@"%@", obj);

}

一般枚举

NSArray *keys = [dic allKeys];

inr length = [keys count];

for (int i = 0; i < length；i++){

     id key = [keys objectAtIndex:i];

     id obj = [dic objectForKey:key];

     NSLog(@"%@", obj);

}

通过枚举类型枚举

NSEnumerator *enumerator = [dic keyEnumerator];

id key = [enumerator nextObject];

while (key) {

        id obj = [dic objectForKey:key];

        NSLog(@"%@", obj);

        key = [enumerator nextObject];

}
```