//
//  DZLPlistObject.h
//  DZLPlistObject
//
//  Created by Sam Dods on 22/03/2014.
//  Copyright (c) 2014 Sam Dods. All rights reserved.
//

@protocol DZLPlistObject <NSObject>
@optional
+ (void)plistObjectClassWillLoad;

@end

@interface DZLPlistObject : NSObject <DZLPlistObject>
- (void)populateFromResource:(NSString *)resource;
+ (void)registerConversionToType:(Class)type fromObjectBlock:(id(^)(id object))block;
+ (void)registerConversionToType:(Class)type fromDictionaryBlock:(id(^)(NSDictionary *dictionary))block;
@end
