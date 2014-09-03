//
//  LSPProgressView.h
//
//  Created by Adam Yanalunas on 2/12/14.
//  Copyright (c) 2014 Amco International Education Services, LLC. All rights reserved.
//

@interface LSPProgressView : UIView

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *foregroundColor;
@property (nonatomic, strong) UIView *progressBackground;
@property (nonatomic, strong) UIView *progressBar;

+ (instancetype)newAutoLayoutView;

- (instancetype)initForAutoLayout;
- (void)setProgress:(Float64)amount;
- (void)setup;

@end
