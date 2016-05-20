//
//  TodayFileManager.h
//  QAMemo
//
//  Created by hourunjing on 16/5/20.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodayFileManager : NSObject

+ (NSArray *)readMemoFile;
+ (BOOL)wrieToMemoFile:(NSArray *)data;
+ (BOOL)createMemoFile;

@end
