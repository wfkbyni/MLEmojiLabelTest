//
//  ReplyView.m
//  MLEmojiLabel
//
//  Created by Mac on 15/3/25.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "ReplyView.h"

#define screenframe [[UIApplication sharedApplication].windows[0] bounds]
#define placeholder @"请发表回复内容"
#define contentHeight 200

@interface ReplyView()
{
    UIView* contentView;
}
@end

@implementation ReplyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithShowTitle:(NSString *)title{
    
    if ([super initWithFrame:screenframe]) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:YES];
        
        
        // 背景view
        UIView *bgView = [[UIView alloc] initWithFrame:screenframe];
        [bgView setBackgroundColor:[UIColor lightGrayColor]];
        [bgView setAlpha:0.95];
        [self addSubview:bgView];
        
        UITapGestureRecognizer *hiddenGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGesture)];
        [bgView addGestureRecognizer:hiddenGesture];
        
        // 内容区域
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, CGRectGetWidth(screenframe), contentHeight)];
        [contentView setAlpha:0.9];
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        // 添加一个取消按钮
        [contentView addSubview:[self cancelBtn]];
        
        // 添加一个确定按钮
        [contentView addSubview:[self selectBtn]];
        
        // 添加一个标题按钮
        [contentView addSubview:[self titleLabel:title]];
        
        // 添加一条分隔线
        [contentView addSubview:[self lineView]];
        
        // 添加一个textview
        [contentView addSubview:[self textView]];
        
        [self addSubview:contentView];
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillShow:)
         
                                                     name:UIKeyboardWillShowNotification
         
                                                   object:nil];
        
        
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillHide:)
         
                                                     name:UIKeyboardWillHideNotification
         
                                                   object:nil];
        
    }
    
    return self;
}

#define btnWidth  32            // 按钮的宽度
#define btnHeight btnWidth      // 按钮的高度
#define line 5                  // 距离左边和右边的间隔
#define offsetTop 3             // 距离上面的间隔
- (UIButton*)cancelBtn{
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(line, offsetTop, btnWidth, btnHeight);
    [cancelBtn setBackgroundColor:[UIColor redColor]];
    [cancelBtn addTarget:self action:@selector(hiddenReplyView) forControlEvents:UIControlEventTouchUpInside];
    
    return cancelBtn;
}

- (UIButton*)selectBtn{
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(CGRectGetWidth(screenframe) - btnWidth - line,offsetTop, btnWidth, btnHeight);
    [selectBtn setBackgroundColor:[UIColor redColor]];
    
    return selectBtn;
}

- (UILabel*)titleLabel:(NSString *)title{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(btnWidth + line * 2, offsetTop, CGRectGetWidth(screenframe) - btnWidth * 2 - line * 4, btnHeight)];
    
    [titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    return titleLabel;
}

- (UIView*)lineView{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(line, offsetTop + btnHeight + offsetTop + 2, CGRectGetWidth(screenframe) - line * 2, 0.5)];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
    return lineView;
}

- (UITextView *)textView{

    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(line, offsetTop * 3 + btnHeight, CGRectGetWidth(screenframe) - line * 2, 200 - btnHeight - offsetTop * 3)];
        _textView.delegate = self;
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        
        if (_placeholderLabel == nil) {
            CGRect frame = _textView.frame;
            frame.origin.x = CGRectGetMinX(frame) + 3;
            frame.origin.y = 6.5;
            frame.size.width = CGRectGetWidth(frame) - 10;
            frame.size.height = 21;
            _placeholderLabel = [[UILabel alloc] initWithFrame:frame];
            
            [_placeholderLabel setTextColor:[UIColor lightGrayColor]];
            [_placeholderLabel setText:placeholder];
            [_placeholderLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
            [_textView addSubview:_placeholderLabel];
        }
    }
    
    return _textView;
}


-(void)textViewDidChange:(UITextView *)textView
{
    self.placeholderLabel.text = textView.text;
    if (textView.text.length == 0) {
        self.placeholderLabel.text = placeholder;
    }else{
        self.placeholderLabel.text = @"";
    }
}


- (void)hiddenGesture{
    [self hiddenReplyView];
}

- (void)showReplyView{
    [_textView becomeFirstResponder];
    
    __weak ReplyView *weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        [weakSelf setAlpha:1];
    } completion:^(BOOL finished) {
        [weakSelf setHidden:NO];
    }];
}

- (void)hiddenReplyView{
    
    [_textView resignFirstResponder];
    
    __weak ReplyView *weakSelf = self;
    [UIView animateWithDuration:0.2f animations:^{
        [weakSelf setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakSelf setHidden:YES];
    }];
}

// 当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification{
    // 获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    int height = keyboardRect.size.height;
    
    float screnHeihgt = screenframe.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        float offset = screnHeihgt - contentHeight - height;
        
        CGRect frame = contentView.frame;
        frame.origin.y = offset;
        
        contentView.frame = frame;
    }];
}


// 当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    
    float screnHeihgt = screenframe.size.height;
    
    CGRect frame = contentView.frame;
    frame.origin.y = screnHeihgt - contentHeight;
    contentView.frame = frame;
}

@end
