//
//  BottonScrollView.h
//  EX_appIOS
//
//  Created by mac_w on 2016/12/8.
//  Copyright © 2016年 aee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KondonPhotoModel.h"
@interface BottonScrollView : UIScrollView
//@property(nonatomic,strong)KondonPhotoModel *model;
@property(nonatomic,strong)NSMutableArray *modelArr;
@property(nonatomic,strong)NSMutableArray *imgARR;

@property (nonatomic,strong) dispatch_queue_t bottonSroqueue;
@end
