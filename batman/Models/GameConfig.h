//
//  GameConfig.h
//  batman
//
//  Created by 山口大輔 on 2015/05/09.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum.h"
#import "SoundPlayer.h"

@interface GameConfig : NSObject

@property (nonatomic) Difficulty difficulty;
@property (nonatomic) Sound sound;

@end
