//
//  RPRLineChartCell.h
//  rprtr
//
//  Created by Karolis Stasaitis on 7/22/14.
//  Copyright (c) 2014 delanoir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNChart/PNChart.h>

@interface RPRLineChartCell : UITableViewCell

@property (nonatomic, strong) PNLineChart *lineChart;

+ (CGFloat)height;

- (void)setData:(NSArray *)data forValues:(NSArray *)values;

@end
