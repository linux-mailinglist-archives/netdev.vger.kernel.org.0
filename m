Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831092B8BF7
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 08:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgKSHFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 02:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgKSHFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 02:05:09 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7760EC061A04
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 23:05:09 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id e18so4704502edy.6
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 23:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=JrAdhbw6sISA41zs66HyAySXleshjPJsnyUygqmXzd4=;
        b=Kte3ZMop7gHdmXBNNyISQ+I+Qlghzcly9y+STCKDivQVQ3VYeouCeIksoMF+Hg7clf
         LQHSHDu9JpNQYxnRTLa+cbGESnC6VqEWZgq7OuvfzfJHO+vH/vJwaJ7PjLYRXgzVPTFU
         NlYHlkdK2WfxX7akSE7yngoR9gmoP1LKFdowfPTZurR9atuz72SezAjsbtkLiknB9hwm
         l/N3gy74XfcVaTfavq3+0GdBoeix1U8gwGGQdN5jBcnZaZPk7prpPB3GoQK5jNaTpWet
         BETTTz4I852ygeI6J3AGxTt9zY3FvYUuMy2UE061M5Ch07l7YhFCAVvLWSkY9jBjSpm0
         KBKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=JrAdhbw6sISA41zs66HyAySXleshjPJsnyUygqmXzd4=;
        b=W/p4D5BEPrLArTGQWM0XQeLPaxgVPHSp5KaZjrY6Wz32RMGfiy16gU/Ca8GLT9WIPj
         mskC7MCFBKYFqdzt7r8GnXfUh0id6vX5bvpAMW6tWGHGEDIqhlwOaohNI9HdcfJ+gttX
         SYAtGYIwhXwO9g0DMlp7kpuLElfQRsG9nEDJxJpbAm5ykTONUfYn8A0/wdrwQzR6ywEc
         d4fc1TejAOOzWuI4gzMezfLnRKpqP5mWo/Vzr4HLIdDeomWoMEOzGcBHa3kEzyogyoje
         69HbJknQ/PYKFrvMJJXu6GzkkGS2Pq1Fg8yNC2yC8EEtJFeTFdmzZ6NcWl+wbr1tavDp
         89Tw==
X-Gm-Message-State: AOAM532fOZSvj2uWxcAa3aEsQOvRkZyYTTua9m5ohZvGFNkJjYJiNoQS
        KGNq7RSrvdE23pHitFU3MMIyswQIgHjQqasgQsVmT9Gb35epaMP4
X-Google-Smtp-Source: ABdhPJzinwnANI3eodWZfO09btpe7t9l0FLxTHA4w6yIz8S9dbyyyamvJS7w6SayMhss0zBtfFsSoRB+N/fVlfrQXvg=
X-Received: by 2002:aa7:c2d7:: with SMTP id m23mr29176107edp.230.1605769507167;
 Wed, 18 Nov 2020 23:05:07 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 19 Nov 2020 12:34:55 +0530
Message-ID: <CA+G9fYvkRAKBzthvdurQ44q_f9HimG2ur9+M=bgyZ0c+XWucgg@mail.gmail.com>
Subject: WARNING: net/mptcp/protocol.c:719 mptcp_reset_timer+0x40/0x50
To:     Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, mptcp@lists.01.org
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        mathew.j.martineau@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Geliang Tang <geliangtang@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running kselftest net/mptcp: mptcp_join.sh on x86_64 device running
linux next 20201118 tag the following warning was noticed.

# selftests: net/mptcp: mptcp_join.sh
<trim>
[ 1276.053194] ------------[ cut here ]------------
[ 1276.057857] WARNING: CPU: 2 PID: 27452 at
/usr/src/kernel/net/mptcp/protocol.c:719 mptcp_reset_timer+0x40/0x50
[ 1276.067870] Modules linked in: xt_tcpudp xt_bpf act_mirred cls_u32
ip6table_mangle mpls_gso mpls_iptunnel mpls_router sch_etf
ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 bridge
stp llc vrf xt_policy sch_fq 8021q iptable_filter xt_mark ip_tables
x_tables cls_bpf sch_ingress veth algif_hash x86_pkg_temp_thermal fuse
[last unloaded: test_blackhole_dev]
[ 1276.106416] CPU: 2 PID: 27452 Comm: kworker/2:4 Tainted: G        W
    K   5.10.0-rc4-next-20201118 #1
[ 1276.115808] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1276.123293] Workqueue: events mptcp_worker
[ 1276.127407] RIP: 0010:mptcp_reset_timer+0x40/0x50
[ 1276.132119] Code: 45 ff 3c 07 74 22 48 8b 87 30 08 00 00 48 85 c0
74 18 48 8b 15 e1 34 d4 00 48 8d b7 50 06 00 00 48 01 c2 e8 72 3b ca
ff c9 c3 <0f> 0b b8 c8 00 00 00 eb df 0f 1f 80 00 00 00 00 0f 1f 44 00
00 55
[ 1276.150863] RSP: 0018:ffffa20b41137d28 EFLAGS: 00010246
[ 1276.156091] RAX: 0000000000000000 RBX: ffff95a6d444b090 RCX: 0000000000000000
[ 1276.163222] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff95a6d444a800
[ 1276.170354] RBP: ffffa20b41137d30 R08: 0000000000000000 R09: 0000000000000000
[ 1276.177487] R10: 0000000000024200 R11: fefefefefefefeff R12: ffff95a6d444a800
[ 1276.184621] R13: 0000000000000000 R14: ffff95a6da9e44d8 R15: 0000000000000000
[ 1276.191752] FS:  0000000000000000(0000) GS:ffff95a9dfd00000(0000)
knlGS:0000000000000000
[ 1276.199838] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1276.205585] CR2: 00007f1770beb810 CR3: 0000000131026005 CR4: 00000000003706e0
[ 1276.212718] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1276.219849] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1276.226983] Call Trace:
[ 1276.229438]  mptcp_push_pending+0x5bf/0x6c0
[ 1276.233633]  mptcp_worker+0xf0/0x650
[ 1276.237218]  ? mptcp_worker+0xf0/0x650
[ 1276.240971]  ? process_one_work+0x21c/0x5e0
[ 1276.245157]  process_one_work+0x289/0x5e0
[ 1276.249171]  worker_thread+0x3c/0x3f0
[ 1276.252836]  ? __kthread_parkme+0x6f/0xa0
[ 1276.256848]  ? process_one_work+0x5e0/0x5e0
[ 1276.261034]  kthread+0x142/0x160
[ 1276.264269]  ? kthread_insert_work_sanity_check+0x60/0x60
[ 1276.269674]  ret_from_fork+0x22/0x30
[ 1276.273254] irq event stamp: 0
[ 1276.276316] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[ 1276.282587] hardirqs last disabled at (0): [<ffffffffbbfbbf4d>]
copy_process+0x75d/0x1d60
[ 1276.290759] softirqs last  enabled at (0): [<ffffffffbbfbbf4d>]
copy_process+0x75d/0x1d60
[ 1276.298932] softirqs last disabled at (0): [<0000000000000000>] 0x0
[ 1276.305197] ---[ end trace fe4f318db7e06cdb ]---

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: 2052923327794192c5d884623b5ee5fec1867bda
  git describe: next-20201118
  make_kernelversion: 5.10.0-rc4
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-next/902/config

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/1952957#L15217

-- 
Linaro LKFT
https://lkft.linaro.org
