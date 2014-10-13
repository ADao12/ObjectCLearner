##IOS学习笔记之了解UIKit中的UI控件

---
---

* UIAlertView：ios里的消息提示框。
	- 初始化：
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Default Alert View"message:@"Defalut" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",@“ThirdButton”, nil]; 
	initWithTitle后为消息框名称，message后为消息框的提示信息，cancelButtonTitle后为cancel按钮，otherButtonTitle后为你另添加的按钮名称，用“，”分隔。   
	可以通过clickedButtonAtIndex方法根据index为按钮添加点击事件，didDismissWithButtonIndex为按钮添加消息框已经消失时执行的事件，didDismissWithButtonIndex添加消息框即将消失时的事件。
	
* UIButton：iOS里的按钮类。
	- 初始化：
	
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];  
	
```  
	buttonWithType后为button类型，共有六种，  
	UIButtonTypeCustom ,          自定义风格   
	UIButtonTypeRoundedRect,         圆角矩形      
    UIButtonTypeDetailDisclosure,    蓝色小箭头按钮，主要做详细说明用   
    UIButtonTypeInfoLight,           亮色感叹号   
    UIButtonTypeInfoDark,            暗色感叹号     
    UIButtonTypeContactAdd,          十字
```  
    btn.frame = CGRectMake(30, 360, 90, 35);//大小和位置    
	[btn setTitle:@"ZoomIn" forState:UIControlStateNormal];//正常状况下button显示的标题    
	[btn setTitle:@"ZoomIn" forState:UIControlStateHighlighted];//高亮显示时button的标题    
	[btn addTarget:self action:@selector(zoomInAction:) 	forControlEvents:UIControlEventTouchUpInside];//button被按下又抬起后发生的事
	
* UIImageView：用来放置图片的相关类   
	* 初始化：  
	UIImageView *imageView1 = [[UIImageView alloc] init];    
	UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:(CGRect)];   
	UIImageView *imageView3 = [[UIImageView alloc] initWithImage:(UIImage *)];    	UIImageView *imageView4 = [[UIImageView alloc] initWithImage:(UIImage *) highlightedImage:(UIImage *)];     
	UIImageView *imageView5 = [[UIImageView alloc] initWithCoder:(NSCoder *)];
	* frame和bound属性：   
	frame设置其位置和大小，而bounds只能设置其大小，其参数中的x、y不起作用即便是之前没有设定frame属性，控件最终的位置也不是bounds所设定的参数。bounds实现的是将UIImageView控件以原来的中心为中心进行缩放。例如有如下代码
	* contentMode属性：  
	这个属性是用来设置图片的显示方式，如居中、居右，是否缩放等
	* 为图片添加点击事件：  
	imageView.userInteractionEnabled = YES;    
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];     
	[imageView addGestureRecognizer:singleTap];
	
* UILabel：ios中的文字显示   
	* 初始化：    
	UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(50.0, 20.0, 200.0, 50.0)];
	* 设置文字：    
	label1.text = @"label1";
	* 设置字体：
	label1.font = [UIFont boldSystemFontOfSize:20];
	* 设置颜色：   
	label1.textColor = [UIColor orangeColor];     
	* 设置位置：   
	label1.textAlignment = UITextAlignmentRight; （左中右）
	* 设置行数：   
	 label1.numberOfLines = 2; 
	* 设置高亮：   
	label1.highlighted = YES;      
    label1.highlightedTextColor = [UIColor orangeColor];  
    * 设置阴影：      
    label1.shadowColor = [UIColor redColor];     
    label1.shadowOffset = CGSizeMake(1.0,1.0);   
    * 设置是否能与用户进行交互     
    label7.userInteractionEnabled = YES;  
* UINavigationBar：设置标题栏相关类
	* 初始化： 	
	UINavigationBar *navBar = self.navigationController.navigationBar;
	* 共有四种样式：  
	[navBar setBarStyle:UIBarStyleDefault]; 
	UIBarStyleDefault	默认样式      
	UIBarStyleBlack		黑色    
    UIBarStyleBlackOpaque    黑色不透明  
    UIBarStyleBlackTranslucent   黑色透明     
    后两种默认弃用。
        
    
    以下代码可以用来修改标题栏的背景，UIBarMetricsDefault为设置竖屏时的标准尺寸，UIBarMetricsLandscapePhone为横屏
    
   		 if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        	[navBar setBackgroundImage:[UIImage imageNamed:@"图片名称"]forBarMetrics:UIBarMetricsDefault];
        }
