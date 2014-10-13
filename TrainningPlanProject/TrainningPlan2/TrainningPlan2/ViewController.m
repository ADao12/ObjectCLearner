//
//  ViewController.m
//  TrainningPlan2
//
//  Created by JiaYing.Cheng on 14-10-10.
//  Copyright (c) 2014年 Flamingo-inc. All rights reserved.
//

#import "ViewController.h"
#import "constant.h"
#import "ResultViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize wbapi;
//@synthesize _selectedIndex;

-(float)GetXPos:(UIInterfaceOrientation)toInterfaceOrientation
{
    float x;
    
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        x = [[UIScreen mainScreen]bounds].size.width/8;
        
    }
    else
    {
        x = [[UIScreen mainScreen]bounds].size.height/8;
    }
    
    //NSLog(@"x pos = %f", x);
    
    return x;
    
}


-(void)redrawSubView:(UIInterfaceOrientation)toInterfaceOrientation width:(CGFloat)width height:(CGFloat)height
{
    [btnLogin removeFromSuperview];
    [btnExtend removeFromSuperview];
    [btnAddPic removeFromSuperview];
    [btnHometimeline removeFromSuperview];
    [btnLogout  removeFromSuperview];
    
//    CGRect frame = [UIScreen mainScreen].bounds;
//    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
    
    btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setFrame:CGRectMake([self GetXPos:toInterfaceOrientation], height*2/8, 240, 40)];
    [btnLogin setTitle:@"授权" forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(onLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    
    
    btnExtend = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnExtend setFrame:CGRectMake([self GetXPos:toInterfaceOrientation], height*3/8, 240, 40)];
    [btnExtend setTitle:@"检查token有效性" forState:UIControlStateNormal];
    [btnExtend addTarget:self action:@selector(onExtend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExtend];
    
    
    btnHometimeline = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnHometimeline setFrame:CGRectMake([self GetXPos:toInterfaceOrientation], height*4/8, 240, 40)];
    [btnHometimeline setTitle:@"获取主时间线" forState:UIControlStateNormal];
    [btnHometimeline addTarget:self action:@selector(onGetHometimeline) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnHometimeline];
    
    
    btnAddPic = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAddPic setFrame:CGRectMake([self GetXPos:toInterfaceOrientation], height*5/8, 240, 40)];
    [btnAddPic setTitle:@"发表带图微博" forState:UIControlStateNormal];
//    [btnAddPic addTarget:self action:@selector(onAddPic) forControlEvents:UIControlEventTouchUpInside];
    [btnAddPic addTarget:self action:@selector(willTogglePhotoLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAddPic];
    
    btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogout setFrame:CGRectMake([self GetXPos:toInterfaceOrientation], height*6/8, 240, 40)];
    [btnLogout setTitle:@"取消授权" forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(onLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    // Do any additional setup after loading the view, typically from a nib.
    // custom the nav bar
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *nextBtnItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@"分享" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(willTogglePhotoLibrary:)];
    
    self.navigationItem.rightBarButtonItem = nextBtnItem;
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedIndex = -1;
    [self setupLocalNotification];
    
    if(self->wbapi == nil)
    {
        self->wbapi = [[WeiboApi alloc]initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUri:REDIRECTURI andAuthModeFlag:0 andCachePolicy:0] ;
    }
    
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat longer = 0;
    CGFloat shorter = 0;
    if (frame.size.width >= frame.size.height) {
        longer = frame.size.width;
        shorter = frame.size.height;
    } else {
        longer = frame.size.height;
        shorter = frame.size.width;
    }
    
    [self redrawSubView:self.interfaceOrientation width:longer height:shorter];
    
//    [self redrawSubView:self.interfaceOrientation];
}

- (void)willTogglePhotoLibrary:(id)sender
{
    if (_selectedIndex != 3) {
        _selectedIndex = 3;
        [wbapi checkAuthValid:TCWBAuthCheckServer andDelegete:self];
    } else {
        [self performSelectorInBackground:@selector(togglePhotoLibrary:) withObject:nil];
    }
}

- (void)togglePhotoLibrary:(id)sender
{
    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=sourceType;
    [self presentModalViewController:picker animated:YES];
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    
//    imagePicker.delegate = self;
//    
//    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    
//    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    
//    imagePicker.allowsEditing = YES;
//    
//    [self presentModalViewController:imagePicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}

- (void)selectPic:(UIImage*)image
{
    NSLog(@"image%@",image);
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"hi,weibo sdk", @"content",
                                   image, @"pic",
                                   nil];
    [wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    
    [self performSelectorInBackground:@selector(detect:) withObject:nil];
}

-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)toggleNextViewController:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"提示" message:@"跳到下一个页面..."
                              delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

