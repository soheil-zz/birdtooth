//
//  AppDelegate.m
//  birdtooth
//
//  Created by Soheil Yasrebi on 10/25/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    if (![self validateArguments]) {
        exit(-1);
    }
    NSString *mac = [self getBTMacAddressFromCommandLineArguments];
    dev = [IOBluetoothDevice deviceWithAddressString:mac];
    [dev performSDPQuery:self];

    // sdpQueryComplete sometimes isn't called
    [NSTimer scheduledTimerWithTimeInterval: .3
                                     target: self
                                   selector: @selector(getRSSI)
                                   userInfo: nil
                                    repeats: NO];

    // minimum wait
    [NSTimer scheduledTimerWithTimeInterval: 2
                                     target: self
                                   selector: @selector(exitWithAvgRSSI)
                                   userInfo: nil
                                    repeats: NO];

    // timeout eventually
    [NSTimer scheduledTimerWithTimeInterval: 5
                                     target: self
                                   selector: @selector(timeout)
                                   userInfo: nil
                                    repeats: NO];
}

- (void)exitWithAvgRSSI
{
    int rssiAvg = (int)rssiSum / rssiCnt;
    // let sdpQueryComplete finish or hit timeout
    if (rssiAvg > 0) {
        return;
    }
    printf("%d\n", rssiAvg);
    exit(0);
}

- (void)getRSSI
{
    rssiSum = [dev rawRSSI];
    rssiCnt++;
}

- (void)timeout
{
    // we have not exited yet that means we haven't got a response yet
    // so go ahead and exit now
    printf("0\n");
    exit(0);
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
