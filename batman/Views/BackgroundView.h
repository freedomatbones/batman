//
//  BackgroundView.h
//  batman
//
//  Created by 山口 大輔 on 2015/04/04.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundView : UIView {
    // 背景
    UIImageView *bgImage1;
    int bgX1;
    int bgY1;
    UIImageView *bgImage2;
    int bgX2;
    int bgY2;
    int sizeWidth;
    int sizeHeight;
    NSTimer *bgMoveTimer;
}

- (void)start;
- (void)end;

@end