-(void)setVerticalFrameWithWidth:(CGFloat)width andHeight:(CGFloat)height
{
    NSLog(@"竖屏");
//    [_background setFrame:CGRectMake(0, 0, width, height)];
}

-(void)setHorizontalFrameWithWidth:(CGFloat)width andHeight:(CGFloat)height
{
    NSLog(@"横屏");
//    [_background setFrame:CGRectMake(0, 0, width, height)];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"UIViewController will rotate to Orientation: %d", toInterfaceOrientation);
    CGRect frame = [UIScreen mainScreen].bounds;
//    CGPoint center = CGPointMake(frame.origin.x + ceil(frame.size.width/2), frame.origin.y + ceil(frame.size.height/2));
//    [_background setCenter:center];
    
    CGFloat longer = 0;
    CGFloat shorter = 0;
    if (frame.size.width >= frame.size.height) {
        longer = frame.size.width;
        shorter = frame.size.height;
    } else {
        longer = frame.size.height;
        shorter = frame.size.width;
    }
    
    [self redrawSubView:toInterfaceOrientation width:longer height:shorter];

    
//
//    
//    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft||toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {//翻转为横屏时
//        
//        [self setHorizontalFrameWithWidth:longer andHeight:shorter];
//
//    }else{//翻转为竖屏时
//        
//        [self setVerticalFrameWithWidth:shorter andHeight:longer];
//    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did rotated to new Orientation, view Information %@", self.view);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    
    return;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击登录按钮
- (void)onLogin {
    _selectedIndex = -1;
    [wbapi loginWithDelegate:self andRootController:self];
}

//点击登录按钮
- (void)onExtend {
    _selectedIndex = -1;
    [wbapi checkAuthValid:TCWBAuthCheckServer andDelegete:self];
    
}

//点击登录按钮
- (void)onGetHometimeline {
    
    
    
    //[self showMsg:str];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"0", @"pageflag",
                                   @"30", @"reqnum",
                                   @"0", @"type",
                                   @"0", @"contenttype",
                                   nil];
    [wbapi requestWithParams:params apiName:@"statuses/home_timeline" httpMethod:@"GET" delegate:self];
//    [params release];
}

//点击登录按钮
- (void)onAddPic {
    
    
    
    _selectedIndex = -1;
    UIImage *pic = [UIImage imageNamed:@"icon.png"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"hi,weibo sdk", @"content",
                                   pic, @"pic",
                                   nil];
    [wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    //[pic release];
//    [params release];
    
}


//点击登录按钮
- (void)AddPic {
    
    
    
    
    UIImage *pic = [UIImage imageNamed:@"icon.png"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"json",@"format",
                                   @"hi,weibo sdk", @"content",
                                   pic, @"pic",
                                   nil];
    [wbapi requestWithParams:params apiName:@"t/add_pic" httpMethod:@"POST" delegate:self];
    //[pic release];
//    [params release];
    
}


- (void)showMsg:(NSString *)msg
{
    ResultViewController *rvc = [[ResultViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rvc];
    rvc.result = msg;
    
    [self presentModalViewController:nav animated:YES];
//    [rvc release];
//    [nav release];
}

- (void)onLogout {
    
    _selectedIndex = -1;
    // 注销授权
    [wbapi  cancelAuth];
    
    NSString *resStr = [[NSString alloc]initWithFormat:@"取消授权成功！"];
    
    [self showMsg:resStr];
//    [resStr release];
    
}


- (void) setLocalNotification:(int) alertWeekDay {
    //现在的时间
    NSDate *now=[NSDate date];
    
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags= NSCalendarUnitSecond|NSCalendarUnitMinute|NSCalendarUnitHour|NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear;
    NSDateComponents * tempComp= [cal components:unitFlags fromDate:now];
    NSInteger year=[tempComp year];
    NSInteger month=[tempComp month];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:12];
    [components setWeekday:alertWeekDay];
    [components setWeekdayOrdinal:1]; // The first Monday in the month
    [components setMonth:month]; // May
    [components setYear:year];
    
    //启动本地通知
    UILocalNotification *notification1=[[UILocalNotification alloc] init];
    
    if (notification1) {
        [components setWeekday:alertWeekDay];
        notification1.fireDate= [cal dateFromComponents:components];
//        notification1.fireDate= [NSDate dateWithTimeIntervalSinceNow:15];
        notification1.repeatInterval = kCFCalendarUnitDay;
        notification1.timeZone=[NSTimeZone defaultTimeZone];
        notification1.soundName = @"ping.caf";
        notification1.applicationIconBadgeNumber = 6;
        notification1.alertBody=@"发条微博和朋友分享吧~~";
        notification1.alertAction = @"好的";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification1];
    }
    
}

