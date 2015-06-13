//
//  SoundPlayer.m
//  batman
//
//  Created by 山口大輔 on 2015/05/09.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "SoundPlayer.h"
#import "AppDelegate.h"

@implementation SoundPlayer

+ (void)playMusic:(Sound)sound {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    SoundPlayer *playingMusic = delegate.music;
    
//    NSLog(@"sound: %@", playingMusic);
//    NSLog(@"sound: %ld", sound);
//    NSLog(@"playingMusic.sound: %ld", playingMusic.sound);
    if (playingMusic == nil || !playingMusic.audio.isPlaying || sound != playingMusic.sound) {
        [self stopMusic];
        SoundPlayer *config = [self getConfig:sound];
//        NSLog(@"sound: %ld", config.sound);
//        NSLog(@"sound: %@", config.type);
//        NSLog(@"sound: %@", config.filename);
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *path = [mainBundle pathForResource:config.filename ofType:config.type];
//        NSLog(@"path: %@", path);
        NSString *expandedPath = [path stringByExpandingTildeInPath];
//        NSLog(@"expandedPath: %@", expandedPath);
        NSURL *url = [NSURL fileURLWithPath:expandedPath];
        NSError *error;
        
        config.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        delegate.music = config;
        
        delegate.music.audio.delegate = (id)self;
        delegate.music.audio.currentTime = config.startTime;
        delegate.music.audio.numberOfLoops = -1;
        delegate.music.audio.volume = config.audio.volume*config.volume;
        [config.audio prepareToPlay];
        [config.audio play];
    }
}

+ (void)pauseMusic {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    NSLog(@"delegate.music.audio.isPlaying: %id", (BOOL)delegate.music.audio.isPlaying);
    if(delegate.music.audio.isPlaying){
        [delegate.music.audio pause];
    } else {
        [delegate.music.audio play];
    }
}

+ (void)stopMusic {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    NSLog(@"delegate.music.audio.isPlaying: %id", (BOOL)delegate.music.audio.isPlaying);
    if(delegate.music.audio.isPlaying){
        [delegate.music.audio stop];
        delegate.music.audio.currentTime = 0;
        [delegate.music.audio prepareToPlay];
        delegate.music.audio = nil;
        delegate.music = nil;
    }
}

+ (void)playSE:(Sound)sound {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    
    SoundPlayer *config = [self getConfig:sound];
//    NSLog(@"sound: %ld", config.sound);
//    NSLog(@"sound: %@", config.type);
//    NSLog(@"sound: %@", config.filename);
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:config.filename ofType:config.type];
//    NSLog(@"path: %@", path);
    NSString *expandedPath = [path stringByExpandingTildeInPath];
//    NSLog(@"expandedPath: %@", expandedPath);
    NSURL *url = [NSURL fileURLWithPath:expandedPath];
    NSError *error;
    
    config.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    config.audio.delegate = (id)self;
    config.audio.currentTime = config.startTime;
    config.audio.numberOfLoops = 0;
    config.audio.volume = config.audio.volume*config.volume;
    [config.audio prepareToPlay];
    [config.audio play];
    
    [delegate.seArray addObject:config];
//    NSLog(@"seArray%ld", delegate.seArray.count);
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    __block NSUInteger delIdx = -1;
    [delegate.seArray enumerateObjectsUsingBlock:^(SoundPlayer *obj, NSUInteger idx, BOOL *stop) {
        if (obj.audio == player) {
            delIdx = idx;
        }   
    }];
    [delegate.seArray removeObjectAtIndex:delIdx];
}

+ (SoundPlayer *)getConfig:(Sound)sound {
    SoundPlayer *soundConfig = [SoundPlayer alloc];
    soundConfig.sound = sound;
    switch (sound) {
        case MAIN_BGM:
            soundConfig.filename = @"main_op_theme3";
            soundConfig.type = @"caf";
            soundConfig.startTime = 17.5;
            soundConfig.volume = 1.2;
            break;
        case ED_BGM:
            soundConfig.filename = @"main_op_theme4";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case POSE_BGM:
            soundConfig.filename = @"tony_theme_mix";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case EDIT_BGM:
            soundConfig.filename = @"ievan_polkka";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 0.5;
            break;
        case RESULT_BGM:
            soundConfig.filename = @"total_result";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case SCORE_BGM:
            soundConfig.filename = @"master";
            soundConfig.type = @"caf";
            soundConfig.startTime = 34.5;
            soundConfig.volume = 0.4;
            break;
        case NORMAL_BGM:
            soundConfig.filename = @"introduce_little_anarchy";
            soundConfig.type = @"caf";
            soundConfig.startTime = 5.0;
            soundConfig.volume = 1.0;
            break;
        case HARD_BGM:
            soundConfig.filename = @"modern";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case WIN_BGM:
            soundConfig.filename = @"you_did_it";
            soundConfig.type = @"caf";
            soundConfig.startTime = 28.5;
            soundConfig.volume = 1.0;
            break;
        case LOSE_BGM:
            soundConfig.filename = @"you_are_dead";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case ATTACK_SE1:
            soundConfig.filename = @"attack1";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.2;
            soundConfig.volume = 1.0;
            break;
        case ATTACK_SE2:
            soundConfig.filename = @"bomb";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case ATTACK_SE3:
            soundConfig.filename = @"";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case ATTACK_SE4:
            soundConfig.filename = @"";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case HIT_SE1:
            soundConfig.filename = @"hit1";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case SELECT_SE:
            soundConfig.filename = @"select";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.3;
            soundConfig.volume = 0.8;
            break;
        case CANCEL_SE:
            soundConfig.filename = @"cancel";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.3;
            soundConfig.volume = 1.0;
            break;
        case TAB_SE:
            soundConfig.filename = @"tab";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.3;
            soundConfig.volume = 1.0;
            break;
        case DELETE_SE:
            soundConfig.filename = @"delete";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.0;
            soundConfig.volume = 1.0;
            break;
        case PAUSE_START_SE:
            soundConfig.filename = @"pause_start";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.3;
            soundConfig.volume = 0.8;
            break;
        case PAUSE_END_SE:
            soundConfig.filename = @"pause_end";
            soundConfig.type = @"caf";
            soundConfig.startTime = 0.3;
            soundConfig.volume = 0.8;
            break;
        default:
            break;
    }
    return soundConfig;
}

@end
