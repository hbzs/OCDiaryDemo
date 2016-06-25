//
//  FileManager.m
//  QAMemo
//
//  Created by hourunjing on 16/5/20.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import "FileManager.h"
#import <CloudKit/CloudKit.h>
#import "CocoaSecurity.h"

NSString *const MemoQuestion = @"question";
NSString *const MemoAnswer   = @"answer";
static NSString *const MemoRecord = @"memorecord";
static NSString *const QAMemoRecordType = @"QAMemo";

@implementation FileManager

+ (CKDatabase *)publicCloudDatabase {
  //1、创建一个容器（使用默认容器）
  CKContainer *myContainer = [CKContainer defaultContainer];
  //2、创建数据库
  return [myContainer publicCloudDatabase];
}

/**
 *  [{"question":question;"answer":answer},{}...]
 */
+ (void)wrieToMemoFile:(NSDictionary *)qamemo success:(WriteSuccess)writeSuccess failure:(WriteFailure)writeFailure {
  //创建一条记录的ID并指定一个唯一的名字，
  CocoaSecurityResult *sha256 = [CocoaSecurity sha256:[NSString stringWithFormat:@"%@:%@",qamemo[MemoQuestion],qamemo[MemoAnswer]]];
  CKRecordID *artworkRecordID = [[CKRecordID alloc] initWithRecordName:sha256.hexLower];
  
  //创建一个记录对象
  CKRecord *artworkRecord = [[CKRecord alloc] initWithRecordType:QAMemoRecordType recordID:artworkRecordID];
  
  //设置记录字段
  artworkRecord[MemoQuestion] = qamemo[MemoQuestion];
  artworkRecord[MemoAnswer] = qamemo[MemoAnswer];
  //3、将记录保存在数据
  [[self publicCloudDatabase] saveRecord:artworkRecord completionHandler:^(CKRecord *artworkRecord, NSError *error){
    if (!error) {
      
      NSLog(@"保存成功");
      writeSuccess();
    }
    else {
      NSLog(@"保存失败%@",error);
      writeFailure();
    }
  }];
}

+ (void)readMemoFile:(MemoList)memoList {
  __block NSMutableArray *qamemoList = [@[] mutableCopy];
  //2.创建记录ID
  CKQuery *query = [[CKQuery alloc] initWithRecordType:QAMemoRecordType predicate:[NSPredicate predicateWithValue:YES]];
  [[self publicCloudDatabase] performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
    for (NSDictionary *record in results) {
      [qamemoList addObject:@{MemoQuestion:record[MemoQuestion],MemoAnswer:record[MemoAnswer]}];
    }
    memoList([qamemoList copy]);
  }];
}

@end
