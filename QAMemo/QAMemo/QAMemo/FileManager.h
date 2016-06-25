//
//  FileManager.h
//  QAMemo
//
//  Created by hourunjing on 16/5/20.
//  Copyright © 2016年 hourunjing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MemoList)(NSArray *);
typedef void (^WriteSuccess)(void);
typedef void (^WriteFailure)(void);

extern NSString *const MemoQuestion;
extern NSString *const MemoAnswer;

@interface FileManager : NSObject

+ (void)readMemoFile:(MemoList)memoList;
+ (void)wrieToMemoFile:(NSDictionary *)qamemoList
               success:(WriteSuccess)writeSuccess
               failure:(WriteFailure)writeFailure;

@end
