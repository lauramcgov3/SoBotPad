//
//  MenuControllerTests.m
//  SoBotPad
//
//  Created by Laura on 27/03/2016.
//  Copyright © 2016 Laura. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MenuController.h"

@interface MenuControllerTests : XCTestCase

@property (strong, nonatomic) UIViewController *vcToTest;

@end

@implementation MenuControllerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.vcToTest = [[MenuController alloc]init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
