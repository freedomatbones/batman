//
//  Person.h
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

typedef NS_ENUM(NSInteger, Difficulty)
{
    NORMAL = 0,
    HARD
};

@property (nonatomic) NSString* name;
@property (nonatomic) UIImage *image;
@property (nonatomic) Difficulty difficulty;

@end
