//
//  ViewController.m
//  ZmFMDB
//
//  Created by stone on 16/7/14.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "ViewController.h"
#import "FMDBModel.h"

@interface ViewController ()
@property (nonatomic,strong)FMDBModel* model;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sIDTf;
@property (weak, nonatomic) IBOutlet UITextField *sexTf;
@property (weak, nonatomic) IBOutlet UITextField *ageTf;



@end

@implementation ViewController
-(FMDBModel *)model{
    if (_model == nil) {
        _model = [FMDBModel new];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nameTF addTarget:self action:@selector(searchdb:) forControlEvents:UIControlEventEditingChanged];
    [self.sexTf addTarget:self  action:@selector(searchdb:) forControlEvents:UIControlEventEditingChanged];

}
- (IBAction)createButton:(id)sender {
    self.model.name = self.nameTF.text;
    self.model.sID = [self.sIDTf.text integerValue];
    self.model.sex = self.sexTf.text;
    self.model.age = [self.ageTf.text integerValue];
    [self.model insertData];
    NSArray* arr = [FMDBModel getAllList];
    DDLogVerbose(@"数据库共有%ld条数据",arr.count);
}
- (IBAction)search:(id)sender {

}
-(void)searchdb:(UITextField*)tf{
    self.model.name = self.nameTF.text;
    self.model.sex = self.sexTf.text;
    NSArray* arr = [self.model search];
    NSLog(@"%ld",arr.count);
    for (FMDBModel* model in arr) {
        NSLog(@"%@",model.name);
    };
}
- (IBAction)remove:(id)sender {
    self.model.sID = [self.sIDTf.text integerValue];
    [self.model remove];
}
- (IBAction)update:(id)sender {
    self.model.name = self.nameTF.text;
    self.model.age = [self.ageTf.text integerValue];
    [self.model update];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
