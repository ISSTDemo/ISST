//
//  VoteProgramParse.m
//  iSST
//
//  Created by jasonross on 13-12-19.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "VoteProgramParse.h"
#import "ISSTShowModel.h"
@implementation VoteProgramParse

+ (id)iSSTShowModelParse:(NSData *)datas
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",array);
    NSMutableArray *showsArray = [[NSMutableArray alloc]init];
    int  count = [array count];
    for (int i=0; i<count; i++) {
        ISSTShowModel *show = [[ISSTShowModel alloc]init ];
        show.Scategory =  [[array objectAtIndex:i] valueForKey:@"category"]  ;
        show.Sid      =    [[array objectAtIndex:i] objectForKey:@"id"];
        show.Sname =   [[array objectAtIndex:i] objectForKey:@"name"];
       // show.Sorganization    =  [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"likes"]];
        show.Sstatus   =  [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"status"]];
        
        NSString  *postTime =   [[array objectAtIndex:i] objectForKey:@"voteTime"];//[[[array objectAtIndex:indexPath.section]valueForKey:@"postTime"]stringValue];
        if ([postTime intValue]==0) {
             show.SvoteTime = @"0";
        }
        else
        {
            NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:[postTime longLongValue]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            show.SvoteTime = [dateFormatter stringFromDate:datePT];
            // show.SvoteTime =   [[array objectAtIndex:i] objectForKey:@"voteTime"];
        }
        NSLog(@"SvoteTime=%@",show.SvoteTime);
        [showsArray addObject:show];
    }
    NSLog(@"%@",showsArray);
    return showsArray;
}

@end
