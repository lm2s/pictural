//
//  Synth.m
//  Swift Synth
//
//  Created by Luís Silva on 26/11/2020.
//  Copyright © 2020 Grant Emerson. All rights reserved.
//

#import "Synth.h"
#import <AVFoundation/AVFoundation.h>

@interface Synth () {
    AVAudioEngine* _audioEngine;
}
@property (nonatomic, strong) AVAudioSourceNode *sourceNode;
@property (nonatomic, assign) float time;
@property (nonatomic, assign) float sampleRate;
@property (nonatomic, assign) float deltaTime;
@property (nonatomic, copy) Signal signal;
@property (nonatomic, copy) PlayingStatusBlock isPlayingStatusBlock;

@end

@implementation Synth

+ (instancetype)shared {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithSignal:Oscillator.sine];
    });

    return sharedInstance;
}

- (id)initWithSignal:(Signal)signal
{
    self = [super init];
    if (self) {
        _audioEngine = [[AVAudioEngine alloc] init];

        AVAudioMixerNode *mainMixer = _audioEngine.mainMixerNode;
        AVAudioOutputNode *outputNode = _audioEngine.outputNode;
        AVAudioFormat* format = [outputNode inputFormatForBus:0];

        _time = 0;
        _sampleRate = format.sampleRate;
        _deltaTime = 1.0 / (float)_sampleRate;

        _signal = signal;

        AVAudioFormat *inputFormat = [[AVAudioFormat alloc]
                                      initWithCommonFormat:format.commonFormat
                                      sampleRate:_sampleRate
                                      channels:1
                                      interleaved:format.isInterleaved];

        [_audioEngine attachNode:self.sourceNode];
        [_audioEngine connect:self.sourceNode to:mainMixer format:inputFormat];
        [_audioEngine connect:mainMixer to:outputNode format:nil];
        mainMixer.outputVolume = 0;

        NSError *error;
        [_audioEngine startAndReturnError:&error];
        if (error) {
            NSLog(@"Could not start audioEngine: %@", error.localizedDescription);
        }
    }
    return self;
}

- (AVAudioSourceNode *)sourceNode {
    if(!_sourceNode) {
        _sourceNode = [[AVAudioSourceNode alloc]
                       initWithRenderBlock:^OSStatus(
                                                     BOOL * _Nonnull isSilence,
                                                     const AudioTimeStamp * _Nonnull timestamp,
                                                     AVAudioFrameCount frameCount,
                                                     AudioBufferList * _Nonnull outputData) {

            for (AVAudioFrameCount frame = 0; frame < frameCount; frame++) {
                float sampleVal = self.signal(self.time);
                self.time += self.deltaTime;

                for (NSInteger i = 0; i < outputData->mNumberBuffers; i++) {
                    float* buffer = outputData->mBuffers[i].mData;
                    buffer[frame] = sampleVal;
                }
            }

            return kAudioServicesNoError;
        }];
    }

    return _sourceNode;
}

- (void)setVolume:(float)volume {
    _audioEngine.mainMixerNode.outputVolume = volume;

    self.isPlayingStatusBlock(volume == 0.0 ? NO : YES);
}

- (float)volume {
    return _audioEngine.mainMixerNode.outputVolume;
}

- (void)setWaveformTo:(Signal)signal {
    _signal = signal;
}

- (void)trackPlayingStatus:(PlayingStatusBlock)playingStatusBlock {
    self.isPlayingStatusBlock = playingStatusBlock;
}

@end