- (void) setupLocalNotification {
    
    //取消之前所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    //清空 icon数量
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self setLocalNotification:1];
    [self setLocalNotification:3];
    [self setLocalNotification:5];

}





#pragma mark WeiboRequestDelegate

/**
 * @brief   接口调用成功后的回调
 * @param   INPUT   data    接口返回的数据
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didReceiveRawData:(NSData *)data reqNo:(int)reqno
{
    NSString *strResult = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"result = %@",strResult);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:strResult];
    });
    
//    [strResult release];
    
}
/**
 * @brief   接口调用失败后的回调
 * @param   INPUT   error   接口返回的错误信息
 * @param   INPUT   request 发起请求时的请求对象，可以用来管理异步请求
 * @return  无返回
 */
- (void)didFailWithError:(NSError *)error reqNo:(int)reqno
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
//    [str release];
}



#pragma mark WeiboAuthDelegate

/**
 * @brief   重刷授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthRefreshed:(WeiboApiObject *)wbobj
{
    
    
    //UISwitch
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r openid = %@\r appkey=%@ \r appsecret=%@\r",wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret];
    
    NSLog(@"result = %@",str);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
//    [str release];
    
}

/**
 * @brief   重刷授权失败后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthRefreshFail:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"refresh token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
//    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi 成功后返回的WeiboApi对象，accesstoken,openid,refreshtoken,expires 等授权信息都在此处返回
 * @return  无返回
 */
- (void)DidAuthFinished:(WeiboApiObject *)wbobj
{
    NSString *str = [[NSString alloc]initWithFormat:@"accesstoken = %@\r\n openid = %@\r\n appkey=%@ \r\n appsecret=%@ \r\n refreshtoken=%@ ", wbobj.accessToken, wbobj.openid, wbobj.appKey, wbobj.appSecret, wbobj.refreshToken];
    
    NSLog(@"result = %@",str);
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
    
    
    // NSLog(@"after add pic");
//    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   wbapi   weiboapi 对象，取消授权后，授权信息会被清空
 * @return  无返回
 */
- (void)DidAuthCanceled:(WeiboApi *)wbapi_
{
    
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
- (void)DidAuthFailWithError:(NSError *)error
{
    NSString *str = [[NSString alloc] initWithFormat:@"get token error, errcode = %@",error.userInfo];
    
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self showMsg:str];
    });
//    [str release];
}

/**
 * @brief   授权成功后的回调
 * @param   INPUT   error   标准出错信息
 * @return  无返回
 */
-(void)didCheckAuthValid:(BOOL)bResult suggest:(NSString *)strSuggestion
{
    NSString *str = [[NSString alloc] initWithFormat:@"ret=%d, suggestion = %@", bResult, strSuggestion];
    //注意回到主线程，有些回调并不在主线程中，所以这里必须回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
        if(bResult == 0) {
            [self onLogin];
        } else {
            if (_selectedIndex == 3) {
                [self performSelectorInBackground:@selector(togglePhotoLibrary:) withObject:nil];
            } else {
                [self showMsg:str];
            }
        }
    });
//    [str release];
}

//- (CGAffineTransform)getTransformMakeRotationByOrientation:(UIInterfaceOrientation)orientation
//{
//    if (orientation == UIInterfaceOrientationLandscapeLeft) {
//        return CGAffineTransformMakeRotation(M_PI*1.5);
//    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
//        return CGAffineTransformMakeRotation(M_PI/2);
//    } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
//        return CGAffineTransformMakeRotation(-M_PI);
//    } else {
//        return CGAffineTransformIdentity;
//    }
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    
//    if (orientation != UIInterfaceOrientationLandscapeLeft ||
//        orientation != UIInterfaceOrientationLandscapeRight)
//    {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
//        
//        //（获取当前电池条动画改变的时间
//        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:duration];
//        
//        self.view.transform = CGAffineTransformIdentity;
//        [UIView commitAnimations];
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//    
//    if (orientation != UIInterfaceOrientationPortrait ||
//        orientation != UIInterfaceOrientationPortraitUpsideDown)
//    {
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//        
//        //（获取当前电池条动画改变的时间
//        CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:duration];
//        
//        //在这里设置view.transform需要匹配的旋转角度的大小就可以了。
//        self.view.transform = [self getTransformMakeRotationByOrientation:orientation];
//        [UIView commitAnimations];
//    }
//}

@end