* UIScrollView：为可以拖动的组件。
	* 初始化：     
	UIScrollView *sv  =[[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.frame.size.width, 400)];     
	或CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame ] ;        
UIScrollView* scrollView = [ [UIScrollView alloc ] initWithFrame:bounds ];    
	* 属性：   
	CGSize contentSize ：设置UIScrollView的滚动范围    
	CGPoint contentOffset ：UIScrollView当前滚动的位置    
	UIEdgeInsets contentInset ：这个属性可以在四周增加滚动范围    
	BOOL bounces	是否有弹簧效果    
	BOOL scrollEnabled	是否能滚动    
	BOOL showsHorizontalScrollIndicator	是否显示水平方向的滚动条    
	BOOL showsVerticalScrollIndicator     是否显示垂直方向的滚动条    
	UIScrollViewIndicatorStyle indicatorStyle  设定滚动条的样式    
	BOOL dragging	 是否正在被拖拽   
	BOOL tracking  当touch后还没有拖动的时候值是YES，否则NO   
	BOOL decelerating	 是否正在减速    
	BOOL zooming	 是否正在缩放   
	
	* 手势缩放   
	设置UIScrollView的id<UISCrollViewDelegate> delegate代理对象   
	设置minimumZoomScale ：缩小的最小比例    
	设置maximumZoomScale ：放大的最大比例    
	让代理对象实现下面的方法，返回需要缩放的视图控件    
	-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView    
	跟缩放相关的常用方法还有    
	正在缩放的时候调用   
	-(void)scrollViewDidZoom:(UIScrollView *)scrollView
	缩放完毕的时候调用    
	-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
	
	* 分页效果   
	设置pagingEnabled=YES即可，UIScrollView会被分割成多个独立页面，用户的滚动体验则变成了页面翻转   
	一般会配合UIPageControl增强分页效果，UIPageControl常用属性：   
	NSInteger numberOfPages : 总页数   
	NSInteger currentPage : 当前的页码   
	BOOL hidesForSinglePage : 当只有一页的时候，是否要隐藏视图   
	监听UIPageControl的页面改变：  
	// 添加监听器   
	[pageControl addTarget:self action:@selector(pageChange:)   
	forControlEvents:UIControlEventValueChanged];  
	// 监听方法  
	-(void)pageChange:(UIPageControl *)pageControl   
	{   
	}
* UITabBar：ios中的标签类   
	* 初始化：
* UITableView：UITableView继承自UIScrollView，可以表现为Plain和Grouped两种风格
	* 初始化：    
		 UITableView *tableView = [[[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain] autorelease];
	* 设置属性：   
	/ 设置tableView的数据源     
    tableView.dataSource = self;     
    // 设置tableView的委托     
    tableView.delegate = self;    
    // 设置tableView的背景图  
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]]; 
    //设置每行内容   
    -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath     
	{  
    	static NSString *CellWithIdentifier = @"Cell";  
    	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];     
    	if (cell == nil) {  
        	cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellWithIdentifier];  
    	}  
    	NSUInteger row = [indexPath row];  
    	cell.textLabel.text = [self.dataList objectAtIndex:row];  
    	cell.imageView.image = [UIImage imageNamed:@"green.png"];  
    	cell.detailTextLabel.text = @"详细信息";  
    	return cell;  
	}
	//设置缩进   
	-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath  
	{  
    	return [indexPath row];  
	}
	//设置行高   
	-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
	{  
    	return 70;  
	}  
	//
* UITextField：ios中的输入框
	* 初始化：
		UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, 130, 30)]	
	* 设置：  
	//设置边框样式　   
  	text.borderStyle = UITextBorderStyleRoundedRect;
