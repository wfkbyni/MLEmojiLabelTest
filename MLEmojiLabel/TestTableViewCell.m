//
//  TestTableViewCell.m
//  MLEmojiLabel
//
//  Created by Mac on 15/3/23.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "TestTableViewCell.h"
#import "MLEmojiLabel.h"

#define kWidth [[UIApplication sharedApplication].windows[0] bounds].size.width - 20


@implementation TestTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(NSMutableDictionary *)dic{
    
    [self clearView];
    
    self.title.text = [dic valueForKey:@"title"];
    
    NSString* support = [dic valueForKey:@"support"];
    
    NSMutableArray *replys = [dic valueForKey:@"replys"];
    // 封装赞和回复view
    [self commViewWithSupport:support withReply:replys];
}

- (void)commViewWithSupport:(NSString *)support withReply:(NSMutableArray *)replys{
    
    
    CGRect frame = CGRectMake(30, 0, CGRectGetWidth(self.replyView.frame) - 35,
                              [TestTableViewCell getNSStringWidthOrHeight:15 :support :CGSizeMake(CGRectGetWidth(self.replyView.frame) - 10, 1000)].height + 10);
    _customBtn = [[CustomButton alloc] initWithFrame:frame WithRowClick:YES];
    _customBtn.emojiLabel.text = support;
    _customBtn.emojiLabel.delegate = self;
    [self.replyView addSubview:_customBtn];
    
    frame = self.supportImageView.frame;
    frame.origin.y = 3;
    frame.size.width = 24;
    frame.size.height = 24;
    self.supportImageView.frame = frame;
    
    
    __block NSArray *supports = [support componentsSeparatedByString:@" ,"];
    [_customBtn.emojiLabel setText:support afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        if (supports.count > 0) {
            for (int i = 0; i < supports.count - 1; i++) {
                NSString *str = [NSString stringWithFormat:@"%@ ,",supports[i]];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.313 green:0.479 blue:1.000 alpha:1.000] range:[support rangeOfString:str]];
                
                
            }
        }
        
        return mutableAttributedString;
    }];
    
    if (supports == nil || supports.count == 0) {
        self.supportImageView.hidden = YES;
    }else{
        self.supportImageView.hidden = NO;
    }
    
    if (supports.count > 0) {
        for (int i = 0; i < supports.count - 1; i++) {
            NSString *str = [NSString stringWithFormat:@"%@",supports[i]];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setValue:str forKey:@"name"];
            [_customBtn.emojiLabel addLinkToTransitInformation:dic withRange:[support rangeOfString:str]];
        }
    }
    
    // 计算回复内容的高度
    float replyConthehHeight = [TestTableViewCell replyContentHeight:replys];
    
    frame = self.replyView.frame;
    frame.size.height = CGRectGetHeight(_customBtn.frame) + replyConthehHeight;
    self.replyView.frame = frame;
    
    int offset = CGRectGetMaxY(_customBtn.frame);
    
    int i = 0;
    
    if (replys == nil || replys.count == 0) {
        self.replyImageView.hidden = YES;
    }else{
        self.replyImageView.hidden = NO;
    }
    
    // 循环回复人
    for (NSDictionary *dic in replys) {
        NSString *name = [dic valueForKey:@"Name"];
        NSString *replyContent = [dic valueForKey:@"Content"];
        
        NSString *content = [NSString stringWithFormat:@"%@ : %@",name,replyContent];
        
        CGRect frame = CGRectMake(30, offset, CGRectGetWidth(self.replyView.frame) - 35,
                                  [TestTableViewCell getNSStringWidthOrHeight:15 :content :CGSizeMake(CGRectGetWidth(self.replyView.frame) - 35, 1000)].height + 10);
        _customBtn = [[CustomButton alloc] initWithFrame:frame WithRowClick:NO];
        _customBtn.emojiLabel.text = content;
        _customBtn.emojiLabel.delegate = self;
        [self.replyView addSubview:_customBtn];
        
        if (i == 0) {
            frame = self.replyImageView.frame;
            frame.origin.y = offset + 3;
            frame.size.width = 24;
            frame.size.height = 24;
            self.replyImageView.frame = frame;
        }
        i++;
        
        offset += CGRectGetHeight(_customBtn.frame);
        
        [_customBtn.emojiLabel setText:content afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
           
            [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.313 green:0.479 blue:1.000 alpha:1.000] range:[content rangeOfString:name]];
            
            return mutableAttributedString;
        }];
        
        [_customBtn.emojiLabel addLinkToTransitInformation:dic withRange:[content rangeOfString:name]];
    }
    
}

- (void)clearView{
    for (UIView *view in self.replyView.subviews) {
        if ([view isKindOfClass:[CustomButton class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - 计算回复内容的高度
+(CGFloat)replyContentHeight:(NSMutableArray *)replys{
    
    float height = 0;
    
    for (NSDictionary *dic in replys) {
        
        NSString *name = [dic valueForKey:@"Name"];
        NSString *replyContent = [dic valueForKey:@"Content"];
        
        NSString *content = [NSString stringWithFormat:@"%@:%@",name,replyContent];
        
        height += [TestTableViewCell getNSStringWidthOrHeight:15 :content :CGSizeMake(kWidth - 35, 10000)].height + 10;
    }
    
    return height;
}

#pragma mark - height
+ (CGFloat)heightForEmojiText:(NSString*)emojiText
{
    static MLEmojiLabel *protypeLabel = nil;
    if (!protypeLabel) {
        protypeLabel = [MLEmojiLabel new];
        protypeLabel.numberOfLines = 0;
        protypeLabel.font = [UIFont systemFontOfSize:14.0f];
        protypeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        protypeLabel.textInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        protypeLabel.isNeedAtAndPoundSign = YES;
        protypeLabel.disableEmoji = NO;
        protypeLabel.lineSpacing = 3.0f;
        
        protypeLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentCenter;
        
        //        protypeLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        //        protypeLabel.customEmojiPlistName = @"expressionImage_custom.plist";
    }
    
    [protypeLabel setText:emojiText];
    
    return [protypeLabel preferredSizeWithMaxWidth:kWidth].height+5.0f*2;
}

+(CGSize)getNSStringWidthOrHeight:(int)fontSize :(NSString *)content :(CGSize)size{
    
    if (content == nil || content.length == 0) {
        return CGSizeZero;
    }
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:content
                                                                                      attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:1];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [attributedStr length])];
    
    CGSize textSize = [attributedStr boundingRectWithSize:size
                                                  options:
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                                  context:nil].size;
    return textSize;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.title.frame;
    frame.size.height = [TestTableViewCell getNSStringWidthOrHeight:15 :self.title.text :CGSizeMake(kWidth, 10000)].height;
    self.title.frame = frame;
    
    CGRect vframe = self.actionView.frame;
    vframe.origin.y = CGRectGetMaxY(self.title.frame);
    self.actionView.frame = vframe;
    
    vframe = self.replyView.frame;
    vframe.origin.y = CGRectGetMaxY(self.actionView.frame);
    self.replyView.frame = vframe;
}

#pragma mark -- TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    NSLog(@"%@",components);
}

@end
