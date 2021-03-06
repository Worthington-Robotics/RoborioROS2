#!/bin/bash
for script in $USER_HOME/compile-lib/*.sh; do
    bash "$script" || break
done