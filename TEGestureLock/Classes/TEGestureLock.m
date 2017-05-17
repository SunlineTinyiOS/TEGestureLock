//
//  GestureLock.h
//  TinyEmbed
//
//  Created by xiangfp on 15/7/6.
//  Copyright (c) 2015年 Sunline. All rights reserved.
//


#import "TEGestureLock.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSBundle+TEGestrueLock.h"
#import "UIImage+TEGestrueLock.h"

static const NSUInteger kNumberOfButtons    = 9;
static const NSUInteger kButtonsPerRow      = 3;
//static const CGSize kButtonDefaultSize      = { 60, 60 };
static const CGFloat kLineDefaultWidth      = 10;

static NSString* const kButtonNormalImageName = @"TEGestureLock.bundle/gesture_lock_button_normal";
static NSString* const kButtonSelectImageName = @"TEGestureLock.bundle/gesture_lock_button_select";
//static NSString* const kButtonNormalImageName = @"gesture_lock_button_normal";
//static NSString* const kButtonSelectImageName = @"gesture_lock_button_select";
static NSString* const kOnCompleteTag       = @"oncomplete";
static NSString* const kErrCompleteTag       = @"errcomplete";

@interface TEGestureLock ()
// 密码节点按钮
@property (nonatomic, retain, readwrite) NSMutableArray* buttons;
// 选中按钮
@property (nonatomic, retain, readwrite) NSMutableArray* selectedButtons;
// 容器视图
@property (nonatomic, retain, readwrite) UIView* contentView;
// 正在跟踪的按下位置
@property (nonatomic, retain) NSValue* trackedGSPoint;
//最少密码节点个数
@property (nonatomic, assign) int minpwd;
//最大错误次数
@property (nonatomic, assign) int maxerr;
//当前错误次数
@property (nonatomic, assign) int currErrTime;
//页面停留时间
@property (nonatomic, assign) NSTimeInterval timeout;
//stateLabel距离顶部button的距离
@property (nonatomic, assign) int kLabelHeight;

@property (nonatomic, assign) CGSize kButtonDefaultSize;


@end

@implementation TEGestureLock
@synthesize kButtonDefaultSize;


- (id)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentInsets = UIEdgeInsetsZero;
        
        self.contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.contentView];
        
        self.lineColor = [UIColor colorWithRed:6.0/255 green:112.0/255 blue:154.0/255 alpha:0.6];
        self.lineWidth = kLineDefaultWidth;
        
        self.selectedButtons = [NSMutableArray array];
        
        
        self.normalButtonImage = [UIImage imageNamed:kButtonNormalImageName];
        self.selectedButtonImage = [UIImage imageNamed:kButtonSelectImageName];
        
//        self.normalButtonImage = [UIImage TEGestrueLockImageNamed:kButtonNormalImageName];
//        self.selectedButtonImage = [UIImage TEGestrueLockImageNamed:kButtonSelectImageName];
        
        //隐藏手势密码的轨迹
        NSString *isGestureTrace = [[NSUserDefaults standardUserDefaults] objectForKey:@"isGestureTrace"];
        NSString *isGestureTraceStr = [NSString stringWithFormat:@"%@",isGestureTrace];
        if ([isGestureTraceStr isKindOfClass:[NSString class]])
        {
            if([isGestureTraceStr isEqualToString:@"0"]){
                self.selectedButtonImage = [UIImage imageNamed:kButtonNormalImageName];
//                 self.selectedButtonImage = [UIImage TEGestrueLockImageNamed:kButtonNormalImageName];
                self.lineColor = [UIColor clearColor];
            }
            else{
                self.selectedButtonImage = [UIImage imageNamed:kButtonSelectImageName];
//                self.selectedButtonImage = [UIImage TEGestrueLockImageNamed:kButtonSelectImageName];
                self.lineColor = [UIColor colorWithRed:6.0/255 green:112.0/255 blue:154.0/255 alpha:0.6];
            }
        }
        
        // 这两个属性必须在最后设置 !!!
        self.numberOfButtons = kNumberOfButtons;
        self.buttonsPerRow = kButtonsPerRow;
        
        //最少节点个数
        self.minpwd = 5;
        
        self.kLabelHeight = 0;
        
        self.timeout = 100;
    }
    return self;
}

