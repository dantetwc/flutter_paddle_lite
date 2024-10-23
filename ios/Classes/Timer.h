//
//  Timer.h
//  Pods
//
//  Created by Dante Tsang on 23/10/2024.
//



@interface Timer : NSObject

@property (nonatomic, strong) NSMutableArray<NSNumber *> *msTime;
@property (nonatomic, strong) NSDate *tstart;
@property (nonatomic, strong) NSDate *tend;

- (instancetype)init;
- (void)clear;
- (void)start;
- (void)end;
- (float)getAverageMs;
- (float)getSumMs;
- (float)getTileTime:(float)tile;
- (NSArray<NSNumber *> *)getTimeStat;

@end
