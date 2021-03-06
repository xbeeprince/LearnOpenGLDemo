//
//  KondorShowVC.m
//  EX_appIOS
//
//  Created by mac_w on 2016/11/11.
//  Copyright © 2016年 aee. All rights reserved.
//

#import "KondorShowVC.h"
#import "cameraPhotoVC.h"
#import "modelSelectView.h"
#import "CameraTool.h"
#import "WTMoiveObject.h"
#import "ModelData.h"
#import "KondorViewVC.h"
#import "KondorNavigationVC.h"

// 选择照片的type 类型
typedef NS_ENUM(NSInteger, PhotoType) {
    Photo_Normal,
    Video_Normal,
    Photo_Burst,
    Photo_Interval,
    Photo_Lapse
};
// 拍照或者录像模式
typedef NS_ENUM(NSInteger, Status) {
    VIDEO_MODE,
    PHOTO_MODE
};

@interface KondorShowVC ()<choiceCameraModelDelegate>

@property(nonatomic,strong) NSURL *mediaUrl;
@property(nonatomic,strong) modelSelectView *modelView;

@property (nonatomic,assign)PhotoType type;

//播放器
//@property (nonatomic,strong) VMediaPlayer *videoPlayer;

@property (nonatomic,strong) NSTimer  *timer;

@property (nonatomic,strong) UILabel *countLabel;
//标题栏
@property (nonatomic,strong) UILabel *titleLabel;

//底部提示View
@property (nonatomic,strong) UILabel *tipsLabel;

@property (nonatomic,strong) UILabel *timeLabel;

//是否需要全屏；
@property (nonatomic,assign) BOOL needFullScreen;

@property (nonatomic,assign) BOOL controlling;

//蒙版视图
@property (nonatomic,strong) UIImageView *maskView;
//提示旋转图标
@property (nonatomic,strong) UIImageView *rolateImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic,strong) UIButton *backBtn;
@end


@implementation KondorShowVC

 static  NSInteger count =3;
 static  int timecount=0;
 bool canTake;
 bool isRecording;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ScreenH<667) {
        _topConstraint.constant=50;
    }
    
    canTake=YES;
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text=@"LIVE VIEW";
    _titleLabel=titleLabel;
    titleLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    _mediaUrl = [NSURL URLWithString:@"rtsp://192.168.42.1/live"];
//    
        NSURL *videoURL = [NSURL URLWithString:@"rtsp://192.168.42.1/live"];
        _mediaUrl=videoURL;
    _type=Video_Normal;
