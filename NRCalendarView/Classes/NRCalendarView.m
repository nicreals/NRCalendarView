//
//  NRCalendarView.m
//  Pods
//
//  Created by Nic on 16/9/8.
//
//

#import "NRCalendarView.h"
#import "NRCalendarItemView.h"
#import "NSDate+Greed.h"
#import "UIWindow+Greed.h"
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, NRCalendarDateChangeAction) {
    NRCalendarDateChangeActionPrevious,
    NRCalendarDateChangeActionNext,
};

const NSString *kNRCalendarViewValidKey = @"valid";
const NSString *kNRCalendarViewTimeKey = @"time";
const NSString *kNRCalendarViewDetailKey = @"detail";
const NSString *kNRCalendarViewInfoKey = @"info";

const NSInteger kNRCalendarViewTag = 100;
const NSInteger kNRCalendarViewCoverButtonTag = 1111;

@implementation NRCalendarView {
    MASConstraint *_itemBgViewHeightConstraint;
    NSMutableArray *_lineViewArray;
    NRCalendarDateChangeAction _dateAction;
}

#pragma mark - NRBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _autoInvalid = YES;
        _maxSelectNumber = 1;
        _dayItemBackColor = [UIColor clearColor];
        _month = [[NSDate date] gr_month];
        _year = [[NSDate date] gr_year];
        _selectArray = [[NSMutableArray alloc] init];
        [self initView];
        [self setConstraints];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = [UIColor colorWithRed:238.f / 255.f green:238.f / 255.f blue:238.f / 255.f alpha:1.f];
    self.layer.masksToBounds = YES;
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:238.f / 255.f green:238.f / 255.f blue:238.f / 255.f alpha:1.f];
        [self addSubview:view];
        self.titleBgView = view;
    }
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        self.itemBgView = view;
    }
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.f];
        [self addSubview:view];
        self.titleLineView = view;
    }
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.f];
        view.hidden = YES;
        [self addSubview:view];
        self.weekSeperateLineView = view;
    }
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.f];
        [self addSubview:view];
        self.topLineView = view;
    }
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14.f];
        [self addSubview:label];
        self.titleLabel = label;
    }
    {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"icon_arrow_left"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.backButton = button;
    }
    {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [UIColor clearColor];
        [button setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goNextMonth) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.forwardButton = button;
    }
    [self initWeekLabels];
}

- (void)setConstraints {
    [_titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(_titleLineView);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_titleBgView.mas_centerY).offset(-4);
    }];
    CGFloat itemWidth = [UIWindow gr_keyWindow].bounds.size.width/7.f;
    [_titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(itemWidth + 25);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.2);
    }];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@0.4);
    }];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_titleLabel.mas_left).offset(-20);
        make.centerY.equalTo(_titleLabel);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    [_forwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel.mas_right).offset(20);
        make.centerY.equalTo(_titleLabel);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    [_weekSeperateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_backButton.mas_bottom).offset(10);
        make.height.equalTo(@0.8f);
    }];
    [_itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(_titleLineView.mas_bottom).offset(0);
        make.bottom.equalTo(self).offset(-0);
    }];
}

#pragma mark - Setter

- (void)setMaxSelectNumber:(NSInteger)maxSelectNumber {
    _maxSelectNumber = maxSelectNumber ? : 1;
}

- (void)setStatusDicArray:(NSArray *)statusDicArray {
    _statusDicArray = statusDicArray;
    [self updateForStatusDicArray:_statusDicArray];
}

- (void)setShowSeperateLine:(BOOL)showSeperateLine {
    if (_showSeperateLine == showSeperateLine) {
        return;
    }
    _showSeperateLine = showSeperateLine;
    [self drawSeperateLines];
}

#pragma mark - Init

/**
 *  加载对应月份的每一天
 */
