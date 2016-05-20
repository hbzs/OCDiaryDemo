//
//  MemoListTableViewCell.m
//  QAMemo
//
//  Created by hourunjing on 16/5/19.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import "MemoListTableViewCell.h"

@implementation MemoListTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  CGFloat width = [UIScreen mainScreen].bounds.size.width - 30;
  self.memoQuestionLabel.preferredMaxLayoutWidth = width;
  self.memoAnswerLabel.preferredMaxLayoutWidth   = width;
}

- (void)setContent:(NSDictionary *)memo {
  self.memoQuestionLabel.text = memo[@"question"];
  self.memoAnswerLabel.text   = memo[@"answer"];
}

@end
