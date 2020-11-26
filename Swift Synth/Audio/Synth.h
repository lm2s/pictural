//
//  Synth.h
//  Swift Synth
//
//  Created by Luís Silva on 26/11/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Oscillator.h"

NS_ASSUME_NONNULL_BEGIN

@interface Synth : NSObject

@property (class, nonatomic, readonly) Synth* shared;

@property (nonatomic, readwrite) float volume;

- (void)setWaveformTo:(Signal)signal;

@end

NS_ASSUME_NONNULL_END
