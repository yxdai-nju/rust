// The raw_pointer_derived lint warns about its removal
// cc #30346

//@ compile-flags:-D raw_pointer_derive

//@ error-pattern:`#[warn(renamed_and_removed_lints)]` on by default
//@ error-pattern:requested on the command line with `-D raw_pointer_derive`

#![warn(unused)]

#[deny(warnings)]
fn main() { let unused = (); } //~ ERROR unused variable: `unused`

//~? WARN lint `raw_pointer_derive` has been removed: using derive with raw pointers is ok
//~? WARN lint `raw_pointer_derive` has been removed: using derive with raw pointers is ok
//~? WARN lint `raw_pointer_derive` has been removed: using derive with raw pointers is ok
