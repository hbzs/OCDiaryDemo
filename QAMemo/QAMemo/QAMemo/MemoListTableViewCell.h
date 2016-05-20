//
//  MemoListTableViewCell.h
//  QAMemo
//
//  Created by hourunjing on 16/5/19.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemoListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *memoQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *memoAnswerLabel;

- (void)setContent:(NSDictionary *)memo;

@end
