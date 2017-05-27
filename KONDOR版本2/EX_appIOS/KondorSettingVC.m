//
//  KondorSettingVC.m
//  EX_appIOS
//
//  Created by mac_w on 2016/11/8.
//  Copyright © 2016年 aee. All rights reserved.
//

#import "KondorSettingVC.h"
#import "settingControllerCell.h"
#import "settingHeaderView.h"
#import "CameraTool.h"
#import "CameraInfoTwelve.h"
#import "settingCellmodel.h"


@interface KondorSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong) NSMutableArray *sectionArr;
@property(nonatomic,strong) NSMutableArray *sectionImgArr;

@property(nonatomic,strong)  CameraInfoTwelve *twelveInfo ;

//可选项数组
@property(nonatomic,strong) NSArray *paramArr;

@property(nonatomic,strong) UIScrollView *selectView;

@property(nonatomic,copy) settingCellmodel *selectedModel;

//z遮挡视图
@property(nonatomic,strong) UIView *SmaskView;

@property(nonatomic,strong) UIView *WifiView;

@property(nonatomic,strong) UITextField *wifiNamefied;
@property(nonatomic,strong) UITextField *wifiPassWordfied;

@property (nonatomic,strong) UIButton *backBtn;

@end

@implementation KondorSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.view.backgroundColor=[UIColor grayColor];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLabel.text=@"SETTINGS";
    titleLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:20];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
    
    [SVProgressHUD show];
    if (![[CameraTool shareTool] isConnecting]) {
        [[CameraTool shareTool] connectingOperate];
    }
 
    [self addNotification];
    
    
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_backBtn setImage:[UIImage imageNamed:@"LIVE VIEW_3_"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    [_backBtn addTarget:self action:@selector(backBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
  }

-(void)backBtnDidClicked{
    
    [_backBtn setImage:[UIImage imageNamed:@"backHightLight"] forState:UIControlStateNormal];
     [[CameraTool shareTool] resetVF];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          [_backBtn setImage:[UIImage imageNamed:@"LIVE VIEW_3_"] forState:UIControlStateNormal];
        
        [self.tabBarController setSelectedIndex:1];
        
    });
    
    
}



