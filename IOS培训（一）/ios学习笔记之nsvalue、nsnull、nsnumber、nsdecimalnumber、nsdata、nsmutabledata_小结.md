##IOS学习笔记之NSValue、NSNull、NSNumber、NSDecimalNumber、NSData、NSMutableData 小结
####From JiaYing.Cheng

---
---
###一、NSValue包装任意数据类型  
可使用下面的类方法创建新的NSValue

```
+ (NSValue *) valueWithBytes: (const void *) value objCType: (const char *) type;
```
NSValue是用来存储任意数据类型的。传递的参数是你想要包装的数值的地址（如一个NSSize或你自己的struct），通常得到的是你想要存储的变量的地址（在C语言中使用操作符&).你也可以提供一个用来描述这个数据类型的字符串（参数objCType)，通常用来说明struct中实体的类型和大小。不需要自己写这个字符串，@encode编译器指令可以接收数据类型的名称并生成合适的字符串。所以按照如下方式把NSRect放入NSArray中。
代码清单显示了如何使用任意结构体创建一个NSValue实例，传入一个结构体实例的地址作为value参数的指针，并通过@encode()指令来查找合适的数据类型。

```
typedef struct
{
    int someMember;
    float someOtherMember;
} MyDataType;


MyDataType item;
item.someMember = 10;
item.someOtherMember = 500.3;
NSValue *boxedStruct = [NSValue value:&item withObjCType:@encode(MyDataType)];
```

该技术适用于自定义或者框架提供的任意结构体。比如，可以使用代码清单中的代码来为NSRect和NSSize这两个Foundation结构体编码。NSValue可以用于存储整型、浮点型等，尽管对于这两种类型的值，NSNumber可能是一个更好的选择。还可以在NSValue中存储动态数据的指针。

```
char *foo = malloc(1024);
NSValue *boxedPointer = [NSValue value:&foo withObjCType:@encode(char **)];
```

需要注意的一个要点就是实际要存储的是指针本身而不是数据。因此，需要确保将它存储到NSValue中之后动态分配的数据不会被释放。

```
//将NSRect放入NSArray中
NSRect rect = NSMakeRect(1, 2, 100, 200);
NSValue *rectValue = [NSValue valueWithBytes:&rect objCType:@encode(NSRect)];
[array addObject:rectValue];


// 使用getValue提取数值,传递参数为要存储这个数值的变量的地址
rectValue = [array objectAtIndex: 0];
[rectValue getValue:&rect];
```

在上面的getValue: 例子中，方法名中的get表明我们提供的是一个指针，而指针所指向的空间用来存储该方法生成的数据。
Cocoa提供了将常用的struct型数据转换成NSValue的便捷方法：

`+ (NSValue *) valueWithPoint: (NSPoint) point;`

```
+ (NSValue *) valueWithSize: (NSSize) size;
+ (NSValue *) valueWithRect: (NSRect) rect;

- (NSPoint) pointValue;
- (NSSize) sizeValue;
- (NSRect) rectValue;

例子：
value = [NSValue valueWithRect: rect];
[array addObject: value];
NSRect anotherRect = [value rectValue];
```

###二、NSNull
因为在NSArray和NSDictionary中nil中有特殊的含义（表示列表结束）所以不能在集合中放入nil值。如要确实需要存储一个表示“什么都没有”的值，可以使用NSNull类；NSNull只有一个方法。

```
+ (NSNull *) null;

例如：
[contact setObject: [NSNull null] forKey: @"home fax"];


id homefax = [contact objectForKey: @"home fax"];
if (homefax == [NSNull null]{
    //...
}
```

###三、NSNumber包装数字
在处理整型、浮点数等数字时对于一个更高层面的抽象，NSNumber类提供了一些能够自动进行类型转换和类型判断的额外的工厂方法和存取器函数。使用NSNumber简单到只需使用数值调用合适的工厂方法。

创建方法：

```
+ (NSNumber *) numberWithChar: (char) value;
+ (NSNumber *) numberWithInt: (int) value;
+ (NSNumber *) numberWithFloat: (float) value;
+ (NSNumber *) numberWithBool: (BOOL) value; 
```

将基本类型数据封装到NSNumber中后，就可以通过下面的实例方法重新获取它：

```
- (char) charValue;
- (int) intValue;
- (float) floatValue;
- (BOOL) boolValue;
- (NSString *) stringValue;
```

```
例子：
int someNumber = 110;
float someFloat = 500.3;
NSNumber *theNumber = [NSNumber numberWithInt:someNumber];
NSNumber *theFloat = [NSNumber numberWithFloat:someFloat];

NSNumber *myIntValue = @32; 
NSNumber *myDoubleValue = @3.22346432; 
NSNumber *myBoolValue = @YES; 
NSNumber *myCharValue = @'V'; 

int n = 5; // Value assigned to primitive type 
NSNumber *numberObject = [NSNumber numberWithInt:n]; // Value object created from primitive type 
int y = [numberObject intValue]; // Encapsulated value obtained from value object
```

