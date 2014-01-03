//
//  SpittleParse.m
//  iSST
//
//  Created by xueshuMac on 13-12-11.
//  Copyright (c) 2013年 LY. All rights reserved.
//

#import "SpittleParse.h"
#import "ISSTSpittleContentModel.h"
@implementation SpittleParse

+ (id)iSSTSpittleContentModelParse:(NSData *)datas
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",array);
    NSMutableArray *spittlesArray = [[NSMutableArray alloc]init];
    int  count = [array count];
    for (int i=0; i<count; i++) {
        ISSTSpittleContentModel *spittle = [[ISSTSpittleContentModel alloc]init ];
        spittle.SCcontent =  [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] valueForKey:@"content"]]  ;
        spittle.SCid      =    [[array objectAtIndex:i] objectForKey:@"id"];
        spittle.SCdislikes = [NSString stringWithFormat:@"%@",  [[array objectAtIndex:i] objectForKey:@"dislikes"]];
        spittle.SClikes    =  [NSString stringWithFormat:@"%@", [[array objectAtIndex:i] objectForKey:@"likes"]];
        spittle.SCuserid   =   [[array objectAtIndex:i] objectForKey:@"userId"];
        
        NSString  *postTime =  [[array objectAtIndex:i] objectForKey:@"postTime"]; //[[[array objectAtIndex:indexPath.section]valueForKey:@"postTime"]stringValue];
        NSDate  *datePT = [NSDate dateWithTimeIntervalSince1970:[postTime longLongValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        spittle.SCposttime = [dateFormatter stringFromDate:datePT];
      //  spittle.SCposttime =   [[array objectAtIndex:i] objectForKey:@"postTime"];
        spittle.SCnickname =   [[array objectAtIndex:i] objectForKey:@"nickname"];
        spittle.SCisliked =   [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"isLiked"]];
        spittle.SCisdisliked =   [NSString stringWithFormat:@"%@",[[array objectAtIndex:i] objectForKey:@"isDisliked"]];
       // spittle.SCisdisplay =    [[array objectAtIndex:i] objectForKey:@"isDisplay"];
        [spittlesArray addObject:spittle];
    }
    return spittlesArray;
}
@end
