Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CC228E000
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388364AbgJNLtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388327AbgJNLtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 07:49:46 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3057C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 04:49:45 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q1so4719475ilt.6
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 04:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ZNJolRz2m/OrIIPEVWnU6jnci1i43YaodPxZ7EspMqk=;
        b=f02vCXkq0h2K6O9fLtRbGFGSGVtxhRymYov9DOr6tELJocnbrQ8bU3J9M0v6dC5Ex5
         i+yfmbsD6xOabkNEtsK5zrW1mQk6e/xlyD1DoRYEWT7eDd0YWVYVJOGGJRp72TxQEO7G
         BFZTon1M1pXuXdOG1gr8jAPBk7aO8w+fjNqHlcPVPV0enE+9bCpYK1zdlKAxONHirGAM
         jLoQpTTqKZL368s4P2ABGpMDqnfoT7ryux2xHR9KWx+SdIrRTsG5xnainT4HfRqxEcue
         BBrrkxOCIkCw7aHdw8qX6trc7vU4UZjr2VbPNMfHQ14xvkeaxl7SnRLKcN88E0IBPUhP
         5wdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ZNJolRz2m/OrIIPEVWnU6jnci1i43YaodPxZ7EspMqk=;
        b=O7fznS3Hs0nFuYJDgnlMgtnOCFUwL4PFLsaaMZFqWiBS6xj/+Ywe9eO54jfKLED5FV
         DP0Mit0Nac8AKcIv4gkf4VXYvdUBCYNu6ylghRvtghTqhIFKGZcpepGweWS/nYowCjVg
         XRDBL/4fMFHhhq6A00e2ECjtbmmp7DLFzWKduZzPlLmyDwv9u5f6NvjQlaOetkV0E4uu
         I5Pue1a3PhQyWDmJZJYGJhKOErQNLJlT0NzJjSIr8K/VujPuz99noPIZSbEto8+GTnI9
         MlDvbh253A3cT3ED2SrfFnP4rt7fiYjvbGz9ua7EQdDfqLioxnOYkbRHGYpKK8RuNX4N
         GI7Q==
X-Gm-Message-State: AOAM5311NVw4JIBqLpi9diT6eatK4gWOANKSrRGAj7M3JhESH0DJwpxD
        gCw1yDsdBC/LBwvXUPGuSi2yjenWCrGW1jK3G177mw==
X-Google-Smtp-Source: ABdhPJyC1vnhl27SGg71MW38ft3eslfIQYWPY565caESAFYaSdD58mPgpHtzcFsGirfJNvR4iu3qqZqZ7lXGw1AoQ8A=
X-Received: by 2002:a92:9944:: with SMTP id p65mr3301909ili.127.1602676184947;
 Wed, 14 Oct 2020 04:49:44 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Oct 2020 17:19:33 +0530
Message-ID: <CA+G9fYv=zPRGCKyhi9DeUsvyb6ZLVVXdV3hW+15XnQN2R3ircQ@mail.gmail.com>
Subject: selftests: netfilter: nft_nat.sh: /dev/stdin:2:9-15: Error: syntax
 error, unexpected counter
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org
Cc:     pablo@netfilter.org, Florian Westphal <fw@strlen.de>,
        fabf@skynet.be, Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftest netfilter test on x86_64 devices linux next
tag 20201013 kernel
these errors are noticed. This not specific to kernel version we have
noticed these errors
earlier also.

Am I missing configs ?
Please refer to the config file we are using.
We are using the minimal busybox shell.
BusyBox v1.27.2 (2020-07-17 18:42:50 UTC) multi-call binary.

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: f2fb1afc57304f9dd68c20a08270e287470af2eb
  git describe: next-20201013
  make_kernelversion: 5.9.0
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-next/879/config

Test output log:
--------------------
selftests: netfilter: nft_nat.sh
[ 1207.251385] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1207.342479] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
# /dev/stdin:2:9-15: Error: syntax error, unexpected counter
# counter ns0in {}
#         ^^^^^^^
# /dev/stdin:3:9-15: Error: syntax error, unexpected counter
# counter ns1in {}
#         ^^^^^^^
# /dev/stdin:4:9-15: Error: syntax error, unexpected counter
# counter ns2in {}
#         ^^^^^^^
# /dev/stdin:6:9-15: Error: syntax error, unexpected counter
# counter ns0out {}
#         ^^^^^^^

