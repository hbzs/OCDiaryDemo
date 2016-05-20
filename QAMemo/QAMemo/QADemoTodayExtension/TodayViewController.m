//
//  TodayViewController.m
//  QADemoTodayExtension
//
//  Created by hourunjing on 16/5/18.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayFileManager.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UIButton *changeQuestionButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAnswerButton;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UITextField *questionTextField;
@property (weak, nonatomic) IBOutlet UITextField *answerTextField;

@property (strong, nonatomic) NSArray *memo;
@property (strong, nonatomic) NSDictionary *currentMemoIndex;
- (IBAction)addQA:(id)sender;


- (IBAction)changeQuestion:(id)sender;
- (IBAction)showAnswer:(id)sender;

@end

@implementation TodayViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self buttonStyle:self.changeQuestionButton];
  [self buttonStyle:self.showAnswerButton];
  
  self.memo = [TodayFileManager readMemoFile];
  [self changeQuestionAction];
  
  [self hiddenAnswerLabel:[self heightForText:self.currentMemoIndex[@"question"]]];
  
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNoData);
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
  return UIEdgeInsetsZero;
}

#pragma mark - style

- (void)buttonStyle:(UIButton *)preStyleButton {
  preStyleButton.layer.borderColor = [UIColor whiteColor].CGColor;
  preStyleButton.layer.borderWidth = 1;
  preStyleButton.clipsToBounds     = YES;
  preStyleButton.layer.cornerRadius= 3;
}

- (void)hiddenAnswerLabel:(CGFloat)questionHeight {
  self.answerLabel.hidden = YES;
  [self.showAnswerButton setTitle:@"显示答案" forState:UIControlStateNormal];
  if (questionHeight < 0.001) {
    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, self.showAnswerButton.frame.origin.y + self.showAnswerButton.bounds.size.height + 10);
  } else {
    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, self.questionLabel.frame.origin.y + questionHeight + 33 + 10);
  }
}

- (void)showAnswerLabel {
  self.answerLabel.hidden = NO;
  [self.showAnswerButton setTitle:@"隐藏答案" forState:UIControlStateNormal];
  self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, self.answerLabel.frame.origin.y + [self heightForText:((NSString *)(self.currentMemoIndex[@"answer"]))] + 10);
}

#pragma mark - action

- (IBAction)addQA:(id)sender {
  if ((![self.questionTextField.text isEqualToString:@""]) && (![self.answerTextField.text isEqualToString:@""])) {
    NSMutableArray *memoList = [(self.memo?:@[]) mutableCopy];
    NSDictionary *memo = @{@"question":self.questionTextField.text,@"answer":self.answerTextField.text};
    [memoList addObject:memo];
    
    BOOL writeSucc = [TodayFileManager wrieToMemoFile:memoList];
    if (writeSucc) {
      self.questionTextField.text = @"";
      self.answerTextField.text   = @"";
      self.memo = [TodayFileManager readMemoFile];
      [self changeQuestionAction];
      [self changeQuestionUI];
    }
  }
}

- (IBAction)changeQuestion:(id)sender {
  [self changeQuestionAction];
  [self changeQuestionUI];
}

- (IBAction)showAnswer:(id)sender {
  if (self.answerLabel.hidden) {
    [self showAnswerLabel];
    [self showAnswerFill];
  } else {
    [self hiddenAnswerLabel:0];
  }
}

- (void)questionLabelFill {
  self.questionLabel.text = self.currentMemoIndex[@"question"];
}

- (int)randomQAMemo {
  return arc4random() % self.memo.count;
}

- (void)changeQuestionAction {
  if (!self.memo || self.memo.count == 0) {
    return;
  }
  int firstIndex = [self randomQAMemo];
  NSLog(@"index:%@",@(firstIndex));
  self.currentMemoIndex = self.memo[firstIndex];
  [self questionLabelFill];
}

- (void)showAnswerFill {
  self.answerLabel.text = self.currentMemoIndex[@"answer"];
}

- (CGFloat)heightForText:(NSString *)text {
  return [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, 1000)options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
}

- (void)changeQuestionUI {
  if (!self.answerLabel.hidden) {
    //答案显示
    [self hiddenAnswerLabel:[self heightForText:self.currentMemoIndex[@"question"]]];
  } else {
    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, self.questionLabel.frame.origin.y + [self heightForText:self.currentMemoIndex[@"question"]] + 33 + 10);
  }
}

@end
