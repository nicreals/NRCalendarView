//
//  NRViewController.m
//  NRCalendarView
//
//  Created by 聂锐 on 12/16/2016.
//  Copyright (c) 2016 聂锐. All rights reserved.
//

#import "NRViewController.h"
#import <Masonry/Masonry.h>
#import "NRCalendarView.h"
#import "NSDate+Greed.h"

@interface NRViewController ()<NRCalendarViewDelegate>

@property (nonatomic, strong) NRCalendarView *calendarView;

@end

@implementation NRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.calendarView];
    [self setConstraints];
    NSDate *date = [NSDate date];
    self.calendarView.statusDicArray = [self getDataWithYear:[date gr_year] month:[date gr_month]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter

- (NRCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[NRCalendarView alloc] init];
        _calendarView.delegate = self;
        _calendarView.showSeperateLine = YES;
        _calendarView.maxSelectNumber = 3;
        _calendarView.dayItemBackColor = [UIColor whiteColor];
        _calendarView.startTimeStamp = [[NSDate date] gr_second];
        _calendarView.endTimeStamp = NSIntegerMax;
    }
    return _calendarView;
}

#pragma mark - NRCalendarViewDelegate

- (void)calendarView:(NRCalendarView *)calendar didReachingMaxSelectNumber:(NSInteger)maxSelectNumber {
    NSLog(@"最多只能选%@个", @(maxSelectNumber));
}

- (void)calendarView:(NRCalendarView *)calendar didSelectWithIndex:(NSInteger)index dateArray:(NSArray<NSDate *> *)array {
    NSLog(@"----------选择了第%@项----------",@(index));
    NSLog(@"%@", [array description]);
}

- (void)calendarView:(NRCalendarView *)calendar deSelectWithIndex:(NSInteger)index dateArray:(NSArray<NSDate *> *)array {
    NSLog(@"----------取消选择第%@项----------",@(index));
    NSLog(@"%@", [array description]);
}

- (void)calendarView:(NRCalendarView *)calendar didGoWithStartTimestamp:(long long)startTime endTimestamp:(long long)endTime {
    NSDate *date = [NSDate gr_dateFromSecond:startTime];
    calendar.month = [date gr_month];
    calendar.year = [date gr_year];
        // 根据当前时间段请求数据后传入数据给NRCalendarView
    NSArray *data =  [self getDataWithYear:[date gr_year] month:[date gr_month]];
    calendar.statusDicArray = data;
}

- (NSArray *)getDataWithYear:(NSInteger)year month:(NSInteger)month {
    NSArray *array = @[
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] - 2] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] - 1] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day]] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] + 1] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(0),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] + 2] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] + 3] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] + 4] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       @{
                           kNRCalendarViewValidKey : @(1),
                           kNRCalendarViewTimeKey : @([[self dateWithYear:year month:month day:[[NSDate date] gr_day] + 8] gr_second]),
                           kNRCalendarViewDetailKey : [NSString stringWithFormat:@"¥%@",@(arc4random() % 100)],
                           kNRCalendarViewInfoKey : [NSString stringWithFormat:@"%@人报名",@(arc4random() % 10)],
                           },
                       ];
    return array;
}

#pragma mark - Private

- (void)setConstraints {
    [_calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.center.equalTo(self.view);
    }];
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayString = day < 10 ? [NSString stringWithFormat:@"0%@",@(day)] : @(day).stringValue;
    NSDate *date = [fmt dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 23:59:59",@(year),@(month),dayString]];
    return date;
}

@end
