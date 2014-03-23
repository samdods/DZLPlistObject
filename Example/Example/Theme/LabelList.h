#import "DZLPlistObject.h"
#import "Label.h"


@interface LabelList : DZLPlistObject

@property (nonatomic, strong, readonly) Label * subtitle;
@property (nonatomic, strong, readonly) Label * header;
@property (nonatomic, strong, readonly) Label * body;
@property (nonatomic, strong, readonly) Label * title;

@end

