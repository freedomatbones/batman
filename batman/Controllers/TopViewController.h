//
//  TopViewController.h
//  batman
//
//  Created by 山口大輔 on 2015/05/06.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "GameConfig.h"

@interface TopViewController : ViewController<AVAudioPlayerDelegate> {
    GameConfig *gameConfig;
    Person *myPerson;
    Person *enemyPerson;
}

@property(nonatomic) AVAudioPlayer *audioPlayer;

@end