//
//    [_timer setFireDate:[NSDate distantFuture]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhotoSuccess:) name:@"getPhotoStatus" object:nil];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreenMeath)];
    
    [_videoPlayView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidLostConnect) name:@"SocketDidDisconnect" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(havegetrecordingtime:) name:@"getCurrentRecordTime" object:nil];
    
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
     [_backBtn setImage:[UIImage imageNamed:@"LIVE VIEW_3_"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    [_backBtn addTarget:self action:@selector(backBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)backBtnDidClicked{
    
    [_backBtn setImage:[UIImage imageNamed:@"backHightLight"] forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    
}



-(void)socketDidLostConnect{
    
//    [SVProgressHUD showErrorWithStatus:@"SOCKET LOST CONNECT"];
    
    [[CameraTool shareTool] connectingOperate];
    
}

-(void)havegetrecordingtime:(NSNotification *)noti{
    
    NSLog(@"----收到录像时间---");
    
}


-(void)fullScreenMeath{
    
   
    if(_needFullScreen==NO){
        _needFullScreen=YES;
        
//        _beginorstopButton.userInteractionEnabled=NO;
//        _changeModelButton.userInteractionEnabled=NO;
        
        
        _beginorstopButton.enabled=NO;
      CGRect  imageframe=_videoPlayView.frame;
        
        _videoPlayView.layer.anchorPoint=CGPointMake(0.5, 0.5);
//        _videoPlayView.transform = CGAffineTransformMakeRotation(90 *M_PI / 180.0);
        CGPoint sourceCenter=CGPointMake(ScreenW*0.5, imageframe.size.height*0.5+imageframe.origin.y);
        
        CGAffineTransform place = CGAffineTransformMakeTranslation(0, ScreenH*0.5-sourceCenter.y);
        CGAffineTransform rotation = CGAffineTransformRotate(place, 90 *M_PI / 180.0);
        CGAffineTransform scale = CGAffineTransformScale(rotation, ScreenH/imageframe.size.width, ScreenW/imageframe.size.height);
        
        _videoPlayView.transform = scale;
        
        
        [[UIApplication sharedApplication].keyWindow.layer addSublayer:_videoPlayView.layer];
        
    }else{
        _needFullScreen=NO;
        _beginorstopButton.enabled=YES;
//        CGPoint sourceCenter=CGPointMake(ScreenW*0.5, imageframe.size.height*0.5+imageframe.origin.y);
//        CGAffineTransform scale = CGAffineTransformMakeScale(imageframe.size.width/ScreenH, imageframe.size.height/ScreenW);
//        CGAffineTransform rotation = CGAffineTransformRotate(scale, 270 *M_PI / 180.0);
//        
//        CGAffineTransform place = CGAffineTransformTranslate(rotation, 0, -(ScreenH*0.5-sourceCenter.y));
////        CGAffineTransform place = CGAffineTransformMakeTranslation(0,-(ScreenH*0.5-sourceCenter.y));
        
        _videoPlayView.transform=CGAffineTransformIdentity;
//        [_videoPlayView.layer removeFromSuperlayer];
        [self.view.layer addSublayer:_videoPlayView.layer];
   
    }
    self.rolateImage.alpha=1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rolateImage.alpha=0;
    });
    
}

//拍照成功回调
-(void)takePhotoSuccess:(NSNotification *)noti{
    
    canTake=YES;
    if (noti.object==nil) {
        
        [self.view addSubview:self.tipsLabel];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tipsLabel removeFromSuperview];
        });
    }
    
}

- (IBAction)changeModelDidClicked:(id)sender {
    
    if (canTake==NO){
        [SVProgressHUD showErrorWithStatus:@"CAMERA IS BUSY"];
       return ;
    }
    
    [self.view addSubview:self.maskView]; //to do
    self.modelView.frame=CGRectMake((ScreenW-250)*0.5, ScreenH, 250, 315);
    self.modelView.layer.cornerRadius=15;
    self.modelView.layer.masksToBounds=YES;
    self.modelView.layer.borderColor=[UIColor colorWithRed:233.0/255.0 green:73.0/255.0 blue:74.0/255.0 alpha:1].CGColor;
    self.modelView.layer.borderWidth=2.0;
    self.modelView.delegate=self;
    [self.view addSubview:self.modelView];
    [UIView animateWithDuration:0.5 animations:^{
       self.modelView.frame=CGRectMake((ScreenW-250)*0.5, (ScreenH-300)*0.5, 250, 315);
    }];
    
}


