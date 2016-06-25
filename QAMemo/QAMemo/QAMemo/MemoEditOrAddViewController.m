//
//  MemoEditOrAddViewController.m
//  QAMemo
//
//  Created by hourunjing on 16/5/19.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import "MemoEditOrAddViewController.h"
#import "RPFloatingPlaceholderTextField.h"
#import "RPFloatingPlaceholderTextView.h"
#import "FileManager.h"
#import <CloudKit/CloudKit.h>

@interface MemoEditOrAddViewController ()

@property (copy, nonatomic) NSString *question;
@property (copy, nonatomic) NSString *answer;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *questionLabel;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextView *answerLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishButtonItem;

@end

@implementation MemoEditOrAddViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.questionLabel.text = _question;
  self.answerLabel.text   = _answer;
}

- (void)setContent:(NSDictionary *)memo {
  self.question = memo[@"question"];
  self.answer   = memo[@"answer"];
}

- (IBAction)finishMemo:(id)sender {
  NSDictionary *memo = @{@"question":self.questionLabel.text,@"answer":self.answerLabel.text};
  
  __weak __typeof(self) wSelf = self;
  self.finishButtonItem.enabled = NO;
  [FileManager wrieToMemoFile:memo success:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      [wSelf.navigationController popViewControllerAnimated:YES];
    });
  } failure:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      wSelf.finishButtonItem.enabled = YES;
    });
  }];
}

@end
