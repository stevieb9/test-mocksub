#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 8;

use lib 't/data';

BEGIN {
    use_ok('Two');
    use_ok('Mock::Sub');
};

{
    my $foo = Mock::Sub->mock('One::foo');
    One::foo;
    is ($foo->name, 'One::foo', "name() does the right thing");
}
{
    my $pre_ret1 = foo();
    my $pre_ret2 = main::foo();

    is ($pre_ret1, 'mainfoo', 'calling a main:: sub without main:: works');
    is ($pre_ret2, 'mainfoo', 'calling a main:: sub with main:: works');

    my $foo = Mock::Sub->mock('foo', return_value => 'mocked_foo');

    my $ret1 = foo();
    my $ret2 = main::foo();

    is ($ret1, 'mocked_foo', 'calling a main:: mock without main:: works');
    is ($ret2, 'mocked_foo', 'calling a main:: mock with main:: works');
    is ($foo->name, 'main::foo', "name() adds main:: properly");

    sub foo {
        return "mainfoo";
    }
}