- (IBAction)stopOrBeginBtnDidClicked:(UIButton *)sender {
    KondorNavigationVC *vierNav  = self.tabBarController.childViewControllers[0];

    KondorViewVC *vierwVC = vierNav.childViewControllers[0];
    if (vierwVC.needRefreshNet==NO) {
        
        vierwVC.needRefreshNet = YES;
    }
    
     if (sender.tag==2){
    
           if (_type==Video_Normal){
               isRecording=NO;
                //停止拍摄
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   canTake=YES;
                   
               });
                [[CameraTool shareTool] recordStopOperate];
               [_timeLabel removeFromSuperview];
               [_timer setFireDate:[NSDate distantFuture]];
               timecount=0;
               _timeLabel.text=@"00:00:00";
               _timer=nil;
                [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_5_"] forState:UIControlStateNormal];
           }else if (_type==Photo_Lapse){
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   canTake=YES;
                   [[CameraTool shareTool] stopLastPhoto];
                   
                   [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
                   
                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[WTMoiveObject sharedPlayer] connectToNewStream];
                   });
                   
               });
               
           }
    
             [_beginorstopButton setTag:0];
        }else{
    
            // 拍摄事件 .....
            if (canTake==NO) return;
            canTake=NO;
            if ([[CameraTool shareTool] isConnecting]){
                
                NSString *cardInfo = [[ModelData shareData] get_dv_fs];
                NSArray *subStrArr=[cardInfo componentsSeparatedByString:@" "];
                NSString *filecount=subStrArr.lastObject;
                NSString *leaveStore=subStrArr[1];
                
                if ([filecount intValue]==0&&[leaveStore intValue]==0) {
                    [SVProgressHUD showErrorWithStatus:@"NO SD_CARD"];
                    return;
                }
                if ([filecount intValue]!=0&&[leaveStore intValue]==0) {
                    [SVProgressHUD showErrorWithStatus:@"SD_CARD FULL"];
                    return;
                }
////
                switch (_type) {
                    case Photo_Normal:
                  
                      [[WTMoiveObject sharedPlayer] getOutStream];
                      
                      [[CameraTool shareTool] shutterOperate];
                       [_beginorstopButton setImage:[UIImage imageNamed:@"capturing"] forState:UIControlStateNormal];
                        break;
                    case Video_Normal:
                       [[CameraTool shareTool] recordOperate];
                        [self.view addSubview:self.timeLabel];
                        
                        //改变按钮图标暂停
                           [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_6_"] forState:UIControlStateNormal];
                        [_beginorstopButton setTag:2];
    
                        break;
                    case Photo_Burst:
//                             [[CameraTool shareTool] stopVF];
//                          [_videoPlayer pause];
                        [[WTMoiveObject sharedPlayer] getOutStream];
                         [[CameraTool shareTool] shutterOperate];
                          [_beginorstopButton setImage:[UIImage imageNamed:@"capturing"] forState:UIControlStateNormal];
                         break;
                    case Photo_Interval:
//                             [[CameraTool shareTool] stopVF];
//                          [_videoPlayer pause]; capturing@2x
                        [[WTMoiveObject sharedPlayer] getOutStream];
                        [_beginorstopButton setImage:[UIImage imageNamed:@"capturing"] forState:UIControlStateNormal];
                        break;
                    case Photo_Lapse:
                        [[WTMoiveObject sharedPlayer] getOutStream];
                        [[CameraTool shareTool] shutterOperate];
                        [_beginorstopButton setImage:[UIImage imageNamed:@"capturing"] forState:UIControlStateNormal];
                        [_beginorstopButton setTag:2];
    
                    default:
                        break;
                }
       
                if (_type==Photo_Normal||_type==Photo_Burst) {
                 
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        canTake=YES;
                         [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
                        [[WTMoiveObject sharedPlayer] connectToNewStream];
                        
                    });
                    
//                    [self playAgin];
                
                }else if(_type==Photo_Interval){
                    __weak typeof(self) weakSelf=self;
                        _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(setTimeCamer) userInfo:nil repeats:YES];
                    NSInteger atimer=[[CameraTool shareTool] timerCount];
                    if (atimer==0) {
                        count=3;
                    }else{
                        count=atimer;
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(count * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [[CameraTool shareTool] shutterOperate];
                      
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             canTake=YES;
                            [[WTMoiveObject sharedPlayer] connectToNewStream];
                              [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
                        });
                        
                    });
                }else if (_type==Video_Normal){
                    isRecording=YES;
                    [_timer setFireDate:[NSDate distantFuture]];
                    [_timer invalidate];
                    _timer=nil;
                    __weak typeof(self) weakSelf=self;
                    _timer =[NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(recoedVideoTime) userInfo:nil repeats:YES];
                   [self.view addSubview:self.timeLabel];
                }

            }else{
                [SVProgressHUD showErrorWithStatus:@"LOST CONNECTION"];
                [[CameraTool shareTool] connectingOperate];
            }
     
    }

    
    
}
//定时器拍照
-(void)setTimeCamer{
    
    if (count==0) {
        count=[[CameraTool shareTool] timerCount];
        [self.countLabel removeFromSuperview];
        
        [_timer setFireDate:[NSDate distantFuture]];
        return;
    }
    [self.view addSubview:self.countLabel];
    _countLabel.text=[NSString stringWithFormat:@"%zd",count];
    count--;
    
}
// 记录录制的时间「
-(void)recoedVideoTime{
    
    timecount++;
    NSString *hourString=[NSString stringWithFormat:@"00"];
    NSString *minuString=[NSString stringWithFormat:@"00"];
    NSString *secondString=[NSString stringWithFormat:@"00"];
    //时
    if (timecount>=3600) {
        int hour = timecount/3600;
        hourString=[NSString stringWithFormat:@"%zd",hour];
        if (hour<10) {
            
            hourString=[NSString stringWithFormat:@"0%zd",hour];
        }
        
        int min=timecount%3600;
        
        int minuse = min/60;
        minuString=[NSString stringWithFormat:@"%zd",minuse];
        if (minuse<10) {
            minuString=[NSString stringWithFormat:@"0%zd",minuse];
        }
        
        int second = min%60;
        secondString=[NSString stringWithFormat:@"%zd",second];
        if (second<10) {
            secondString=[NSString stringWithFormat:@"0%zd",second];
        }

        
    }else if (timecount>=60) {
        
        int minuse = timecount/60;
        minuString=[NSString stringWithFormat:@"%zd",minuse];
        if (minuse<10) {
            minuString=[NSString stringWithFormat:@"0%zd",minuse];
        }
        int second = timecount%60;
        secondString=[NSString stringWithFormat:@"%zd",second];
        if (second<10) {
            secondString=[NSString stringWithFormat:@"0%zd",second];
        }
        
    }else{
        
        secondString=[NSString stringWithFormat:@"%zd",timecount];
        if (timecount<10) {
            secondString=[NSString stringWithFormat:@"0%zd",timecount];
        }
  
    }
    
    _timeLabel.text=[NSString stringWithFormat:@"%@:%@:%@",hourString,minuString,secondString];

}

