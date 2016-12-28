//
//  ViewController.m
//  QAMemo
//
//  Created by hourunjing on 16/5/18.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import "ViewController.h"
#import "MemoListTableViewCell.h"
#import "MemoEditOrAddViewController.h"
#import "FileManager.h"
#import "MBProgressHUD.h"

static NSString *const MemoListCellIdentifier = @"MemoListCellIdentifier";

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *memos;
@property (strong, nonatomic) MemoListTableViewCell *memoCell;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  self.memoCell = [self.tableView dequeueReusableCellWithIdentifier:MemoListCellIdentifier];
  
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  __weak __typeof(self) wSelf = self;
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.animationType = MBProgressHUDAnimationZoom;
  hud.labelText = @"问答获取中……";
  dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    [FileManager readMemoFile:^(NSArray *memoList) {
      __strong __typeof(wSelf) sSelf = wSelf;
      if (sSelf) {
        sSelf.memos = [memoList mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
          [MBProgressHUD hideHUDForView:sSelf.view animated:YES];
          [sSelf.tableView reloadData];
        });
      }
    }];
  });
}

#pragma mark - table view datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.memos?self.memos.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MemoListTableViewCell *memoListCell = [tableView dequeueReusableCellWithIdentifier:MemoListCellIdentifier forIndexPath:indexPath];
  [memoListCell setContent:self.memos[indexPath.row]];
  
  return memoListCell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  self.memoCell.memoQuestionLabel.text = self.memos[indexPath.row][@"question"];
  self.memoCell.memoAnswerLabel.text   = self.memos[indexPath.row][@"answer"];
  return [self.memoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
  MemoEditOrAddViewController *vc = [segue destinationViewController];
  if ([segue.identifier isEqualToString:@"MemoEditIdentifier"]) {
    vc.title = @"修改问答";
    UITableViewCell *cell = (UITableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [vc setContent:self.memos[indexPath.row]];
  } else if ([segue.identifier isEqualToString:@"MemoAddIdentifier"]) {
    vc.title = @"添加问答";
  }
  
}

@end
