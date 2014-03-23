#import "Theme.h"


@implementation Theme

+ (void)load
{
  if ([[self class] respondsToSelector:@selector(plistObjectClassWillLoad)]) {
    [self plistObjectClassWillLoad];
  }
  [[self theme] populateFromResource:@"Theme"];
}

+ (instancetype)theme
{
  static Theme *singleton;
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    singleton = [Theme new];
  });
  return singleton;
}

@end

