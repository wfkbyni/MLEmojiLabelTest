//
//  CustomButton.h
//  MLEmojiLabel
//
//  Created by Mac on 15/3/23.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface CustomButton : UIButton<UIGestureRecognizerDelegate>

@property (nonatomic, strong) MLEmojiLabel *emojiLabel;

- (id)initWithFrame:(CGRect)frame WithRowClick:(BOOL)isClick;

@end
