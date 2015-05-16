//
//  ViewController.m
//  mosquitam
//
//  Created by Cosaki on 2015/01/31.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize listView;

// ???:通知、アラームを鳴らす
//
- (void)viewDidLoad
{
    [super viewDidLoad];    pl=0;
    
    saveData = [NSUserDefaults standardUserDefaults]; //初期化
    
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];
    
    if (!saveDataArray.count) {
        
        saveDataArray = [NSMutableArray array];
    }
    
    //てすてす
    NSDate *weekDay = [self dateOfNextWeekday:7 fromDate:[NSDate date]];//1~7まで
    NSLog(@"test: %@",weekDay);
    
#ifdef DEBUG
    NSLog(@"%@",saveDataArray);
#endif
    [listView reloadData];
    
    [listView setDataSource:self];
    [listView setDelegate:self];
}



//willじゃなくてdid
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    saveData = [NSUserDefaults standardUserDefaults];
    
    saveDataArray = [[saveData objectForKey:@"list"] mutableCopy];
    
    if (!saveDataArray.count) {
        
        saveDataArray = [NSMutableArray array];
    }
    
        [nowIndexPathDictionary setObject:[self dateOfNextWeekday:[nowIndexPathDictionary[@"dayFlags"] integerValue] fromDate:[NSDate date]] forKey:@"nextDayKey"];
    
#ifdef DEBUG
    NSLog(@"%@",saveDataArray);
#endif
    [listView reloadData];
}



-(IBAction)alarmLocalNotificationDidAppear{
    
    /* STEP.1 現在時刻の設定 */
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]]; //日付を取得（9時間ずらす）
    // 参考サイト：http://qiita.com/edo_m18/items/38f6775120a376d93d8f
    
    NSCalendar *nowCalendar = [NSCalendar currentCalendar];
    NSUInteger flags;
    NSDateComponents *comps;
    
    // 時・分・秒を取得
    flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [nowCalendar components:flags fromDate:nowDate];
    
    NSInteger nowHourTimedays = comps.hour;
    NSInteger nowMinuteTimedays = comps.minute;
    NSInteger nowSecondTimedays = comps.second;
    
    
     NSInteger nowTimeInteger = nowHourTimedays*3600+nowMinuteTimedays*60+nowSecondTimedays; //18と29と00を変数にする！！！！
     


    /* STEP.2 セットする時間の設定 */
    nowIndexPathDictionary = saveDataArray[1];
    NSString *alermDateString = nowIndexPathDictionary[@"timeKey"]; //alarm取得（例：18:29）
    NSNumber *alermDaysNumber = nowIndexPathDictionary[@"dayFlags"]; //曜日の番号取得（例：0）
    
    //18:29 の文字列をだす
    NSDate *alermDatedays;
    
    NSNumber *alermHourTimedays,*alermMinuteTimedays;
    alermHourTimedays = [NSNumber numberWithInt:[[alermDateString substringToIndex:2] intValue]]; //例：18
    alermMinuteTimedays = [NSNumber numberWithInt:[[alermDateString substringFromIndex:3] intValue]];//例：29
//    NSCalendar *alermCalendardays = [NSCalendar currentCalendar];
//    NSDateComponents *alermDateCompsdays = [alermCalendardays components:NSYearCalendarUnit |
//                                        NSMonthCalendarUnit  |
//                                        NSDayCalendarUnit    |
//                                        NSHourCalendarUnit   |
//                                        NSMinuteCalendarUnit |
//                                        NSSecondCalendarUnit fromDate:alermDatedays];
    
    NSInteger alermTimeInteger = [alermHourTimedays integerValue]*3600+[alermMinuteTimedays integerValue]*60; //18と29を変数にする！！！！
    
    /* 【セットする曜日の番号一覧】
     日曜日：1
     月曜日：2
     火曜日：3
     水曜日：4
     木曜日：5
     金曜日：6
     土曜日：7
     
     */
    
    
    

    NSDate *alermDate;
    
    if (nowTimeInteger<alermTimeInteger) {
        //これだと今日の日付がでてくる
        alermDate = nowDate;
    }else{
    //これだと来週がでてくる
    alermDate= [self dateOfNextWeekday:alermDaysNumber.integerValue fromDate:nowDate]; //日付をつくる　例：2015-05-16
    }
//    
//    NSCalendar *daycalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* comps = [daycalendar components:NSWeekdayCalendarUnit
//                                          fromDate:[NSDate date]];
//    
//    NSDateFormatter* df = [[NSDateFormatter alloc] init];
//    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja"];
//    
//    //comps.weekdayは 1-7の値が取得できるので-1する
//    NSString *weekDayStr = df.shortWeekdaySymbols[comps.weekday-1];
//    NSLog(@"よーーーび:%@",weekDayStr);
//
    
    NSNumber *alermHourTime,*alermMinuteTime;
    alermHourTime = [NSNumber numberWithInt:[[alermDateString substringFromIndex:12] intValue]]; //例：18
    alermMinuteTime = [NSNumber numberWithInt:[[alermDateString substringFromIndex:3] intValue]];//例：29
    NSCalendar *alermCalendar = [NSCalendar currentCalendar];
    NSDateComponents *alermDateComps = [alermCalendar components:NSYearCalendarUnit |
                                   NSMonthCalendarUnit  |
                                   NSDayCalendarUnit    |
                                   NSHourCalendarUnit   |
                                   NSMinuteCalendarUnit |
                                   NSSecondCalendarUnit fromDate:alermDate];
    
