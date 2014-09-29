##IOS学习笔记之NSString、MutableString学习
####From JiaYing.Cheng

---
---

###NSString方法
```
+(id) stringWithContentsOfFile:path encoding:enc error:err
创建一个新字符串并将其设置为path指定的文件的内容，使用字符编码enc，如果非零，则返回err中错误
+(id) stringWithContentsOfURL:url encoding:enc error:err
创建一个新的字符串，并将其设置为url的内容，使用字符编码enc，如果非零，则返回err中的错误
+(id) string
创建一个新的空字符串
+(id) stringWithString:nsstring
创建一个新的字符串，并将其设置为nsstring
-(id)initWithString:nsstring
将分配的字符串设置为nsstring
-(id) initWithContentsOfFile:path encoding:enc error:err
将字符串设置为path制定的文件的内容
-(id) initWithContentsOfURL:url encoding:enc error:err
将字符串设置为url(NSURL *)url的内容，使用字符编码enc，如果非零，则返回err中的错误
-(id) (UNSIgned int)length
返回字符串中的字符数目
-(unichar)characterAtIndex:i
返回索引i的Unicode字符
-(NSString *)substringFromIndex:i
返回从i开始知道结尾的子字符串
-(NSString *)substringWithRange:range
根据指定范围返回子字符串
-(NSString *)substringToIndex:i
返回从该字符串开始到索i的子字符串
-(NSComparator *)caseInsensitiveCompare:nsstring
比较两个字符串，忽略大小写
-(NSComparator *)compare:nsstring
比较两个字符串
-(BOOL)hasPrefix:nsstring
测试字符串是否以nsstring开始
-(BOOL)hasSuffix:nsstring
测试字符串是否以nsstrng结尾
-(BOOL)isEqualToString:nsstring
测试两个字符串是否相等
-(NSString *) capitalizedString
返回每个单词首字母大写的字符串（每个单词的其余字母转换为小写）
-(NSString *)lowercaseString
返回转换为小写的字符串
-(NSString *)uppercaseString
返回转换为大写的字符串
-(const char*)UTF8String
返回转换为UIF－8字符串的字符串
-(double)doubleValue
返回转换为double的字符串
-(float)floatValue
返回转换为浮点值的字符串
-(NSInteger)integerValue
返回转换为NSInteger整数的字符串
-(int)intValue
返回转换为整数的字符串

```

###NSMutableString方法
```
+(id) stringWithCapacity:size
创建一个字符串，初始包含size的字符
-(id) initWithCapacity:size
使用初始容量为size的字符串来初始化字符串
-(void) setString:nsstring
将字符串设置为nsstring
-(void) appendString:nsstring
在接收者的末尾附加nsstring
-(void) deleteCharactersInRange:range
删除指定range中的字符
-(void) insertString:nsstring atIndex:i
以索引i为起始位置插入nsstring
-(void) replaceCharactersInRange:range withString:nsstring
使用nsstring替换range指定的字符
-(void) replaceOccurrencesOf
String:nsstring withString:
nsstring2 options:opts range:range
根据选项opts。使用指定range中的nsstring2替换所有的nsstring。选项可以包括NSBackwardsSearch（从范围的结尾开始搜索）NSAnchoredSearch(nsstring必须匹配范围的开始)，NSLiteralSearch(执行逐字节比较以及NSCaceInsensitiveSearch的按位或组合)

[aString substringToIndex:([aString length]-1)];//字符串删除最后一个字符
//字符串删除最后一个字符
 NSRange range = {0,1};
 [aStr deleteCharactersInRange:range];

NSString是不可变的，意思是他声明的对象我们不可以改变，如果要改变，可以使用它的子类：NSMutableString
 
你可以使用类方法：stringWithCapacity来创建一个新的NSMutableString,声明如下：
 
*(id) stringWithCapacity: (unsigned) capacity:
 
可按如下方法声明一个新的可变字符串：
NSString *str1;
Str1 = [NSMutableString stringWithCapacity:42];
 
可以使用appendString或appendFormat来对可变字符串操作：
  - （void）appendString: (Nsstring *) aString;
  -  (void) appendFormat: (NSString *) Format;
 
appendString 接受参数aString,然后将其复制到接受对象的末尾。
appendFormat类似，他将格式化的字符串附加在接受对象的末尾，而不是创建新的对象。
 
EXP:
NSMutableString *string;
string = [NSMutableString stringWithcapacity:50];
[string appendString: @”hello,there”];
[string appendFormat: @”human %d!”, 39];
 这段代码的string最后被赋值为：hello,there human 39!
 
你还可以使用deleteCharactersInRange:方法来删除字符串中的字符：
- （void） deleteCharactersInRange: (NSRange) range;
 
通常将deleteCharactersInRange: 和rangeOfString:连在一起使用，NSMutableString可以使用NSString的全部功能，包括rangeOfString:、字符串比较和其他任何功能。
```


