//
//  CustomButton.m
//  MLEmojiLabel
//
//  Created by Mac on 15/3/23.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

-(id)initWithFrame:(CGRect)frame WithRowClick:(BOOL)isClick{
    
    if ([super initWithFrame:frame]) {
        
        frame = CGRectMake(5, 2, frame.size.width - 10, frame.size.height - 4);
        _emojiLabel = [[MLEmojiLabel alloc] initWithFrame:frame];
        _emojiLabel.numberOfLines = 0;
        _emojiLabel.font = [UIFont systemFontOfSize:15.0f];
        [_emojiLabel setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapclick:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        if (isClick) {
        
            //self.enabled = YES;
            
        }
        
        [self addSubview:_emojiLabel];
        
    }
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)onTapclick:(UITapGestureRecognizer *)sender{
    CustomButton* obj = (CustomButton *)sender.view;
    NSLog(@"%@",obj.emojiLabel);
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scrollShowView" object:nil];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{

    [gestureRecognizer.view setBackgroundColor:[UIColor clearColor]];
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    BOOL isSelect = ![_emojiLabel containslinkAtPoint:[touch locationInView:_emojiLabel]];
    if (isSelect) {
        [gestureRecognizer.view setBackgroundColor:[UIColor lightGrayColor]];
    }
    return isSelect;
}

@end
