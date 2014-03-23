//
//  DZLPlistObject.m
//  DZLPlistObject
//
//  Created by Sam Dods on 22/03/2014.
//  Copyright (c) 2014 Sam Dods. All rights reserved.
//

#import "DZLPlistObject.h"


@interface NSString (Additions)
- (NSString *)dzl_upperCamelCase;
- (NSString *)dzl_lowerCamelCase;
@end

@implementation NSString (Additions)

- (NSString *)dzl_upperCamelCase
{
  return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].uppercaseString, [self substringFromIndex:1]];
}

- (NSString *)dzl_lowerCamelCase
{
  return [NSString stringWithFormat:@"%@%@", [self substringToIndex:1].lowercaseString, [self substringFromIndex:1]];
}

@end


@implementation DZLPlistObject

+ (NSMutableDictionary *)objectConversionBlockByClassName
{
  static NSMutableDictionary *dict;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dict = [NSMutableDictionary new];
  });
  return dict;
}

+ (NSMutableDictionary *)dictionaryConversionBlockByClassName
{
  static NSMutableDictionary *dict;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dict = [NSMutableDictionary new];
  });
  return dict;
}

+ (void)registerConversionToType:(Class)type fromObjectBlock:(id(^)(id))block
{
  NSParameterAssert(block);
  if (block) {
    [self objectConversionBlockByClassName][NSStringFromClass(type)] = block;
  }
}

+ (void)registerConversionToType:(Class)type fromDictionaryBlock:(id (^)(NSDictionary *))block
{
  NSParameterAssert(block);
  if (block) {
  }
  [self dictionaryConversionBlockByClassName][NSStringFromClass(type)] = block;
}

- (void)populateFromResource:(NSString *)resource
{
  NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"plist"];
  NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
  [self populateFromDictionary:dictionary];
}

- (void)populateFromDictionary:(NSDictionary *)dictionary
{
  for (NSString *key in dictionary.allKeys) {
    id value, obj = dictionary[key];
    BOOL isDictionary = [obj isKindOfClass:NSDictionary.class];
    
    NSString *propertyKey = key;
    
    if (isDictionary) {
      char firstChar = key.UTF8String[0];
      if (firstChar == '#') {
        // list
        propertyKey = [key substringFromIndex:1];
        value = [self processListFromDictionary:obj forKey:&propertyKey];
        
      } else {
        NSUInteger location = [key rangeOfString:@"("].location;
        if (location == NSNotFound) {
          // sub-root
          NSString *propertyType = key.dzl_upperCamelCase;
          value = [NSClassFromString(propertyType) new];
          [(DZLPlistObject *)value populateFromDictionary:obj];
          
        } else {
          // conversion from dictionary
          propertyKey = [key substringToIndex:location];
          NSString *typeString = [key substringFromIndex:location + 1];
          location = [typeString rangeOfString:@")"].location;
          typeString = [typeString substringToIndex:location];
          
          id(^block)(NSString *) = [self.class dictionaryConversionBlockByClassName][typeString];
          BOOL hasConversionBlock = block != nil;
          NSAssert(hasConversionBlock, @"No conversion block registered from type [%@]", typeString);
          if (hasConversionBlock) {
            value = block(obj);
            NSAssert(value, @"Conversion failed for property[%@] to type[%@]", propertyKey, typeString);
          }
          
        }
      }
    } else {
      // normal property
      NSUInteger location = [key rangeOfString:@"("].location;
      if (location == NSNotFound) {
        value = obj;
      } else {
        propertyKey = [key substringToIndex:location];
        NSString *typeString = [key substringFromIndex:location + 1];
        location = [typeString rangeOfString:@")"].location;
        typeString = [typeString substringToIndex:location];
        
        id(^block)(NSString *) = [self.class objectConversionBlockByClassName][typeString];
        BOOL hasConversionBlock = block != nil;
        NSAssert(hasConversionBlock, @"No conversion block registered from type [%@]", typeString);
        if (hasConversionBlock) {
          value = block(obj);
          NSAssert(value, @"Conversion failed for property[%@] to type[%@]", propertyKey, typeString);
        }
      }
    }
    
    [self setValue:value forKey:propertyKey];
  }
}

- (DZLPlistObject *)processListFromDictionary:(NSDictionary *)dictionary forKey:(inout NSString **)key
{
  NSUInteger location = [*key rangeOfString:@"("].location;
  NSString *typeString;
  NSString *property;
  
  if (location == NSNotFound) {
    property = (*key).dzl_lowerCamelCase;
    typeString = (*key).dzl_upperCamelCase;
  } else {
    property = [*key substringToIndex:location].dzl_lowerCamelCase;
    NSString *type = [*key substringFromIndex:location + 1];
    location = [type rangeOfString:@")"].location;
    typeString = [type substringToIndex:location];
  }
  
  NSString *propertyType = [property.dzl_upperCamelCase stringByAppendingString:@"List"];
  Class propertyClass = NSClassFromString(propertyType);
  DZLPlistObject *propertyInstance = [propertyClass new];
  [propertyInstance convertObjectsOfType:typeString inDictionary:dictionary];
  
  *key = property;
  return propertyInstance;
}

- (void)convertObjectsOfType:(NSString *)type inDictionary:(NSDictionary *)dictionary
{
  for (NSString *key in dictionary.allKeys) {
    id value, obj = dictionary[key];
    if ([obj isKindOfClass:NSDictionary.class]) {
      if ([self.class dictionaryConversionBlockByClassName][type] != nil) {
        id(^block)(NSString *) = [self.class dictionaryConversionBlockByClassName][type];
        value = block(obj);
      } else {
        value = [NSClassFromString(type) new];
        [(DZLPlistObject *)value populateFromDictionary:obj];
      }
    } else {
      if ([self.class objectConversionBlockByClassName][type] != nil) {
        id(^block)(NSString *) = [self.class objectConversionBlockByClassName][type];
        value = block(obj);
      } else {
        value = obj;
      }
    }
    NSParameterAssert(value);
    [self setValue:value forKey:key];
  }
}

- (id)objectForKey:(id)aKey
{
  return [self valueForKey:aKey];
}

- (id)objectForKeyedSubscript:(id)key
{
  return [self objectForKey:key];
}

@end
