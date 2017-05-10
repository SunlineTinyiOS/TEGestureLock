//
//  GestureLockView.h
//  Breeze2.1.1
//
//  Created by LingBinXing on 14-4-25.
//
//

#import <UIKit/UIKit.h>

@interface TEGestureLock : UIView
{
    BOOL    _isCheckPasswordState;
}
@property (nonatomic,retain)UIImageView *stateImageView;

@property (nonatomic,retain)NSString *firstPassword;
// 全部按钮
@property (nonatomic, retain, readonly) NSMutableArray* buttons;
// 选中的按钮
@property (nonatomic, retain, readonly) NSMutableArray* selectedButtons;

// 总按钮数，默认 9
@property (nonatomic, assign) NSUInteger numberOfButtons;
// 每行按钮数，默认 3
@property (nonatomic, assign) NSUInteger buttonsPerRow;

@property (nonatomic, retain) UIImage* normalButtonImage;
@property (nonatomic, retain) UIImage* selectedButtonImage;

@property (nonatomic, retain) UIColor* lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

// buttons 的容器
@property (nonatomic, retain, readonly) UIView *contentView;
// 容器距离此 view 的边距
@property (nonatomic, assign) UIEdgeInsets contentInsets;

//taojl 说明text
@property (nonatomic, retain) UILabel *stateLabel;
@end
