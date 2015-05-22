//
//  Score.m
//  batman
//
//  Created by 山口大輔 on 2015/05/11.
//  Copyright (c) 2015年 山口 大輔. All rights reserved.
//

#import "Score.h"

@implementation Score

// Specify default values for properties

+ (NSString *)primaryKey {
    return @"key";
}

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

//+ (NSArray *)indexedProperties
//{
//    return @[@"key"];
//}

+ (NSMutableArray *)findAll {
    RLMResults *all = [[Score allObjects] sortedResultsUsingProperty:@"key" ascending:YES];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (Score *score in all) {
        [arr addObject: score];
    }
    return arr;
}

+ (NSMutableArray *)findNormalAll {
    RLMResults *all = [[Score objectsWhere:[[NSString alloc] initWithFormat:@"difficulty = %ld",(long)NORMAL]]
                                                sortedResultsUsingProperty:@"time"
                                                                 ascending:YES];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (Score *score in all) {
        [arr addObject: score];
    }
    return arr;
}

+ (NSMutableArray *)findHardAll {
    RLMResults *all = [[Score objectsWhere:[[NSString alloc] initWithFormat:@"difficulty = %ld",(long)HARD]]
                       sortedResultsUsingProperty:@"time"
                       ascending:YES];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (Score *score in all) {
        [arr addObject: score];
    }
    return arr;
}

- (NSInteger)nextPrimaryKey {
    // After
    RLMResults *all = [[Score allObjects] sortedResultsUsingProperty:@"key" ascending:YES];
    Score *last = [all lastObject];
    return last.key + 1;
}

- (NSString*)timeToString {
    // int hour   = self.time / (60 * 60);
    int minute = fmod((self.time / 60) ,60);
    int second = fmod(self.time ,60);
    int miliSec = (self.time - floor(self.time)) * 1000;
    NSString *format = @"%02d:%02d.%03d";
    return [NSString stringWithFormat:format, minute, second, miliSec];
}

@end
