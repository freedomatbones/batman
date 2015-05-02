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
    bgImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"d_apri_bg.png"]];
    bgImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"d_apri_bg.png"]];
    
    bgX1 = 0;
    bgY1 = 0;
    
    bgX2 = 0;
    bgY2 = self.frame.size.height;
    
    sizeWidth = self.frame.size.width;
    sizeHeight = self.frame.size.height;
    
    bgImage2.frame = CGRectMake(0, self.frame.size.height, sizeWidth, sizeHeight);
    
    [self addSubview:bgImage1];
    [self addSubview:bgImage2];
    
    [NSThread detachNewThreadSelector:@selector(threadAction) toTarget:self withObject:nil];
    
    return self;
}

-(void)threadAction{
    while (true) {
        [NSThread sleepForTimeInterval:0.01];
        [self performSelectorOnMainThread:@selector(timerIntervalShowImage) withObject:nil waitUntilDone:NO];
    }
}

// 移動
- (void)timerIntervalShowImage {
    if(self.frame.size.height <= bgY1){
        bgY1 = 0 - sizeHeight;
    }
    if(self.frame.size.height <= bgY2){
        bgY2 = 0 - sizeHeight;
    }
    
    bgY1++;
    bgY2++;
    
    bgImage1.frame = CGRectMake(0, bgY1, sizeWidth, sizeHeight);
    bgImage2.frame = CGRectMake(0, bgY2, sizeWidth, sizeHeight);
}

@end