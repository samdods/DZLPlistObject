#import "DZLPlistObject.h"
#import "LabelList.h"
#import "GroupedLabels.h"


@interface Theme : DZLPlistObject

+ (instancetype)theme;

@property (nonatomic, strong, readonly) UIFont * defaultFont;
@property (nonatomic, strong, readonly) LabelList * label;
@property (nonatomic, strong, readonly) GroupedLabels * groupedLabels;

@end

