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
    if (![self validateArguments]) {
        exit(-1);
    }
    NSString *mac = [self getBTMacAddressFromCommandLineArguments];

    IOBluetoothDevice *dev = [IOBluetoothDevice deviceWithAddressString:mac];
    [dev performSDPQuery:self];
}

- (BOOL)validateArguments
{
    char *usage = "\n\nusage: birdtooth xx-xx-xx-xx-xx-xx\n";
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];

    if ([arguments count] < 2) {
        printf("No argument provided.%s", usage);
        return NO;
    }
    NSString *mac = arguments[1];
    char *cMac = (char *)malloc(sizeof(char) * [mac lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1);
    strcpy(cMac, [mac cStringUsingEncoding:NSUTF8StringEncoding]);
    if ([mac length] != 17) {
        printf("Invalid argument provided: %s%s", cMac, usage);
        return NO;
    }

    return YES;
}

- (NSString *)getBTMacAddressFromCommandLineArguments
{
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    return arguments[1];
}

- (void)sdpQueryComplete:(IOBluetoothDevice *)device status:(IOReturn)status
{
    printf("%d\n", [device rawRSSI]);
    [device performSDPQuery:self];
    exit(0);
}

@end
