#!/bin/bash
for script in $(dirname $0)/lib/*.sh; do
    bash "$script" || break
done