//
//  PlusViewController.m
//  mosquitam
//
//  Created by Cosaki on 2015/02/25.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import "PlusViewController.h"

@interface PlusViewController ()

@end

@implementation PlusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Slider
    fqcSlider.maximumValue = 20000.0f;
    fqcSlider.minimumValue = 0.0f;
    fqcSlider.value = 10000.0f;
    fqc = (int)fqcSlider.value;
    
    /* 数値を文字列に変換して表示 */
    fqcStr = [NSString stringWithFormat:@"%d", fqc];
    fqcLabel.text = fqcStr;
    
    //離した時
    [fqcSlider addTarget:self action:@selector(stopSound) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel)];
    
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];
    
}


//view action to call everyone
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    saveData = [NSUserDefaults standardUserDefaults];
    
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];
    
    reNameTextField.delegate=self;
    
//    saveDataArray = [NSMutableArray array];//初期化
    saveDataArray = [[saveData arrayForKey:@"list"] mutableCopy];
    
    if (!saveDataArray.count) {
        
        saveDataArray = [NSMutableArray array];
    }
    
    daysData = [[saveData arrayForKey:@"day"] mutableCopy];
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];
    

//    NSLog(@"%@",saveDataArray);
    
    //初期設定
    reNameStr = @"Arelm";
    fqcStr = @"10000";
    brtBool = false;
    snzBool = false;
    fdinBool = false;
//    dayFlags = All;
    sunBool = false;
    monBool = false;
    tueBool = false;
    wedBool = false;
    thuBool = false;
    friBool = false;
    satBool = false;
    
    
    displayTime = [displayFormatter stringFromDate:timeDatePicker.date];
    displayTime = @"12:00";
    timeStr = @"12:00";
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //キーボード消去
    [textField resignFirstResponder];
    return YES;
    
}

-(IBAction)backgroundTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)changeFrequency:(UISlider *)sender
{
    //周波数（音程）
    _frequency = sender.value;
    fqcLabel.text = [NSString stringWithFormat:@"%.1f", _frequency];
    fqcStr = [NSString stringWithFormat:@"%.1f", _frequency];
    [self playSound];
    
}


-(IBAction)changeBrtSwitch{
//    if (brtSwitch.on == YES) {
//        brtBool = true;
//    }else{
//        brtBool = false;
//    }

//    brtBool = brtSwitch.on ? true : false;
  
    brtBool = brtSwitch.on;
}

-(IBAction)changeSnzSwitch{
    snzBool = snzSwitch.on;
}

-(IBAction)changeFdinSwitch{
    fdinBool = fdinSwitch.on;
}

-(IBAction)dateTapped:(UIButton *)sender{
    if (sender.tag == 1) {
        if (sunBool == true) {
            sunBool = false;
            NSLog(@"日/OFF");
        }else{
            sunBool = true;
            NSLog(@"日/ON");
        }
    }else if (sender.tag == 2) {
        if (monBool == true) {
            monBool = false;
            NSLog(@"月/OFF");
        }else{
            monBool = true;
            NSLog(@"月/ON");
        }
    }else if (sender.tag == 3) {
        if (tueBool == true) {
            tueBool = false;
            NSLog(@"火/OFF");
        }else{
            tueBool = true;
            NSLog(@"火/ON");
        }
    }else if (sender.tag == 4) {
        if (wedBool == true) {
            wedBool = false;
            NSLog(@"水/OFF");
        }else{
            wedBool = true;
            NSLog(@"水/ON");
        }
    }else if (sender.tag == 5) {
        if (thuBool == true) {
            thuBool = false;
            NSLog(@"木/OFF");
        }else{
            thuBool = true;
            NSLog(@"木/ON");
        }
    }else if (sender.tag == 6) {
        if (friBool == true) {
            friBool = false;
            NSLog(@"金/OFF");
        }else{
            friBool = true;
            NSLog(@"金/ON");
        }
    }else if (sender.tag == 7) {
        if (satBool == true) {
            satBool = false;
            NSLog(@"土/OFF");
        }else{
            satBool = true;
            NSLog(@"土/ON");
//        dayFlags ^= Satday;
        }
    }
    /*
    if (sender.tag) {
        dayFlags ^= 1 << (sender.tag -1);
    }
     */
    //こっちは表示に使ってる（現時点ではひとつしか表示されない）
    dayFlags = sender.tag;
    NSLog(@"%ld",dayFlags);
    
    
}