- (void)initDayItems {
    NSDate *beginDate = [self getBeginDateWithMonth:_month];
    NSInteger beginWeek = [self weekOfDate:beginDate];
    NSInteger numberOfDays = [self daysOfMonth:_month];
    NSDate *currentDate = [NSDate date];
    NSDate *endDate = [self getEndDateWithMonth:_month];
    _backButton.enabled = [beginDate gr_second] > _startTimeStamp;
    _forwardButton.enabled = [endDate gr_second] < _endTimeStamp;
    _titleLabel.text = [NSString stringWithFormat:@"%@年%@月",@(_year),@(_month)];
    for (UIView *view in [_itemBgView subviews]) {
        if ([view isKindOfClass:[NRCalendarItemView class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat itemWidth = [UIWindow gr_keyWindow].bounds.size.width/7.f;
    for (int i = 0; i < numberOfDays; i ++) {
        NRCalendarItemView *item = [[NRCalendarItemView alloc] init];
        item.day = i + 1;
        item.backgroundColor = _dayItemBackColor;
        [item.coverButton addTarget:self action:@selector(goSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        item.coverButton.tag = i + kNRCalendarViewCoverButtonTag;
        item.tag = i + kNRCalendarViewTag;
        item.titleLabel.text = [NSString stringWithFormat:@"%@",@(i + 1)];
        item.isValid = !_autoInvalid;
        NSDate *date = [self dateWithYear:_year month:_month day:i + 1];
        if (_maxSelectNumber > 1) {
            if (_selectArray.count) {
                if ([_selectArray containsObject:date]) {
                    item.isSelected = YES;
                } else {
                    item.isSelected = NO;
                }
            }
        } else if ([_selectedDate isEqualToDate:[self dateWithYear:_year month:_month day:i + 1]]) {
            item.isSelected = YES;
        } else {
            item.isSelected = NO;
        }
        if ([date gr_second] >= [currentDate gr_second]) {
            item.isValid = YES;
            item.backgroundColor = _dayItemBackColor;
        } else {
            item.isValid = NO;
            item.backgroundColor = self.backgroundColor;
            item.bgView.backgroundColor = self.backgroundColor;
        }
        if ([currentDate gr_day] == i + 1 && [currentDate gr_month] == _month) {
            item.titleLabel.text = @"今天";
            item.isValid = YES;
            item.backgroundColor = _dayItemBackColor;
        }
        [_itemBgView addSubview:item];
        
        NSInteger column = (beginWeek - 1 + i) %7;
        NSInteger row = (beginWeek - 1 + i) / 7;
        CGFloat top = row * itemWidth;
        CGFloat left = column * itemWidth;
        if (column == 0 || column == 6) {
            //            item.isWeekend = YES;
        }
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(itemWidth));
            make.left.equalTo(_itemBgView).offset(left);
            make.top.equalTo(_itemBgView).offset(top);
            if (i == numberOfDays - 1) {
                make.bottom.equalTo(_itemBgView);
            }
        }];
    }
}

/**
 *  加载顶部星期label
 */
- (void)initWeekLabels {
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    [weekArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = obj;
        [self addSubview:label];
        CGFloat left = ([UIScreen mainScreen].bounds.size.width/7.f) * (idx + 0.5);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_weekSeperateLineView).offset(10);
            make.centerX.equalTo(self.mas_left).offset(left);
        }];
    }];
}

#pragma mark - Action

- (void)goSelectItem:(UIButton *)button {
    NRCalendarItemView *view = [self viewWithTag:button.tag - kNRCalendarViewCoverButtonTag + kNRCalendarViewTag];
    NSDate *date = [self dateWithYear:_year month:_month day:view.day];
    if (view.isSelected) {
        view.isSelected = NO;
        if ([_selectArray containsObject:date]) {
            [_selectArray removeObject:date];
        }
        if ([self.delegate respondsToSelector:@selector(calendarView:deSelectWithIndex:dateArray:)]) {
            [self.delegate calendarView:self deSelectWithIndex:view.index dateArray:_selectArray];
        }
    } else {
        if (_selectArray.count < _maxSelectNumber) {
            view.isSelected = YES;
            [_selectArray addObject:date];
            if (_maxSelectNumber == 1) {
                if (_selectedDate) {
                    if ([_selectArray containsObject:_selectedDate]) {
                        [_selectArray removeObject:_selectedDate];
                    }
                    NSInteger day = [_selectedDate gr_day];
                    NRCalendarItemView *preItem = [self viewWithTag:day - 1 + kNRCalendarViewTag];
                    preItem.isSelected = NO;
                }
                _selectedDate = [self dateWithYear:_year month:_month day:view.day];
            }
            [self.delegate calendarView:self didSelectWithIndex:view.index dateArray:_selectArray];
            
        } else {
            view.isSelected = NO;
            if ([self.delegate respondsToSelector:@selector(calendarView:didReachingMaxSelectNumber:)]) {
                [self.delegate calendarView:self didReachingMaxSelectNumber:_maxSelectNumber];
            }
        }
        
    }
}

- (void)goPreviousMonth {
    _dateAction = NRCalendarDateChangeActionPrevious;
    _month--;
    if (_month < 1) {
        _month = 12;
        _year --;
    }
    [self goSelectMonth];
}

- (void)goNextMonth {
    _dateAction = NRCalendarDateChangeActionNext;
    _month++;
    if (_month > 12) {
        _month = 1;
        _year ++;
    }
    [self goSelectMonth];
}