**备注：**将一个基本类型的数据包装成对象叫做**装箱（boxing)**，从对象中提取基本类型的数据叫做**取消装箱**或**拆箱(unboxing)**。Objective-C***不支持自动装箱***。

###四、NSDecimalNumber进行算术运算
尽管为了进行算术运算可以简单地获取NSNumber中的底层值，但是有时就想仅通过NSNumber对象进行一些简单的操作。为此，Foundation提供了NSDecimalNumber类。

NSDecimalNumber类是NSNumber的子类，它提供了执行简单的十进制算术运算的方法。它有很多方法，如:
  
* \-decimalNumberByAdding:、
* \-deciamlNumberBySubtracting:、
* \-decimalNumberByRaisingToPower:等方法。

这些方法使得使用-makeObjectsPerformSelector: withObject:等NSArray方法来对集合上的所有成员进行算术运算变得更容易。
  
**说明：NSDecimalNumber是不可变的，所有这里提到的任何算术操作都会返回一个新的NSDecimalNumber实例。**

如何利用这些方法来为员工数据库中的所有员工发奖金的示例如代码清单所示。如下代码清单，给所有的员工发5000美元的奖金

```
NSArray *employees = ...;
[employees makeObjectsPerformSelector:@selector(addToSalary:) withObject:[NSDecimalNumber numberWithFloat:5000.0]];

// addToSalary:的可能实现
-(void)addToSalary:(NSDecimalNumber *)inRaise{
   self.salary = [self.salary decimalNumberByAdding:inRaise];
}
```

由于NSDecimalNumber能够存储很大的值（大到38 位 x 10^+/-128）。这样进行一些大数值运算时也很方便，但是直接使用C的标量值会比通过NSDecimalNumber更快，所以需要慎重选择该方法。通常来说，这只在集合中使用。

在使用二进制数据块时，Foundation提供了NSData和NSMutableData类用于处理数据的面向对象接口。这些类可以用于管理缓冲区的分配和释放，并提供一个在集合类中存储数据的对象包装器类。它们同时也提供了一个将数据写到文件以及通过套接字通信进行数据传输的接口。

###五、NSData
NSData遵循NSCopying NSCoding协议,它提供面向对象的数组存储为字节，适用与读写文件，而读写文件的时候需要一个缓冲区，而NSDate就提供了这么一个缓存区 

___
#####1）创建NSData对象
可以利用之前分配的现有底层数据结构体或从支持NSCopying协议的Objective-C对象类型复制数据来创建NSData对象。

为了利用C数据结构体的原始数据创建一个NSData对象，可以使用`+dataWithBytes:length:`工厂方法，该方法接收一个指向数据缓冲区的指针并复制数据缓冲区中的字节到NSData对象。如果想直接访问缓冲区中的数据而不用复制，就可以使用`+dataWithBytes:NoCopy:length:`工厂方法，这样不复制数据就可以创建一个NSData对象，实际结果就是会生成一个NSData对象，可以直接通过缓冲区访问所提供的原始内存。

本例中，由于NSData对象会通过free函数释放数据，所以所提供的字节必须通过malloc创建。**由于NSMutableData支持对它所包含的数据进行修改，当指向一个外部分配的缓冲区时，修改数据就会有问题。因此，在使用NSMutableData时对象会复制数据，而无视是否指定要复制。**代码清单显示了一个利用预先分配的字节缓冲区创建NSData对象的示例。

`const char * string = "Hi there ,this is a C string"; ` 

```
//建立缓冲区，把字符串添加进去  
NSData * data = [NSData dataWithBytes:string length:strlen(string)+1];

char *buf = malloc(1024);
NSData *data = [NSData dataWithBytes:buf length:1024];
```

NSData对象最常用于访问存储在文件中或者网络资源中的数据。
可以通过工厂方法`+dataWithContentsOfFile:`利用文件的内容创建一个NSData对象，该方法接收一个文件路径作为参数。

对于网络上的资源则可以使用工厂方法`+dataWithContentsOfURL:`。该方法会通过指定URL中提供的协议访问网络并下载资源，之后将资源中可用的原始数据作为NSData对象的原始数据。***通常，和大多数这类的便捷方法类似，下载过程会阻塞当前线程直至完成，因此要小心使用该方法***。

NSData还提供了`-writeToFile:atomically:`和`-writeToURL:atomically:`方法将数据写入硬盘。

`-writeToURL:atomically:`仅支持写入本地文件的URL。这两种方法的第二个参数都是指定写入*是否是原子性操作*。在要写入的数据相当大时，应用可能在写入数据的过程中终止。这会导致硬盘上的文件受损。atomic参数指定该文件**首先被写入临时文件，并在临时文件上的文件操作完成后复制到最终位置**。通过该标志就知道原始文件仅在替换文件可以完全写入成功的情况下被替换。

