//
//  SoundPlayer.h
//  batman
//
//  Created by 山口大輔 on 2015/05/09.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer : NSObject<AVAudioPlayerDelegate>

typedef NS_ENUM(NSInteger, Sound)
{
    MAIN_BGM = 0,
    ED_BGM,
    POSE_BGM,
    EDIT_BGM,
    RESULT_BGM,
    SCORE_BGM,
    WIN_BGM,
    LOSE_BGM,
    NORMAL_BGM,
    HARD_BGM,
    
    ATTACK_SE1,
    ATTACK_SE2,
    SELECT_SE,
    CANCEL_SE,
    TAB_SE,
    DELETE_SE,
    PAUSE_START_SE,
    PAUSE_END_SE,
    ENEMY_SHOT_SE,
    LOW_HIT_SE,
    MIDDLE_HIT_SE,
    HIGH_HIT_SE,
    KNIFE_HIT_SE,
    KO_SE,
    HIT_BOMB_SE
};

@property (nonatomic) Sound sound;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSString *type;
@property (nonatomic) double startTime;
@property (nonatomic) double volume;
@property (nonatomic) AVAudioPlayer *audio;

+ (void)playMusic:(Sound)sound;
+ (void)pauseMusic;
+ (void)stopMusic;
+ (void)playSE:(Sound)sound;
+ (SoundPlayer *)getConfig:(Sound)music;

@end