- (void)goSelectMonth {
    NSDate *beginDate = [self getBeginDateWithMonth:_month];
    NSDate *endDate = [self getEndDateWithMonth:_month];
    if ([endDate gr_second] > _endTimeStamp) {
        endDate = [NSDate gr_dateFromSecond:_endTimeStamp];
    }
    if([self.delegate respondsToSelector:@selector(calendarView:didGoWithStartTimestamp:endTimestamp:)]) {
        [self.delegate calendarView:self didGoWithStartTimestamp:[beginDate gr_second] endTimestamp:[endDate gr_second]];
    }
}

#pragma mark - Private

- (void)drawSeperateLines {
    if (_showSeperateLine) {
        _itemBgView.backgroundColor = [UIColor clearColor];
        _weekSeperateLineView.hidden = NO;
        CGFloat itemWidth = [UIWindow gr_keyWindow].bounds.size.width / 7.f;
        for (int i = 0; i < 7; i ++) {
            UIView *columLine = [[UIView alloc] init];
            columLine.backgroundColor = [UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.f];
            columLine.layer.zPosition = 150.f;
            [_itemBgView addSubview:columLine];
            [columLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_itemBgView).offset(i * itemWidth - 0.2f);
                make.width.equalTo(@0.4);
                make.top.bottom.equalTo(_itemBgView);
            }];
            UIView *rowLine = [[UIView alloc] init];
            rowLine.backgroundColor = [UIColor colorWithRed:221.f / 255.f green:221.f / 255.f blue:221.f / 255.f alpha:1.f];
            rowLine.layer.zPosition = 150.f;
            [_itemBgView addSubview:rowLine];
            [rowLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_itemBgView).offset(i*itemWidth - 0.4);
                make.left.right.equalTo(_itemBgView);
                make.height.equalTo(@0.4);
            }];
        }
    } else {
        _itemBgView.backgroundColor = [UIColor whiteColor];
        _weekSeperateLineView.hidden = YES;
        
        for (UIView *view in [_itemBgView subviews]) {
            if (![view isKindOfClass:[NRCalendarItemView class]]) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)updateForStatusDicArray:(NSArray *)array {
    [self initDayItems];
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull dic, NSUInteger idx, BOOL * _Nonnull stop) {
        long long time = [(NSNumber *)dic[kNRCalendarViewTimeKey] longLongValue];
        NSInteger valid = [(NSNumber *)dic[kNRCalendarViewValidKey] integerValue];
        NSString *detail = (NSString *)dic[kNRCalendarViewDetailKey];
        NSString *info = (NSString *)dic[kNRCalendarViewInfoKey];
        NSDate *itemDate = [NSDate gr_dateFromSecond:time];
        NRCalendarItemView *item = [self viewWithTag:([itemDate gr_day] + kNRCalendarViewTag - 1)];
        item.index = idx;
        if ([itemDate gr_year] == _year && [itemDate gr_month] == _month) {
            item.isValid = valid;
            item.detailLabel.text = detail.length ? detail : @" ";
            item.infoLable.text = info.length ? info : @" ";
        }
    }];
}

/**
 *  返回指定日期是星期几
 */
- (NSInteger)weekOfDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    return [comps weekday];
}

/**
 指定月份有多少天
 */
- (NSInteger)daysOfMonth:(NSInteger)month {
    NSDate *date = [self getBeginDateWithMonth:month];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    return days.length;
}

/**
 指定月份第一天date
 */
- (NSDate *)getBeginDateWithMonth:(NSInteger)month {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *beginDate = [fmt dateFromString:[NSString stringWithFormat:@"%@-%@-01 00:00:00",@(_year),@(month)]];
    return beginDate;
}

/**
 返回指定月份的最后一天
 */
- (NSDate *)getEndDateWithMonth:(NSInteger)month {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSInteger days = [self daysOfMonth:month];
    NSDate *beginDate = [fmt dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 23:59:59",@(_year),@(month),@(days)]];
    return beginDate;
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dayString = day < 10 ? [NSString stringWithFormat:@"0%@",@(day)] : @(day).stringValue;
    NSDate *date = [fmt dateFromString:[NSString stringWithFormat:@"%@-%@-%@ 12:59:59",@(year),@(month),dayString]];
    return date;
}

- (void)revokeDateChangeAction {
    if (_dateAction == NRCalendarDateChangeActionPrevious) {
        if (_month > 12) {
            _month = 1;
            _year ++;
        }
    } else if (_dateAction == NRCalendarDateChangeActionNext) {
        _month--;
        if (_month < 1) {
            _month = 12;
            _year --;
        }
    }
}

@end
