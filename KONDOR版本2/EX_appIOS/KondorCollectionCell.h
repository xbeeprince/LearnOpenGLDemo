//
//  KondorCollectionCell.h
//  EX_appIOS
//
//  Created by mac_w on 2016/11/8.
//  Copyright © 2016年 aee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KondonPhotoModel.h"
#import "UIImageView+VideoFirstImage.h"

@protocol cellselectedDelegate <NSObject>

-(void)cellDidSelected;

//双击点击事件的方法
-(void)doubletapDidClicked;

@end

@interface KondorCollectionCell : UICollectionViewCell

@property(nonatomic,strong) UIImageView *photoImg;

@property(nonatomic,copy) NSString *photoName;

//蒙版VIew
@property(nonatomic,strong)UIImageView *MYmaskView;

//是否选中
@property(nonatomic,assign) BOOL hasSelected;

//双击选中
@property(nonatomic,assign) BOOL hasdoubleSelected;

@property(nonatomic,weak) id<cellselectedDelegate> delegate;

//数据模型
@property(nonatomic,strong)KondonPhotoModel *model;


@property(nonatomic,strong) NSMutableArray *generatorArr;

//视频加载线程
@property (nonatomic,weak)dispatch_queue_t cellque;
@end