___
######2）访问NSData对象中的生数据
NSMutableData类为包含着想要操作的字节的NSData对象提供了一个面向对象的接口。
可以通过`-appendBytes:length:`和`-apendData:`方法来增加字节，
可以通过`-replaceBytesInRange:withBytes:`替换字节，
通过`-setLength:.`方法来截断或者扩充NSMutableData的缓冲区。
如果只是想将缓冲区的某部分置为0（将字节设置成0），可以使用`-resetBytesInRange:`方法。它提供了任意操作文件或者结构体中的原始数据所需的工具。代码清单展示了可以使用该功能来读取硬盘中的文件、修改指定字节，然后将其写回硬盘。在本例中，目标文件是一个使用了硬编码文件格式的遗留的游戏数据保存文件，它会将特定的值存储在数据的特定位置。

```
int goldOffset = 617; // 文件中偏移617 的位置  
int goldLength = 4;   // 用于存储gold 值的4 字节空间  
  
NSRange goldRange = NSMakeRange(goldOffset, goldLength);  
NSMutableData *gameData = [NSMutableData dataWithContentsOfFile:@"..."];  
  
[gameData replaceBytesInRange:goldRange withBytes:newGoldValue];   
[gameData writeToFile:@"..." atomically:YES];  
```

可以看出，NSData提供了一个访问原始数据的方便的底层接口。它还提了了一个在集合类内部存储数据的一个很方便的包装器，这与NSNumber和NSValue类似。

```
//文件管理器使用NSData  
//NSFileManager可以用来查询单词库目录，创建，重命名，删除目录以及获取、设置文件属性的方法  
NSFileManager *fm = [NSFileManager defaultManager];  
  
//创建缓冲区，利用NSFileManager对象来获取文件中的内容，也就是这个文件的属性可修改  
NSData *fileData = [fm contentsAtPath:@"/tmp/ver.txt"];  
NSLog(@"file data is %@",fileData);  
  
//对NSData对象进行判断  
if(!fileData)  
{  
    NSLog(@"file read failed");  
}  
```

###六、数据类型转换 NSData转NSString，Byte，UIImage

```
1，NSData 与 NSString
　　NSData --> NSString
　　NSString *aString = [[NSString alloc] initWithData:adata encoding:NSUTF8StringEncoding];
　　NSString --> NSData
　　NSString *aString = @"1234";
　　NSData *aData = [aString dataUsingEncoding: NSUTF8StringEncoding];

2，NSData 与 Byte
　　NSData --> Byte
　　NSString *testString = @"1234567890";
　　NSData *testData = [testString dataUsingEncoding: NSUTF8StringEncoding];
　　Byte *testByte = (Byte *)[testData bytes];
　　Byte --> NSData
　　Byte byte[] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
　　NSData *adata = [[NSData alloc] initWithBytes:byte length:24];

3，NSData 与 UIImage
　　NSData --> UIImage
　　UIImage *aimage = [UIImage imageWithData: imageData];
　　//例：从本地文件沙盒中取图片并转换为NSData
　　NSString *path = [[NSBundle mainBundle] bundlePath];
　　NSString *name = [NSString stringWithFormat:@"ceshi.png"];
　　NSString *finalPath = [path stringByAppendingPathComponent:name];
　　NSData *imageData = [NSData dataWithContentsOfFile: finalPath];
　　UIImage *aimage = [UIImage imageWithData: imageData];
　　UIImage－> NSData
　　NSData *imageData = UIImagePNGRepresentation(aimae);

4，NSData 与 NSMutableData
　　NSData --> MSMutableData
　　NSData *data=[[NSData alloc]init];
　　NSMutableData *mdata=[[NSMutableData alloc]init];   
　　mdata=[NSData dataWithData:data];

5，NSData合并为一个NSMutableData		
```

```
- (NSString *)filePathWithName:(NSString *)filename
{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return [documentsDirectory stringByAppendingPathComponent:filename];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    //音频文件路径
        NSString *mp3Path1 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
        NSString *mp3Path2 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp3"];
        //音频数据
        NSData *sound1Data = [[NSData alloc] initWithContentsOfFile: mp3Path1];
        NSData *sound2Data = [[NSData alloc] initWithContentsOfFile: mp3Path2];
        //合并音频
        NSMutableData *sounds = [NSMutableData alloc];
        [sounds appendData:sound1Data];
        [sounds appendData:sound2Data];
        //保存音频
        NSLog(@"data length:%d", [sounds length]);
        [sounds writeToFile:[self filePathWithName:@"tmp.mp3"] atomically:YES];    
        [window makeKeyAndVisible];
    
    return YES;
}
```

```
6，NSString 合并
 
NSString* string; // 结果字符串
NSString* string1, string2; //已存在的字符串，需要将string1和string2连接起来
//方法1. 
string = [NSString initWithFormat:@"%@,%@", string1, string2 ];
//方法2. 
string = [string1 stringByAppendingString:string2];
//方法3 . 
string = [string stringByAppendingFormat:@"%@,%@",string1, string2];
```