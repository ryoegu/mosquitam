//
//  ViewController.h
//  mosquitam
//
//  Created by Cosaki on 2015/01/31.
//  Copyright (c) 2015年 Carmine. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 継承 */
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    int pl;
    int ten;
    
    UILocalNotification *alarmLocalNotification;
    NSObject *alarml;
    
    //save
    NSUserDefaults *saveData;
    NSMutableDictionary *saveDataDictionary;
    NSMutableArray *saveDataArray;
    NSMutableDictionary *nowIndexPathDictionary;
    
    NSDate *dateOfNextWeekday;
    
    BOOL isEdit;
    
    IBOutlet UIBarButtonItem *editBarButton;
    
    UISwitch *changeSwitch;
    
    BOOL *changeBool;
    
    
    
    
}

+ (void)addLocalNotification;


-(IBAction)editAction:(id)sender;
-(IBAction)alarmLocalNotificationDidAppear;

@property (weak, nonatomic) IBOutlet UITableView *listView;


@end

