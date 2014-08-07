//
//  RPRLineChartCell.m
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import "RPRLineChartCell.h"
#import <PNChart/PNChart.h>

@interface RPRLineChartCell ()


@end

@implementation RPRLineChartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        //For LineChart
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 200.0)];
        self.lineChart.backgroundColor = [UIColor clearColor];
        
        //Year Label
        self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 20.0)];
        self.yearLabel.textAlignment = NSTextAlignmentCenter;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        
        self.yearLabel.text = [formatter stringFromDate:[NSDate date]];
        
        [self addSubview:self.lineChart];
        [self addSubview:self.yearLabel];
    }
    return self;
}

- (void)setData:(NSArray *)data forValues:(NSArray *)values
{
    for (UIView *l in self.lineChart.subviews) {
        [l removeFromSuperview];
    }
    [self.lineChart setXLabels:values];
    
    // Line Chart No.1
    NSArray *data01Array = data;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = [UIColor colorWithHex:0xF28142];
    data01.itemCount = self.lineChart.xLabels.count;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    
    [self.lineChart strokeChart];
}

+ (CGFloat)height
{
    return 240.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
