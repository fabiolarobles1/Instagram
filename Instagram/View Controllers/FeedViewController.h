//
//  FeedViewController.h
//  Instagram
//
//  Created by Fabiola E. Robles Vega on 7/7/20.
//  Copyright © 2020 Fabiola E. Robles Vega. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeedViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource >

-(void) fetchPosts;
@end

NS_ASSUME_NONNULL_END
