Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2E9FBFEA
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfKNF4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:56:35 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:41065 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbfKNF4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:56:35 -0500
Received: by mail-lj1-f175.google.com with SMTP id m4so314996ljj.8
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ur38ds81sUtsB7WwEoxbZzrJxxo0/K/xVm7wVOW1iw4=;
        b=g3NZqAdpVYRAQ3ct2mftJb+sGNGxzlmqW4IktdIxPmc5ld1K5T6YNk/tbQsS8PhhK/
         Z1PfzjXiaMziYD9QlCWwos6/azzEnI3NW+KEgOC8dAJ5xdLo5iNWJOi7ipCw8ZVVysjv
         6FZEev2S2y4QHN5A3/H0buO8quLpI4o2PKorP8sp9EadUy9dLt5WCaF+8pjRIPNmEPVI
         nUzYd7V4+5RUUyCCUtgZoRckbrrr3+HwtLaJ3IoACNhv0cDKsbSMD580E5u/8AMDPy3W
         9vXiMcWEwFTtaNZ65M4qJgAM/brtSHpks5CyHLlKkUCbggTPwFSNwjoOedq1zdaKQxJt
         rysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ur38ds81sUtsB7WwEoxbZzrJxxo0/K/xVm7wVOW1iw4=;
        b=XfOUs+XB3lwTiyWaAYa5NjSi5R+r5ZiFpIqeOwC67+3KbYWQ2jw7dkd4CsXGS9+wGv
         ih2wAnDNWIIEMjLw8Hj9kbopUwxEOwu4pGiAHO/rONbeXgGYaFqCkwba005+N4WOvDQO
         t2V7mGFyh7on97KP5MZoq4oHYzqA2u5DhyHtnH5FUXQEHn3c/IQlOgaLasWzS56MB/u1
         rjJj9I5T9IVP+H9nvJecKmNdm2PdmcgATW0Cm9j6Rl1fPPBgJug/Jv+sZmhSU/xgjWUz
         nRIDEqUAIYst7ly24vDzJeamNfy5+WF1qEQjal2fthU9RxQ5o/TWn8QesMKr7CE29m4P
         lkSw==
X-Gm-Message-State: APjAAAUOBJj1QEVdZhTI4hQ6TINpc991+XP40WakCbjtlnHDu84UubEI
        Rpv0mIweHBrN3Z2q9VC43GwLs4Du+IpVTNt2071b6g==
X-Google-Smtp-Source: APXvYqxXCNjPyVdeQUDj0G/N4823KeOTYugYe9hd28AraHuiGIdx9c+groEIIeqxfRnjKZYB0tXPAY0olnorI0zmoX0=
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr5383691ljq.20.1573710992764;
 Wed, 13 Nov 2019 21:56:32 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 14 Nov 2019 11:26:21 +0530
Message-ID: <CA+G9fYv-zFg2L5cdcbxNkaYC95nrTwvXMhrTUwRxcwkVR4E+DA@mail.gmail.com>
Subject: selftests/bpf: make *** tools/bpf/bpftool No such file or directory. Stop.
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org, Daniel Diaz <daniel.diaz@linaro.org>,
        quentin.monnet@netronome.com,
        Daniel Borkmann <daniel@iogearbox.net>, lmb@cloudflare.com,
        jakub.kicinski@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

selftests bpf test_bpftool_build.sh failed on arm32 beagleboard x15
device with below error.
Can this be skipped with minimal verbose on console ?
In our setup, we build kselftests on server machine and copies onto
target device and run tests by using run_kselftest.sh script file.

# selftests bpf test_bpftool_build.sh
bpf: test_bpftool_build.sh_ #
# Trying to build bpftool
to: build_bpftool #
# ... through kbuild
through: kbuild_ #
#
: _ #
# skip    make tools/bpf (no .config found)
make: tools/bpf_(no #
#
: _ #
# skip    make tools/bpf OUTPUT=<dir> (not supported)
make: tools/bpf_OUTPUT=<dir> #
#
: _ #
# skip    make tools/bpf O=<dir> (no .config found)
make: tools/bpf_O=<dir> #
#
: _ #
# ... from kernel source tree
from: kernel_source #
#
: _ #
# $PWD    /
/: _ #
# command make -s -C tools/bpf/bpftool >/dev/null
make: -s_-C #
# make *** tools/bpf/bpftool No such file or directory.  Stop.
***: tools/bpf/bpftool_No #
# realpath tools/bpf/bpftool No such file or directory
tools/bpf/bpftool: No_such #
# binary  find unrecognized -executable
find: unrecognized_-executable #
# BusyBox v1.27.2 (2019-10-04 190344 UTC) multi-call binary.
v1.27.2: (2019-10-04_190344 #
#
: _ #
# Usage find [-HL] [PATH]... [OPTIONS] [ACTIONS]
find: [-HL]_[PATH]... #
# ./test_bpftool_build.sh line 59 cd tools/bpf/bpftool No such file or directory
line: 59_cd #
# make *** No rule to make target 'clean'.  Stop.
***: No_rule #
#
: _ #
# $PWD    /
/: _ #
# command make -s -C tools/bpf/bpftool OUTPUT=/tmp/tmp.FmobyZwd5L/ >/dev/null
make: -s_-C #
# make *** tools/bpf/bpftool No such file or directory.  Stop.
***: tools/bpf/bpftool_No #
# binary  find unrecognized -executable
find: unrecognized_-executable #
# BusyBox v1.27.2 (2019-10-04 190344 UTC) multi-call binary.
v1.27.2: (2019-10-04_190344 #
#
: _ #
# Usage find [-HL] [PATH]... [OPTIONS] [ACTIONS]
find: [-HL]_[PATH]... #
#
: _ #
# $PWD    /
/: _ #
# command make -s -C tools/bpf/bpftool O=/tmp/tmp.ZS53rCFfid/ >/dev/null
make: -s_-C #
# make *** tools/bpf/bpftool No such file or directory.  Stop.
***: tools/bpf/bpftool_No #
# binary  find unrecognized -executable
find: unrecognized_-executable #
# BusyBox v1.27.2 (2019-10-04 190344 UTC) multi-call binary.
v1.27.2: (2019-10-04_190344 #
#
: _ #
# Usage find [-HL] [PATH]... [OPTIONS] [ACTIONS]
find: [-HL]_[PATH]... #
#
: _ #
# ... from tools/
from: tools/_ #
#
: _ #
# ./test_bpftool_build.sh line 112 cd tools/ No such file or directory
line: 112_cd #
# $PWD    /
/: _ #
# command make -s bpf >/dev/null
make: -s_bpf #
# make *** No rule to make target 'bpf'.  Stop.
***: No_rule #
# binary  find unrecognized -executable
find: unrecognized_-executable #
# BusyBox v1.27.2 (2019-10-04 190344 UTC) multi-call binary.
v1.27.2: (2019-10-04_190344 #
#
: _ #
# Usage find [-HL] [PATH]... [OPTIONS] [ACTIONS]
find: [-HL]_[PATH]... #
# ./test_bpftool_build.sh line 59 cd bpf No such file or directory
line: 59_cd #
# make *** No rule to make target 'clean'.  Stop.
***: No_rule #

Test complete log link (new and old),
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20191113/testrun/1008653/log
https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20190904/testrun/898453/log

- Naresh
