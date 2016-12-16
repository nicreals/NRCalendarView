//
//  NRCalendarItemView.h
//  Pods
//
//  Created by Nic on 2016/12/16.
//
//

#import <UIKit/UIKit.h>

@interface NRCalendarItemView : UIView

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *detailLabel;

/**
 几人想去
 */
@property (nonatomic, strong) UILabel *infoLable;

@property (nonatomic, assign) NSInteger day;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL isValid;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, assign) BOOL isWeekend;

@end