　	typedef enum {
    	UITextBorderStyleNone,   
    	UITextBorderStyleLine,  
    	UITextBorderStyleBezel,  
    	UITextBorderStyleRoundedRect     
  	} UITextBorderStyle;   
  	//设置输入框的背景颜色，此时设置为白色 如果使用了自定义的背景图片边框会被忽略掉　   
 	text.backgroundColor = [UIColor whiteColor];    
 	//设置背景   
  	text.background = [UIImage imageNamed:@"dd.png"]    
  	//设置输入框内容的字体样式和大小    
  	text.font = [UIFont fontWithName:@"Arial" size:20.0f];  
  	//设置字体颜色
  	text.textColor = [UIColor redColor];   
  	//输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容    
  	text.clearButtonMode = UITextFieldViewModeAlways;      
	typedef enum {     
    	UITextFieldViewModeNever,　从不出现   
    	UITextFieldViewModeWhileEditing, 编辑时出现   
    	UITextFieldViewModeUnlessEditing,　除了编辑外都出现   
    	UITextFieldViewModeAlways 　一直出现   
	} UITextFieldViewMode;     
	//每输入一个字符就变成点 用语密码输入    
  	text.secureTextEntry = YES;
  	//是否纠错     
  	text.autocorrectionType = UITextAutocorrectionTypeNo;   
	typedef enum {   
    	UITextAutocorrectionTypeDefault, 默认    
   	 	UITextAutocorrectionTypeNo, 　不自动纠错    
    	UITextAutocorrectionTypeYes,　自动纠错    
	} UITextAutocorrectionType;   
	//再次编辑就清空   
  	text.clearsOnBeginEditing = YES;     
	//内容对齐方式   
  	text.textAlignment = UITextAlignmentLeft;    
	//内容的垂直对齐方式  UITextField继承自UIControl,此类中有一个属性contentVerticalAlignment     
  	text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
	//设置为YES时文本会自动缩小以适应文本窗口大小.默认是保持原来大小,而让长文本滚动　    
  	textFied.adjustsFontSizeToFitWidth = YES;    
	//设置自动缩小显示的最小字体大小    
  	text.minimumFontSize = 20;   
  	//设置键盘的样式    
  	text.keyboardType = UIKeyboardTypeNumberPad;     
	typedef enum {     
    	UIKeyboardTypeDefault,     　默认键盘，支持所有字符           
    	UIKeyboardTypeASCIICapable,　支持ASCII的默认键盘    
    	UIKeyboardTypeNumbersAndPunctuation,　标准电话键盘，支持＋＊＃字符     
    	UIKeyboardTypeURL,            URL键盘，支持.com按钮 只支持URL字符    
		UIKeyboardTypeNumberPad,            　数字键盘    
		UIKeyboardTypePhonePad,　 　电话键盘    
    	UIKeyboardTypeNamePhonePad, 　电话键盘，也支持输入人名    
		UIKeyboardTypeEmailAddress, 　用于输入电子 邮件地址的键盘        
		UIKeyboardTypeDecimalPad,   　数字键盘 有数字和小数点    
    	UIKeyboardTypeTwitter,      　优化的键盘，方便输入@、#字符    
    	UIKeyboardTypeAlphabet = UIKeyboardTypeASCIICapable,     
	} UIKeyboardType;    
	//首字母是否大写     
  	text.autocapitalizationType = UITextAutocapitalizationTypeNone;   
	typedef enum {    
    	UITextAutocapitalizationTypeNone, 不自动大写       
    	UITextAutocapitalizationTypeWords,　单词首字母大写   
    	UITextAutocapitalizationTypeSentences,　句子的首字母大写   
    	UITextAutocapitalizationTypeAllCharacters, 所有字母都大写    
	} UITextAutocapitalizationType;    
 	//return键变成什么键     
 	text.returnKeyType =UIReturnKeyDone;      
	typedef enum {    
    	UIReturnKeyDefault, 默认 灰色按钮，标有Return       
    	UIReturnKeyGo,    　标有Go的蓝色按钮   
    	UIReturnKeyGoogle,标有Google的蓝色按钮，用语搜索   
    	UIReturnKeyJoin,标有Join的蓝色按钮   
    	UIReturnKeyNext,标有Next的蓝色按钮   
    	UIReturnKeyRoute,标有Route的蓝色按钮    
    	UIReturnKeySearch,标有Search的蓝色按钮     
    	UIReturnKeySend,标有Send的蓝色按钮     
    	UIReturnKeyYahoo,标有Yahoo的蓝色按钮     
    	UIReturnKeyYahoo,标有Yahoo的蓝色按钮      
    	UIReturnKeyEmergencyCall, 紧急呼叫按钮     
	} UIReturnKeyType;     
 	//键盘外观    
 	textView.keyboardAppearance=UIKeyboardAppearanceDefault；     
	typedef enum {      
		UIKeyboardAppearanceDefault， 默认外观，浅灰色     
		UIKeyboardAppearanceAlert，　 　深灰 石墨色      
	} UIReturnKeyType;
	//设置代理 用于实现协议     
  	text.delegate = self;    
	//把textfield加到视图中     
  	[self.window addSubview:text];     
 	//最右侧加图片是以下代码　 左侧类似    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];     
    text.rightView=image;    
    text.rightViewMode = UITextFieldViewModeAlways;     
	typedef enum {    
    	UITextFieldViewModeNever,     
    	UITextFieldViewModeWhileEditing,    
    	UITextFieldViewModeUnlessEditing,     
    	UITextFieldViewModeAlways    
	} UITextFieldViewMode;            
	//按return键键盘往下收  becomeFirstResponder类要采用UITextFieldDelegate协议   
	text.delegate = self;　声明text的代理是self，self会去实现把键盘往下收的方法 这个方法在	UITextFieldDelegate里所以要采用UITextFieldDelegate这个协议     
	-(BOOL)textFieldShouldReturn:(UITextField *)textField     
	{      
    	[text resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收     
		return YES;     
	}
* UITextView：ios中的文本框
	* 初始化：		
	self.textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];    
	* 设置：    
	self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色    
 	self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小    
 	self.textView.delegate = self;//设置它的委托方法    
 	self.textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色     
	self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";//设置它显示的内容    
 	self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型      
 	self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型    
 	self.textView.scrollEnabled = YES;//是否可以拖动    
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度    
	[self.view addSubview: self.textView];//加入到整个页面中    
