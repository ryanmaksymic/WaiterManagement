//
//  ViewController.m
//  StaffManagement
//
//  Created by Derek Harasen on 2015-03-14.
//  Copyright (c) 2015 Derek Harasen. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Restaurant.h"
#import "RestaurantManager.h"
#import "Waiter.h"
#import "StaffManagement-Swift.h"

static NSString * const kCellIdentifier = @"CellIdentifier";
static NSString * const kShowShiftsSegue = @"ShowShiftsSegue";

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray *waiters;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    self.waiters = [[[[RestaurantManager sharedManager]currentRestaurant].staff sortedArrayUsingDescriptors:@[sortByName]] mutableCopy];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.waiters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    Waiter *waiter = self.waiters[indexPath.row];
    cell.textLabel.text = waiter.name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Waiter *waiterToDelete = [self.waiters objectAtIndex:indexPath.row];
        [[RestaurantManager sharedManager] deleteWaiter:waiterToDelete];
        [self.waiters removeObject:waiterToDelete];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kShowShiftsSegue sender:nil];
}


# pragma mark - Actions

// TODO: Disable Save button while text field is empty
- (IBAction)addWaiter:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Waiter" message:@"Enter new waiter's name" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *newWaiterName = [alert.textFields.firstObject.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
        Waiter *newWaiter = [[RestaurantManager sharedManager] newWaiter:newWaiterName];
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
        self.waiters = [[[[RestaurantManager sharedManager]currentRestaurant].staff sortedArrayUsingDescriptors:@[sortByName]] mutableCopy];
        NSIndexPath * newWaiterIndex = [NSIndexPath indexPathForRow:[self.waiters indexOfObject:newWaiter] inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newWaiterIndex] withRowAnimation:YES];
    }];
    [alert addAction:addAction];
    addAction.enabled = NO;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textContentType = UITextContentTypeName;
        textField.returnKeyType = UIReturnKeyDone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.textAlignment = NSTextAlignmentCenter;
        textField.placeholder = @"e.g. Jane Doe";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [textField addTarget:self action:@selector(alertTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(UITextField *)sender {
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    if (alert) {
        UITextField *textField = alert.textFields.firstObject;
        UIAlertAction *addAction = alert.actions.firstObject;
        addAction.enabled = textField.text.length > 0;
    }
}


# pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShiftsTableViewController *stvc = segue.destinationViewController;
    Waiter * selectedWaiter = self.waiters[self.tableView.indexPathForSelectedRow.row];
    stvc.waiter = selectedWaiter;
}

@end
