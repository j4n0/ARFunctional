Functional categories for NSArray, NSDictionary, NSSet.

### NSArray, NSDictionary, NSSet

- __and__ returns true if every object of the collection returns true for the given block.
- __each:__ calls the block passing each of the objects.
- __find__ returns the first object for which the block returns true.
- __reduce__ folds the collection to one value by running result=block(first,second), then result=block(result,next) until the end of the list. 
- __map__ apply the block to each object and return the results in a collection of the same type.
- __or__ returns true if any object of the collection returns true for the given block.
- __pluck:__ returns an array containing the objects for the given key path.
- __split:__ returns an array of partitions of the original collection with up to 'size' elements each.
- __where:__ returns a collection with the objects for which the block returns true.

``` objc
[@[@1,@2,@3] and:^BOOL(id object) { 
    return [(NSNumber*)object intValue] %2 == 0; 
}]; // false

[@[@1,@2,@3] or:^BOOL(id object) { 
    return [(NSNumber*)object intValue] %2 == 0;
}]; // true

[@[@"apple"] each:^(id object) {
    NSLog(@"%@", [object capitalizedString]); 
}]; // Apple

[@[@1,@2,@3] find:^BOOL(id object) { 
    return [(NSNumber*)object intValue] %2 == 0; 
}]; // @2

[@[@1,@2,@3] reduce:^(id a, id b){
    return [NSNumber numberWithInt:[a intValue]+[b intValue]];
}]; // 6

[@[@1,@2,@3] map:^id(id object) {
    return [NSNumber numberWithInt:[(NSNumber*)object intValue]-1];
}]; // @0,@1,@2

[@[@1,@2,@3] pluck:@"@count"]; // 3

[ [@[@1,@2,@3,@4,@5]split:3] isEqualToArray:@[ @[@1,@2,@3], @[@4,@5] ] ]; // true

[@[@1,@2,@3,@4] where:^BOOL(id object) {
	return [(NSNumber*)object intValue]%2==0;
}]; // @[@2,@4]
```

### NSArray

- __eachWithIndex:__ calls the block passing each of the objects and the index of the object in the iteration.
- __head__ returns a number of elements at the beginning of the collection.
- __tail__ returns a number of elements at the end of the collection.
- __until__ calls the block for each object until the block returns true.

``` objc
[@[@"apple"] eachWithIndex:^(id object, int index) {
    NSLog(@"%d,%@", index, [object capitalizedString]); 
}]; // 1,Apple

[@[@1,@2,@3] head:2]; // @[@1,@2]

[@[@1,@2,@3] tail:2]; // @[@2,@3]

[@[@1,@2,@3] until:^(id object) {
    BOOL result = [(NSNumber*)object intValue] %2 == 0;
    if (!result) NSLog(@"%@",object);
    return result;
}]; // 1
```