* UIToolbar：ios中的工具栏   
	* 初始化：
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
* UIView：   
	UIView类用于实现视图。    
    UIView提供了方法来添加和删除子视图。一个视图可以有多个子视图,这些子视图按照顺序放在父窗口下:    
      	-(void) addSubview:(UIView *)view;//添加子视图      
      	-(void) removeFromSuperview;//从父窗口上删除子视图（自己）   
      	-(void) insertSubview:(UIView *)view atIndex:(int)index;//按照顺序添加子视图   
      	-(void) insertSubview:(UIView *)view belowSubview:(UIView *)view;   
      	-(void) insertSubview:(UIView *)view belowSubview:(UIView *)view;    
      	-(void) insertSubview:(UIView *)view belowSubview:(UIView *)view;   
      	-(void) exchangeSubviewAtIndex:(int) indexwithSubviewAtIndex:(int)otherIndex;   
  视图结构的相关函数        
       	CGPointMake（x,y）                              
       	CGPoint point=CGPointMake(50.0,50.0);  
       	声明位置的信息                                       
       	point.x=50.0;
       	point.y=50.0;     
       	CGSizeMake(width,height)
       	声明大小的信息                                       
       	CGSize size=CGSizeMake(200.0,100.0);    
       	size.width=200.0;     
       	size.height=200.0;
 		CGRectMake(x,y,width,height)               
      	CGRect rect=CGRectMake(50.0,50.0,200.0,200.0)
      	声明位置和大小信息                                  
      	rect.origin.x=50.0;
	  	rect.size.width=200.0;    
	Frame和Bound         
	视图的大小和位置用两种方式表示。一种方式是Frame（框架），即以其父视图为起点，得出它自己的信息。另一种方式是Bound（界限），即以它自己为起点，得到其位置。     
    其实，系统内部存放的是图的中心点位置和大小信息。Frame方式的信息是按照中心点位置计算出来的。当我们创建一个视图的时，我们往往采用Frame方式。当我们旋转一个视图或者处理视图事件时，我们大多采用Bound方式。      
	
* UIWebView：ios中内置的浏览器控件
	* 初始化：   
		CGRect bouds = [[UIScreen manScreen]applicationFrame];  
		UIWebView* webView = [[UIWebView alloc]initWithFrame:bounds]; 
	* 应用：    
		webView.scalespageToFit = YES;//自动对页面进行缩放以适应屏幕   
		webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打    
		[self.view addSubview:webView];  //显示网页视图    
		NSURL* url = [NSURL URLWithString:@"http://www.youku.com"];//创建URL  
		NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest   
		[webView loadRequest:request];//加载    
		--导航     
		[webView goBack];  
		[webView goForward];  
		[webView reload];//重载   
		[webView stopLoading];//取消载入内容  