- (UIImage *)gesImageWithPassword:(NSString *)pwd{
    if (!pwd) {
        pwd = @"";
    }
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 2.0);
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.082 green: 0.855 blue: 0.996 alpha: 1];
    UIColor* colorLine = [UIColor colorWithRed: 0.8 green: 0.8 blue: 0.8 alpha: 0.7];
    NSArray *frames = @[[NSValue valueWithCGRect:CGRectMake(1.5, 1.5, 7, 7)],//0
                        [NSValue valueWithCGRect:CGRectMake(11.5, 1.5, 7, 7)],//1
                        [NSValue valueWithCGRect:CGRectMake(21.5, 1.5, 7, 7)],//2
                        [NSValue valueWithCGRect:CGRectMake(1.5, 11.5, 7, 7)],//3
                        [NSValue valueWithCGRect:CGRectMake(11.5, 11.5, 7, 7)],//4
                        [NSValue valueWithCGRect:CGRectMake(21.5, 11.5, 7, 7)],//5
                        [NSValue valueWithCGRect:CGRectMake(1.5, 21.5, 7, 7)],//6
                        [NSValue valueWithCGRect:CGRectMake(11.5, 21.5, 7, 7)],//7
                        [NSValue valueWithCGRect:CGRectMake(21.5, 21.5, 7, 7)]];//8
    
    for (int i = 0; i<frames.count; i++) {
        NSRange range = [pwd rangeOfString:[@(i) stringValue]];
        CGRect frame = [frames[i] CGRectValue];
        if (range.location != NSNotFound) { //有密码
            //// Oval0 Drawing
            UIBezierPath* oval0Path = [UIBezierPath bezierPathWithOvalInRect: frame];
            [color setFill];
            [oval0Path fill];
            [color setStroke];
            oval0Path.lineWidth = 1;
            [oval0Path stroke];
        }else{                              //无密码
            //// Oval2 Drawing
            UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: frame];
            [colorLine setStroke];
            oval2Path.lineWidth = 1;
            [oval2Path stroke];
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect tempRect = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    self.contentView.frame = tempRect;
    
    float btnWidth = tempRect.size.width / 3;
    kButtonDefaultSize = CGSizeMake(btnWidth, btnWidth);
    
    CGFloat hButtonMargin = (self.contentView.bounds.size.width - kButtonDefaultSize.width * self.buttonsPerRow) / (self.buttonsPerRow - 1);
    NSUInteger numberOfRows = ceilf((self.numberOfButtons * 1.0 / self.buttonsPerRow));
    CGFloat vButtonMargin = (self.contentView.bounds.size.height - kButtonDefaultSize.height * numberOfRows-self.kLabelHeight) / (numberOfRows - 1);
    
    for (NSInteger i = 0; i < self.numberOfButtons; ++i) {
        NSInteger row = i / self.buttonsPerRow;
        NSInteger column = i % self.buttonsPerRow;
        UIButton* button = self.buttons[i];
        button.frame =
        CGRectMake(
                   floorf((kButtonDefaultSize.width + hButtonMargin) * column),
                   floorf((kButtonDefaultSize.height + vButtonMargin) * row)+self.kLabelHeight,
                   kButtonDefaultSize.width,
                   kButtonDefaultSize.height
                   );
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    if ([self.selectedButtons count] > 0) {
        
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        UIButton* firstButton = self.selectedButtons[0];
        [bezierPath moveToPoint:[self convertPoint:firstButton.center fromView:self.contentView]];
        
        for (NSUInteger i = 1; i < [self.selectedButtons count]; ++i) {
            UIButton* button = self.selectedButtons[i];
            [bezierPath addLineToPoint:[self convertPoint:button.center fromView:self.contentView]];
        }
        
        
        if (self.trackedGSPoint != nil) {
            CGPoint startGSPoint = [self.trackedGSPoint CGPointValue];
            
            [bezierPath addLineToPoint:[self convertPoint:startGSPoint fromView:self.contentView]];
        }
        
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [bezierPath setLineWidth:self.lineWidth];
        [self.lineColor setStroke];
        
        [bezierPath stroke];
    }
}

#pragma mark Private Methods
// 创建纯色图片
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
// 查找包含某点的按钮
- (UIButton*)buttonContainsPoint:(CGPoint)point
{
    for (UIButton* __button in self.buttons) {
        if (CGRectContainsPoint(__button.frame, point)) {
            return __button;
        }
    }
    return nil;
}

#pragma mark Mouse Input
// 点下开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint testPoint = [touch locationInView:self.contentView];
    
    UIButton* hittedButton = [self buttonContainsPoint:testPoint];
    if (hittedButton) {
        hittedButton.selected = YES;
        [self.selectedButtons addObject:hittedButton];
        [self setNeedsDisplayInRect:hittedButton.frame];
    }
    self.trackedGSPoint = [NSValue valueWithCGPoint:testPoint];
}
// 点下移动中
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint testPoint = [touch locationInView:self.contentView];
    
    if (CGRectContainsPoint(self.contentView.bounds, testPoint)) {
        UIButton* hittedButton = [self buttonContainsPoint:testPoint];
        if (hittedButton && ![self.selectedButtons containsObject:hittedButton]) {
            hittedButton.selected = YES;
            [self.selectedButtons addObject:hittedButton];
        }
        self.trackedGSPoint = [NSValue valueWithCGPoint:testPoint];
        if (hittedButton != nil || self.selectedButtons.count != 0) {
            // 如果当前点在按钮上; 或者, 当前没有点中按钮, 但已经有按钮选中, 才需要重绘
            NSMutableArray* passwords = [NSMutableArray arrayWithCapacity:self.selectedButtons.count];
            for (UIButton* __button in self.selectedButtons) {
                NSUInteger idx = [self.buttons indexOfObject:__button];
                [passwords addObject:@(idx)];
            }
            NSString *pwd = [[NSString alloc] initWithString:[passwords componentsJoinedByString:@"|"]];
            //第一次手势密码不存在 或则  第一次手势密码存在且前后2次密码相同时
            if (!self.firstPassword || (self.firstPassword && [pwd isEqualToString:self.firstPassword])) {
                _stateImageView.image = [self gesImageWithPassword:pwd];
            }
            
            
            [self setNeedsDisplay];
        }
    }

    
}
// 点下结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.selectedButtons count]==0) {
        return;
    }
    
    NSMutableArray* passwords = [NSMutableArray arrayWithCapacity:self.selectedButtons.count];
    for (UIButton* __button in self.selectedButtons) {
        __button.selected = NO;
        
        NSUInteger idx = [self.buttons indexOfObject:__button];
        [passwords addObject:@(idx)];
    }
    [self.selectedButtons removeAllObjects];
    self.trackedGSPoint = nil;
    [self setNeedsDisplay];
    [self nitifyWithPasswords:passwords];
}

