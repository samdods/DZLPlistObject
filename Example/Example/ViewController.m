//
//  ViewController.m
//  DZLPlistObject
//
//  Created by Sam Dods on 23/03/2014.
//  Copyright (c) 2014 Sam Dods. All rights reserved.
//

#import "ViewController.h"
#import "Theme.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;

@property (weak, nonatomic) IBOutlet UILabel *groupHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupBodyLabel;

@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.defaultLabel.font = [Theme theme].defaultFont;
  
  self.titleLabel.text = [Theme theme].label.title.text;
  self.titleLabel.font = [Theme theme].label.title.font;
  self.titleLabel.textColor = [Theme theme].label.title.color;
  
  self.subtitleLabel.text = [Theme theme].label.subtitle.text;
  self.subtitleLabel.font = [Theme theme].label.subtitle.font;
  self.subtitleLabel.textColor = [Theme theme].label.subtitle.color;
  
  self.bodyLabel.text = [Theme theme].label.body.text;
  self.bodyLabel.font = [Theme theme].label.body.font;
  self.bodyLabel.textColor = [Theme theme].label.body.color;
  
  self.groupHeaderLabel.text = [Theme theme].groupedLabels.label.header.text;
  self.groupHeaderLabel.font = [Theme theme].groupedLabels.label.header.font;
  self.groupHeaderLabel.textColor = [Theme theme].groupedLabels.label.header.color;
  
  self.groupBodyLabel.text = [Theme theme].groupedLabels.label.body.text;
  self.groupBodyLabel.font = [Theme theme].groupedLabels.label.body.font;
  self.groupBodyLabel.textColor = [Theme theme].groupedLabels.label.body.color;
}

@end
