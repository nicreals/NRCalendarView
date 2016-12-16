//
//  NRCalendarItemView.m
//  Pods
//
//  Created by Nic on 16/9/8.
//
//

#import "NRCalendarItemView.h"
#import <Masonry/Masonry.h>

@implementation NRCalendarItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self setConstraints];
    }
    return self;
}


- (void)initView {
    self.backgroundColor = [UIColor clearColor];
    {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        self.bgView = view;
    }
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor =  [UIColor colorWithRed:150.f / 255.f green:150.f / 255.f blue:150.f / 255.f alpha:1.f];
        label.font = [UIFont systemFontOfSize:18.f];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.titleLabel = label;
    }
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor =  [UIColor colorWithRed:150.f / 255.f green:150.f / 255.f blue:150.f / 255.f alpha:1.f];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.detailLabel = label;
    }
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor =  [UIColor colorWithRed:150.f / 255.f green:150.f / 255.f blue:150.f / 255.f alpha:1.f];
        label.text = @" ";
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.infoLable = label;
    }
    {
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = [ UIColor clearColor];
        [self addSubview:button];
        self.coverButton = button;
    }
}

- (void)setConstraints {
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView);
        make.bottom.equalTo(_bgView.mas_centerY).offset(-3);
    }];
    [_infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bgView);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView);
        make.top.equalTo(_infoLable.mas_bottom).offset(1);
    }];
    [_coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_bgView);
    }];
}

- (void)setIsValid:(BOOL)isValid {
    if (isValid == _isValid) {
        return;
    }
    _isValid = isValid;
    [self updateLabelStatus];
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    [self updateLabelStatus];
}

- (void)updateLabelStatus {
    [UIView animateWithDuration:0.2f animations:^{
        if (_isValid) {
            _coverButton.enabled = YES;
            if (_isWeekend) { // 如果是周末 日期为红色
                //            _titleLabel.textColor = [UIColor colorWithRed:250.f / 255.f green:110.f / 255.f blue:81.f / 255.f alpha:1.f];
            }
            if (_isSelected) {
                _titleLabel.textColor = [UIColor whiteColor];
                _detailLabel.textColor = [UIColor whiteColor];
                _infoLable.textColor = [UIColor whiteColor];
                _bgView.backgroundColor = [UIColor colorWithRed:250.f / 255.f green:110.f / 255.f blue:81.f / 255.f alpha:1.f];
            } else {
                _titleLabel.textColor = [UIColor colorWithRed:60.f / 255.f green:60.f / 255.f blue:60.f / 255.f alpha:1.f];
                _detailLabel.textColor = [UIColor colorWithRed:250.f / 255.f green:110.f / 255.f blue:81.f / 255.f alpha:1.f];
                _infoLable.textColor = [UIColor blackColor];
                _bgView.backgroundColor = [UIColor whiteColor];
            }
        } else {
            _titleLabel.textColor = [UIColor colorWithRed:160.f / 255.f green:160.f / 255.f blue:160.f / 255.f alpha:1.f];
            _detailLabel.textColor =[UIColor colorWithRed:160.f / 255.f green:160.f / 255.f blue:160.f / 255.f alpha:1.f];
            _coverButton.enabled = NO;
        }
    }];
}

@end