// 点下取消(来电等情况)
- (void)touchCancel:(id)sender event:(UIEvent *)event
{
    NSMutableArray* passwords = [NSMutableArray arrayWithCapacity:self.selectedButtons.count];
    
    for (UIButton* __button in self.selectedButtons) {
        __button.selected = NO;
        NSUInteger idx = [self.buttons indexOfObject:__button];
        [passwords addObject:@(idx)];
    }
    [self.selectedButtons removeAllObjects];
    self.trackedGSPoint = nil;
    [self setNeedsDisplay];
    
    [self nitifyWithPasswords:passwords];
}
// 通知密码给回调
- (void)nitifyWithPasswords:(NSArray*)passwords
{
    if (passwords.count != 0) {
        NSString* value = [passwords componentsJoinedByString:@""];
        NSString *md5 = [self calcMD5:value];
        NSArray *array = @[@(passwords.count), md5];
        [self executiveEvent:@"touchesEnd" array:array];
    }
}

-(void)executiveEvent:(NSString *)event array:(NSArray *)array
{
    UIView *supView = self.superview;
    if([supView respondsToSelector:@selector(executiveEvent: array:)]) {
        [supView performSelector:@selector(executiveEvent: array:) withObject:event withObject:array];
    }
}

#pragma mark Getter & Setter
- (void)setNumberOfButtons:(NSUInteger)numberOfButtons
{
    if (_numberOfButtons != numberOfButtons) {
        NSUInteger oldNumOfButtons = _numberOfButtons;
        _numberOfButtons = numberOfButtons;
        NSInteger delta = numberOfButtons - oldNumOfButtons;
        
        // 更新按钮
        if (delta > 0) { // 增多
            if (self.buttons == nil) {
                self.buttons = [NSMutableArray arrayWithCapacity:numberOfButtons];
            }
            for (NSInteger i = 0; i < numberOfButtons; ++i) {
                if (i >= oldNumOfButtons) {
                    UIButton* button = [[UIButton alloc] init];
                    CGRect frame = button.frame;
                    frame.size = kButtonDefaultSize;
                    button.frame = frame;
                    button.backgroundColor = [UIColor clearColor];
                    button.userInteractionEnabled = NO;
                    
                    [button setImage:self.normalButtonImage forState:UIControlStateNormal];
                    [button setImage:self.selectedButtonImage forState:UIControlStateSelected];
                    
                    [self.contentView addSubview:button];
                    [self.buttons addObject:button];
                }
            }
        } else { // 减小
            if (numberOfButtons == 0) {
                for (UIButton* __button in self.buttons) {
                    [__button removeFromSuperview];
                }
                self.buttons = nil;
            } else {
                for (NSInteger i = 0; i < (-delta); ++i) {
                    [[self.buttons lastObject] removeFromSuperview];
                    [self.buttons removeLastObject];
                }
            }
            NSAssert(self.buttons.count == numberOfButtons, nil);
        }
        
        [self setNeedsLayout];
    }
}

