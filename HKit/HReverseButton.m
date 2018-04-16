//
//  HButton.m
//  bjabn
//
//  Created by hare on 2017/4/20.
//  Copyright © 2017年 bjabn. All rights reserved.
//

#import "HReverseButton.h"
#import "UIView+Frame.h"

@implementation HReverseButton

+(instancetype)h_buttonWithTitle:(NSString *)title image:(UIImage *)image{
    HReverseButton *button = [[HReverseButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.h_x = (self.h_width - self.titleLabel.h_width - self.imageView.h_width)/2.0;
    self.imageView.h_x = self.titleLabel.h_right;
    
}

@end
