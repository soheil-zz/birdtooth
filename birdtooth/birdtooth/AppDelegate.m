//
//  AppDelegate.m
//  birdtooth
//
//  Created by Soheil Yasrebi on 10/25/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import "AppDelegate.h"
#import <IOBluetooth/IOBluetooth.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    IOBluetoothDevice *dev = [IOBluetoothDevice deviceWithAddressString:@"60-33-4b-ef-8b-25"];
    [dev performSDPQuery:self];
}

- (void)sdpQueryComplete:(IOBluetoothDevice *)device status:(IOReturn)status
{
    printf("%d\n", [device rawRSSI]);
    [device performSDPQuery:self];
    exit(0);
}

@end
