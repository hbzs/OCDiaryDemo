//
//  TodayFileManager.m
//  QAMemo
//
//  Created by hourunjing on 16/5/20.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import "TodayFileManager.h"

@implementation TodayFileManager

+ (NSString *)memoPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    //获取文件的完整路径
    return [path stringByAppendingPathComponent:@"memo.plist"];
}

+ (BOOL)memoFileExist {
  return [[NSFileManager defaultManager] fileExistsAtPath:[self memoPath]];
}

+ (BOOL)createMemoFile {
  if (![self memoFileExist]) {
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:@[] format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    return [[NSFileManager defaultManager] createFileAtPath:[self memoPath] contents:data attributes:nil];
  }
  return YES;
}

+ (BOOL)wrieToMemoFile:(NSArray *)data {
  [self createMemoFile];
  return [data writeToFile:[self memoPath] atomically:YES];
}

+ (NSArray *)readMemoFile {
  return [NSArray arrayWithContentsOfFile:[self memoPath]];
}

@end
