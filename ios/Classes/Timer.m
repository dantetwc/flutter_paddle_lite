#import <Foundation/Foundation.h>
#import "Timer.h"

@implementation Timer

- (instancetype)init {
    self = [super init];
    if (self) {
        _msTime = [NSMutableArray array];
    }
    return self;
}

- (void)clear {
    [self.msTime removeAllObjects];
}

- (void)start {
    self.tstart = [NSDate date];
}

- (void)end {
    self.tend = [NSDate date];
    NSTimeInterval elapsed = [self.tend timeIntervalSinceDate:self.tstart] * 1000.0;
    [self.msTime addObject:@(elapsed)];
}

- (float)getAverageMs {
    if (self.msTime.count == 0) {
        return 0.0f;
    }
    float sum = 0.0f;
    for (NSNumber *time in self.msTime) {
        sum += [time floatValue];
    }
    return sum / self.msTime.count;
}

- (float)getSumMs {
    if (self.msTime.count == 0) {
        return 0.0f;
    }
    float sum = 0.0f;
    for (NSNumber *time in self.msTime) {
        sum += [time floatValue];
    }
    return sum;
}

- (float)getTileTime:(float)tile {
    if (tile < 0 || tile > 100) {
        return -1.0f;
    }
    NSInteger totalItems = self.msTime.count;
    if (totalItems == 0) {
        return -2.0f;
    }
    
    NSArray *sortedTimes = [self.msTime sortedArrayUsingSelector:@selector(compare:)];
    NSInteger pos = (NSInteger)(tile * totalItems / 100);
    return [sortedTimes[pos] floatValue];
}

- (NSArray<NSNumber *> *)getTimeStat {
    return [self.msTime copy];
}

@end
