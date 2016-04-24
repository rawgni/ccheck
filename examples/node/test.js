var test = require('tape');

test('simple test', (t) => {
  t.plan(2);

  t.equal(1+1, 2, '1+1 = 2');
  t.notEqual('hello', 'world', 'hello not equal world');
});