<trim>

# /dev/stdin:12:9-15: Error: syntax error, unexpected counter
# counter ns2in6 {}
#         ^^^^^^^
# /dev/stdin:14:9-15: Error: syntax error, unexpected counter
# counter ns0out6 {}
#         ^^^^^^^
[ 1208.229989] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter ns0in
#      ^^^^^^^
# ERROR: ns0in counter in ns1-loU9Vlmj has unexpected value (expected
packets 1 bytes 84) at check_counters 1
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter ns0in
#      ^^^^^^^
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter ns0out
#      ^^^^^^^
# ERROR: ns0out counter in ns1-loU9Vlmj has unexpected value (expected
packets 1 bytes 84) at check_counters 2
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter ns0out
#      ^^^^^^^
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter ns0in6

# ERROR: ns1 counter in ns0-loU9Vlmj has unexpected value (expected
packets 1 bytes 104) at check_ns0_counters 5
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter ns1
#      ^^^^^^^

<trim>

# <cmdline>:1:16-19: Error: syntax error, unexpected inet
# reset counters inet
#                ^^^^
# <cmdline>:1:16-19: Error: syntax error, unexpected inet
# reset counters inet
#                ^^^^
# FAIL: nftables v0.7 (Scrooge McDuck)
not ok 2 selftests: netfilter: nft_nat.sh # exit=1
# selftests: netfilter: bridge_brouter.sh
# SKIP: Could not run test without ebtables
ok 3 selftests: netfilter: bridge_brouter.sh # SKIP
# selftests: netfilter: conntrack_icmp_related.sh
[ 1215.679815] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1215.698932] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1215.711612] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1216.678043] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter unknown
#      ^^^^^^^
# ERROR: counter unknown in nsclient1 has unexpected value (expected
packets 0 bytes 0)
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter unknown
#      ^^^^^^^

<trim>