-(IBAction)timeChanged{
    
    NSDateFormatter *time = [[NSDateFormatter alloc]init];
    time.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    timeStr = [time stringFromDate:timeDatePicker.date];
 //   NSLog(@"Time:%@",timeDatePicker.date);
    NSLog(@"%@",timeStr);
    
    
    displayFormatter = [[NSDateFormatter alloc]init];
    displayFormatter.dateFormat = @"HH:mm";
    
    displayTime = [displayFormatter stringFromDate:timeDatePicker.date];
    
}
-(IBAction)saveAlerm{
    
    //NSMutableDictionaryの保存
    if ([reNameTextField.text  isEqual: @""]) {
        reNameStr = @"アラーム";
    }else{
        reNameStr = reNameTextField.text;
    }
//    
//    daysData = [[NSMutableArray alloc] initWithCapacity:0];
//    [daysData addObject:@"Sun"];
//    [daysData addObject:@"Mon"];
//    [daysData addObject:@"Tue"];
//    [daysData addObject:@"Wed"];
//    [daysData addObject:@"Thu"];
//    [daysData addObject:@"Fri"];
//    [daysData addObject:@"Sat"];
//    
    saveDataDictionary = [NSMutableDictionary dictionary];
    [saveDataDictionary setObject:reNameStr forKey:@"reNameStr"]; //tag:1
    [saveDataDictionary setObject:fqcStr forKey:@"frequencyKey"];
    
    [saveDataDictionary setObject:[NSNumber numberWithBool:brtBool] forKey:@"brtKey"];
    [saveDataDictionary setObject:[NSNumber numberWithBool:snzBool] forKey:@"snzKey"];
    [saveDataDictionary setObject:[NSNumber numberWithBool:fdinBool] forKey:@"fdinKey"];
    
    
    
    [saveDataDictionary setObject:[NSNumber numberWithInteger:dayFlags] forKey:@"dayFlags"]; //tag3
    
    [saveDataDictionary setObject:timeStr forKey:@"timeKey"]; //tag:2
    [saveDataDictionary setObject:displayTime forKey:@"displayKey"];
    
#ifdef DEBUG
    NSLog(@"%@",saveDataDictionary);
#endif
    //保存
    saveData = [NSUserDefaults standardUserDefaults];
   
    [saveDataArray addObject:saveDataDictionary];
    
    [saveData setObject:saveDataArray forKey:@"list"];
    [saveData synchronize]; //ここまでで保存
    
//    [saveDataArray addObject:saveDataArray];
    
    
    //前の画面に戻る
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //2遷移
    if ([segue.identifier isEqualToString:@"plusAlarm"]) {
        //渡す(?)
    }
}


-(void)playSound{
    if (!aU) {
        //Sampling rate
        _sampleRate = 44100.0f;
        
        //Bit rate
        bitRate = 8;  // 8bit
        
        //AudioComponentDescription
        AudioComponentDescription aCD;
        aCD.componentType = kAudioUnitType_Output;
        aCD.componentSubType = kAudioUnitSubType_RemoteIO;
        aCD.componentManufacturer = kAudioUnitManufacturer_Apple;
        aCD.componentFlags = 0;
        aCD.componentFlagsMask = 0;
        
        //AudioComponent
        AudioComponent aC = AudioComponentFindNext(NULL, &aCD);
        AudioComponentInstanceNew(aC, &aU);
        AudioUnitInitialize(aU);
        
        //コールバック
        AURenderCallbackStruct callbackStruct;
        callbackStruct.inputProc = renderer;
        callbackStruct.inputProcRefCon = (__bridge void*)self;
        AudioUnitSetProperty(aU,
                             kAudioUnitProperty_SetRenderCallback,
                             kAudioUnitScope_Input,
                             0,
                             &callbackStruct,
                             sizeof(AURenderCallbackStruct));
        
        //AudioStreamBasicDescription
        AudioStreamBasicDescription aSBD;
        aSBD.mSampleRate = _sampleRate;
        aSBD.mFormatID = kAudioFormatLinearPCM;
        aSBD.mFormatFlags = kAudioFormatFlagsAudioUnitCanonical;
        aSBD.mChannelsPerFrame = 2;
        aSBD.mBytesPerPacket = sizeof(AudioUnitSampleType);
        aSBD.mBytesPerFrame = sizeof(AudioUnitSampleType);
        aSBD.mFramesPerPacket = 1;
        aSBD.mBitsPerChannel = bitRate * sizeof(AudioUnitSampleType);
        aSBD.mReserved = 0;
        
        //AudioUnit
        AudioUnitSetProperty(aU,
                             kAudioUnitProperty_StreamFormat,
                             kAudioUnitScope_Input,
                             0,
                             &aSBD,
                             sizeof(aSBD));
        
        //再生
        AudioOutputUnitStart(aU);
    }
}

static OSStatus renderer(void *inRef,
                         AudioUnitRenderActionFlags *ioActionFlags,
                         const AudioTimeStamp* inTimeStamp,
                         UInt32 inBusNumber,
                         UInt32 inNumberFrames,
                         AudioBufferList *ioData) {
    
    //キャスト
    PlusViewController *def = (__bridge PlusViewController*)inRef;
    
    //サイン波
    float freq = def.frequency*2.0*M_PI/def.sampleRate;
    
    //値を書き込むポインタ
    AudioUnitSampleType *outL = ioData->mBuffers[0].mData;
    AudioUnitSampleType *outR = ioData->mBuffers[1].mData;
    
    for (int i = 0; i < inNumberFrames; i++) {
        // 周波数を計算
        float wave = sin(def.phase);
        AudioUnitSampleType sample = wave * (1 << kAudioUnitSampleFractionBits);
        *outL++ = sample;
        *outR++ = sample;
        def.phase += freq;
    }
    
    return noErr;
};



- (void)stopSound
{
    AudioOutputUnitStop(aU);
    aU = nil;
}

@end
