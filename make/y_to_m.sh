#!/bin/bash

grep -ri -- 'y -> m' diffconfig | sed -E 's/(\w+).*/\1/' | xargs -I % sed -Ei 's/%=y/%=m/' make/kernel-config.txt