//    if (comps.weekday-1 == alermDaysNumber) {
//        if (comps.hour*60+comps.minute < alermDateComps.hour*60+dateComps.minute) {
////            alermDate = [self dateOfNextWeekday];
//        }
//    }
    
    
    [alermDateComps setHour:alermHourTime.integerValue];
    [alermDateComps setMinute:alermMinuteTime.integerValue];
    [alermDateComps setSecond:0];
    
    alermDate = [alermCalendar dateFromComponents:alermDateComps]; //日付と時刻を合体
    alermDate = [NSDate dateWithTimeInterval:[[NSTimeZone systemTimeZone]secondsFromGMT] sinceDate:alermDate];//ローカル時間分（9時間）ずらす
    
    /* STEP.3 UnixTimeに変換 */
    //【現在時刻】
    double nowUnixTime = [self convertUnixTimeFromDate:nowDate];
    NSLog(@"現在時刻%@",[self convertDateFromUnixTime:nowUnixTime]);
    
    //【設定時刻】
    double alermUnixTime = [self convertUnixTimeFromDate:alermDate]; //alermDateからalermUnixDateへ（NSDateからdoubleに）
    NSLog(@"セット時刻%@",[self convertDateFromUnixTime:alermUnixTime]);
    
    
    /* STEP.4 アラームの設定 */
    //つくる
    alarmLocalNotification = [[UILocalNotification alloc] init];
    double gap = alermUnixTime - nowUnixTime;
    NSLog(@"【確認】\n現在時刻（Unix）：%f\nセット時刻（Unix）：%f\nギャップ(秒)：%f",nowUnixTime,alermUnixTime,gap);
    
    alarmLocalNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:(gap)];
    
    //きじゅん
    alarmLocalNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //ぶんしょう
    alarmLocalNotification.alertBody = @"ああああああ";
    
    //    //さうんど
    //    alarmLocalNotification.soundName = /* モスキート音鳴らす */;
    
    //とうろく
    [[UIApplication sharedApplication] scheduleLocalNotification:alarmLocalNotification];
    
    
}

- (double)convertUnixTimeFromDate:(NSDate *)date{
    double unixtime = [date timeIntervalSince1970];
    
    return unixtime; //生成物（返り値） 型：double
}

- (NSDate *)convertDateFromUnixTime:(double)unixtime{
    NSDate *alermDate = [NSDate dateWithTimeIntervalSince1970:unixtime];
    
    return alermDate;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//
- (NSDate*)dateOfNextWeekday:(NSInteger)weekday fromDate:(NSDate*)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    // 渡された日付から曜日を取り出します。
    NSDateComponents* baseComponents = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    NSDateComponents* addingComponents = [[NSDateComponents alloc] init];
    
    // 指定された曜日だけ進めます。
    NSInteger addingDay = weekday - baseComponents.weekday;
    
    // 同じ曜日か手前の曜日の場合は 0 以下になるので、そのときは一週間先を指定します。
    if (addingDay <= 0) addingDay += 7;
    
    // 目的の曜日の日付を取得します。
    addingComponents.day = addingDay;
    return [calendar dateByAddingComponents:addingComponents toDate:date options:0];
}

- (NSString *)changeIntegerToDayString:(NSInteger)dayNumber {
    NSString *dayString;
    switch (dayNumber) {
        case 1:
            dayString = @"日";
            break;
        case 2:
            dayString = @"月";
            break;
        case 3:
            dayString = @"火";
            break;
        case 4:
            dayString = @"水";
            break;
        case 5:
            dayString = @"木";
            break;
        case 6:
            dayString = @"金";
            break;
        case 7:
            dayString = @"土";
            break;
            
        default:
            break;
    }
    return dayString;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; //とりあえずセクションは1個
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return saveDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //カスタムセルを選ぶ
    static NSString *CellIdentifier = @"xxxcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    NSMutableDictionary *nowIndexPathDictionary = saveDataArray[indexPath.row];
    
    
    //各要素にはタグでアクセスする
    UILabel *reNameLabel = (UILabel*)[cell viewWithTag:1];
    reNameLabel.text = nowIndexPathDictionary[@"reNameStr"];
    UILabel *timeLabel = (UILabel*)[cell viewWithTag:2];
    timeLabel.text = nowIndexPathDictionary[@"displayKey"];
    UILabel *dayLabel = (UILabel*)[cell viewWithTag:3];
    //FIXME:ここに曜日
    NSInteger dayFlags = [nowIndexPathDictionary[@"dayFlags"] integerValue];
    dayLabel.text = [self changeIntegerToDayString:dayFlags];
    
    
    //Switch
    changeSwitch = (UISwitch*)[cell viewWithTag:4];
    [changeSwitch addTarget:self action:@selector(tapSwitch:) forControlEvents:UIControlEventTouchUpInside];
    
    if (isEdit == YES) {
        
        changeSwitch.hidden = YES; // 表示
        
    } else {
        
        changeSwitch.hidden = NO; // 非表示
        
    }
    
    return cell;
    
}



// UISwitchがタップされた際に呼び出されるメソッド。
-(void)tapSwitch:(id)sender {
    changeSwitch = (UISwitch *)sender;
    NSLog(@"switch tapped. value = %@", (changeSwitch.on ? @"ON" : @"OFF"));
}


-(void)reloadDate{
    
    [listView reloadData];
}

- (IBAction)editAction:(id)sender{
    if (isEdit == YES) {
        
        [listView setEditing:NO];
        isEdit = NO;
        editBarButton.title = @"Edit";
        
    } else {
        
        [listView setEditing:YES];
        isEdit = YES;
        editBarButton.title = @"Set";
        
    }
    
    [listView reloadData];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [saveDataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationLeft];
        [tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.3];
        
        [saveData setObject:saveDataArray forKey:@"list"];
    }
}


@end
