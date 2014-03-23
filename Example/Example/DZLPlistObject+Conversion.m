//
//  DZLPlistObject+SomeTest.m
//  DZLPlistObject
//
//  Created by Sam Dods on 22/03/2014.
//  Copyright (c) 2014 Sam Dods. All rights reserved.
//

#import "DZLPlistObject+Conversion.h"

@implementation DZLPlistObject (Conversion)

+ (void)plistObjectClassWillLoad
{
  [self registerConversionToType:UIColor.class fromObjectBlock:^UIColor *(NSString *string) {
    NSArray *components = [string componentsSeparatedByString:@","];
    NSAssert(components.count == 3, @"Color string must be 3 components: \"red,green,blue\"");
    CGFloat red = ((NSString *)components[0]).integerValue / 255.0;
    CGFloat green = ((NSString *)components[1]).integerValue / 255.0;
    CGFloat blue = ((NSString *)components[2]).integerValue / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
  }];
  
  [self registerConversionToType:UIFont.class fromDictionaryBlock:^id(NSDictionary *dictionary) {
    return [UIFont fontWithName:dictionary[@"name"] size:((NSNumber *)dictionary[@"size"]).floatValue];
  }];
}

@end
