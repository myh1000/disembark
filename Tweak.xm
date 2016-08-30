#define myAlertViewsTag 999888
#import <UIKit/UIKit.h>
#import "substrate.h"

 
@interface SBTelephonyManager : NSObject {}
-(BOOL)isInAirplaneMode;
-(void)setIsInAirplaneMode:(BOOL)airplaneMode;
+(id)sharedTelephonyManager;
//-(BOOL)airplaneModeEnabled;
//-(void)flipAirplaneMode;
@end
 
@interface SBWiFiManager : NSObject {}
-(void)setWiFiEnabled:(BOOL)enabled;
-(BOOL)wiFiEnabled;
+(id)sharedInstance;
@end
 
/*@interface CLLocationManager : NSObject {}
-(BOOL)locationServicesEnabled;
-(void)setLocationServicesEnabled:(BOOL)
 
@end*/
 
static SBTelephonyManager *telephonyManager;
static SBWiFiManager *wiFiManager;

//opening maps - SBLaunchAlertItem - settings - ok | Turn Off Airplane Mode or Use Wi-Fi to Access Data
//facetime
//SBUserNotificationAlert - WiFi settings - ok | No Network Connection  (title) Connect t a wifi network or cellular data to use facetime.
//Trying to call - SBLaunchAlertItem - you must disable airplane mode to place a call(title) - cancel | disable
//SBUserNotificationAlert - WiFi settings - ok | No Network Connection  (title) Connect t a wifi network or cellular data to use facetime AUDIO.
%hook SBAlertItemsController
 
 /*
 static void SBAlertItemDiscard(SBAlertItemsController * controller, SBAlertItem * alert) {

    if ([alert isKindOfClass:[%c(SBUserNotificationAlert) class]]) 
    {

        if ([[(SBUserNotificationAlert *)alert alertHeader] isEqual:TRUST_THIS_COMPUTER_string]) {

            int response = (TRUST_THIS_COMPUTER == 2);

            [(SBUserNotificationAlert *)alert _setActivated:NO];
            [(SBUserNotificationAlert *)alert _sendResponse:response];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"SBUserNotificationDoneNotification" object:alert];

            [(SBUserNotificationAlert *)alert _cleanup];

        } else
            [(SBUserNotificationAlert *)alert cancel];

    } else {

        [controller deactivateAlertItem:alert];

    }

}*/

//SBLaunchAlertItem
- (void)activateAlertItem:(id)alert
{
        NSLog(@"Alert item = %@",alert);
       //UIAlertView *input = (UIAlertView *)alert;


         if ([alert isKindOfClass:[%c(SBLaunchAlertItem) class]]) 
         {

            UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Write here"
                                      message:@"Nope"
                                     delegate:self
                            cancelButtonTitle:@"Ignore"
                            otherButtonTitles:@"Settings", @"Turn off Airplane",@"Turn on Wi-Fi", nil];
                                alert.tag = myAlertViewsTag;
        [alert show];
        [alert release];
                    return;
        }
 
       /*if ([item isKindOfClass:%c(SBLaunchAlertItem)])
        {
                NSLog(@"Alert item = %@",item);
        UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Turn Off Airplane Mode or Use Wi-Fi to Access Data"
                                      message:nil
                                     delegate:self
                            cancelButtonTitle:@"Ignore"
                            otherButtonTitles:@"Settings", @"Turn off Airplane",@"Turn on Wi-Fi", nil];
                                alert.tag = myAlertViewsTag;
        [alert show];
        [alert release];
                        return;
        }else*/
%orig;
}
 
 
 
//Feb 25 20:05:03 Joshs-iPhone SpringBoard[1368]: Clicked button 1//settings
//Feb 25 20:05:12 Joshs-iPhone SpringBoard[1368]: Clicked button 2//turn off airplane
//Feb 25 20:06:48: --- last message repeated 1 time ---
//Feb 25 20:06:48 Joshs-iPhone SpringBoard[1368]: Clicked button 3//turn off wifi
//Feb 25 20:07:00 Joshs-iPhone SpringBoard[1368]: Clicked button 0//OK


%new(v@:@@)
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == myAlertViewsTag)
        {
        if (buttonIndex == 0) {
           NSLog(@"Clicked button 0");
        }
        else if (buttonIndex == 1)
        {
                 NSLog(@"Clicked button 1");
                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
        }else if (buttonIndex == 2)
        {
         NSLog(@"Clicked button 2");
                telephonyManager = [objc_getClass("SBTelephonyManager") sharedTelephonyManager];
                        bool mode = [telephonyManager isInAirplaneMode];
                        [telephonyManager setIsInAirplaneMode:!mode];
        }else if (buttonIndex == 3)
        {
         NSLog(@"Clicked button 3");
                wiFiManager = [objc_getClass("SBWiFiManager") sharedInstance];
                bool mode = [wiFiManager wiFiEnabled];
                [wiFiManager setWiFiEnabled:!mode];
        }
        }
        else
        {
        }
 
}

 
%end