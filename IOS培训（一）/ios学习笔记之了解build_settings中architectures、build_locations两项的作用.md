##IOS学习笔记之了解build settings中Architectures、build locations两项的作用

---
---
###Build Locations

```
Each time you create a project, Xcode sets the build locations for that project to the default build locations specified in the Building pane of Xcode preferences. You can, however, override these default build locations on a per-project basis. By taking advantage of this feature, you can choose default build locations that works best for most of your projects, and specify other default build locations for individual projects as needed.
 
1. In the Groups & Files list of the project window, select the project group and then click the Info button in the toolbar.
2. Click General to see the current build location.
3. Change the location of the build products by selecting “Custom location”, clicking Choose, and navigating to a location.
```


###Architectures
目前ios的指令集有以下几种：
1，armv6,支持的机器iPhone,iPhone2,iPhone3G及对应的iTouch
2，armv7,支持的机器iPhone4,iPhone4S
3，armv7s,支持的机器iPhone5,iPhone5C
4，arm64，支持的机器：iPhone5S
机器对指令集的支持是向下兼容的，因此armv7的指令集是可以运行在iphone5S的，只是效率没那么高而已~

___
Architecture ： 指你想支持的指令集。
Valid architectures : 指即将编译的指令集。
Build Active Architecture Only : 只是否只编译当前适用的指令集。
___
现在是2014年初，其实4和4S的用户还是蛮多的，而iphone3之类的机器几乎没有了，所以我们的指令集最低必须基于armv7.
因此,Architecture的值选择：armv7 armv7s arm64(选arm64时需要最低支持5.1.1，这块不太明白）

1. 如果想自己的app在各个机器都能够最高效率的运行，则需要将Build Active Architecture Only改为NO,Valid architectures选择对应的指令集：armv7 armv7s arm64。这个会为各个指令集编译对应的代码，因此最后的 ipa体积基本翻了3倍。（如果不在乎app大小的话，应该这样做）

2. 如果想让app体积保持最小，则现阶段应该选择Valid architectures为armv7,这样Build Active Architecture Only选YES或NO就无所谓了。

---

#####解决问题： iOS - Xcode升级到5.1& iOS升级到iOS7.1问题:Undefined symbols for architecture x86_64
Xcode升级到5.1 新特性之一就是默认让所有App都通过64位编译器编译。原来在Xcode5.0.x的时候默认的Standard architectures只有（arm7,armv7s），到5.1之后默认就带上arm64的参数了。


目前临时的解决办法是 


1. 把1.选中Targets—>Build Settings—>Architectures。
把build active architectures only 改为 NO。
2. 把最下面的Valid Architectures中的arm64参数删掉就可以了
   
   或者：
   
   双击Architectures，选择other，删除$(ARCH_STANDARD)，然后增加armv7和armv7s（写上：$(ARCHS_STANDARD_32_BIT)）。
3. clean 再build。

---

###build Settings常见参数解析

**1.Installation Directory：**安装路径

静态库编译时，在Build Settings中Installation Directory设置“$(BUILT_PRODUCTS_DIR)”

Skip Install设为YES

Installation Directory默认为/usr/local/lib

因为Build Location默认时，.a文件会放在很长（比如：/Users/xxx/Library/Developer/Xcode/DerivedData/xxxProgram

dalrvzehhtesxdfqhxixzafvddwe/Build/Products/Debug-iPhoneos）的路径下，或是我们target指定的路径

Skip Install如果是NO,可能会被安装到默认路径/usr/local/lib

2.Public Headers Folder Path：对外公开头文件路径

设为“include”（具体的头文件路径为：$(BUILT_PRODUCTS_DIR)/include/xx.h）

在最终文件.a同级目录下生成一个include目录

默认：/usr/local/include

Public Headers Folder Path这个路径就是使用这lib的某工程需要依赖的外部头文件.导入这路径后，#include/import "xx.h"才能看到

**3.User Header Search Paths：**依赖的外部头文件搜索路径

设置为“$(BUILT_PRODUCTS_DIR)/include”

和2中路径对应

**4.Per-configuration Build Products Path：**最终文件路径

比如设为“../app”，就会在工程文件.xcodeproj上一层目录下的app目录里，创建最终文件

默认为$(BUILD_DIR)/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME) 

等于$(BUILT_PRODUCTS_DIR)

**5.Per-configuration Intermediate Build Files Path：**临时中间文件路径

默认为：$(PROJECT_TEMP_DIR)/$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)

**6.Code Signing Identity：**真机调试的证书选择

选一个和Bundle identifier相对应的证书

Library Search Paths：库搜索路径

Architectures：架构，设为 armv6 或 armv7

Valid Architectures：应用框架，可以设为 armv6、 armv7 或i386

Product Name:工程文件名，默认为$(TARGET_NAME)

Info.plist File：info文件路径

Build Variants：默认为normal

Other Linker Flags：其他链接标签

设为“-ObjC”

当导入的静态库使用了类别，需要设为-ObjC

iOS Deployment Target：ios部署对象

比如可以选择设为，ios3到ios5的一种版本

Prefix Header：预编头文件（比如：UtilLib/UtilLib-Prefix.pch）

Precompile Prefix Header：设为“Yes”，表示允许加入预编译头