-(void)checkIsCameraAllInfo:(NSNotification *)noti{
    
    [SVProgressHUD dismiss];
    
    _tableView=nil;
    _dataArr=nil;
    _paramArr=nil;
    
    _twelveInfo=noti.object;
    
    [self.view addSubview:self.tableView];

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *sectionArr=self.dataArr[section];
    
    return sectionArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    settingHeaderView *headerview=[[settingHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    
    headerview.iconView.image=[UIImage imageNamed:self.sectionImgArr[section]];
    
    headerview.nameLabel.text=self.sectionArr[section];
    
    return headerview;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    settingControllerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"setting"];
    if (cell==nil) {
        cell=[[NSBundle mainBundle] loadNibNamed:@"settingControllerCell" owner:self options:nil].lastObject;
    }
    NSMutableArray *sectionArr=self.dataArr[indexPath.section];
    settingCellmodel *mode=sectionArr[indexPath.row];
    cell.namelabel.text=mode.nameString;
    cell.infoLabel.text=mode.infoString;
    
    
    if ([mode.typeString isEqualToString:@"photo_selftimer"]){
        NSInteger astring=[[CameraTool shareTool] timerCount];
        if (astring==0) {
            astring=3;
        }
        NSString *string=[NSString stringWithFormat:@"%ld",(long)astring];
        cell.infoLabel.text=string;
 
    }
    
  
    return cell;
}

#pragma mark --- cell被选中的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSMutableArray *sectionArr=_dataArr[indexPath.section];
    settingCellmodel *model=sectionArr[indexPath.row];
   
    _selectedModel=model;
//    [[CameraTool shareTool] getSingleWithOption:model.typeString];
    
    [SVProgressHUD show];
    if ([model.typeString isEqualToString:@"photo_size"]) {
        
        [[CameraTool shareTool] getSingleWithOption:model.typeString];
    
    }else if ([model.typeString isEqualToString:@"photo_stamp"]){
       [[CameraTool shareTool] getSingleWithOption:model.typeString];
    }else if ([model.typeString isEqualToString:@"video_quality"]){
      [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"video_resolution"]){
       [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"video_loop_back"]){
        [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"video_stamp"]){
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"photo_shot_mode"]){
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"photo_selftimer"]){
        
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
    }else if ([model.typeString isEqualToString:@"photo_tlm"] ){
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
    }
    else if ([model.typeString isEqualToString:@"key_tone"]){
        
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
    }else if ([model.typeString isEqualToString:@"setup_selflamp"]){
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"video_standard"]){
         [[CameraTool shareTool] getSingleWithOption:model.typeString];
        
    }else if ([model.typeString isEqualToString:@"language"]){
        [[CameraTool shareTool] getSingleWithOption:model.typeString];
    }else if ([model.typeString isEqualToString:@"WIFI"]){
        [SVProgressHUD dismiss];
        [self.view addSubview:self.SmaskView];
        [self.view addSubview:self.WifiView];
        
    }else if ([model.typeString isEqualToString:@"DATE/TIME"]){
          [[CameraTool shareTool] setOptionsMode:model.infoString Type:@"camera_clock"];
        
        
    }else if ([model.typeString isEqualToString:@"FORMAT"]){
        
        UIAlertView  *aletView=[[UIAlertView alloc]initWithTitle:@"WARNING" message:@"Are you sure you want to format your SD card? This will delete all media." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [aletView show];
        
        
    }else if ([model.typeString isEqualToString:@"RESTORE DEFAULT"]){
        
        UIAlertView  *aletView=[[UIAlertView alloc]initWithTitle:@"WARNING" message:@"Are you sure you want to restore default?" delegate:self cancelButtonTitle:@" Cancel" otherButtonTitles:@"Confirm", nil];
        [aletView show];
       
    }else if ([model.typeString isEqualToString:@"USER AGREEMENT"]){
        
        return;
    }
    

}
#pragma mark --- 确认视图代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [SVProgressHUD dismiss];
    if (buttonIndex!=0) {
        
        if ([_selectedModel.typeString isEqualToString:@"FORMAT"]) {
            [[CameraTool shareTool] formatSDCard];
            
        }else{
             [[CameraTool shareTool] initDefaultSetting];
        }
        
    }else{
        return ;
    }
    
}



#pragma mark -- 注册通知及回调方法
//添加通知
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkIsCameraAllInfo:) name:@"GetAllCameraInfo" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSingleSetting:) name:@"getSingleOptions" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSingleSetting:) name:@"setSingleOptions" object:nil];
}
-(void)getSingleSetting:(NSNotification *)noti{
    [SVProgressHUD dismiss];
    NSDictionary *dic = noti.object;
    
    self.paramArr = dic[@"options"];
   
    [self creatSelectionView];
    
    
}


-(void)setSingleSetting:(NSNotification *)noti{
    [SVProgressHUD dismiss];
    
    [WTMoiveObject sharedPlayer].needReConnect=YES;
    
    [_SmaskView removeFromSuperview];
    [_selectView removeFromSuperview];
    [SVProgressHUD showSuccessWithStatus:@"SETTING SUCCESS"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[CameraTool shareTool] isConnecting]) {
            [SVProgressHUD show];
            [[CameraTool shareTool] getAllOptions];
            
        }
    });
    NSLog(@"设置成功");
}

