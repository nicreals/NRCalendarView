//
//  NRCalendarView.h
//  Pods
//
//  Created by Nic on 16/9/8.
//
//

#import <UIKit/UIKit.h>

extern const NSString *kNRCalendarViewValidKey;
extern const NSString *kNRCalendarViewTimeKey;
extern const NSString *kNRCalendarViewDetailKey;
extern const NSString *kNRCalendarViewInfoKey;

@class NRCalendarView;

@protocol NRCalendarViewDelegate <NSObject>

- (void)calendarView:(NRCalendarView *)calendar didSelectWithIndex:(NSInteger)index dateArray:(NSArray <NSDate *>*)array;

@optional

/**
 取消选择时调用 可选
 */
- (void)calendarView:(NRCalendarView *)calendar deSelectWithIndex:(NSInteger)index dateArray:(NSArray <NSDate *>*)array;

/**
 当选择项大于最大选择数时调用
 */
- (void)calendarView:(NRCalendarView *)calendar didReachingMaxSelectNumber:(NSInteger)maxSelectNumber;

/**
 将要展示某个时间段内的数据 点击切换月份时调用
 @param startTime 时间段起始时间戳
 @param endTime 时间段结束时间戳
 */
- (void)calendarView:(NRCalendarView *)calendar didGoWithStartTimestamp:(long long)startTime endTimestamp:(long long)endTime;

@end

/**
 *  日历控件
 */
@interface NRCalendarView : UIView

@property (nonatomic, weak) id<NRCalendarViewDelegate> delegate;

/**
 选择的日期
 */
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) NSMutableArray *selectArray;

/**
 根据该数据来初始化指定日期的数据
 格式:
 @[
 @{
 kNRCalendarViewValidKey : @(1),           //是否有效
 kNRCalendarViewTimeKey : @(1481817600),   //时间戳
 kNRCalendarViewDetailKey : @"nie",        //底部detailLabel text
 kNRCalendarViewInfoKey : @"rui",         //中间infoLable text
 }
 ]
 */
@property (nonatomic, strong) NSArray *statusDicArray;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger month;

@property (nonatomic, assign) NSInteger year;

/**
 起始时间戳 指定最小显示日期
 */
@property (nonatomic, assign) long long startTimeStamp;

/**
 结束时间戳 指定最大显示日期
 */
@property (nonatomic, assign) long long endTimeStamp;

/**
 每个日期item的背景颜色
 */
@property (nonatomic, strong) UIColor *dayItemBackColor;

/**
 当天没有数据时 是否自动不让那天处于不可选状态 默认YES
 */
@property (nonatomic, assign) BOOL autoInvalid;

/**
 是否显示日期之间的分割线;
 */
@property (nonatomic, assign) BOOL showSeperateLine;

/**
 最多选择数量 默认 1
 */
@property (nonatomic, assign) NSInteger maxSelectNumber;

/**
 撤销对日期的更改 当外部网络请求失败或者没有数据时调用
 */
- (void)revokeDateChangeAction;

/**
 初始化日期子控件
 */
- (void)initDayItems;

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *forwardButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *titleBgView;

@property (nonatomic, strong) UIView *titleLineView;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *weekSeperateLineView;

@property (nonatomic, strong) UIView *itemBgView;

@end