###练习代码
```
int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        //----------------NSString-----------------------------
        NSString *str1 = @"这是一个字符串常量";
        NSLog(@"str1 = %@",str1);
        //创建一个空字符串
        NSString *str2 = [[NSString alloc]init];
        NSString *str3 = [NSString string];
        NSLog(@"str2 = %@",str2);
        NSLog(@"str3 = %@",str3);
        //快速创建一个字符串
        NSString *str4 = [[NSString alloc]initWithString:str1];
        NSString *str5 = [NSString stringWithString:str1];
        NSLog(@"str4 = %@",str4);
        NSLog(@"str5 = %@",str5);
        //创建一个格式化字符串
        NSString *str6 = [[NSString alloc]initWithFormat:@"%d",10];
        NSString *str7 = [NSString stringWithFormat:@"%.2f",10.8099887];
        NSLog(@"str6 = %@",str6);
        NSLog(@"str7 = %@",str7);
        
        //比较两个字符串内容是否相等
        if ([str6 isEqualToString:str7]) {
            NSLog(@"str6 is EqualToString str7");
        }else{
            NSLog(@"str6 is not EqualToString str7");
        }
        
        //转换为基本数据类型
        NSString *str8 = @"3";
        float f1 = [str8 floatValue];
        NSLog(@"str8 = %.2f",f1);
        
        //字符串拆分为数组
        NSString *str9 = @"命 运 就 算 颠 沛 流 离";
        NSArray *array = [str9 componentsSeparatedByString:@" "];
        NSLog(@"array = %@",array);
        NSLog(@"array[0] = %@",array[0]);
        
        //截取字符串
        NSString *str10 = @"123456789";
        NSString *subStr1 = [str10 substringToIndex:4];
        NSString *subStr2 = [str10 substringFromIndex:6];
        NSLog(@"subStr1 = %@",subStr1);
        NSLog(@"subStr2 = %@",subStr2);
        
        NSRange range = {4,2};
        NSString *subStr3 = [str10 substringWithRange:range];
        NSLog(@"subStr3 = %@",subStr3);
        
        //拼接字符串
        NSString *str11 = @"123";
        NSString *str12 = @"456";
        NSString *appStr1 = [[NSString alloc]initWithFormat:@"%@%@",str11,str12];
        NSString *appStr2 = [str11 stringByAppendingFormat:@"%@",str12];
        NSString *appStr3 = [str11 stringByAppendingString:str12];
        NSLog(@"appStr1 = %@",appStr1);
        NSLog(@"appStr2 = %@",appStr2);
        NSLog(@"appStr3 = %@",appStr3);
        
        //查找字符串
        NSString *str13 = @"qweradsfzxcvqazxsw";
        NSRange range1 = [str13 rangeOfString:@"dsfzx"];
        NSLog(@"%@",NSStringFromRange(range1));
        NSLog(@"%d",range1.location);
        if (range1.location != NSNotFound) {
            NSLog(@"str found");
        }else{
            NSLog(@"str not found");
        }
        
        /*------------NSMutableString 可变字符串-----------------*/
        //插入
        NSMutableString *mStr1 = [[NSMutableString alloc] initWithFormat:@"abcd"];
        [mStr1 insertString:@"defg" atIndex:4];    //注意：此处为在源字符串上修改，并未生成新的字符串
        NSLog(@"mStr1 = %@",mStr1);
        
        //替换
        [mStr1 replaceCharactersInRange:NSMakeRange(4, 4) withString:@"1234"];
        NSLog(@"%@",mStr1);
        
        //删除
        [mStr1 deleteCharactersInRange:NSMakeRange(4, 4)];
        NSLog(@"%@",mStr1);
    }
    return 0;
}
```