#pragma mark -- 创建显示VIew方法
-(void)creatSelectionView{
    
    if (self.selectView!=nil) {
        [self.selectView removeFromSuperview];
    }
    
    [self.view addSubview:self.SmaskView];
    
    CGFloat height=0.0;
    if (44*(self.paramArr.count+1)>400) {
        height=400;
    }else{
        height=44*(self.paramArr.count+1);
    }
    self.selectView=[[UIScrollView alloc]initWithFrame:CGRectMake((ScreenW-300)*0.5, (ScreenH-height)*0.5, 300, height)];
    self.selectView.backgroundColor=[UIColor lightGrayColor];
    [self.view  addSubview:self.SmaskView];
    [self.view addSubview:self.selectView];
    
    self.selectView.layer.cornerRadius=15;
    self.selectView.layer.masksToBounds=YES;
    self.selectView.layer.borderColor=[UIColor redColor].CGColor;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
    tipLabel.textAlignment=NSTextAlignmentCenter;
    tipLabel.font=[UIFont systemFontOfSize:18];
    tipLabel.textColor=[UIColor whiteColor];
    tipLabel.text=_selectedModel.nameString;
    [self.selectView addSubview:tipLabel];
    
    for (int i=0; i<self.paramArr.count; i++) {
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, (i+1)*44, 300, 44)];
        btn.tag=i;
        [btn addTarget:self action:@selector(setPropertyBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor=[UIColor grayColor];
        
        NSString *gettedTitle = _paramArr[i];
        if ([gettedTitle isEqualToString:@"photo_stamp_dat"]) {
            gettedTitle=@"date";
        }else if ([gettedTitle isEqualToString:@"photo_stamp_tim"]){
            gettedTitle=@"time";
        }else if ([gettedTitle isEqualToString:@"photo_stamp_bot"]){
            gettedTitle=@"date/time";
        }else if ([gettedTitle isEqualToString:@"photo_stamp_off"]){
            gettedTitle=@"off";
        }else if ([gettedTitle isEqualToString:@"setup_loop_back_on_"]){
            gettedTitle=@"on";
        }else if ([gettedTitle isEqualToString:@"setup_loop_back_off"]){
            gettedTitle=@"off";
        }else if ([gettedTitle isEqualToString:@"photo_shot_03"]){
            gettedTitle=@"3 photos/s";
        }else if ([gettedTitle isEqualToString:@"photo_shot_06"]){
            gettedTitle=@"6 photos/s";
        }else if ([gettedTitle isEqualToString:@"photo_shot_08"]){
            gettedTitle=@"8 photos/s";
        } else if ([gettedTitle isEqualToString:@"photo_selftimer_03s"]){
            gettedTitle=@"3 s";
        }else if ([gettedTitle isEqualToString:@"photo_selftimer_05s"]){
            gettedTitle=@"5 s";
        }else if ([gettedTitle isEqualToString:@"photo_selftimer_10s"]){
            gettedTitle=@"10 s";
        }else if ([gettedTitle isEqualToString:@"photo_selftimer_off"]){
            gettedTitle=@"off";
        } else if ([gettedTitle isEqualToString:@"photo_laps_off"]){
            gettedTitle=@"off";
        }else if ([gettedTitle isEqualToString:@"photo_tlm_01s"]){
            gettedTitle=@"1 s";
        }else if ([gettedTitle isEqualToString:@"photo_tlm_02s"]){
            gettedTitle=@"2 s";
        }else if ([gettedTitle isEqualToString:@"photo_tlm_03s"]){
            gettedTitle=@"3 s";
        }else if ([gettedTitle isEqualToString:@"photo_tlm_05s"]){
            gettedTitle=@"5 s";
        }else if ([gettedTitle isEqualToString:@"photo_tlm_10s"]){
            gettedTitle=@"10 s";
        }else if ([gettedTitle isEqualToString:@"photo_tlm_20s"]){
            gettedTitle=@"20 s";
        }else if ([gettedTitle isEqualToString:@"setup_key_tone_off"]){
            gettedTitle=@"off";
        }else if ([gettedTitle isEqualToString:@"setup_key_tone_med"]){
            gettedTitle=@"med";
        }else if ([gettedTitle isEqualToString:@"setup_key_tone_sta"]){
            gettedTitle=@"sta";
        }else if ([gettedTitle isEqualToString:@"setup_selflamp_off"]){
            gettedTitle=@"off";
        }else if ([gettedTitle isEqualToString:@"setup_selflamp_on_"]){
            gettedTitle=@"on";
        }
        
        
        [btn setTitle:gettedTitle forState:UIControlStateNormal];
        [self.selectView addSubview:btn];
    }
    self.selectView.contentSize=CGSizeMake(300, 44*(self.paramArr.count+1));
    self.selectView.scrollEnabled=YES;
    [SVProgressHUD dismiss];
    
}

