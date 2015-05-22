//
//  MusicConfig.m
//  batman
//
//  Created by 山口大輔 on 2015/05/09.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "MusicConfig.h"

@implementation MusicConfig

+ (MusicConfig *)getConfig:(Music)music {
    MusicConfig *musicConfig;
    switch (music) {
        case MAIN_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"main_op_theme3";
            musicConfig.type = @"m4a";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case ED_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"main_op_theme4";
            musicConfig.type = @"m4a";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case POSE_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"tony_theme_mix";
            musicConfig.type = @"m4a";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case EDIT_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"ievan_polkka";
            musicConfig.type = @"mp3";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 0.6;
            break;
        case RESULT_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"total_result";
            musicConfig.type = @"mp3";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case SCORE_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"master";
            musicConfig.type = @"mp3";
            musicConfig.startTime = 34.5;
            musicConfig.volume = 0.4;
            break;
        case NORMAL_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"introduce_little_anarchy";
            musicConfig.type = @"mp3";
            musicConfig.startTime = 5.0;
            musicConfig.volume = 1.0;
            break;
        case HARD_BGM:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"modern";
            musicConfig.type = @"m4a";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case ATTACK_SE1:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"";
            musicConfig.type = @"";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case ATTACK_SE2:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"";
            musicConfig.type = @"";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case ATTACK_SE3:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"";
            musicConfig.type = @"";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case ATTACK_SE4:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"";
            musicConfig.type = @"";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case SELECT_SE1:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"";
            musicConfig.type = @"";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        case SELECT_SE2:
            musicConfig = [MusicConfig alloc];
            musicConfig.music = @"";
            musicConfig.type = @"";
            musicConfig.startTime = 0.0;
            musicConfig.volume = 1.0;
            break;
        default:
            break;
    }
    return musicConfig;
}

@end
