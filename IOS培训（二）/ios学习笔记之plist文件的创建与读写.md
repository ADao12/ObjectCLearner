##IOS学习笔记之Plist文件的创建与读写

---
---

###注意点：
1. 把plist文件保存在resource文件夹中，只能读不能写
2. xcode中的resource中的资源只能读，写不进。一般情况下，文件读、写入路径的文件保存在以下目录：   
`/Users/MyName/Library/Application Support/iPhone Simulator/4.3.2/Applications/27451C88-B8C8-4055-AEA8-A3D6D949DA97/Documents/`
该目录获取的方法：就是获取应用程序沙盒的Documents目录

```
	//获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
	//得到完整路径的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"test.plist"];
```

###创建plist文件。
按command +N快捷键创建，或者File —> New —> New File，选择Mac OSX下的Property List

###读取plist文件的数据

现在文件创建成功了，如何读取呢，实现代码如下：

```
[cpp] view plaincopyprint?
- (void)viewDidLoad
{
    [super viewDidLoad];
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"plistdemo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);//直接打印数据。
}
```

###创建和写入plist文件
在开发过程中，有时候需要把程序的一些配置保存下来，或者游戏数据等等。 这时候需要写入Plist数据。
写入的plist文件会生成在对应程序的沙盒目录里。
接着上面读取plist数据的代码，加入了写入数据的代码，

```
- (void)viewDidLoad
{
    [super viewDidLoad];
    //读取plist

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"plistdemo" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);
    
    //添加一项内容
    [data setObject:@"add some content" forKey:@"c_key"];
    
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"test.plist"];
   //输入写入
    [data writeToFile:filename atomically:YES];
    //那怎么证明我的数据写入了呢？读出来看看
    NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    NSLog(@"%@", data1);
// Do any additional setup after loading the view, typically from a nib.
}
```

在获取到自己手工创建的plistdemo.plist数据后，在这些数据后面加了一项内容，证明输入写入了。

获取resource文件中的.plist中的内容：

示例1：（获取.plist中的字典，获取所有key值组成的数组）

```
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:
                           @"statedictionary" ofType:@"plist"];//获取文件路径
 
    NSDictionary *dictionary = [[NSDictionary alloc]
                                initWithContentsOfFile:plistPath];//根据路径获取文件中的内容（字典）

    self.stateZips = dictionary;//stateZips事先定义的字典
    [dictionary release];
 
    NSArray *components = [self.stateZips allKeys];//获取字典所有key值组成的数组
    NSArray *sorted = [components sortedArrayUsingSelector:
                       @selector(compare:)];//对数组进行排序
    self.states = sorted;//states事先定义的数组
 
    NSString *selectedState = [self.states objectAtIndex:0];//第一个字典key值
    NSArray *array = [stateZips objectForKey:selectedState];//根据字典key值获取字典中的数组
    self.zips = array;
```

[http://blog.sina.com.cn/s/blog_4754829801019b8v.html](http://blog.sina.com.cn/s/blog_4754829801019b8v.html)