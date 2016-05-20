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

@interface MemoEditOrAddViewController ()

@property (copy, nonatomic) NSString *question;
@property (copy, nonatomic) NSString *answer;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *questionLabel;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextView *answerLabel;

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
  NSMutableArray *memoList = [([FileManager readMemoFile]?:@[]) mutableCopy];
  NSDictionary *memo = @{@"question":self.questionLabel.text,@"answer":self.answerLabel.text};
  [memoList addObject:memo];
  
  BOOL writeSucc = [FileManager wrieToMemoFile:memoList];
  if (writeSucc) {
    NSLog(@"write succ");
  } else {
    NSLog(@"write error");
  }
  
  [self.navigationController popViewControllerAnimated:YES];
}

@end
