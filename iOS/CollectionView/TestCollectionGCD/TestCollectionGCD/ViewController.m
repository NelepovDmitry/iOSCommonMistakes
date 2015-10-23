//
//  ViewController.m
//  TestCollectionGCD
//
//  Created by Dmitry Nelepov on 23.10.15.
//  Copyright © 2015 Dmitry Nelepov. All rights reserved.
//

#import "ViewController.h"
#import "TestCollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *cv;
@property (nonatomic) NSUInteger items;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = 0;
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionVertical;
    flow.minimumLineSpacing = flow.minimumInteritemSpacing = 0;
    flow.sectionInset = UIEdgeInsetsZero;
//    flow.estimatedItemSize = CGSizeMake(self.view.bounds.size.width, 1);
    
    
    self.cv = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    self.cv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.cv registerNib:[UINib nibWithNibName:@"TestCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"TestCollectionViewCell"];
    
    [self.cv addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.cv];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:0 metrics:nil views:@{ @"cv" : self.cv }]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cv]|" options:0 metrics:nil views:@{ @"cv" : self.cv }]];
    
    self.cv.delegate = self;
    self.cv.dataSource = self;

//    [self performSelector:@selector(reloadDataCV) withObject:nil afterDelay:3];
    __weak typeof(self) wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        wSelf.items = 100;
        [wSelf reloadDataCV];
    });
}

- (void)reloadDataCV {
    __weak typeof(self) wSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
    
        [wSelf.cv reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HeightGCD:%@", @(wSelf.cv.contentSize.height));
            [wSelf.cv scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:50 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        });
//    });
    
//[self perof]
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf addItems];
    });
}

- (void)addItems {
    self.items += 10;
    [self reloadDataCV];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([object isEqual:self.cv]) {
        if (self.cv.contentSize.height > 0) {
            [self.cv removeObserver:self forKeyPath:@"contentSize"];
        }
        NSLog(@"Height Observe:%@", @(self.cv.contentSize.height));
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger r = arc4random_uniform(10) + 1;
    
    return CGSizeMake(CGRectGetWidth(collectionView.bounds), 20 * r);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TestCollectionViewCell *retCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCollectionViewCell" forIndexPath:indexPath];
    retCell.backgroundColor = [UIColor whiteColor];
    return retCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(TestCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.testLabel.text = [NSString stringWithFormat:@"Cell index :%@", @(indexPath.item)];
}


@end
