
// BSD License. Created by jano@jano.com.es

#import <SenTestingKit/SenTestingKit.h>
#import "NSDictionary+Functional.h"

/** Test for the NSDictionary(Functional) category. */
@interface NSDictionaryTest : SenTestCase
@property (readonly) NSDictionary *input;
@end

@implementation NSDictionaryTest

-(NSDictionary*)input {
    return @{ @1:@1, @2:@2, @3:@3 };
}

- (void)testAnd {
    NSDictionary *input = [self input];
    BOOL output = [input and:^BOOL(id object) {
        return [(NSNumber*)object intValue] % 2 == 0;
    }];
    STAssertFalse(output, nil);
}

- (void)testEach {
    NSDictionary *input = [self input];
    __block NSInteger max;
    [input each:^(id object) {
        if (max<[(NSNumber*)object intValue]){
            max = [(NSNumber*)object intValue];
        }
    }];
    STAssertTrue((max==3), @"should be 3");
    STAssertThrows([@{} each:nil], nil);
}

- (void)testFind {
    NSDictionary *input = [self input];
    id output = [input find:^BOOL(id object) {
        return [(NSNumber*)object intValue] %2 == 0;
    }];
    STAssertTrue(([(NSNumber*)output isEqualToNumber:@2]), nil);
    STAssertThrows([@{} find:nil], nil);
}

- (void)testMap {
    NSDictionary *input = [self input];
    NSDictionary *output = [input map:^id(id object) {
        return [NSNumber numberWithInt:[(NSNumber*)object intValue]-1];
    }];
    STAssertTrue(([output isEqualToDictionary:@{@1:@0,@2:@1,@3:@2}]), @"should be equal to %@", output);
    STAssertThrows([@{} map:nil], nil);
}

- (void)testOr {
    NSDictionary *input = [self input];
    BOOL output = [input or:^BOOL(id object) {
        return [(NSNumber*)object intValue] % 2 == 0;
    }];
    STAssertTrue(output, nil);
}

- (void)testPluck {
    NSDictionary *input = @{@1:[self input]};
    NSDictionary *result = [input pluck:@"@count"];
    STAssertTrue(([(NSNumber*)[result objectForKey:@1] isEqualToNumber:@3]), nil);
    STAssertThrows([@{} map:nil], nil);
}

- (void)testReduce {
    NSDictionary *input = [self input];
    NSNumber *result = [input reduce:^(id a, id b){
        return [NSNumber numberWithInt:[a intValue]+[b intValue]];
    }];
    STAssertTrue(([result intValue]==6), @"should be 6");
    STAssertThrows([@{} map:nil], nil);
}

- (void)testSplit {
    NSDictionary *input = @{ @1:@1, @2:@2, @3:@3, @4:@4, @5:@5, @6:@6, @7:@7, @8:@8 };
    NSArray *result = [input split:3];
    STAssertTrue( ([[result objectAtIndex:0] count]==3), nil );
    STAssertTrue( ([[result objectAtIndex:1] count]==3), nil );
    STAssertTrue( ([[result objectAtIndex:2] count]==2), nil );
    result = [input split:0];
    STAssertTrue( ([result count]==0), nil);
}

- (void)testWhere {
    NSDictionary *input = [self input];
    NSDictionary *result = [input where:^BOOL(id object) {
        return [(NSNumber*)object intValue]%2==0;
    }];
    STAssertTrue(([result count]==1), nil);
    STAssertThrows([@{} where:nil], nil);
}

@end











