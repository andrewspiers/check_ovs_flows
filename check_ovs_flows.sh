#!/usr/bin/env bash
#Alert if the total number of openvswitch flows exceeds predefined amounts.

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


read -d '' USAGE <<EOF
Usage: $0 n_warning n_critical

Requirements: grep, awk, ovs-dpctl
EOF
OVSDPCTL="$(which ovs-dpctl)"

if [ "$#" -eq "2" ]; then
n="$(${OVSDPCTL} show | grep flows | awk 'END { print s } { s +=$2 }')"
else
 echo "${USAGE}"
 exit 3
fi



if [ "${n}" -gt "$2" ]; then
 echo "CRITICAL: ${n} flows  > $2"
 exit 2
elif [ "${n}" -gt "$1" ]; then
 echo "WARNING: ${n} flows > $1"
 exit 1
fi

echo "OK: ${n} flows < $1 and $2"