# ERROR: counter related in nsclient1 has unexpected value (expected
packets 2 bytes 1856)
# <cmdline>:1:6-12: Error: syntax error, unexpected counter
# list counter inet filter related
#      ^^^^^^^
# ERROR: icmp error RELATED state test has failed
not ok 4 selftests: netfilter: conntrack_icmp_related.sh # exit=1
# selftests: netfilter: nft_flowtable.sh
# Cannot create namespace file \"/var/run/netns/ns1\": File exists
[ 1230.570705] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1230.757525] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1230.843221] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# PASS: netns routing/connectivity: ns1 can reach ns2
# BusyBox v1.27.2 (2020-07-17 18:42:50 UTC) multi-call binary.
#
# Usage: nc [IPADDR PORT]
# BusyBox v1.27.2 (2020-07-17 18:42:50 UTC) multi-call binary.
#
# Usage: nc [IPADDR PORT]
# FAIL: file mismatch for ns1 -> ns2
# -rw------- 1 root root 1079296 Oct 13 09:54 /tmp/tmp.EyNCJDBncG
# -rw------- 1 root root 0 Oct 13 09:54 /tmp/tmp.CR5cdEqIHB
# FAIL: file mismatch for ns1 <- ns2
# -rw------- 1 root root 4677632 Oct 13 09:54 /tmp/tmp.NkSMo4ZijB
# -rw------- 1 root root 0 Oct 13 09:54 /tmp/tmp.irBE9wPUAV
# FAIL: flow offload for ns1/ns2:
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# BusyBox v1.27.2 (2020-07-17 18:42:50 UTC) multi-call binary.
#
# Usage: nc [IPADDR PORT]
# BusyBox v1.27.2 (2020-07-17 18:42:50 UTC) multi-call binary.
#
# Usage: nc [IPADDR PORT]
# FAIL: file mismatch for ns1 -> ns2
# -rw------- 1 root root 1079296 Oct 13 09:54 /tmp/tmp.EyNCJDBncG
# -rw------- 1 root root 0 Oct 13 09:54 /tmp/tmp.CR5cdEqIHB
# FAIL: file mismatch for ns1 <- ns2
# -rw------- 1 root root 4677632 Oct 13 09:54 /tmp/tmp.NkSMo4ZijB
# -rw------- 1 root root 0 Oct 13 09:54 /tmp/tmp.irBE9wPUAV
# FAIL: flow offload for ns1/ns2 with NAT
# <cmdline>:1:1-23: Error: Could not process rule: Table 'filter' does not exist
# list table inet filter
# ^^^^^^^^^^^^^^^^^^^^^^^
# <cmdline>:1:32-32: Error: syntax error, unexpected newline, expecting handle
# delete rule inet filter forward
#                                ^
# FAIL: Could not delete large-packet accept rule
not ok 5 selftests: netfilter: nft_flowtable.sh # exit=1
# selftests: netfilter: ipvs.sh
# skip: could not run test without ipvs module
ok 6 selftests: netfilter: ipvs.sh # SKIP
# selftests: netfilter: nft_concat_range.sh
# TEST: reported issues
#   Add two elements, flush, re-add                               [
1240.096121] kauditd_printk_skb: 40 callbacks suppressed
[ 1240.096124] audit: type=1325 audit(1602582894.032:87830):
table=t:72;?:0 family=2 entries=1 op=nft_register_table pid=9084
subj=kernel comm=\"nft\"
[ 1240.114551] audit: type=1325 audit(1602582894.032:87830):
table=t:72;s:1 family=2 entries=0 op=nft_register_set pid=9084
subj=kernel comm=\"nft\"
[ 1240.127450] audit: type=1325 audit(1602582894.032:87830):
table=?:0;?:0 family=0 entries=2 op=nft_register_gen pid=9084
subj=kernel comm=\"nft\"
[FAIL]
[ 1240.169015] audit: type=1325 audit(1602582894.105:87831):
table=t:72;s:1 family=2 entries=0 op=nft_unregister_set pid=9087
subj=kernel comm=\"nft\"
[ 1240.182153] audit: type=1325 audit(1602582894.105:87831):
table=t:72;?:0 family=2 entries=0 op=nft_unregister_table pid=9087
subj=kernel comm=\"nft\"
[ 1240.195412] audit: type=1325 audit(1602582894.105:87831):
table=?:0;?:0 family=0 entries=3 op=nft_register_gen pid=9087
subj=kernel comm=\"nft\"
not ok 7 selftests: netfilter: nft_concat_range.sh # exit=1
# selftests: netfilter: nft_conntrack_helper.sh
# SKIP: Could not run test without conntrack tool
ok 8 selftests: netfilter: nft_conntrack_helper.sh # SKIP
# selftests: netfilter: nft_queue.sh
[ 1242.587245] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1242.605473] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
[ 1243.557996] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
# PASS: ns1-4ngWFkmc can reach ns2-4ngWFkmc
# internal:0:0-0: Error: Could not open file \"-\": No such file or directory
#
#
# FAIL: ip expected failure, got 0
not ok 9 selftests: netfilter: nft_queue.sh # exit=1
# selftests: netfilter: nft_meta.sh
# /dev/stdin:2:9-15: Error: syntax error, unexpected counter
# counter iifcount {}
#         ^^^^^^^
# /dev/stdin:3:9-15: Error: syntax error, [ 1245.942205] kselftest:
Running tests in nsfs
unexpected counter
# counter iifnamecount {}
#         ^^^^^^^
# /dev/stdin:4:9-15: Error: syntax error, unexpected counter
# counter iifgroupcount {}
#         ^^^^^^^

<trim>

# /dev/stdin:11:9-15: Error: syntax error, unexpected counter
# counter icurrentyearc[ 1246.027275] kselftest: Running tests in pidfd
ounter {}
#         ^^^^^^^
# SKIP: Could not add test ruleset

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/1839013#L12339

-- 
Linaro LKFT
https://lkft.linaro.org