//各个选项点击事件--设置属性事件
-(void)setPropertyBtnDidClicked:(UIButton *)btn{
    [SVProgressHUD show];
    
    if ([_selectedModel.typeString isEqualToString:@"photo_selftimer"]){
        
        NSInteger count;
        switch (btn.tag) {
            case 0:
                 count=3;
                break;
            case 1:
                 count=5;
                break;
            case 2:
                 count=10;
                break;
            case 3:
                count=0;
                break;
            default:
                break;
        }
         [[CameraTool shareTool] setTimerCount:count];
        [SVProgressHUD showSuccessWithStatus:@"SETTING SUCCESS"];
        [WTMoiveObject sharedPlayer].needReConnect=YES;
        [_SmaskView removeFromSuperview];
        [_selectView removeFromSuperview];
        [self.tableView reloadData];
    
    }else{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[CameraTool shareTool] setOptionsMode:_paramArr[btn.tag] Type:_selectedModel.typeString];
        });
        
    }
    
}

-(void)settingBtnDIdClicked{
    
    
    if (_wifiNamefied.text==nil||[_wifiNamefied.text isEqualToString:@""]||_wifiPassWordfied.text==nil||[_wifiPassWordfied.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"NAME OR PASSWORD IS EMPTY"];
        return;
    }else if (_wifiPassWordfied.text.length<8){
        
        [SVProgressHUD showErrorWithStatus:@"Password Should Be a Minimum of 8 Characters"];
    }else{
        
        [_WifiView removeFromSuperview];
        NSString*nameAndPss= [NSString stringWithFormat:@"%@$%@",_wifiNamefied.text,_wifiPassWordfied.text];
        [[CameraTool shareTool] setWiFiInfoWithNewNameAndPassword:nameAndPss];
        [SVProgressHUD showSuccessWithStatus:@"Setup successful, please wait 2 minutes before turning on the camera's Wi-Fi and reconnecting"];
    }
    
}



#pragma mark --- 生命周期方法
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addNotification];
    
}



-(void)viewDidAppear:(BOOL)animated
{
      [super viewDidAppear:animated];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([[CameraTool shareTool] isConnecting]==NO){
            
            [SVProgressHUD showErrorWithStatus:@"THIS OPTION REQUIRES CONNECTION TO THE CAMERA"];
        }else{
            
            if (_dataArr==nil) {
                [SVProgressHUD showWithStatus:@"LOADING"];
                
                [[CameraTool shareTool] stopVF];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[CameraTool shareTool] getAllOptions];
                });
            }
            
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           
            [SVProgressHUD dismiss];
        });
    });
    
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [[CameraTool shareTool] resetVF];
    [SVProgressHUD dismiss];
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
    [super viewDidDisappear:animated];
    
}



//懒加载
-(UITableView *)tableView
{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH-64-44)];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
        _tableView.backgroundColor=[UIColor lightGrayColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        
//        _tableView.autoresizesSubviews=NO;
//        _tableView.
    }
    return _tableView;
}

