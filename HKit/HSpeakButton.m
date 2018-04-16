//
//  HSpeakStringButton.m
//  Demo
//
//  Created by 张文军 on 2017/12/6.
//  Copyright © 2017年 xbwqlwq. All rights reserved.
//

#import "HSpeakButton.h"
#import <AVFoundation/AVFoundation.h>

@interface HSpeakButton ()<AVSpeechSynthesizerDelegate>

@property(nonatomic,assign)int speakIndex;

@property(nonatomic,copy)NSString *speakLanguage;
@property(nonatomic,copy)NSString *speakStr;
@property(nonatomic,strong)NSArray *speakArr;

/** 文字转语音对象*/
@property(nonatomic,strong)AVSpeechSynthesizer *speech;

@end


@implementation HSpeakButton

#pragma mark - 生命周期 Life Circle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 播放的
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithSpeakStr:(NSString *)str{
    
    if (str.length > 100) {
        if ([str containsString:@"\n"]) {
            return [self initWithSpeakArr:[str componentsSeparatedByString:@"\n"]];
        }else if([str containsString:@"。"]){
            return [self initWithSpeakArr:[str componentsSeparatedByString:@"。"]];
        }
    }
    self = [self init];
    if (self) {
        _speakStr = str;
    }
    return self;
    
}
-(instancetype)initWithSpeakArr:(NSArray *)arr{
    self = [self init];
    if (self) {
        _speakArr = arr;
    }
    return self;
}
-(instancetype)initWithSpeakStr:(NSString *)str andLanguage:(NSString *)language{
    self = [self initWithSpeakStr:str];
    if (self) {
        _speakLanguage = language;
    }
    return self;
}
-(instancetype)initWithSpeakArr:(NSArray *)arr andLanguage:(NSString *)language{
    self = [self initWithSpeakArr:arr];
    if (self) {
        _speakLanguage = language;
    }
    return self;
}

+(instancetype)speakButton{
    return [[self alloc] init];
}
+(instancetype)speakButtonWithSpeakStr:(NSString *)str{
    return [[self alloc] initWithSpeakStr:str];
}
+(instancetype)speakButtonWithSpeakArr:(NSArray *)arr{
    return [[self alloc] initWithSpeakArr:arr];
}
+(instancetype)speakButtonWithSpeakStr:(NSString *)str andLanguage:(NSString *)language{
    return [[self alloc] initWithSpeakStr:str andLanguage:language];
}
+(instancetype)speakButtonWithSpeakArr:(NSArray *)arr andLanguage:(NSString *)language{
    return [[self alloc] initWithSpeakArr:arr andLanguage:language];
}

-(void)clear{
    if (_speech) {
        [_speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        _speech = nil;
    }
}

-(void)dealloc{
    if (_speech) {
        [_speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
        _speech = nil;
    }
    NSLog(@"按钮挂了");
}

#pragma mark - 公开方法 public Methods
-(void)changeSpeakStr:(NSString *)str{
    if (str.length > 100) {
        if ([str containsString:@"\n"]) {
            _speakArr = [str componentsSeparatedByString:@"\n"];
            _speakStr = nil;
            return;
        }else if([str containsString:@"。"]){
            _speakArr = [str componentsSeparatedByString:@"。"];
            _speakStr = nil;
            return;
        }
    }
    _speakArr = nil;
    _speakStr = str;
    
    self.selected = NO;
    if (self.speech.isSpeaking || self.speech.isPaused) {
        [self.speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}
-(void)changeSpeakArr:(NSArray *)arr{
    _speakArr = arr;
    _speakStr = nil;
    
    self.selected = NO;
    if (self.speech.isSpeaking || self.speech.isPaused) {
        [self.speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}
-(void)changeLanguage:(NSString *)language{
    _speakLanguage = language;
    self.selected = NO;
    if (self.speech.isSpeaking || self.speech.isPaused) {
        [self.speech stopSpeakingAtBoundary:AVSpeechBoundaryWord];
    }
}

#pragma mark - 私有方法 private Methods
/** 判断字符串是否为空 */
-(BOOL)isBlankString:(NSString *)string{
    if ([string isKindOfClass:[NSString class]] == NO) {
        return YES;
    }
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if([string isEqualToString:@"(null)"]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - AVSpeechSynthesizerDelegate
-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    // 1. 如果是短句
    if (_speakStr) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakEnd:)]) {
            [self.delegate speakEnd:self];
        }
        self.selected = NO;
        return;
    }
    // 2. 如果是长句
    _speakIndex ++;
    // 2.1 判断结束条件
    if (_speakIndex >= self.speakArr.count) {
        _speakIndex = 0;
        self.selected = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(speakEnd:)]) {
            [self.delegate speakEnd:self];
        }
        return;
    }
    // 2.2 播放
    AVSpeechUtterance *utt =[AVSpeechUtterance speechUtteranceWithString:_speakArr[_speakIndex]];
    // 设置语言, //zh-CN 中文
    utt.voice=[AVSpeechSynthesisVoice voiceWithLanguage:self.speakLanguage];
    [self.speech speakUtterance:utt];
}

#pragma mark - Touch Event

-(void)click:(UIButton *)button{
    
    if (button.selected) {
        button.selected = NO;
        [self.speech pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
    }else{
        
        if ([self.speech isPaused]) {
            self.selected = YES;
            [self.speech continueSpeaking];
            return;
        }
        
        // 1. 如果是短句
        if (_speakStr) {
            // 1.1 条件判断
            if (_speakStr.length == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(speakButton:playError:)]) {
                    [self.delegate speakButton:self playError:[NSError errorWithDomain:@"播放内容不能为空" code:0 userInfo:0]];
                }
                return;
            }
            // 1.2 播放
            AVSpeechUtterance *utt =[AVSpeechUtterance speechUtteranceWithString:_speakStr];
            // 设置语言, //zh-CN 中文
            utt.voice=[AVSpeechSynthesisVoice voiceWithLanguage:self.speakLanguage];
            [self.speech speakUtterance:utt];
            self.selected = YES;
            return;
        }
        // 2. 如果是长句
        // 2.1 条件判断
        if (self.speakArr.count == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(speakButton:playError:)]) {
                [self.delegate speakButton:self playError:[NSError errorWithDomain:@"播放内容不能为空" code:0 userInfo:0]];
            }
            return;
        }
        _speakIndex = 0;
        NSString *str = self.speakArr[_speakIndex];
        // 2.2 播放
        AVSpeechUtterance *utt =[AVSpeechUtterance speechUtteranceWithString:str];
        // 设置语言, //zh-CN 中文
        utt.voice=[AVSpeechSynthesisVoice voiceWithLanguage:self.speakLanguage];
        [self.speech speakUtterance:utt];
        self.selected = YES;
    }
}

#pragma mark - getter and stter

-(AVSpeechSynthesizer *)speech{
    if (_speech == nil) {
        _speech = [[AVSpeechSynthesizer alloc] init];
        _speech.delegate = self;
    }
    return _speech;
}
-(NSString *)speakLanguage{
    if (_speakLanguage == nil) {
        _speakLanguage = @"zh-CN";
    }
    return _speakLanguage;
}

@end

