//
//  BackgroundView.m
//  batman
//
//  Created by 山口 大輔 on 2015/04/04.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "BackgroundView.h"

@implementation BackgroundView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //[image_ drawInRect:rect];
//}

// コードで初期化する場合
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeView];
    }
    return self;
}

// xib を使用する場合
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initializeView];
    }
    return self;
}

- (id)initializeView {
    bgImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-road.png"]];
    bgImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-road.png"]];
    
    bgX1 = 0;
    bgY1 = 0;
    
    bgX2 = 0;
    bgY2 = self.frame.size.height;
    
    sizeWidth = self.frame.size.width;
    sizeHeight = self.frame.size.height;
    
    bgImage1.frame = CGRectMake(0, bgY1, sizeWidth, sizeHeight);
    bgImage2.frame = CGRectMake(0, self.frame.size.height, sizeWidth, sizeHeight);
    
    [self addSubview:bgImage1];
    [self addSubview:bgImage2];
        
    return self;
}

// 移動
- (void)timerIntervalShowImage {
    //NSLog(@"timerIntervalShowImage: %@", [NSThread currentThread]);
    if(self.frame.size.height <= bgY1){
        bgY1 = 0 - sizeHeight;
    }
    if(self.frame.size.height <= bgY2){
        bgY2 = 0 - sizeHeight;
    }
    
    bgY1 += 1;
    bgY2 += 1;
    
    bgImage1.frame = CGRectMake(0, bgY1, sizeWidth, sizeHeight);
    bgImage2.frame = CGRectMake(0, bgY2, sizeWidth, sizeHeight);
}

- (void)start {
    NSLog(@"start: %@", [NSThread currentThread]);
    bgMoveTimer = [NSTimer timerWithTimeInterval:0.005 target:self selector:@selector(timerIntervalShowImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:bgMoveTimer forMode:NSRunLoopCommonModes];
}

- (void)end {
    [bgMoveTimer invalidate];
    bgMoveTimer = nil;
}

@end
