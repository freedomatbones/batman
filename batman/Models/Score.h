//
//  Score.h
//  batman
//
//  Created by 山口大輔 on 2015/05/11.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <Realm/Realm.h>
#import "Enum.h"

@interface Score : RLMObject

@property NSInteger key;
@property NSString* name;
@property NSTimeInterval time;
@property Difficulty difficulty;

+ (NSMutableArray *)findAll;
+ (NSMutableArray *)findNormalAll;
+ (NSMutableArray *)findHardAll;
- (NSInteger)nextPrimaryKey;
- (NSString*)timeToString;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Score>
RLM_ARRAY_TYPE(Score)
