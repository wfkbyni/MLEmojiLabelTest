//
//  TestTableViewCell.h
//  MLEmojiLabel
//
//  Created by Mac on 15/3/23.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface TestTableViewCell : UITableViewCell<MLEmojiLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *replyView;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UIImageView *supportImageView;
@property (weak, nonatomic) IBOutlet UIImageView *replyImageView;

@property (nonatomic, strong) CustomButton *customBtn;

+ (CGFloat)heightForEmojiText:(NSString*)emojiText;

+ (CGFloat)replyContentHeight:(NSMutableArray *)replys;

/**
 *  获取文字的宽度和高度
 *
 *  @param fontSize 文字大小
 *  @param content  文字
 *  @param size     所占view的宽度和高度
 *
 *  @return 文字的宽度和高度
 */
+ (CGSize)getNSStringWidthOrHeight:(int)fontSize :(NSString*)content :(CGSize)size;

- (void)configCell:(NSMutableDictionary *)dic;

@end