//拍照时重新播放方法
-(void)playAgin{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[CameraTool shareTool] resetVF];
//        [_videoPlayer reset];
//        [_videoPlayer unSetupPlayer];
//        //                isResume = NO;
//        _videoPlayer = [VMediaPlayer sharedInstance];
//        [_videoPlayer setupPlayerWithCarrierView:self.videoPlayView withDelegate:self];
//        NSURL *videoURL = [NSURL URLWithString:@"rtsp://192.168.42.1/live"];
//        [_videoPlayer setDataSource:videoURL];
//        [_videoPlayer prepareAsync];
        
    });
}

//切换相机模式---选择界面代理方法
-(void)customerChoiceCameraModelWithCount:(NSInteger)count{
    
    switch (count) {
        case 1:
            _type=Photo_Normal;
            _titleLabel.text=@"CAMERA";
            [[CameraTool  shareTool] setOptionsMode:@"photo_cap_mode_nor" Type:@"photo_mode"];
            [_changeModelButton setImage:[UIImage imageNamed:@"VIDEO_1_"] forState:UIControlStateNormal];
            [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
            
            //   TIME LAPSE PHOTO  VIDEO_9_@2x    VIDEO_4_
            break;
        case 2:
            _type=Video_Normal;
            _titleLabel.text=@"VIDEO";
//            [[CameraTool  shareTool] setOptionsMode:@"photo_cap_mode_nor" Type:@"photo_mode"]; LIVE VIEW_4_
            [_tipsLabel removeFromSuperview];
            [_changeModelButton setImage:[UIImage imageNamed:@"VIDEO_3_"] forState:UIControlStateNormal];
            [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_5_"] forState:UIControlStateNormal];
            break;
        case 3:
            _type=Photo_Burst;
              _titleLabel.text=@"BURST";
            [[CameraTool  shareTool] setOptionsMode:@"photo_cap_mode_fas" Type:@"photo_mode"];
            [_changeModelButton setImage:[UIImage imageNamed:@"VIDEO_2_"] forState:UIControlStateNormal];
            [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
            break;
        case 4:
            _type=Photo_Interval;
              _titleLabel.text=@"TIMER";
           [[CameraTool  shareTool] setOptionsMode:@"photo_cap_mode_nor" Type:@"photo_mode"];
           [_changeModelButton setImage:[UIImage imageNamed:@"VIDEO_9_"] forState:UIControlStateNormal];
           [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
           
            break;
        case 5:
            _type=Photo_Lapse;
            _titleLabel.text=@"LAPSE";
            [[CameraTool  shareTool] setOptionsMode:@"photo_cap_mode_tlm" Type:@"photo_mode"];
            [_changeModelButton setImage:[UIImage imageNamed:@"VIDEO_4_"] forState:UIControlStateNormal];
            [_beginorstopButton setImage:[UIImage imageNamed:@"LIVE VIEW_4_"] forState:UIControlStateNormal];
            
            break;
            
        default:
            break;
    }
    
    
}

//注销关闭播放器
- (void)closePlayer{
   
   
}
//移除视图
-(void)didRemoveMyMaskView{
    [self.maskView removeFromSuperview];
    [self.modelView removeFromSuperview];
    
}

#pragma mark -- 控制器生命周期方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [[WTMoiveObject sharedPlayer] playWithImageView:_videoPlayView];
//getCurrentRecordTime
    
    //如果正在录制就要矫正时间
//    if (isRecording==YES) {
//        [[CameraTool shareTool] getRecordingTime];
//    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.rolateImage.frame=CGRectMake(ScreenW-80, 10, 50, 50);
    [self.videoPlayView addSubview:self.rolateImage];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.rolateImage.alpha=0;
    });
    
      [SVProgressHUD dismiss];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[WTMoiveObject sharedPlayer] StopPlay];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -- 懒加载
-(UILabel *)countLabel
{
    if (_countLabel==nil) {
        _countLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenW-50)*0.5, (ScreenH-50)*0.5, 50, 50)];
        _countLabel.font=[UIFont systemFontOfSize:30];
        _countLabel.textAlignment=NSTextAlignmentCenter;
        _countLabel.textColor=[UIColor whiteColor];
    }
    return _countLabel;
}

