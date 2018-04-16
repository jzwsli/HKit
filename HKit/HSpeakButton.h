//
//  HSpeakStringButton.h
//  Demo
//  使用的时候，需要自己设置图片，正常状态播放，非正常状态暂停
//  Created by 张文军 on 2017/12/6.
//  Copyright © 2017年 xbwqlwq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSpeakButton;


@protocol HSpeakDelegate<NSObject>

@optional
-(void)speakButton:(HSpeakButton *)button playError:(NSError *)error;
-(void)speakEnd:(HSpeakButton *)button;

@end


@interface HSpeakButton : UIButton

@property(nonatomic,weak)NSObject<HSpeakDelegate> *delegate;

-(instancetype)initWithSpeakStr:(NSString *)str;
-(instancetype)initWithSpeakArr:(NSArray *)arr;
-(instancetype)initWithSpeakStr:(NSString *)str andLanguage:(NSString *)language;
-(instancetype)initWithSpeakArr:(NSArray *)arr andLanguage:(NSString *)language;

+(instancetype)speakButton;
+(instancetype)speakButtonWithSpeakStr:(NSString *)str;
+(instancetype)speakButtonWithSpeakArr:(NSArray *)arr;
+(instancetype)speakButtonWithSpeakStr:(NSString *)str andLanguage:(NSString *)language;
+(instancetype)speakButtonWithSpeakArr:(NSArray *)arr andLanguage:(NSString *)language;

-(void)changeSpeakStr:(NSString *)str;
-(void)changeSpeakArr:(NSArray *)arr;
-(void)changeLanguage:(NSString *)language;

-(void)clear;

@end

