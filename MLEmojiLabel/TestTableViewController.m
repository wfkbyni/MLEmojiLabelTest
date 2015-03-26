//
//  TestTableViewController.m
//  MLEmojiLabel
//
//  Created by Mac on 15/3/23.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "TestTableViewController.h"
#import "TestTableViewCell.h"
#import "ReplyView.h"


#define kWidth [[UIApplication sharedApplication].windows[0] bounds].size.width
#define kHeight [[UIApplication sharedApplication].windows[0] bounds].size.height
@interface TestTableViewController ()
{
    NSMutableArray *arrays;
    
    ReplyView *replyView;
}
@end

#define kTempText @"风头痛医头让人头疼头疼如同讨厌团团圆圆天然淘汰讨厌雨天豚蹄穰田一样天堂与 u 回归饭否风格很尴尬头痛欲也一天天一个个 vv 哈哈一天图 u 音乐体育 u体育一条条鱼 u 一天宇 u 一样讨厌 vv 提供蝇营狗苟 v 还有哥哥 vvv刚刚蝇营狗苟 vv 关于狗狗 vv 关于狗狗 v 哈哈刚刚国画家哈哈巩固与提高规划和规范体育 u 哈哈刚刚过红红火火官方广告红红火火哥哥哥哥耿耿于怀哈哈给哥哥哥哥给哥哥哥哥红红火火家回家"

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TestTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    arrays = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10; i ++) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        // 主题
        [dic setValue:kTempText forKey:@"title"];
        
        [dic setValue:@"刘文荣 ,段昌兴 ,朱迪 ,陈芳 ,何道银 ,舒永超 ,wfkbyni ,sych ,8人觉得很赞" forKey:@"support"];
        
        int count = random() / 1000 % 10;
        
        NSMutableArray* replys = [[NSMutableArray alloc] init];
        for (int j = 0; j < count; j++) {
            
            NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
            
            int _id = rand();
            
            [item setValue:[NSNumber numberWithInt:_id] forKey:@"ID"];
            [item setValue:@"嘉靖" forKey:@"Name"];
            [item setValue:@"测试效果看看怎么样！！！！测试效果看看怎么样！！！！" forKey:@"Content"];
            
            [replys addObject:item];
            
        }
        
        [dic setValue:replys forKey:@"replys"];
        
        [arrays addObject:dic];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollShowView:) name:@"scrollShowView" object:nil];
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    
    replyView = [[ReplyView alloc] initWithShowTitle:@"发表回复"];
    [window addSubview:replyView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)scrollShowView:(NSNotification *)notificaiton{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"scrollShowView" object:notificaiton.object];
    
    NSArray* obj = notificaiton.object;
    
    // keyboardHeight
    float keyboardHeight = 256;
    float y = [obj[0] floatValue];
    
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    float screenHiehgt = window.bounds.size.height;
    
    float offset = 0;
    
    if (screenHiehgt - y > keyboardHeight) {
        offset = y - keyboardHeight;
    }else{
        offset = screenHiehgt - keyboardHeight;
    }
    
    NSLog(@"onclick: %.2f    offset: %.2f",y,offset);
    //[self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentOffset.y + offset , window.bounds.size.width, screenHiehgt) animated:YES];
    
    [replyView showReplyView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary * dic = arrays[indexPath.row];
    
    // 计算cell的高度
    float cellHeight = 80;
    
    // 计算主题的高度
    cellHeight += [TestTableViewCell getNSStringWidthOrHeight:15 :[dic valueForKey:@"title"] :CGSizeMake(kWidth - 20, 10000)].height;
    cellHeight += 10;
    
    // 功能view的高度
    cellHeight += 30;
    
    // 赞的高度
    float supportHeight = [TestTableViewCell getNSStringWidthOrHeight:15 :[dic valueForKey:@"support"] :CGSizeMake(kWidth - 35, 1000)].height;
    cellHeight += supportHeight != 0 ? supportHeight + 10 : supportHeight;
    
    // 回复的高度
    cellHeight += [TestTableViewCell replyContentHeight:[dic valueForKey:@"replys"]];
    
    return cellHeight;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return arrays.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    [cell configCell:arrays[indexPath.row]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
