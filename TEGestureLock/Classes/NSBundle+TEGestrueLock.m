//
//  NSBundle+TEGestrueLock.m
//  Pods
//
//  Created by kingdomrain on 2017/5/10.
//
//

#import "NSBundle+TEGestrueLock.h"
#import "TEGestureLock.h"

@implementation NSBundle (TEGestrueLock)
+ (NSBundle *)TEGestrueLockBundle {
    return [self bundleWithURL:[self TEGestureLockBundleURL]];
}
+ (NSURL *)TEGestureLockBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[TEGestureLock class]];
    return [bundle URLForResource:@"TEGestureLock" withExtension:@"bundle"];
}

@end
