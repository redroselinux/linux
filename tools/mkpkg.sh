#!/bin/sh

fakeroot tar -I zstd -cf linux-stable.tar.zst stage
fakeroot tar -I zstd -cf linux-headers.tar.zst stage-h
sha256sum ./*.tar.zst
