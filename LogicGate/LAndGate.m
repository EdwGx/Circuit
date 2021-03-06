//
//  LAndGate.m
//  Circuit
//
//  Created by Edward Guo on 2014-07-05.
//  Copyright (c) 2014 Edward Peiliang Guo. All rights reserved.
//

#import "LAndGate.h"

@implementation LAndGate

-(NSString*)imageName{
    return @"and_gate";
}

- (BOOL)outputForFirstInput:(BOOL)firstInput SecondInput:(BOOL)secondInput{
    return (firstInput && secondInput);
}

-(GateType)getDefultGateType{
    return GateTypeAND;
}

-(NSString*)formatInBooleanFormula:(NSInteger)format{
    switch (format) {
        case 0:
        default:
            return @"( %@ AND %@ )";
            break;
        
        case 1:
            return @"( %@ ∧ %@ )";
            break;
    }
}

+(NSString*)gateName{
    return @"AND Gate";
}

@end
