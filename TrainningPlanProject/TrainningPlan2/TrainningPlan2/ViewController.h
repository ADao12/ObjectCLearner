//
//  ViewController.h
//  TrainningPlan2
//
//  Created by JiaYing.Cheng on 14-10-10.
//  Copyright (c) 2014年 Flamingo-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboApi.h"

@interface ViewController : UIViewController <WeiboRequestDelegate,WeiboAuthDelegate>
{
    UIButton                    *btnLogin;
    UIButton                    *btnExtend;
    UIButton                    *btnHometimeline;
    UIButton                    *btnAddPic;
    UIButton                    *btnLogout;
    
    WeiboApi                    *wbapi;
}

@property (strong, nonatomic) UITextView *background;

@property (nonatomic , retain) WeiboApi *wbapi;

@property int selectedIndex;

- (void) toggleNextViewController:(id)sender;
- (void) setupLocalNotification;

@end

