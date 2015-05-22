//
//  Enum.h
//  batman
//
//  Created by 山口大輔 on 2015/05/08.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Enum : NSObject

typedef NS_ENUM(NSInteger, Difficulty)
{
    NORMAL = 0,
    HARD
};

@end
