#!/usr/bin/env bash

die() { echo "${1:-error}"; exit "${2:-1}"; }

hash aws 2>/dev/null || die "no aws"

accs=$(echo 0 | myob-auth l | wc -l)
#There is a total of 7 lines that are just empty, info or not accounts when you call myob-auth
n="$(($accs - 7))"

for (( i = 0; i <= $n; i++ )); do
	echo $i | myob-auth l &>/dev/null || die "Unable to myob auth to ${i} account"
	# aws sts get-caller-identity
	aws ssm delete-parameters --names $(aws ssm get-parameters-by-path --path /ops/bk/ --recursive --output text --query "Parameters[].[Name]" --output text)	
done
