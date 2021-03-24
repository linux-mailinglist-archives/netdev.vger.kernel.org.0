Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC333473F8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 09:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbhCXIw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 04:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbhCXIwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 04:52:39 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB960C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 01:52:38 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id hq27so31524936ejc.9
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 01:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=67ajk7WhFs/IdDrGY2/QG90lqtVQtfJLbG3k20v4ai4=;
        b=JAJDRzh/uUkuTn1KcHFIDYFu0gh5OsRmF+RrEKx2M/D+8sxkyI6dysmviWDWbZZnjK
         ylHvS5/9DWnkACLJxV8EA2acyLl1axDWbySXYj4PEB5D1ljYDUBzDU6vyLvz5/CrOBYc
         8RJmWbo53kkKJq1aOto6fle/dM5H4ucP/L8wkLC5SQR3A5wNSVGA9GEYE36hXUc9Cqa2
         LA/SIroaSZNewKFS6WK0gkvP4H9i5dZ3o+R1prW359qzZB2B5accJfPwUopV56+Gpn+D
         PbchiYjK1S259IKWedP9EYCkTWwjHZ3xOJJPN1adp08yNjth8xFB4c5gwDEsFATk7dFn
         V91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=67ajk7WhFs/IdDrGY2/QG90lqtVQtfJLbG3k20v4ai4=;
        b=gdkMlhIiH3vHQtwFyVbG5gkmy61VcdgUXNOwiNX6Ck+ExIPcVaakP2QlffsrHG5YIP
         SGuuqdal3kD/ZTpldond2sBLGPngGJaZEcucArWrDfKlZu/EV1EXS62wczvKaa1O+WX0
         B/O3c5+rgPVMO4Ihlsn5Pg7CGt+9Vx0nmYAuNTFl4DIQl4OGuTOpLizgaBCU6oq5OaXW
         c6DeYBKkSmKxkCTwqq+NHILEC23Pryb8DV69aVZCGd0kM2bdHNkWF3lo1Juuehkj5AGz
         EYpGRRgqQ9NAJY5h84t/7MHwOMuPBtz4FUwdzmMYc4NPoBt+KCNNDMXkOKNTOQRkb4lW
         wnkw==
X-Gm-Message-State: AOAM5314r3vKFQtTs2RfUNdieb6WGmPDdglH5mG/V58XvH3RJSjP7V/C
        foM6meBmDaPg+l8NvuHM4TgyuIFV0lLLZ17qUGDUrQ==
X-Google-Smtp-Source: ABdhPJyL3dwwveojv23iSSBdwO6zoSS1tMQ+/jy2O9CHxh6THHnUCJTEF0Oj8wytrVghmK3+k4gO+xloECc9WOPzNjU=
X-Received: by 2002:a17:906:70d:: with SMTP id y13mr2413764ejb.170.1616575957042;
 Wed, 24 Mar 2021 01:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210322151845.637893645@linuxfoundation.org> <CA+G9fYsYXPkx+0sBYg-v46V6d9JhJxyXEir5PxX0byTXN+r0wg@mail.gmail.com>
In-Reply-To: <CA+G9fYsYXPkx+0sBYg-v46V6d9JhJxyXEir5PxX0byTXN+r0wg@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Mar 2021 14:22:25 +0530
Message-ID: <CA+G9fYsNsqWHdY7oQdV2NZa6NXCo=FBcmmUX1ZPkd0yggDYPCQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Gautam Dawar <gdawar.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, lingshan.zhu@intel.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Mar 2021 at 14:19, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Mon, 22 Mar 2021 at 20:49, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 156 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 24 Mar 2021 15:18:19 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h


> While runnning Kselftest net mptcp_join.sh tests the following warnings and
> kernel panic triggered on arm64, x86 and i386.
>  - arm64 juno-r2
>  - arm64 hikey
>  - x86
>  - i386
>
> easy to reproduce:
> Please find more details in this email.
>
> Warning:
> --------
> [ 1040.114695] refcount_t: addition on 0; use-after-free.
> [ 1040.119857] WARNING: CPU: 3 PID: 31925 at
> /usr/src/kernel/lib/refcount.c:25 refcount_warn_saturate+0xd7/0x100
> [ 1040.129769] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1040.159030] CPU: 3 PID: 31925 Comm: mptcp_connect Tainted: G
> W     K   5.10.26-rc2 #1
> [ 1040.167459] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1040.174851] RIP: 0010:refcount_warn_saturate+0xd7/0x100
>
> And
>
> Kernel Panic:
> -------------
> [ 1069.557485] BUG: kernel NULL pointer dereference, address: 0000000000000010
> [ 1069.564446] #PF: supervisor read access in kernel mode
> [ 1069.569583] #PF: error_code(0x0000) - not-present page
> [ 1069.574714] PGD 0 P4D 0
> [ 1069.577246] Oops: 0000 [#1] SMP PTI
> [ 1069.580730] CPU: 1 PID: 17 Comm: ksoftirqd/1 Tainted: G        W
>  K   5.10.26-rc2 #1
> [ 1069.588719] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1069.596106] RIP: 0010:selinux_socket_sock_rcv_skb+0x3f/0x290
> ...
> [ 1069.961697] Kernel panic - not syncing: Fatal exception in interrupt
> [ 1069.968083] Kernel Offset: 0x18600000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
>
> steps to reproduce:
> --------------------------
>           - cd /opt/kselftests/mainline/net/mptcp
>           - ./mptcp_join.sh  || true
>

