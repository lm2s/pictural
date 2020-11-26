//
//  Oscillator.m
//  Swift Synth
//
//  Created by Luís Silva on 26/11/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import "Oscillator.h"

@implementation Oscillator

static float _amplitude = 1;
static float _frequency = 440;

+ (void)setAmplitude:(float)amplitude {
    _amplitude = amplitude;
}

+ (float)amplitude {
    return _amplitude;
}

+ (void)setFrequency:(float)frequency {
    _frequency = frequency;
}

+ (float)frequency {
    return _frequency;
}

//static float (^sineBlock)(float) = ^float(float time) {
//    return Oscillator.amplitude * sin(2.0 * M_PI * Oscillator.frequency * time);
//};

+ (float (^)(float))sine {
    return ^(float time) {
        return (float)(Oscillator.amplitude * sin(2.0 * M_PI * Oscillator.frequency * time));
    };
}

+ (float (^)(float))triangle {
    return ^(float time) {
        double period = 1.0 / (double)Oscillator.frequency;
        double currentTime = fmod((double)time, period);

        double value = currentTime / period;

        double result = 0.0;

        if (value < 0.25) {
            result = value * 4;
        }
        else if (value < 0.75) {
            result = 2.0 - (value * 4.0);
        }
        else {
            result = value * 4 - 4.0;
        }

        return (float)(Oscillator.amplitude * (float)result);
    };
}

+ (float (^)(float))sawtooth {
    return ^(float time) {
        double period = 1.0 / (double)Oscillator.frequency;
        double currentTime = fmod((double)time, period);

        return (float)(Oscillator.amplitude * ((float)currentTime / period) * 2 - 1.0);
    };
}

+ (float (^)(float))square {
    return ^(float time) {
        double period = 1.0 / (double)Oscillator.frequency;
        double currentTime = fmod((double)time, period);

        return (float)(((currentTime / period) < 0.5) ? Oscillator.amplitude : -1.0 * Oscillator.amplitude);
    };
}

+ (float (^)(float))whiteNoise {
    return ^(float time) {
        return (float)(Oscillator.amplitude * (-1.0 + (double)arc4random() / (double)UINT32_MAX * 2.0));
    };
}

@end
