//
//  LSPProgressView.h
//
//  Created by Adam Yanalunas on 2/12/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN


@interface LSPProgressView : UIView

@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *foregroundColor;
@property (nonatomic) UIView *progressBackground;
@property (nonatomic) UIView *progressBar;

- (instancetype)initForAutoLayout NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)newAutoLayoutView;

- (void)setProgress:(Float64)amount;
- (void)setup;

@end

NS_ASSUME_NONNULL_END
