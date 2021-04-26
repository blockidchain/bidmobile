//
//  EventEmitter.h
//  BidWallet
//
//  Created by Marcos Rodriguez on 12/25/20.
//  Copyright © 2020 BidWallet. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface EventEmitter : RCTEventEmitter <RCTBridgeModule>

+ (EventEmitter *)sharedInstance;
- (void)sendNotification:(NSDictionary *)userInfo;
- (void)openSettings;

@end
