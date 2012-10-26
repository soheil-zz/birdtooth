//
//  AppDelegate.h
//  birdtooth
//
//  Created by Soheil Yasrebi on 10/25/12.
//  Copyright (c) 2012 Soheil Yasrebi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/IOBluetooth.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IOBluetoothDevice *dev;
}

@property (assign) IBOutlet NSWindow *window;

@end
