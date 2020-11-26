//
//  Oscillator.h
//  Swift Synth
//
//  Created by Luís Silva on 26/11/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef float (^Signal)(float);

typedef NS_ENUM(NSInteger, Waveform) {
    sine, triangle, sawtooth, square, whiteNoise
};


NS_ASSUME_NONNULL_BEGIN

@interface Oscillator : NSObject

@property (class, nonatomic, assign) float amplitude;
@property (class, nonatomic, assign) float frequency;

@property (class, nonatomic, readonly, copy) float (^sine)(float);
@property (class, nonatomic, readonly, copy) float (^triangle)(float);
@property (class, nonatomic, readonly, copy) float (^sawtooth)(float);
@property (class, nonatomic, readonly, copy) float (^square)(float);
@property (class, nonatomic, readonly, copy) float (^whiteNoise)(float);

@end

NS_ASSUME_NONNULL_END
