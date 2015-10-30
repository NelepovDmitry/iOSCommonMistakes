//
//  ImageLoadingCollectionViewCell.m
//  CollectionViewAsyncImageLoading
//
//  Created by Dmitry Nelepov on 30.10.15.
//  Copyright © 2015 NelepovDS. All rights reserved.
//

#import "ImageLoadingCollectionViewCell.h"

@implementation ImageLoadingCollectionViewCell

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    NSURL *url = [NSURL URLWithString:imageUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    
    __weak typeof(self) wSelf = self;
    NSCachedURLResponse *cached = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    if (cached.data) {
        UIImage *dataImg = [UIImage imageWithData:cached.data];
        wSelf.imageView.image = dataImg;
    } else {
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            wSelf.imageView.image = [UIImage imageWithData:data];
        }];
    }
}

@end