The reported warning and kernel crash is bisected and found this commit is
cause.

> Florian Westphal <fw@strlen.de>
>     mptcp: put subflow sock on connect error

We have reverted this patch and re-tested and confirmed that after reverting
the reported issue got disappeared.

>
> Summary
> ------------------------------------------------------------------------
>
> kernel: 5.10.26-rc2
> git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> git branch: linux-5.10.y
> git commit: deabac90f919203307e6eee2606366bdb19bbe93
> git describe: v5.10.25-157-gdeabac90f919
> Test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.25-157-gdeabac90f919
> Test config: http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/juno/lkft/linux-stable-rc-5.10/113/config
>
>
> # selftests: net/mptcp: mptcp_join.sh
> [ 1032.910970] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1032.946716] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1033.003858] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1033.072944] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> # Created /tmp/tmp.YJ5EeX04Tc (size 1 KB) containing data sent by client
> # Created /tmp/tmp.TzVm9gRu34 (size 1 KB) containing data sent by server
> [ 1033.918127] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> # 01 no JOIN                              syn[ ok ] - synack[ ok ] - ack[ ok ]
> [ 1035.374798] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1035.440014] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1035.493485] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1035.548411] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1036.350125] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> # 02 single subflow, limited by client    syn[ ok ] - synack[ ok ] - ack[ ok ]
> [ 1037.842366] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1037.910581] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1037.977716] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1038.047941] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1039.106156] IPv4: Attempt to release alive inet socket 00000000e87684f6
> [ 1040.110048] ------------[ cut here ]------------
> [ 1040.114695] refcount_t: addition on 0; use-after-free.
> [ 1040.119857] WARNING: CPU: 3 PID: 31925 at
> /usr/src/kernel/lib/refcount.c:25 refcount_warn_saturate+0xd7/0x100
> [ 1040.129769] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1040.159030] CPU: 3 PID: 31925 Comm: mptcp_connect Tainted: G
> W     K   5.10.26-rc2 #1
> [ 1040.167459] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1040.174851] RIP: 0010:refcount_warn_saturate+0xd7/0x100
> [ 1040.180076] Code: 01 e8 ed 52 ad ff 0f 0b 5d c3 80 3d 7e b1 a2 01
> 00 0f 85 67 ff ff ff 48 c7 c7 b0 b0 0a 9b c6 05 6a b1 a2 01 01 e8 c9
> 52 ad ff <0f> 0b 5d c3 48 c7 c7 68 b0 0a 9b c6 05 54 b1 a2 01 01 e8 b2
> 52 ad
> [ 1040.198822] RSP: 0018:ffffa57ec5733d30 EFLAGS: 00010282
> [ 1040.204049] RAX: 0000000000000000 RBX: ffff90cfc7d6b840 RCX: 0000000000000000
> [ 1040.211181] RDX: 0000000000000001 RSI: ffff90d12fb97f30 RDI: ffff90d12fb97f30
> [ 1040.218313] RBP: ffffa57ec5733d30 R08: 0000000000000000 R09: 0000000000000000
> [ 1040.225445] R10: 0000000000000000 R11: ffffa57ec5733ae8 R12: 0000000000000000
> [ 1040.232578] R13: ffff90cfc7d6b8c0 R14: 0000000000000007 R15: ffff90cffe32d8f0
> [ 1040.239712] FS:  00007f3b5fbb14c0(0000) GS:ffff90d12fb80000(0000)
> knlGS:0000000000000000
> [ 1040.247798] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1040.253542] CR2: 00007ffec6cbecb0 CR3: 00000001041ec001 CR4: 00000000003706e0
> [ 1040.260677] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1040.267809] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1040.274940] Call Trace:
> [ 1040.277397]  tcp_close+0x45b/0x4f0
> [ 1040.280808]  inet_release+0x47/0x80
> [ 1040.284302]  __sock_release+0x8b/0xc0
> [ 1040.287977]  sock_release+0x10/0x20
> [ 1040.291478]  __mptcp_close_ssk+0x59/0x60
> [ 1040.295412]  mptcp_close+0x173/0x2f0
> [ 1040.298992]  inet_release+0x47/0x80
> [ 1040.302493]  __sock_release+0x42/0xc0
> [ 1040.306167]  sock_close+0x18/0x20
> [ 1040.309486]  __fput+0xb6/0x270
> [ 1040.312546]  ____fput+0xe/0x10
> [ 1040.315612]  task_work_run+0x6f/0xc0
> [ 1040.319192]  exit_to_user_mode_prepare+0x1a0/0x1b0
> [ 1040.323985]  syscall_exit_to_user_mode+0x3e/0x240
> [ 1040.328692]  do_syscall_64+0x43/0x50
> [ 1040.332278]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1040.337331] RIP: 0033:0x7f3b5f6c47c4
> [ 1040.340910] Code: ff eb 98 b8 ff ff ff ff eb 91 66 2e 0f 1f 84 00
> 00 00 00 00 66 90 48 8d 05 41 e1 2c 00 8b 00 85 c0 75 13 b8 03 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 3c c3 0f 1f 00 53 89 fb 48 83 ec 10 e8
> e4 a6
> [ 1040.359656] RSP: 002b:00007ffec6cbcc98 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000003
> [ 1040.367222] RAX: 0000000000000000 RBX: 00000000000003b8 RCX: 00007f3b5f6c47c4
> [ 1040.374354] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
> [ 1040.381484] RBP: 0000000000000005 R08: 00007f3b5f98d1e0 R09: 00007f3b5f98d240
> [ 1040.388629] R10: 0000000000000403 R11: 0000000000000246 R12: 0000000000000000
> [ 1040.395770] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 1040.402904] irq event stamp: 0
> [ 1040.405969] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [ 1040.412236] hardirqs last disabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1040.420408] softirqs last  enabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1040.428581] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [ 1040.434846] ---[ end trace 8a7765e77d8e79e5 ]---
> [ 1040.439466] ------------[ cut here ]------------
> [ 1040.444085] refcount_t: underflow; use-after-free.
> [ 1040.448882] WARNING: CPU: 3 PID: 31925 at
> /usr/src/kernel/lib/refcount.c:28 refcount_warn_saturate+0x93/0x100
> [ 1040.458799] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1040.488060] CPU: 3 PID: 31925 Comm: mptcp_connect Tainted: G
> W     K   5.10.26-rc2 #1
> [ 1040.496497] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1040.503891] RIP: 0010:refcount_warn_saturate+0x93/0x100
> [ 1040.509118] Code: cb b1 a2 01 01 e8 2d 53 ad ff 0f 0b 5d c3 80 3d
> bd b1 a2 01 00 75 ab 48 c7 c7 e0 b0 0a 9b c6 05 ad b1 a2 01 01 e8 0d
> 53 ad ff <0f> 0b 5d c3 80 3d a0 b1 a2 01 00 75 8b 48 c7 c7 68 b0 0a 9b
> c6 05
> [ 1040.527863] RSP: 0018:ffffa57ec5733d18 EFLAGS: 00010286
> [ 1040.533087] RAX: 0000000000000000 RBX: ffff90cfc7d6b840 RCX: 0000000000000000
> [ 1040.540220] RDX: 0000000000000001 RSI: ffff90d12fb97f30 RDI: ffff90d12fb97f30
> [ 1040.547353] RBP: ffffa57ec5733d18 R08: 0000000000000000 R09: 0000000000000000
> [ 1040.554486] R10: 0000000000000000 R11: ffffa57ec5733ad0 R12: ffff90cfc7d6b8c8
> [ 1040.561618] R13: ffff90cfc7d6b8c0 R14: 0000000000000007 R15: ffff90cffe32d8f0
> [ 1040.568751] FS:  00007f3b5fbb14c0(0000) GS:ffff90d12fb80000(0000)
> knlGS:0000000000000000
> [ 1040.576836] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1040.582584] CR2: 00007ffec6cbecb0 CR3: 00000001041ec001 CR4: 00000000003706e0
> [ 1040.589717] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1040.596851] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1040.603987] Call Trace:
> [ 1040.606444]  inet_csk_destroy_sock+0xd8/0x130
> [ 1040.610811]  tcp_close+0x426/0x4f0
> [ 1040.614217]  inet_release+0x47/0x80
> [ 1040.617710]  __sock_release+0x8b/0xc0
> [ 1040.621375]  sock_release+0x10/0x20
> [ 1040.624867]  __mptcp_close_ssk+0x59/0x60
> [ 1040.628795]  mptcp_close+0x173/0x2f0
> [ 1040.632383]  inet_release+0x47/0x80
> [ 1040.635884]  __sock_release+0x42/0xc0
> [ 1040.639557]  sock_close+0x18/0x20
> [ 1040.642877]  __fput+0xb6/0x270
> [ 1040.645935]  ____fput+0xe/0x10
> [ 1040.648994]  task_work_run+0x6f/0xc0
> [ 1040.652574]  exit_to_user_mode_prepare+0x1a0/0x1b0
> [ 1040.657367]  syscall_exit_to_user_mode+0x3e/0x240
> [ 1040.662072]  do_syscall_64+0x43/0x50
> [ 1040.665653]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1040.670713] RIP: 0033:0x7f3b5f6c47c4
> [ 1040.674293] Code: ff eb 98 b8 ff ff ff ff eb 91 66 2e 0f 1f 84 00
> 00 00 00 00 66 90 48 8d 05 41 e1 2c 00 8b 00 85 c0 75 13 b8 03 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 3c c3 0f 1f 00 53 89 fb 48 83 ec 10 e8
> e4 a6
> [ 1040.693038] RSP: 002b:00007ffec6cbcc98 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000003
> [ 1040.700604] RAX: 0000000000000000 RBX: 00000000000003b8 RCX: 00007f3b5f6c47c4
> [ 1040.707735] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
> [ 1040.714869] RBP: 0000000000000005 R08: 00007f3b5f98d1e0 R09: 00007f3b5f98d240
> [ 1040.722002] R10: 0000000000000403 R11: 0000000000000246 R12: 0000000000000000
> [ 1040.729134] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 1040.736267] irq event stamp: 0
> [ 1040.739325] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [ 1040.745592] hardirqs last disabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1040.753764] softirqs last  enabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1040.761935] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [ 1040.768202] ---[ end trace 8a7765e77d8e79e6 ]---
> # 03 single subflow, limited by server    syn[ ok ] - synack[ ok ] - ack[ ok ]
> [ 1040.917139] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1040.989376] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1041.057848] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1041.128414] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1041.918135] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> # 04 single subflow                       syn[ ok ] - synack[ ok ] - ack[ ok ]
> [ 1043.451283] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1043.519437] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1043.591193] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1043.662269] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1045.735845] ------------[ cut here ]------------
> [ 1045.740483] refcount_t: decrement hit 0; leaking memory.
> [ 1045.745809] WARNING: CPU: 1 PID: 32066 at
> /usr/src/kernel/lib/refcount.c:31 refcount_warn_saturate+0x53/0x100
> [ 1045.755724] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1045.784988] CPU: 1 PID: 32066 Comm: mptcp_connect Tainted: G
> W     K   5.10.26-rc2 #1
> [ 1045.793427] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1045.800821] RIP: 0010:refcount_warn_saturate+0x53/0x100
> [ 1045.806053] Code: 00 00 5d c3 83 fe 03 74 45 83 fe 04 75 20 80 3d
> fc b1 a2 01 00 75 eb 48 c7 c7 08 b1 0a 9b c6 05 ec b1 a2 01 01 e8 4d
> 53 ad ff <0f> 0b 5d c3 80 3d db b1 a2 01 00 75 cb 48 c7 c7 38 b1 0a 9b
> c6 05
> [ 1045.824798] RSP: 0018:ffffa57ec59f3cf0 EFLAGS: 00010282
> [ 1045.830025] RAX: 0000000000000000 RBX: 0000000000000010 RCX: 0000000000000000
> [ 1045.837158] RDX: 0000000000000001 RSI: ffff90d12fa97f30 RDI: ffff90d12fa97f30
> [ 1045.844290] RBP: ffffa57ec59f3cf0 R08: 0000000000000000 R09: 0000000000000000
> [ 1045.851424] R10: 0000000000000000 R11: ffffa57ec59f3aa8 R12: ffff90d007a02d00
> [ 1045.858555] R13: ffff90d007a02d80 R14: 0000000000000009 R15: ffff90d00be4c4f0
> [ 1045.865689] FS:  00007f55368c24c0(0000) GS:ffff90d12fa80000(0000)
> knlGS:0000000000000000
> [ 1045.873783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1045.879527] CR2: 00007ffe2b569540 CR3: 000000013dd62002 CR4: 00000000003706e0
> [ 1045.886659] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1045.893791] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1045.900924] Call Trace:
> [ 1045.903380]  tcp_release_cb+0x10f/0x180
> [ 1045.907220]  release_sock+0x48/0xb0
> [ 1045.910719]  tcp_close+0x25e/0x4f0
> [ 1045.914125]  inet_release+0x47/0x80
> [ 1045.917620]  __sock_release+0x8b/0xc0
> [ 1045.921291]  sock_release+0x10/0x20
> [ 1045.924784]  __mptcp_close_ssk+0x59/0x60
> [ 1045.928712]  mptcp_close+0x173/0x2f0
> [ 1045.932291]  inet_release+0x47/0x80
> [ 1045.935782]  __sock_release+0x42/0xc0
> [ 1045.939450]  sock_close+0x18/0x20
> [ 1045.942769]  __fput+0xb6/0x270
> [ 1045.945837]  ____fput+0xe/0x10
> [ 1045.948905]  task_work_run+0x6f/0xc0
> [ 1045.952492]  exit_to_user_mode_prepare+0x1a0/0x1b0
> [ 1045.957283]  syscall_exit_to_user_mode+0x3e/0x240
> [ 1045.961990]  do_syscall_64+0x43/0x50
> [ 1045.965569]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1045.970623] RIP: 0033:0x7f55363d57c4
> [ 1045.974201] Code: ff eb 98 b8 ff ff ff ff eb 91 66 2e 0f 1f 84 00
> 00 00 00 00 66 90 48 8d 05 41 e1 2c 00 8b 00 85 c0 75 13 b8 03 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 3c c3 0f 1f 00 53 89 fb 48 83 ec 10 e8
> e4 a6
> [ 1045.992944] RSP: 002b:00007ffe2b567528 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000003
> [ 1046.000513] RAX: 0000000000000000 RBX: 000000000000011c RCX: 00007f55363d57c4
> [ 1046.007652] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
> [ 1046.014784] RBP: 0000000000000005 R08: 00007f553669e1e4 R09: 00007f553669e240
> [ 1046.021918] R10: 0000000000000403 R11: 0000000000000246 R12: 0000000000000000
> [ 1046.029052] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [ 1046.036185] irq event stamp: 0
> [ 1046.039251] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [ 1046.045517] hardirqs last disabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1046.053690] softirqs last  enabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1046.061862] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [ 1046.068129] ---[ end trace 8a7765e77d8e79e7 ]---
> # 05 multiple subflows                    syn[ ok ] - synack[ ok ] - ack[ ok ]
> [ 1046.222612] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1046.292278] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1046.366140] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1046.436225] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1047.230122] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> [ 1047.510886] IPv4: Attempt to release alive inet socket 000000003578f3a2
> # 06 multiple subflows, limited by server syn[ ok ] - synack[ ok ] - ack[ ok ]
> [ 1048.769959] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1048.845133] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1048.916783] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1048.985439] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1049.726207] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> # 07 unused signal address                syn[ ok ] - synack[ ok ] - ack[ ok ]
> #                                         add[ ok ] - echo  [ ok ]
> [ 1051.315169] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1051.384917] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1051.452335] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1051.519687] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> # 08 signal address                       syn[ ok ] - synack[ ok ] - ack[ ok ]
> #                                         add[ ok ] - echo  [ ok ]
> [ 1053.866917] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1053.934026] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1054.003350] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1054.071502] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> # 09 subflow and signal                   syn[ ok ] - synack[ ok ] - ack[ ok ]
> #                                         add[ ok ] - echo  [ ok ]
> [ 1056.407692] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1056.461570] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1056.516522] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1056.573242] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1057.406178] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> # 10 multiple subflows and signal         syn[ ok ] - synack[ ok ] - ack[ ok ]
> #                                         add[ ok ] - echo  [ ok ]
> [ 1058.944588] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1058.998517] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1059.051399] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1059.114126] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1059.902128] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> # 11 remove single subflow                syn[ ok ] - synack[ ok ] - ack[ ok ]
> #                                         rm [ ok ] - sf    [ ok ]
> [ 1065.672583] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth1: link becomes ready
> [ 1065.712249] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth2: link becomes ready
> [ 1065.751709] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth3: link becomes ready
> [ 1065.792078] IPv6: ADDRCONF(NETDEV_CHANGE): ns1eth4: link becomes ready
> [ 1066.686117] IPv6: ADDRCONF(NETDEV_CHANGE): ns2eth1: link becomes ready
> [ 1067.902073] IPv4: Attempt to release TCP socket in state 1 0000000079de8dcd
> [ 1068.875113] ------------[ cut here ]------------
> [ 1068.879758] refcount_t: saturated; leaking memory.
> [ 1068.884577] WARNING: CPU: 1 PID: 32609 at
> /usr/src/kernel/lib/refcount.c:22 refcount_warn_saturate+0xee/0x100
> [ 1068.894497] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1068.923755] CPU: 1 PID: 32609 Comm: pm_nl_ctl Tainted: G        W
>   K   5.10.26-rc2 #1
> [ 1068.931842] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1068.939240] RIP: 0010:refcount_warn_saturate+0xee/0x100
> [ 1068.944468] Code: 48 c7 c7 b0 b0 0a 9b c6 05 6a b1 a2 01 01 e8 c9
> 52 ad ff 0f 0b 5d c3 48 c7 c7 68 b0 0a 9b c6 05 54 b1 a2 01 01 e8 b2
> 52 ad ff <0f> 0b 5d c3 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 8b 07
> 3d 00
> [ 1068.963224] RSP: 0018:ffffa57ec64af7f0 EFLAGS: 00010282
> [ 1068.968456] RAX: 0000000000000000 RBX: 000000000000002c RCX: 0000000000000000
> [ 1068.975587] RDX: 0000000000000001 RSI: ffff90d12fa97f30 RDI: ffff90d12fa97f30
> [ 1068.982719] RBP: ffffa57ec64af7f0 R08: 0000000000000000 R09: 0000000000000000
> [ 1068.989854] R10: 000000000000058c R11: ffffa57ec64af5a8 R12: ffffa57ec64af830
> [ 1068.996993] R13: ffff90cfc08eaee0 R14: 000000000000058c R15: ffff90d007a04380
> [ 1069.004131] FS:  00007f018dc0d4c0(0000) GS:ffff90d12fa80000(0000)
> knlGS:0000000000000000
> [ 1069.012220] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1069.017966] CR2: 00007f018d79c285 CR3: 000000013d894001 CR4: 00000000003706e0
> [ 1069.025098] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1069.032231] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1069.039362] Call Trace:
> [ 1069.041820]  __tcp_transmit_skb+0x851/0xcf0
> [ 1069.046017]  tcp_write_xmit+0x251/0x11a0
> [ 1069.049946]  __tcp_push_pending_frames+0x37/0x100
> [ 1069.054651]  tcp_send_fin+0x4f/0x240
> [ 1069.058230]  tcp_close+0x36f/0x4f0
> [ 1069.061640]  inet_release+0x47/0x80
> [ 1069.065141]  __sock_release+0x8b/0xc0
> [ 1069.068814]  sock_release+0x10/0x20
> [ 1069.072306]  __mptcp_close_ssk+0x59/0x60
> [ 1069.076232]  mptcp_pm_nl_rm_subflow_received+0xcb/0x110
> [ 1069.081461]  mptcp_pm_remove_subflow+0x34/0x70
> [ 1069.085913]  mptcp_nl_cmd_del_addr+0x3eb/0x440
> [ 1069.090361]  genl_family_rcv_msg_doit.isra.16+0x117/0x150
> [ 1069.095767]  ? genl_family_rcv_msg_doit.isra.16+0x117/0x150
> [ 1069.101341]  genl_rcv_msg+0xe8/0x1e0
> [ 1069.104926]  ? remove_anno_list_by_saddr+0x50/0x50
> [ 1069.109722]  ? genl_family_rcv_msg_doit.isra.16+0x150/0x150
> [ 1069.115301]  netlink_rcv_skb+0x56/0x100
> [ 1069.119141]  genl_rcv+0x28/0x40
> [ 1069.122285]  netlink_unicast+0x1b8/0x270
> [ 1069.126213]  netlink_sendmsg+0x339/0x460
> [ 1069.130148]  sock_sendmsg+0x63/0x70
> [ 1069.133649]  __sys_sendto+0x142/0x180
> [ 1069.137323]  ? __audit_syscall_entry+0xdd/0x130
> [ 1069.141855]  ? syscall_trace_enter.isra.16+0x179/0x230
> [ 1069.147000]  __x64_sys_sendto+0x28/0x30
> [ 1069.150852]  do_syscall_64+0x37/0x50
> [ 1069.154438]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1069.159490] RIP: 0033:0x7f018d72f577
> [ 1069.163070] Code: 64 89 02 48 c7 c0 ff ff ff ff eb b6 0f 1f 80 00
> 00 00 00 48 8d 05 91 f3 2b 00 41 89 ca 8b 00 85 c0 75 10 b8 2c 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 71 c3 41 57 4d 89 c7 41 56 41 89 ce 41
> 55 49
> [ 1069.181815] RSP: 002b:00007ffd65cf3ae8 EFLAGS: 00000246 ORIG_RAX:
> 000000000000002c
> [ 1069.189382] RAX: ffffffffffffffda RBX: 00007ffd65cf3b30 RCX: 00007f018d72f577
> [ 1069.196512] RDX: 0000000000000020 RSI: 00007ffd65cf3b30 RDI: 0000000000000005
> [ 1069.203647] RBP: 0000000000000020 R08: 00007ffd65cf3af4 R09: 000000000000000c
> [ 1069.210777] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [ 1069.217910] R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
> [ 1069.225047] irq event stamp: 0
> [ 1069.228112] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [ 1069.234378] hardirqs last disabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1069.242548] softirqs last  enabled at (0): [<ffffffff997bbde3>]
> copy_process+0x753/0x1d40
> [ 1069.250722] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [ 1069.256987] ---[ end trace 8a7765e77d8e79e8 ]---
> [ 1069.261660] ------------[ cut here ]------------
> [ 1069.266292] refcount_t: saturated; leaking memory.
> [ 1069.271104] WARNING: CPU: 1 PID: 17 at
> /usr/src/kernel/lib/refcount.c:19 refcount_warn_saturate+0xb3/0x100
> [ 1069.280759] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1069.310010] CPU: 1 PID: 17 Comm: ksoftirqd/1 Tainted: G        W
>  K   5.10.26-rc2 #1
> [ 1069.318007] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1069.325401] RIP: 0010:refcount_warn_saturate+0xb3/0x100
> [ 1069.330627] Code: ad b1 a2 01 01 e8 0d 53 ad ff 0f 0b 5d c3 80 3d
> a0 b1 a2 01 00 75 8b 48 c7 c7 68 b0 0a 9b c6 05 90 b1 a2 01 01 e8 ed
> 52 ad ff <0f> 0b 5d c3 80 3d 7e b1 a2 01 00 0f 85 67 ff ff ff 48 c7 c7
> b0 b0
> [ 1069.349374] RSP: 0018:ffffa57ec00e7bd8 EFLAGS: 00010282
> [ 1069.354599] RAX: 0000000000000000 RBX: ffff90d007a043e8 RCX: 0000000000000000
> [ 1069.361731] RDX: 0000000000000001 RSI: ffff90d12fa97f30 RDI: ffff90d12fa97f30
> [ 1069.368862] RBP: ffffa57ec00e7bd8 R08: 0000000000000000 R09: 0000000000000000
> [ 1069.375997] R10: 0000000000000000 R11: ffffa57ec00e7990 R12: 0000000096271b27
> [ 1069.383128] R13: 0203000a0101000a R14: ffff90cfffa66500 R15: 00000000bbb40c37
> [ 1069.390260] FS:  0000000000000000(0000) GS:ffff90d12fa80000(0000)
> knlGS:0000000000000000
> [ 1069.398346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1069.404092] CR2: 00007f018d79c285 CR3: 00000001ed026002 CR4: 00000000003706e0
> [ 1069.411223] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1069.418357] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1069.425488] Call Trace:
> [ 1069.427943]  __inet_lookup_established+0x141/0x170
> [ 1069.432735]  tcp_v4_early_demux+0xab/0x180
> [ 1069.436836]  ? rcu_read_lock_held+0x25/0x60
> [ 1069.441022]  ip_rcv_finish_core.isra.23+0x483/0x570
> [ 1069.445900]  ip_rcv_finish+0x6d/0xc0
> [ 1069.449478]  ip_rcv+0x142/0x200
> [ 1069.452625]  ? lock_acquire+0x1d4/0x3a0
> [ 1069.456466]  ? kfree+0x3e4/0x720
> [ 1069.459697]  ? process_backlog+0x73/0x250
> [ 1069.463709]  __netif_receive_skb_one_core+0x86/0xa0
> [ 1069.468591]  __netif_receive_skb+0x18/0x60
> [ 1069.472697]  process_backlog+0xe2/0x250
> [ 1069.476537]  net_rx_action+0x144/0x460
> [ 1069.480288]  __do_softirq+0xc3/0x42a
> [ 1069.483869]  ? smpboot_thread_fn+0x2b/0x1f0
> [ 1069.488053]  ? smpboot_thread_fn+0x70/0x1f0
> [ 1069.492242]  run_ksoftirqd+0x2b/0x60
> [ 1069.495818]  smpboot_thread_fn+0x149/0x1f0
> [ 1069.499920]  ? sort_range+0x30/0x30
> [ 1069.503411]  kthread+0x142/0x160
> [ 1069.506642]  ? kthread_insert_work_sanity_check+0x60/0x60
> [ 1069.512045]  ret_from_fork+0x22/0x30
> [ 1069.515632] irq event stamp: 195412
> [ 1069.519131] hardirqs last  enabled at (195411):
> [<ffffffff997c6db0>] run_ksoftirqd+0x30/0x60
> [ 1069.527564] hardirqs last disabled at (195412):
> [<ffffffff9a739c94>] __schedule+0x624/0x950
> [ 1069.535910] softirqs last  enabled at (195410):
> [<ffffffff9aa00308>] __do_softirq+0x308/0x42a
> [ 1069.544428] softirqs last disabled at (195383):
> [<ffffffff997c6dab>] run_ksoftirqd+0x2b/0x60
> [ 1069.552860] ---[ end trace 8a7765e77d8e79e9 ]---
> [ 1069.557485] BUG: kernel NULL pointer dereference, address: 0000000000000010
> [ 1069.564446] #PF: supervisor read access in kernel mode
> [ 1069.569583] #PF: error_code(0x0000) - not-present page
> [ 1069.574714] PGD 0 P4D 0
> [ 1069.577246] Oops: 0000 [#1] SMP PTI
> [ 1069.580730] CPU: 1 PID: 17 Comm: ksoftirqd/1 Tainted: G        W
>  K   5.10.26-rc2 #1
> [ 1069.588719] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.2 05/23/2018
> [ 1069.596106] RIP: 0010:selinux_socket_sock_rcv_skb+0x3f/0x290
> [ 1069.601762] Code: 54 4c 8d 75 98 53 49 89 fd 48 83 ec 78 0f b7 5f
> 10 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 48 8b 87 48 04 00 00
> 4c 89 f7 <44> 8b 78 10 31 c0 f3 48 ab 89 d8 83 e0 f7 66 83 f8 02 0f 85
> 4a 01
> [ 1069.620498] RSP: 0018:ffffa57ec00e7a20 EFLAGS: 00010246
> [ 1069.625715] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000007
> [ 1069.632841] RDX: ffffffff9995c813 RSI: ffff90cffe966b00 RDI: ffffa57ec00e7a58
> [ 1069.639965] RBP: ffffa57ec00e7ac0 R08: 0000000000000000 R09: 0000000000000000
> [ 1069.647090] R10: 0000000000000000 R11: ffff90cfffa66500 R12: ffff90cffe966b00
> [ 1069.654221] R13: ffff90d007a04380 R14: ffffa57ec00e7a58 R15: ffff90d007a04380
> [ 1069.661344] FS:  0000000000000000(0000) GS:ffff90d12fa80000(0000)
> knlGS:0000000000000000
> [ 1069.669421] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1069.675159] CR2: 0000000000000010 CR3: 00000001ed026002 CR4: 00000000003706e0
> [ 1069.682284] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1069.689407] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1069.696530] Call Trace:
> [ 1069.698976]  ? __cgroup_bpf_run_filter_skb+0x20c/0x670
> [ 1069.704115]  ? lock_release+0xcf/0x270
> [ 1069.707868]  ? rcu_read_lock_held_common+0x12/0x50
> [ 1069.712659]  ? rcu_read_lock_held+0x25/0x60
> [ 1069.716837]  security_sock_rcv_skb+0x2f/0x50
> [ 1069.721112]  sk_filter_trim_cap+0x48/0x350
> [ 1069.725208]  ? tcp_v4_inbound_md5_hash+0x60/0x1e0
> [ 1069.729906]  tcp_v4_rcv+0xb59/0xd70
> [ 1069.733390]  ? lock_acquire+0x1d4/0x3a0
> [ 1069.737229]  ip_protocol_deliver_rcu+0x3c/0x270
> [ 1069.741754]  ip_local_deliver_finish+0x92/0x130
> [ 1069.746286]  ip_local_deliver+0x1a1/0x200
> [ 1069.750289]  ? rcu_read_lock_held+0x25/0x60
> [ 1069.754468]  ip_rcv_finish+0x8a/0xc0
> [ 1069.758046]  ip_rcv+0x142/0x200
> [ 1069.761183]  ? lock_acquire+0x1d4/0x3a0
> [ 1069.765014]  ? kfree+0x3e4/0x720
> [ 1069.768248]  ? process_backlog+0x73/0x250
> [ 1069.772261]  __netif_receive_skb_one_core+0x86/0xa0
> [ 1069.777138]  __netif_receive_skb+0x18/0x60
> [ 1069.781228]  process_backlog+0xe2/0x250
> [ 1069.785061]  net_rx_action+0x144/0x460
> [ 1069.788812]  __do_softirq+0xc3/0x42a
> [ 1069.792382]  ? smpboot_thread_fn+0x2b/0x1f0
> [ 1069.796561]  ? smpboot_thread_fn+0x70/0x1f0
> [ 1069.800746]  run_ksoftirqd+0x2b/0x60
> [ 1069.804326]  smpboot_thread_fn+0x149/0x1f0
> [ 1069.808423]  ? sort_range+0x30/0x30
> [ 1069.811908]  kthread+0x142/0x160
> [ 1069.815132]  ? kthread_insert_work_sanity_check+0x60/0x60
> [ 1069.820524]  ret_from_fork+0x22/0x30
> [ 1069.824104] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
> ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
> nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
> iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
> x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
> [ 1069.853359] CR2: 0000000000000010
> [ 1069.856671] ---[ end trace 8a7765e77d8e79ea ]---
> [ 1069.861290] RIP: 0010:selinux_socket_sock_rcv_skb+0x3f/0x290
> [ 1069.866940] Code: 54 4c 8d 75 98 53 49 89 fd 48 83 ec 78 0f b7 5f
> 10 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 48 8b 87 48 04 00 00
> 4c 89 f7 <44> 8b 78 10 31 c0 f3 48 ab 89 d8 83 e0 f7 66 83 f8 02 0f 85
> 4a 01
> [ 1069.885676] RSP: 0018:ffffa57ec00e7a20 EFLAGS: 00010246
> [ 1069.890893] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000007
> [ 1069.898018] RDX: ffffffff9995c813 RSI: ffff90cffe966b00 RDI: ffffa57ec00e7a58
> [ 1069.905141] RBP: ffffa57ec00e7ac0 R08: 0000000000000000 R09: 0000000000000000
> [ 1069.912264] R10: 0000000000000000 R11: ffff90cfffa66500 R12: ffff90cffe966b00
> [ 1069.919389] R13: ffff90d007a04380 R14: ffffa57ec00e7a58 R15: ffff90d007a04380
> [ 1069.926514] FS:  0000000000000000(0000) GS:ffff90d12fa80000(0000)
> knlGS:0000000000000000
> [ 1069.934589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1069.940328] CR2: 0000000000000010 CR3: 00000001ed026002 CR4: 00000000003706e0
> [ 1069.947449] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1069.954575] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1069.961697] Kernel panic - not syncing: Fatal exception in interrupt
> [ 1069.968083] Kernel Offset: 0x18600000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [ 1069.978859] ---[ end Kernel panic - not syncing: Fatal exception in
> interrupt ]---
>
>
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.25-157-gdeabac90f919/testrun/4220685/suite/linux-log-parser/test/check-kernel-bug-2434782/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.25-157-gdeabac90f919/testrun/4221759/suite/linux-log-parser/test/check-kernel-warning-2434838/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.25-157-gdeabac90f919/testrun/4221747/suite/linux-log-parser/test/check-kernel-bug-2434809/log
>
> LAVA jobs link,
> https://lkft.validation.linaro.org/scheduler/job/2436164
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
