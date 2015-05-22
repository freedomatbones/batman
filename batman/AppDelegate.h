//
//  AppDelegate.h
//  batman
//
//  Created by 山口 大輔 on 2015/03/07.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) SoundPlayer *music;
@property (retain, nonatomic) NSMutableArray *seArray;

@end

