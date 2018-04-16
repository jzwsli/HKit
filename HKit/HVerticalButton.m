//
//  HVerticalButton.m
//  bjabn
//
//  Created by hare on 2017/4/21.
//  Copyright © 2017年 bjabn. All rights reserved.
//

#import "HVerticalButton.h"
#import "UIView+Frame.h"

@implementation HVerticalButton

+(instancetype)h_buttonWithTitle:(NSString *)title image:(UIImage *)image{
    HVerticalButton *button = [[HVerticalButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.imageView.h_y = (self.h_height - self.imageView.h_height - self.titleLabel.h_height - 8 ) / 2;
    self.imageView.h_centerX = self.h_width / 2;
    self.titleLabel.h_centerX = self.h_width / 2;
    
    self.titleLabel.h_y = self.imageView.h_bottom+8;
}

@end