-(NSMutableArray *)dataArr
{

    if (_dataArr==nil) {
        
        //第一组
        settingCellmodel *mode1=[[settingCellmodel alloc]init];
        mode1.nameString=@"IMAGE SIZE";
        mode1.infoString=_twelveInfo.photo_size;
        mode1.typeString=@"photo_size";
        
        settingCellmodel *mode2=[[settingCellmodel alloc]init];
        mode2.nameString=@"TIME STAMP";
        NSArray *strArr0= [_twelveInfo.photo_stamp componentsSeparatedByString:@"_"];

        mode2.infoString=strArr0.lastObject;
        mode2.typeString=@"photo_stamp";
        
        //第二组
        settingCellmodel *mode3=[[settingCellmodel alloc]init];
        mode3.nameString=@"VIDEO QUALITY";
        mode3.infoString=_twelveInfo.video_quality;
        mode3.typeString=@"video_quality";
        
        settingCellmodel *mode4=[[settingCellmodel alloc]init];
        mode4.nameString=@"VIDEO SIZE";
        mode4.infoString=_twelveInfo.video_resolution;
        
        //如果是1080P的图片，让中间的视图添加标示图片
        
        mode4.typeString=@"video_resolution";
        
        settingCellmodel *mode5=[[settingCellmodel alloc]init];
        mode5.nameString=@"LOOP OVERWRITE";
        NSArray *strArr= [_twelveInfo.video_loop_back componentsSeparatedByString:@"_"];
        mode5.infoString=strArr.lastObject;
        mode5.typeString=@"video_loop_back";
        
        settingCellmodel *mode6=[[settingCellmodel alloc]init];
        mode6.nameString=@"TIME STAMP";
        mode6.infoString=_twelveInfo.video_stamp;
        mode6.typeString=@"video_stamp";
        //第三组
        settingCellmodel *mode7=[[settingCellmodel alloc]init];
        mode7.nameString=@"IMAGE SIZE";
        mode7.infoString=_twelveInfo.photo_size;
        mode7.typeString=@"photo_size";
        
        settingCellmodel *mode8=[[settingCellmodel alloc]init];
        mode8.nameString=@"SHOOTING MODE";
        NSArray *str2=[_twelveInfo.photo_shot_mode componentsSeparatedByString:@"_"];
        NSString *numberPhotos=str2.lastObject;
        NSString *nsss=[numberPhotos substringFromIndex:1];
        
        mode8.infoString=[NSString stringWithFormat:@"%@photos/s",nsss];
        mode8.typeString=@"photo_shot_mode";
        
        //第四组
        settingCellmodel *mode9=[[settingCellmodel alloc]init];
        mode9.nameString=@"IMAGE SIZE";
        mode9.infoString=_twelveInfo.photo_size;
        mode9.typeString=@"photo_size";
        
        settingCellmodel *mode10=[[settingCellmodel alloc]init];
        mode10.nameString=@"SHOOTING MODE";
        NSArray *strArr3=[_twelveInfo.photo_shot_mode componentsSeparatedByString:@"_"];//?
        mode10.infoString=strArr3.lastObject;
        mode10.typeString=@"photo_selftimer";
        
        //第五组
        settingCellmodel *mode11=[[settingCellmodel alloc]init];
        mode11.nameString=@"IMAGE SIZE";
        mode11.infoString=_twelveInfo.photo_size;
        mode11.typeString=@"photo_size";
        
        settingCellmodel *mode12=[[settingCellmodel alloc]init];
        mode12.nameString=@"SHOOTING MODE";
        NSArray *strArr4=[_twelveInfo.photo_tlm componentsSeparatedByString:@"_"];
        NSString *nPhotos=strArr4.lastObject;
        NSString *nstr;
        if ([nPhotos hasPrefix:@"0"]) {
            nstr=[nPhotos substringFromIndex:1];
        }else if ([nPhotos hasPrefix:@"p"]){
            nstr=@"0.5s";
        }else{
            nstr=nPhotos;
        }
        
        mode12.infoString=nstr;
        mode12.typeString=@"photo_tlm"; //timelapse_photo
        
        //第六组
        settingCellmodel *mode13=[[settingCellmodel alloc]init];
        mode13.nameString=@"WI-FI";
        mode13.infoString=@"     ";
        mode13.typeString=@"WIFI";
        
        settingCellmodel *mode14=[[settingCellmodel alloc]init];
        mode14.nameString=@"WARNING TONE";
//        NSArray *strArr4=[_twelveInfo.key_tone componentsSeparatedByString:@"_"];
        mode14.infoString=@"Standard";
        mode14.typeString=@"key_tone";
        
        settingCellmodel *mode15=[[settingCellmodel alloc]init];
        NSArray *strArr5=[_twelveInfo.setup_selflamp componentsSeparatedByString:@"_"];
        mode15.infoString=strArr5[strArr5.count-2];
        mode15.nameString=@"STATUS INDICATOR";
        mode15.typeString=@"setup_selflamp";
//        mode13.infoString=_twelveInfo.setup_selflamp;
        settingCellmodel *mode16=[[settingCellmodel alloc]init];
        mode16.nameString=@"TV OUTPUT";
        mode16.infoString=_twelveInfo.video_standard;
        mode16.typeString=@"video_standard";
        
        settingCellmodel *mode17=[[settingCellmodel alloc]init];
        mode17.nameString=@"DV LANGUAGE";
        mode17.infoString=_twelveInfo.language;
        mode17.typeString=@"language";
        
        settingCellmodel *mode18=[[settingCellmodel alloc]init];
        mode18.nameString=@"DATE/TIME";
        NSDateFormatter *format=[[NSDateFormatter alloc]init];
        [format setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *dateString=[format stringFromDate:[NSDate date]];
        mode18.infoString=dateString;
        
        mode18.typeString=@"DATE/TIME";
        
        settingCellmodel *mode19=[[settingCellmodel alloc]init];
        mode19.nameString=@"FORMAT";
        mode19.infoString=@"   "; //格式化
        mode19.typeString=@"FORMAT";
        
        settingCellmodel *mode20=[[settingCellmodel alloc]init];
        mode20.nameString=@"RESTORE DEFAULT";//恢复出厂设置
        mode20.infoString=@"  ";
        mode20.typeString=@"RESTORE DEFAULT";
        
   
        NSMutableArray *da1=[NSMutableArray arrayWithObjects:mode1,mode2, nil];
        NSMutableArray *da2=[NSMutableArray arrayWithObjects:mode3,mode4,mode5,mode6, nil];
        NSMutableArray *da3=[NSMutableArray arrayWithObjects:mode7,mode8, nil];
        NSMutableArray *da4=[NSMutableArray arrayWithObjects:mode9,mode10, nil];
        NSMutableArray *da5=[NSMutableArray arrayWithObjects:mode11,mode12, nil];
        NSMutableArray *da6=[NSMutableArray arrayWithObjects:mode13,mode14,mode15,mode16,mode17,mode18, mode19, mode20, nil];
        
        _dataArr=[NSMutableArray arrayWithObjects:da1,da2,da3,da4,da5,da6,nil];
    }
    return _dataArr;
}

-(void)removeMaskFromSuper{
    if (_wifiNamefied.isFirstResponder==YES||_wifiPassWordfied.isFirstResponder==YES) {
        [_wifiPassWordfied resignFirstResponder];
        [_wifiNamefied resignFirstResponder];
        return;
    }
    
    [self.WifiView removeFromSuperview];
    [self.selectView removeFromSuperview];
    [self.SmaskView removeFromSuperview];
    
}


-(NSMutableArray *)sectionArr
{
    if (_sectionArr==nil) {
        _sectionArr=[NSMutableArray arrayWithObjects:@"CAMERA",@"VIDEO",@"BURST",@"TIMER" ,@"TIME LAPSE PHOTO",@"GENERAL",nil];
    }
    return _sectionArr;
}

-(NSMutableArray *)sectionImgArr
{
    if (_sectionImgArr==nil) {
//        EX_App_MAIN MENU_SETTINGS    EX_App_CAMERA_1     EX_App_MAIN MENU_VIEWER
//        EX_App_CAMERA_VIDEO    EX_App_CAMERA_BURST    EX_App_CAMERA_TIMER     VIDEO_9_
        
        _sectionImgArr=[NSMutableArray arrayWithObjects:@"EX_App_CAMERA_1",@"EX_App_CAMERA_VIDEO",@"EX_App_CAMERA_BURST",@"VIDEO_9_",@"EX_App_CAMERA_TIMER",@"EX_App_MAIN MENU_SETTINGS", nil];
    }
    return _sectionImgArr;
}
-(UIView *)SmaskView
{
    if (_SmaskView==nil) {
        _SmaskView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeMaskFromSuper)];
        [_SmaskView addGestureRecognizer:tap];
        
    }
    return _SmaskView;
}
-(UIView *)WifiView
{
    if (_WifiView==nil) {
        _WifiView=[[UIView alloc] initWithFrame:CGRectMake((ScreenW-300)*0.5, (ScreenH-44*4)*0.5, 300, 44*4)];
        _WifiView.backgroundColor=[UIColor colorWithRed:163/255.0 green:163/255.0 blue:164/255.0 alpha:1];
        UILabel *TipLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 44)];
        TipLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:25];;
        TipLabel.textColor=[UIColor colorWithRed:167/255.0 green:79/255.0 blue:84/255.0 alpha:1];
        TipLabel.text=@"WIFI SETTING";
        TipLabel.textAlignment=NSTextAlignmentCenter;
        [_WifiView addSubview:TipLabel];
        UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 44, 120, 44)];
        nameLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:15];
        nameLabel.textColor=[UIColor whiteColor];
        nameLabel.text=@"WIFI NAME";
        nameLabel.textAlignment=NSTextAlignmentCenter;
        [_WifiView addSubview:nameLabel];
        
        UILabel *passWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 44*2, 120, 44)];
        passWordLabel.font=[UIFont fontWithName:@"DINOffc-Medi" size:15];
        passWordLabel.textColor=[UIColor whiteColor];
        passWordLabel.text=@"WIFI PASSWORD";
        passWordLabel.textAlignment=NSTextAlignmentCenter;
        [_WifiView addSubview:passWordLabel];
        
        UITextField *nameFild=[[UITextField alloc]initWithFrame:CGRectMake(120, 44+5, 180, 44-10)];
        [_WifiView addSubview:nameFild];
        nameFild.borderStyle=UITextBorderStyleRoundedRect;
         UITextField *passWordFild=[[UITextField alloc]initWithFrame:CGRectMake(120, 44*2+5, 180, 44-10)];
        _wifiNamefied=nameFild;
        _wifiPassWordfied=passWordFild;
        
        [_WifiView addSubview:passWordFild];
        passWordFild.borderStyle=UITextBorderStyleRoundedRect;
        
        UIButton *wifiSettingBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 44*3, 300, 44)];
        [wifiSettingBtn setTitle:@"SET" forState:UIControlStateNormal];
        [wifiSettingBtn setBackgroundColor:[UIColor redColor]];
        [wifiSettingBtn addTarget:self action:@selector(settingBtnDIdClicked) forControlEvents:UIControlEventTouchUpInside];
        [_WifiView addSubview:wifiSettingBtn];
        _WifiView.layer.cornerRadius=15;
        _WifiView.layer.borderColor=[UIColor colorWithRed:167/255.0 green:79/255.0 blue:84/255.0 alpha:1].CGColor;
        _WifiView.layer.masksToBounds=YES;
       
    }
    return _WifiView;
    
}
-(void)dealloc{
    
}


@end
