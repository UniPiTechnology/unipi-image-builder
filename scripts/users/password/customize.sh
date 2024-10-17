#!/bin/sh
# Copyright (C) Unipi Technology spol. s r.o. - All Rights Reserved
# SPDX-License-Identifier: MIT
#
# @author Miroslav Ondra <ondra@unipi.technology>
# @author Unipi Technology <info@unipi.technology>
# @date 2024-10-07

# This is mmdebstrap customize hook to set root password

echo root:${ENCPASSWD} | /sbin/chpasswd -R "$1" -e'
