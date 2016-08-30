#define myAlertViewsTag 999888
#import <UIKit/UIKit.h>
#import "substrate.h"


// @interface SBTelephonyManager : NSObject {}
// -(BOOL)isInAirplaneMode;
// -(void)setIsInAirplaneMode:(BOOL)airplaneMode;
// +(id)sharedTelephonyManager;
// //-(BOOL)airplaneModeEnabled;
// //-(void)flipAirplaneMode;
// @end

extern "C" Boolean CTCellularDataPlanGetIsEnabled();
extern "C" void CTCellularDataPlanSetIsEnabled(Boolean enabled);

@interface SBWiFiManager : NSObject {}
-(void)setWiFiEnabled:(BOOL)enabled;
-(BOOL)wiFiEnabled;
+(id)sharedInstance;
@end

/*@interface CLLocationManager : NSObject {}
-(BOOL)locationServicesEnabled;
-(void)setLocationServicesEnabled:(BOOL)

@end*/

// static SBTelephonyManager *telephonyManager;
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
        NSLog(@"[Disembark] Alert item = %@",alert);
        NSLog(@"[Disembark] Cellular is %@", (CTCellularDataPlanGetIsEnabled() ? @"on" : @"off"));
        NSLog(@"[Disembark] Wifi is %@", ([[objc_getClass("SBWiFiManager") sharedInstance] wiFiEnabled] ? @"on" : @"off"));
       //UIAlertView *input = (UIAlertView *)alert;


         if ([alert isKindOfClass:[%c(SBUserNotificationAlert) class]])
         {

            UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Cellular Data is Turned Off"
                                      message:@"Turn on cellular data or use Wi-Fi to access data."
                                     delegate:self
                            cancelButtonTitle:@"Ignore"
                            otherButtonTitles:@"Settings", @"Turn on Cellular Data", @"Turn on Wi-Fi", nil];
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

%new(v@:@@)
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == myAlertViewsTag) {
        if (buttonIndex == 0) {
           NSLog(@"[Disembark] Clicked button 0");
        }
        else if (buttonIndex == 1)
        {
             NSLog(@"[Disembark] Clicked button 1");
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
        }else if (buttonIndex == 2)
        {
            NSLog(@"[Disembark] Clicked button 2");
            CTCellularDataPlanSetIsEnabled(true);
        }else if (buttonIndex == 3)
        {
            NSLog(@"[Disembark] Clicked button 3");
            wiFiManager = [objc_getClass("SBWiFiManager") sharedInstance];
            [wiFiManager setWiFiEnabled:true];
        }
    }
}


%end
