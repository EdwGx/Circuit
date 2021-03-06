//
//  LGate.h
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPort.h"
#import "GateType.h"
#import "LObjectProtocol.h"
#import "LTAGateInfoViewDelegate.h"
#import "LGateDelegate.h"

@interface LGate : UIImageView<LObjectProtocol, LPortDelegate, LTAGateInfoViewDelegate>
- (instancetype)initGate;
+ (instancetype)gate;

- (void)initPorts;

- (void)updateOutput;
- (void)updateRealIntput;

- (NSString*)imageName;
- (BOOL)isRealInputSource;

//-(void)updatePortPositonInDurtion:(NSTimeInterval)duration;

+ (NSString*)gateName;
- (NSString*)booleanFormulaWithFormat:(NSInteger)format;

- (void)startUpdateTimer;
- (void)endUpdateTimer;

- (void)initUserInteractionWithTarget:(id)target action:(SEL)sector;

@property (nonatomic,weak) id<LGateDelegate> delegate;

@property (nonatomic) BOOL selected;

@property (nonatomic, readonly) GateType gateType;
@property (nonatomic, readonly) BOOL realInput;

@property (nonatomic) NSArray* inPorts;
@property (nonatomic) NSArray* outPorts;
@end
