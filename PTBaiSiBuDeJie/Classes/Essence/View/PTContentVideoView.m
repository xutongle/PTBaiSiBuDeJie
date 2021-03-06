//
//  PTContentVideoView.m
//  PTBaiSiBuDeJie
//
//  Created by hpt on 16/6/24.
//  Copyright © 2016年 hpt. All rights reserved.
//

#import "PTContentVideoView.h"
#import "PTPictureController.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "KRVideoPlayerController.h"



@interface PTContentVideoView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *playTime;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end

@implementation PTContentVideoView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPicture)]];
}

+ (instancetype)videoView {
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}

- (void)showPicture {
    PTPictureController *showPicVc = [[PTPictureController alloc]init];
    showPicVc.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicVc animated:YES completion:nil];
}

- (void)setTopic:(PTTopicModel *)topic {
    _topic = topic;
    self.playCount.text = [NSString stringWithFormat:@"%ld次播放",(long)topic.playcount];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.middle_image]];
    self.playTime.text = [NSString stringWithFormat:@"%02ld:%02ld", topic.videotime / 60, topic.videotime % 60];
}

// 播放按钮
- (IBAction)playBtn:(UIButton *)sender {
    
    [self playVideoWithURL:[NSURL URLWithString:self.topic.videouri]];
    [self addSubview:self.videoController.view];
}

- (void)playVideoWithURL:(NSURL *)url {
    if (!self.videoController) {
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:self.imageView.bounds];
        __weak typeof(self) weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
    }
    self.videoController.contentURL = url;
}

// 停止视频的播放
- (void)reset {
    [self.videoController dismiss];
    self.videoController = nil;
}

@end
