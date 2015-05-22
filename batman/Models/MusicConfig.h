//
//  MusicConfig.h
//  batman
//
//  Created by 山口大輔 on 2015/05/09.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicConfig : NSObject

typedef NS_ENUM(NSInteger, Music)
{
    aaa
//    MAIN_BGM = 0,
//    ED_BGM,
//    POSE_BGM,
//    EDIT_BGM,
//    RESULT_BGM,
//    SCORE_BGM,
//    NORMAL_BGM,
//    HARD_BGM,
//    
//    ATTACK_SE1,
//    ATTACK_SE2,
//    ATTACK_SE3,
//    ATTACK_SE4,
//    SELECT_SE1,
//    SELECT_SE2
};

@property (nonatomic) NSString *music;
@property (nonatomic) NSString *type;
@property (nonatomic) double startTime;
@property (nonatomic) double volume;

+ (MusicConfig *)getConfig:(Music)music;

@end
