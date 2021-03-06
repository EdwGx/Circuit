//
//  LGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-06-29.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LGate.h"

#define kPositionKeyPath @"position"

@implementation LGate{
    BOOL _initializedUserInteraction;
    NSTimer* _updateTimer;
    UIView* _selectedView;
    CGRect _estTouchBounds;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initGate];
    if (self) {
        self.center = [aDecoder decodeCGPointForKey:@"center"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeCGPoint:self.center forKey:@"center"];
}


#pragma mark - Initialization

- (instancetype)initGate{
    self = [super init];
    if (self) {
        //Initialize image
        self.image = [UIImage imageNamed:[self imageName]];
        [self sizeToFit];
        
        //Initialize ports
        [self initPorts];
        [self updateRealIntput];
        [self updateOutput];
        
        [self setInPortDelegate];
        
        self.userInteractionEnabled = YES;
        _initializedUserInteraction = NO;
        
        [self.layer addObserver:self forKeyPath:kPositionKeyPath options:0 context:nil];
        
        _estTouchBounds = CGRectInset(self.bounds, -5.0, -5.0);
    }
    return self;
}

+ (instancetype)gate{
    return [[self alloc] initGate];
}


- (void)initPorts{
    /* Initialization of Ports*/
}

#pragma mark - Initialize User Interaction
- (void)initUserInteractionWithTarget:(id)target action:(SEL)sector{
    if (!_initializedUserInteraction) {
        _initializedUserInteraction = YES;
        for (LPort *aPort in _inPorts){
            UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:sector];
            [aPort addGestureRecognizer:recognizer];
        }
        for (LPort *aPort in _outPorts){
            UIPanGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:target action:sector];
            [aPort addGestureRecognizer:recognizer];
        }
    }
}

#pragma mark - Update gate status
- (void)updateOutput{
     /*Update boolean output*/
}

-(void)updateRealIntput{
    /*Get the real input boolean*/
    BOOL real = YES;
    
    //Check do all ports have real input
    for (LPort* anInPort in _inPorts) {
        if (!anInPort.realInput) {
            real = NO;
            break;
        }
    }
    
    if (self.realInput != real || [self isRealInputSource]){
        _realInput = real || [self isRealInputSource];
        for (LPort* anOutPort in _outPorts) {
            anOutPort.realInput = self.realInput;
        }
    }
}

#pragma mark - Gate info for subclasses
- (NSString*)imageName{
    return @"and_gate";
}

- (BOOL)isRealInputSource{
    return NO;
}

+ (NSString*)gateName{
    return @"GATE";
}

- (NSString*)booleanFormulaWithFormat:(NSInteger)format{
    return @"Not enough information to generate boolean formula.";
}

#pragma mark - LObjectProtocol
- (void)objectRemove{
    if (self.delegate) {
        [self.delegate gateWillRemove];
    }
    [_inPorts makeObjectsPerformSelector:@selector(removeAllWire)];
    [_outPorts makeObjectsPerformSelector:@selector(removeAllWire)];
    [self removeFromSuperview];
}

#pragma mark - LPortDelegate
- (void)setInPortDelegate{
    for (LPort* port in _inPorts){
        [port addDelegate:self];
    }
}

- (void)portRealInputDidChange:(PortType)portType{
    [self updateRealIntput];
    if (self.delegate) {
        [self.delegate gateBooleanFormulaDidChange];
    }
}

- (void)portBoolStatusDidChange:(PortType)portType{
    [self updateOutput];
}

#pragma mark - Selected Layer
- (void)setSelected:(BOOL)selected{
    if (selected != _selected) {
        _selected = selected;
        if (_selected) {
            if (!_selectedView) {
                _selectedView = [[UIView alloc] initWithFrame:CGRectInset(self.bounds, -5, -5)];
                _selectedView.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:0.86 alpha:0.2];
                _selectedView.layer.cornerRadius = 5;
                _selectedView.layer.borderWidth = 2;
                _selectedView.layer.borderColor = [UIColor blackColor].CGColor;
                _selectedView.userInteractionEnabled = NO;
                [self addSubview:_selectedView];
            }
        }else{
            if (_selectedView) {
                [_selectedView removeFromSuperview];
                _selectedView = nil;
            }
        }
    }
}

#pragma mark - Timer
- (void)startUpdateTimer{
    if (!_updateTimer) {
        _updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.015
                                                        target:self
                                                      selector:@selector(positionDidChange)
                                                      userInfo:nil
                                                       repeats:YES];
        [_updateTimer setTolerance:0.01];
    }
}

- (void)endUpdateTimer{
    if (_updateTimer) {
        [_updateTimer invalidate];
        _updateTimer = nil;
    }
}

#pragma mark - PositionDidChange

- (void)positionDidChange{
    for (LPort *aPort in _inPorts){
        [aPort gatePositionDidChange];
    }
    for (LPort *aPort in _outPorts){
        [aPort gatePositionDidChange];
    }
}

#pragma mark - Point
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(_estTouchBounds, point)) {
        UIView* closestView = nil;
        CGFloat closestDistance = 100.0;
        
        //Find Closest View to Touch
        for (LPort* inPort in _inPorts) {
            CGFloat distance = [self nonSqrtDistanceBetweenPointA:inPort.center PointB:point];
            if (distance <= closestDistance) {
                closestView = inPort;
                closestDistance = distance;
            }
        }
        
        for (LPort* outPort in _outPorts) {
            CGFloat distance = [self nonSqrtDistanceBetweenPointA:outPort.center PointB:point];
            if (distance <= closestDistance) {
                closestView = outPort;
                closestDistance = distance;
            }
        }
        
        if (closestView) {
            return closestView;
        } else if (CGRectContainsPoint(self.bounds, point)){
            return self;
        }else{
            return nil;
        }
    }
    return nil;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return CGRectContainsPoint(_estTouchBounds, point);
}

- (CGFloat)nonSqrtDistanceBetweenPointA:(CGPoint)pointA PointB:(CGPoint)pointB{
    #if __LP64__
        return (pow(pointA.x - pointB.x, 2.0) + pow(pointA.y - pointB.y, 2.0));
    #else
        return (powf(pointA.x - pointB.x, 2.0) + powf(pointA.y - pointB.y, 2.0));
    #endif
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:kPositionKeyPath] && _initializedUserInteraction) {
        [self positionDidChange];
    }
}

-(void)dealloc{
    [self.layer removeObserver:self forKeyPath:kPositionKeyPath];
}
@end