-(UILabel *)tipsLabel{
    
    if (_tipsLabel==nil) {
        _tipsLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenW-200)*0.5, ScreenH-146-64, 200, 30)];
        _tipsLabel.backgroundColor=[UIColor lightGrayColor];
        _tipsLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:12];
        _tipsLabel.text=@"PHOTO CAPTURED";
        _tipsLabel.textColor=[UIColor whiteColor];
        _tipsLabel.textAlignment=NSTextAlignmentCenter;
        _tipsLabel.layer.cornerRadius=15;
        _tipsLabel.layer.masksToBounds=YES;
    }
    return _tipsLabel;
}

-(UILabel *)timeLabel{
    
    if (_timeLabel==nil) {
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake((ScreenW-272)*0.5, ScreenH-156-70, 272, 70)];
        _timeLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:40];
        _timeLabel.text=@"00:00:00";
        _timeLabel.textColor=[UIColor whiteColor];
        _timeLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _timeLabel;
}


-(modelSelectView *)modelView
{
    if (_modelView==nil) {
        _modelView=[[modelSelectView alloc]init];
    }
    return _modelView;
}

-(UIImageView *)maskView
{
    if (_maskView==nil) {
        _maskView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskView.userInteractionEnabled=YES;
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didRemoveMyMaskView)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}

-(UIImageView *)rolateImage
{
    
    if (_rolateImage==nil) {
        _rolateImage=[[UIImageView alloc]init];
        _rolateImage.image=[UIImage imageNamed:@"rotate"];
    }
    return _rolateImage;
}



-(void)dealloc{
    
    [_timer invalidate];
    _timer=nil;
    
}

@end
