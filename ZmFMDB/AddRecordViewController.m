//
//  AddRecordViewController.m
//  ZmFMDB
//
//  Created by stone on 16/7/16.
//  Copyright © 2016年 zm. All rights reserved.
//

#import "AddRecordViewController.h"


@interface AddRecordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *SIDTf;
@property (weak, nonatomic) IBOutlet UITextField *ageTf;
@property (weak, nonatomic) IBOutlet UITextField *sexTf;


@end

@implementation AddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (IBAction)confirmAdd:(id)sender {
    if (self.nameTf.text.length==0 || self.SIDTf.text.length == 0 || self.ageTf.text.length == 0 || self.sexTf.text.length == 0) {

        [self showHud:NO];

    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"confirmAdd" object:self userInfo:[self addUserInfo]];
          [self showHud:YES];
            //停留一秒后退出此页面
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [self.navigationController popViewControllerAnimated:YES];

        });
    }
}
- (void)showHud:(BOOL)confirm{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    if (confirm) {
        hud.labelText = @"增加成功！";
    }else{
        hud.labelText = @"以上内容不能为空";
    }
     [hud hide:YES afterDelay:1];
}


-(NSDictionary*)addUserInfo{

    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setValue:self.nameTf.text forKey:@"name"];
    [userInfo setValue:self.SIDTf.text forKey:@"sID"];
    [userInfo setValue:self.ageTf.text forKey:@"age"];
    [userInfo setValue:self.sexTf.text forKey:@"sex"];
    return [userInfo copy];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