- (void)setButtonsPerRow:(NSUInteger)buttonsPerRow
{
    if (_buttonsPerRow != buttonsPerRow) {
        _buttonsPerRow = buttonsPerRow;
        
        [self setNeedsLayout];
    }
}

- (NSString *)calcMD5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(void)setParam:(NSString *)name :(id)value{
    if([name isEqualToString:@"disable"]) {
        self.userInteractionEnabled = NO;
    }
    else if([name isEqualToString:@"lineColor"]) {
        //隐藏手势密码的轨迹
        NSString *isGestureTrace = [[NSUserDefaults standardUserDefaults] objectForKey:@"isGestureTrace"];
        NSString *isGestureTraceStr = [NSString stringWithFormat:@"%@",isGestureTrace];
        if ([isGestureTraceStr isKindOfClass:[NSString class]])
        {
            if([isGestureTraceStr isEqualToString:@"0"]){
                self.lineColor = [UIColor clearColor];
            }
            else{
                self.lineColor = [self colorWithHex:value andAlpha:1];
            }
        }
    }
}
- (UIColor*)colorWithHex:(NSString*)hex andAlpha:(float)alpha{
    hex = [hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!hex || [hex length] != 7) {
        return [UIColor clearColor];
    }
    
    unsigned red = 256, green = 256, blue = 256;
    
    NSRange redRange = {1,2};
    NSScanner *scanner = [NSScanner scannerWithString:[hex substringWithRange:redRange]];
    [scanner scanHexInt:&red];
    
    NSRange greenRange = {3,2};
    scanner = [NSScanner scannerWithString:[hex substringWithRange:greenRange]];
    [scanner scanHexInt:&green];
    
    NSRange blueRange = {5,2};
    scanner = [NSScanner scannerWithString:[hex substringWithRange:blueRange]];
    [scanner scanHexInt:&blue];
    
    if (red == 256 || green == 256 || blue == 256) {
        return nil;
    }
    else {
        return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
    }
}



@end
