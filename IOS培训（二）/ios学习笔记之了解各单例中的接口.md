##IOS学习笔记之了解各单例中的接口

---
---

+ UIApplication：    
-(void)applicationWillResignActive:(UIApplication *)application   
    当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
	
	-(void)applicationDidBecomeActive:(UIApplication *)application   
	当应用程序入活动状态执行，这个刚好跟上面那个方法相反

	-(void)applicationDidEnterBackground:(UIApplication *)application

	当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可

	-(void)applicationWillEnterForeground:(UIApplication *)application

	当程序从后台将要重新回到前台时候调用，这个刚好跟上面的那个方法相反。

	-(void)applicationWillTerminate:(UIApplication *)application

	当程序将要退出是被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。

	-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application

	iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止

	-(void)applicationSignificantTimeChange:(UIApplication*)application

	当系统时间发生改变时执行

	-(void)applicationDidFinishLaunching:(UIApplication*)application

	当程序载入后执行

	-(void)application:(UIApplication)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame

	当StatusBar框将要变化时执行

	-(void)application:(UIApplication*)application willChangeStatusBarOrientation:
(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration

	当StatusBar框方向将要变化时执行

	-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url

	当通过url执行

	-(void)application:(UIApplication*)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation

	当StatusBar框方向变化完成后执行

	-(void)application:(UIApplication*)application didChangeSetStatusBarFrame:(CGRect)oldStatusBarFrame

	当StatusBar框变化完成后执行
+ UIDevice：   
	typedef NS_ENUM(NSInteger, UIDeviceOrientation) //设备方向    
	{   
   	 	UIDeviceOrientationUnknown,   
    	UIDeviceOrientationPortrait,                   // 竖向，头向上   
    	UIDeviceOrientationPortraitUpsideDown,  // 竖向，头向下   
    	UIDeviceOrientationLandscapeLeft,         // 横向，头向左   
    	UIDeviceOrientationLandscapeRight,       // 横向，头向右    
    	UIDeviceOrientationFaceUp,                   // 平放，屏幕朝下   
    	UIDeviceOrientationFaceDown                // 平放，屏幕朝下   
	};   
 
	typedef NS_ENUM(NSInteger, UIDeviceBatteryState) //电池状态   
	{   
    	UIDeviceBatteryStateUnknown,    
    	UIDeviceBatteryStateUnplugged,   // 未充电    
    	UIDeviceBatteryStateCharging,     // 正在充电    
    	UIDeviceBatteryStateFull,             // 满电   
	}; 

	typedef NS_ENUM(NSInteger, UIUserInterfaceIdiom) //用户界面类型    
	{    
	//iOS3.2以上有效
		＃if _IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED    
    	UIUserInterfaceIdiomPhone,           // iPhone 和 iPod touch 风格    
    	UIUserInterfaceIdiomPad,              // iPad 风格    
		＃endif    
	};    
	+(UIDevice *)currentDevice; // 获取当前设备       
	@property(nonatomic,readonly,retain) NSString *name;                // e.g. "My iPhone"   
	@property(nonatomic,readonly,retain) NSString    *model;               // e.g. @"iPhone", @"iPod touch"   
	@property(nonatomic,readonly,retain) NSString    *localizedModel;    // localized version of model    
	@property(nonatomic,readonly,retain) NSString    *systemName;      // e.g. @"iOS"    
	@property(nonatomic,readonly,retain) NSString    *systemVersion;    // e.g. @"4.0"
	@property(nonatomic,readonly) UIDeviceOrientation orientation;       // 除非正在生成设备方向的通知，否则返回UIDeviceOrientationUnknown 。    

	@property(nonatomic,readonly,retain) NSUUID      *identifierForVendor NS_AVAILABLE_IOS(6_0);      // 可用于唯一标识该设备，同一供应商不同应用具有相同的UUID 。   

	@property(nonatomic,readonly,getter=isGeneratingDeviceOrientationNotifications) BOOL generatesDeviceOrientationNotifications; //是否生成设备转向通知    
	-(void)beginGeneratingDeviceOrientationNotifications; 
	-()void)endGeneratingDeviceOrientationNotifications;

	@property(nonatomic,getter=isBatteryMonitoringEnabled) BOOL batteryMonitoringEnabled NS_AVAILABLE_IOS(3_0);  // 是否启动电池监控，默认为NO     
	@property(nonatomic,readonly) UIDeviceBatteryState batteryState NS_AVAILABLE_IOS(3_0);  // 如果禁用电池监控，则电池状态为UIDeviceBatteryStateUnknown     
	@property(nonatomic,readonly) float batteryLevel NS_AVAILABLE_IOS(3_0);  //电量百分比， 0 .. 1.0。如果电池状态为UIDeviceBatteryStateUnknown，则百分比为-1.0   

	@property(nonatomic,getter=isProximityMonitoringEnabled) BOOL proximityMonitoringEnabled NS_AVAILABLE_IOS(3_0); // 是否启动接近监控（例如接电话时脸靠近屏幕），默认为NO    
	@property(nonatomic,readonly)  BOOL proximityState NS_AVAILABLE_IOS(3_0);  // 如果设备不具备接近感应器，则总是返回NO      

	@property(nonatomic,readonly,getter=isMultitaskingSupported) BOOL multitaskingSupported NS_AVAILABLE_IOS(4_0); // 是否支持多任务

	@property(nonatomic,readonly) UIUserInterfaceIdiom userInterfaceIdiom NS_AVAILABLE_IOS(3_2); // 当前用户界面模式

	-(void)playInputClick NS_AVAILABLE_IOS(4_2);  // 播放一个输入的声音


	@protocol UIInputViewAudioFeedback     
	@optional    
	@property (nonatomic, readonly) BOOL enableInputClicksWhenVisible; // 实现该方法，返回YES则自定义的视图能够播放输入的声音    
	@end

	UIKIT_EXTERN NSString *const UIDeviceOrientationDidChangeNotification; // 屏幕方向变化通知    
	UIKIT_EXTERN NSString *const UIDeviceBatteryStateDidChangeNotification   NS_AVAILABLE_IOS(3_0); // 电池状态变化通知    
	UIKIT_EXTERN NSString *const UIDeviceBatteryLevelDidChangeNotification   NS_AVAILABLE_IOS(3_0); // 电池电量变化通知     
	UIKIT_EXTERN NSString *const UIDeviceProximityStateDidChangeNotification NS_AVAILABLE_IOS(3_0); // 接近状态变化通知   