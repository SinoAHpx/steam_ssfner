# steam_ssfner

A Steam SSFN writer.

[What is SSFN?](https://gaming.stackexchange.com/a/240081)

To login your account without 2FA, 3 things have to be prepared:

+ Your Steam account
+ Your Steam password
+ Your Steam SSFN(string)

# Features

+ Automatically download and write Steam SSFN files, only you need is a SSFN string.
+ Aesthetically designed interface.
+ My very first functional flutter app, so forgive my poor architecture design.

## Principium

The app will grab SSFN from [SSFNBox](https://ssfnbox.com/), and match your input SSFN with the SSFNBox's SSFN, if there's a match, the app will download the binary SSFN file from the cloud to local storage.

**Notice: All the SSFN from the website is completely random generated hash, so you don't have to worry about your account security.**