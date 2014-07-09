//
//  ViewController.h
//  LogicGate
//
//  Created by Edward Guo on 2014-06-28.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

#import "ECToolBar.h"
#import "ECNavigationBar.h"
#import "ECGridView.h"
#import "ECScreenEdgeScrollController.h"
#import "LTAGateInfoView.h"

typedef NS_ENUM(NSUInteger, TapMode){
    TapModeNone,
    TapModeRemove,
    TapModeAdjust
};

typedef NS_ENUM(NSUInteger, MenuState){
    MenuNormalState,
    MenuHidenState,
    MenuAppealingState,
    MenuDisappealingState
};

@interface ViewController : UIViewController<ECNavigationBarDelegate,ECToolBarDelegate>

@end
