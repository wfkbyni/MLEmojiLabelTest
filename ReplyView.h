//
//  ReplyView.h
//  MLEmojiLabel
//
//  Created by Mac on 15/3/25.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReplyView : UIView<UITextViewDelegate>

- (instancetype)initWithShowTitle:(NSString *)title;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholderLabel;

- (void)showReplyView;
- (void)hiddenReplyView;

@end
