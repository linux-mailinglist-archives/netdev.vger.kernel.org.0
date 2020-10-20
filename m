Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC752941DE
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408939AbgJTSFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgJTSFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 14:05:41 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C102C0613D3
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:05:41 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p16so3563117ilq.5
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 11:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=r82QmIbFF2xFdXg/o0KpezumP1MatOfRuk9pVxv+U4s=;
        b=hpVCgt8KtuPblM0JNOiebIXuyI9GZhrskkMVpYo+AWlKO7XwwT0xu79OidGe72ywd0
         abdzkeofBn4vuG7Vwm6Rte07Ca8d2QntF0e1QWMWjpXQuGBYJf8OBhhE8LPGF6/eXfc0
         M+e9UePYZ+KUWF5zqV4B/+DWB9YIfKvkFibtEZ+5CJ5pDAKxrxRY/rdQx+BY7KCfD95v
         icKX39ZFPkG+7yx8vAYSEN+i3bnQ1y9bj3Y0KoYI9gWzraR0oTe71XUq8I7qpS81i/4Y
         +kddmlYJUYC/F8dIzdAnTAjaorqu5XkAW8J+0H8A27ZeF1IMN7NzcJrucmFa81X6c9QX
         ZtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=r82QmIbFF2xFdXg/o0KpezumP1MatOfRuk9pVxv+U4s=;
        b=Oa0JdLxxN//3RTpTXVI5dpC+hjWhsbdFZcEtgiH5HV7e7L6DluiFQFR3lWDayGvHry
         cIJDews65rqymQ+xiShWau/CicRVF4cQF2J078yuwgRPeJ6cDg7jMOjjgi4VjfDcfz1S
         CIslA5G1Cqulv4LTYhvnH6KVzF0RBO8qMAmDUOHzh6bbKRhNLvQTgq8EIPEjD6MByNj1
         1/P/fgfQQiGUrgHWfPahdIwJhF/wt5FeLACu5E0xSwyYVqYmqmo1NuHraH9RT0oOJiy5
         tZ4S8QVhMtDgcqsGotz4tW7W3B+4B36Jd2/zzCEqtDC+IqryjczpiR85eVP0g1byIZ6l
         VBSw==
X-Gm-Message-State: AOAM532eC4BoaWxvWFaGSImfXMvHnSlVp5oFPzWUsxEvp4J0vWfXOEBl
        ucn3w10BRt7Lr90V5mbmCz6cLboKNP0SGs06fqox2g==
X-Google-Smtp-Source: ABdhPJx/xkusFUQ/PyeJLvJ0hdsIzn5vTNv6CVzc+adHtzV6cn1+Z6skT3dhIkI4lIJVMUqzPCEGgRhhjLVmpvuzKzw=
X-Received: by 2002:a92:9944:: with SMTP id p65mr2845837ili.127.1603217139924;
 Tue, 20 Oct 2020 11:05:39 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Oct 2020 23:35:28 +0530
Message-ID: <CA+G9fYs7YLWx=90425onuwZU8WOLWwpH4T9EQgv0b9Y3tiPe=w@mail.gmail.com>
Subject: BUG: unable to handle page fault for address - PF: supervisor read
 access in kernel mode
To:     open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Netdev <netdev@vger.kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <guro@fb.com>, linux-mm <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

while running selftests net icmp_redirect.sh the following crash noticed on
x86_64 on linux-next master.

BUG: unable to handle page fault for address: ffff9c00302d7872
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 2c401067 P4D 2c401067 PUD 0
Oops: 0000 [#1] SMP PTI
CPU: 1 PID: 887 Comm: ip Tainted: G        W     K   5.9.0-next-20201016 #1
Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS 2.0b 07/27/2017
RIP: 0010:__kmalloc_track_caller+0x100/0x340

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

metadata:
  git branch: master
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
  git commit: b2926c108f9fd225d3fe9ea73fb5c35f48735d20
  git describe: next-20201016
  make_kernelversion: 5.9.0
  kernel-config:
http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/intel-corei7-64/lkft/linux-next/881/config

steps to reproduce:
----------------------------
# cd /opt/kselftests/default-in-kernel/
# ./run_kselftest.sh -t net:icmp_redirect.sh

crash log:
----------
# selftests: net: icmp_redirect.sh
<trim>
[ 1062.257877] eth0: renamed from r1h1
[ 1062.311218] eth0: renamed from r2h1
[ 1062.321114] device eth1 left promiscuous mode
[ 1062.325655] br0: port 2(eth1) entered disabled state
[ 1062.325671] audit: type=1700 audit(1602906729.931:89088): dev=eth1
prom=0 old_prom=256 auid=4294967295 uid=0 gid=0 ses=4294967295
[ 1062.353160] device eth0 left promiscuous mode
[ 1062.357640] br0: port 1(eth0) entered disabled state
[ 1062.357707] audit: type=1700 audit(1602906729.963:89089): dev=eth0
prom=0 old_prom=256 auid=4294967295 uid=0 gid=0 ses=4294967295
[ 1062.506822] eth2: renamed from r2h2
[ 1062.516999] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[ 1062.529632] BUG: unable to handle page fault for address: ffff9c00302d7872
[ 1062.536516] #PF: supervisor read access in kernel mode
[ 1062.541655] #PF: error_code(0x0000) - not-present page
[ 1062.546786] PGD 2c401067 P4D 2c401067 PUD 0
[ 1062.551058] Oops: 0000 [#1] SMP PTI
[ 1062.554544] CPU: 1 PID: 887 Comm: ip Tainted: G        W     K
5.9.0-next-20201016 #1
[ 1062.562540] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1062.570013] RIP: 0010:__kmalloc_track_caller+0x100/0x340
[ 1062.575325] Code: 4d 8b 04 24 65 49 8b 50 08 65 4c 03 05 01 70 20
4a 49 8b 00 48 85 c0 48 89 45 c8 0f 84 ba 01 00 00 41 8b 4c 24 28 49
8b 3c 24 <48> 8b 1c 08 48 8d 4a 01 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2
41 8b
[ 1062.594070] RSP: 0018:ffffb83c009f3ce8 EFLAGS: 00010286
[ 1062.599296] RAX: ffff9c00302d7872 RBX: 0000000000000cc0 RCX: 0000000000000000
[ 1062.606420] RDX: 000000000031bfb3 RSI: 0000000000000cc0 RDI: 000000000002f2d0
[ 1062.613544] RBP: ffffb83c009f3d28 R08: ffff9c541fcaf2d0 R09: 0000000000000000
[ 1062.620666] R10: ffffb83c009f3b98 R11: 0000000000000246 R12: ffff9c50c0042e00
[ 1062.627791] R13: 0000000000000cc0 R14: 0000000000000005 R15: ffffffffb5da0814
[ 1062.634917] FS:  00007f74b53d9440(0000) GS:ffff9c541fc80000(0000)
knlGS:0000000000000000
[ 1062.642999] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1062.648738] CR2: ffff9c00302d7872 CR3: 0000000105d3e002 CR4: 00000000003706e0
[ 1062.655861] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1062.662984] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1062.670109] Call Trace:
[ 1062.672558]  kstrdup+0x31/0x60
[ 1062.675616]  kstrdup_const+0x24/0x30
[ 1062.679193]  alloc_vfsmnt+0x64/0x1a0
[ 1062.682774]  clone_mnt+0x36/0x2f0
[ 1062.686092]  copy_tree+0x12e/0x390
[ 1062.689498]  copy_mnt_ns+0xb5/0x380
[ 1062.692983]  create_new_namespaces+0x61/0x2c0
[ 1062.697340]  unshare_nsproxy_namespaces+0x5a/0xb0
[ 1062.702040]  ksys_unshare+0x1e5/0x370
[ 1062.705704]  __x64_sys_unshare+0x12/0x20
[ 1062.709631]  do_syscall_64+0x37/0x50
[ 1062.713208]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1062.718256] RIP: 0033:0x7f74b46d4d27
[ 1062.721831] Code: 73 01 c3 48 8b 0d 71 a1 2b 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 41 a1 2b 00 f7 d8 64 89
01 48
[ 1062.740569] RSP: 002b:00007fff74b0dbb8 EFLAGS: 00000206 ORIG_RAX:
0000000000000110
[ 1062.748135] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f74b46d4d27
[ 1062.755257] RDX: 0000000000080000 RSI: 0000000040000000 RDI: 0000000000020000
[ 1062.762380] RBP: 00007fff74b11c45 R08: 0000000000000002 R09: 0000000000000000
[ 1062.769504] R10: 0000000000000358 R11: 0000000000000206 R12: 00007fff74b10ec8
[ 1062.776628] R13: 0000000000470deb R14: 00007fff74b11c3b R15: 00007fff74b10ed0
[ 1062.783757] Modules linked in: ip6table_mangle mpls_iptunnel
mpls_router sch_etf ip6table_filter xt_conntrack nf_conntrack
nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 iptable_filter
ip_tables netdevsim vrf 8021q bridge stp llc sch_fq sch_ingress veth
algif_hash x86_pkg_temp_thermal fuse [last unloaded:
test_blackhole_dev]
[ 1062.812840] CR2: ffff9c00302d7872
[ 1062.816158] ---[ end trace 47c4f9ef0796b428 ]---
[ 1062.820769] RIP: 0010:__kmalloc_track_caller+0x100/0x340
[ 1062.826081] Code: 4d 8b 04 24 65 49 8b 50 08 65 4c 03 05 01 70 20
4a 49 8b 00 48 85 c0 48 89 45 c8 0f 84 ba 01 00 00 41 8b 4c 24 28 49
8b 3c 24 <48> 8b 1c 08 48 8d 4a 01 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2
41 8b
[ 1062.844817] RSP: 0018:ffffb83c009f3ce8 EFLAGS: 00010286
[ 1062.850033] RAX: ffff9c00302d7872 RBX: 0000000000000cc0 RCX: 0000000000000000
[ 1062.857158] RDX: 000000000031bfb3 RSI: 0000000000000cc0 RDI: 000000000002f2d0
[ 1062.864284] RBP: ffffb83c009f3d28 R08: ffff9c541fcaf2d0 R09: 0000000000000000
[ 1062.871415] R10: ffffb83c009f3b98 R11: 0000000000000246 R12: ffff9c50c0042e00
[ 1062.878540] R13: 0000000000000cc0 R14: 0000000000000005 R15: ffffffffb5da0814
[ 1062.885662] FS:  00007f74b53d9440(0000) GS:ffff9c541fc80000(0000)
knlGS:0000000000000000
[ 1062.893740] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1062.899475] CR2: ffff9c00302d7872 CR3: 0000000105d3e002 CR4: 00000000003706e0
[ 1062.906600] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1062.913726] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1062.920850] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:49
[ 1062.931101] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid:
887, name: ip
[ 1062.938485] INFO: lockdep is turned off.
[ 1062.942403] irq event stamp: 2686
[ 1062.945715] hardirqs last  enabled at (2685): [<ffffffffb6aef301>]
_raw_spin_unlock_irqrestore+0x31/0x40
[ 1062.955186] hardirqs last disabled at (2686): [<ffffffffb6adfb31>]
irqentry_enter+0x21/0x50
[ 1062.963522] softirqs last  enabled at (1978): [<ffffffffb6755555>]
release_sock+0x85/0xb0
[ 1062.971686] softirqs last disabled at (1976): [<ffffffffb67554ee>]
release_sock+0x1e/0xb0
[ 1062.979850] CPU: 1 PID: 887 Comm: ip Tainted: G      D W     K
5.9.0-next-20201016 #1
[ 1062.987841] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1062.995310] Call Trace:
[ 1062.997756]  dump_stack+0x7d/0x9f
[ 1063.001066]  ___might_sleep+0x163/0x250
[ 1063.004897]  __might_sleep+0x4a/0x80
[ 1063.008469]  exit_signals+0x33/0x2f0
[ 1063.012047]  do_exit+0xa9/0xcb0
[ 1063.015185]  rewind_stack_do_exit+0x17/0x20
[ 1063.019369] RIP: 0033:0x7f74b46d4d27
[ 1063.022941] Code: 73 01 c3 48 8b 0d 71 a1 2b 00 f7 d8 64 89 01 48
83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 41 a1 2b 00 f7 d8 64 89
01 48
[ 1063.041677] RSP: 002b:00007fff74b0dbb8 EFLAGS: 00000206 ORIG_RAX:
0000000000000110
[ 1063.049233] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f74b46d4d27
[ 1063.056359] RDX: 0000000000080000 RSI: 0000000040000000 RDI: 0000000000020000
[ 1063.063483] RBP: 00007fff74b11c45 R08: 0000000000000002 R09: 0000000000000000
[ 1063.070614] R10: 0000000000000358 R11: 0000000000000206 R12: 00007fff74b10ec8
[ 1063.077739] R13: 0000000000470deb R14: 00007fff74b11c3b R15: 00007fff74b10ed0
# ./icmp_redirect.sh: line 165:   887 Killed                  ip
-netns r1 li add eth1 type veth peer name r2r1
[ 1067.354852] BUG: unable to handle page fault for address: ffff9c00302d7872
[ 1067.361741] #PF: supervisor read access in kernel mode
[ 1067.361742] #PF: error_code(0x0000) - not-present page
[ 1067.361743] PGD 2c401067 P4D 2c401067 PUD 0
[ 1067.361746] Oops: 0000 [#2] SMP PTI
[ 1067.361747] CPU: 1 PID: 332 Comm: systemd-journal Tainted: G      D
W     K   5.9.0-next-20201016 #1
[ 1067.361748] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1067.361751] RIP: 0010:__kmalloc_track_caller+0x100/0x340
[ 1067.361753] Code: 4d 8b 04 24 65 49 8b 50 08 65 4c 03 05 01 70 20
4a 49 8b 00 48 85 c0 48 89 45 c8 0f 84 ba 01 00 00 41 8b 4c 24 28 49
8b 3c 24 <48> 8b 1c 08 48 8d 4a 01 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2
41 8b
[ 1067.361754] RSP: 0018:ffffb83c00ca7ad8 EFLAGS: 00010286
[ 1067.361755] RAX: ffff9c00302d7872 RBX: 0000000000000a20 RCX: 0000000000000000
[ 1067.361755] RDX: 000000000031bfb3 RSI: 0000000000000a20 RDI: 000000000002f2d0
[ 1067.361756] RBP: ffffb83c00ca7b18 R08: ffff9c541fcaf2d0 R09: 0000000000000000
[ 1067.361757] R10: ffffffffb884f560 R11: ffffb83c00ca7dd8 R12: ffff9c50c0042e00
[ 1067.361757] R13: 0000000000000a20 R14: 0000000000000007 R15: ffffffffb603d886
[ 1067.361758] FS:  00007f0aa293b480(0000) GS:ffff9c541fc80000(0000)
knlGS:0000000000000000
[ 1067.361759] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1067.361760] CR2: ffff9c00302d7872 CR3: 00000001040e2006 CR4: 00000000003706e0
[ 1067.361761] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1067.361761] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1067.361762] Call Trace:
[ 1067.361766]  kmemdup+0x20/0x50
[ 1067.361769]  security_sid_to_context_core+0x86/0x290
[ 1067.361771]  ? __might_fault+0x79/0x80
[ 1067.361774]  security_sid_to_context+0x14/0x20
[ 1067.515084]  selinux_secid_to_secctx+0x1d/0x20
[ 1067.519522]  security_secid_to_secctx+0x41/0x60
[ 1067.524054]  unix_dgram_recvmsg+0x46b/0x600
[ 1067.528241]  ? lock_release+0xcf/0x270
[ 1067.531995]  sock_recvmsg+0x6d/0x70
[ 1067.535486]  ____sys_recvmsg+0x9b/0x1b0
[ 1067.539325]  ? import_iovec+0x1b/0x20
[ 1067.542989]  ? copy_msghdr_from_user+0x60/0x90
[ 1067.547426]  ? avc_has_perm+0x139/0x2b0
[ 1067.551259]  ___sys_recvmsg+0x8c/0xd0
[ 1067.554923]  ? sock_ioctl+0x280/0x3c0
[ 1067.558580]  ? file_has_perm+0xc6/0xd0
[ 1067.562324]  ? sock_ioctl+0x280/0x3c0
[ 1067.565984]  __sys_recvmsg+0x66/0xb0
[ 1067.569561]  ? __sys_recvmsg+0x66/0xb0
[ 1067.573307]  ? do_syscall_64+0x13/0x50
[ 1067.577058]  __x64_sys_recvmsg+0x1f/0x30
[ 1067.580975]  do_syscall_64+0x37/0x50
[ 1067.584547]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1067.589602] RIP: 0033:0x7f0aa20e26a7
[ 1067.593179] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48
83 ec 10 e8 8b eb ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2f 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 c4 eb ff
ff 48
[ 1067.611924] RSP: 002b:00007ffec379aca0 EFLAGS: 00000293 ORIG_RAX:
000000000000002f
[ 1067.619487] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f0aa20e26a7
[ 1067.626611] RDX: 0000000040000040 RSI: 00007ffec379ad10 RDI: 0000000000000004
[ 1067.633737] RBP: 00007ffec379ad10 R08: 0000000000000000 R09: 000000000000042a
[ 1067.640867] R10: 00000000ffffffff R11: 0000000000000293 R12: 0000000040000040
[ 1067.647993] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[ 1067.655118] Modules linked in: ip6table_mangle mpls_iptunnel
mpls_router sch_etf ip6table_filter xt_conntrack nf_conntrack
nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 iptable_filter
ip_tables netdevsim vrf 8021q bridge stp llc sch_fq sch_ingress veth
algif_hash x86_pkg_temp_thermal fuse [last unloaded:
test_blackhole_dev]
[ 1067.684200] CR2: ffff9c00302d7872
[ 1067.687511] ---[ end trace 47c4f9ef0796b429 ]---
[ 1067.692123] RIP: 0010:__kmalloc_track_caller+0x100/0x340
[ 1067.697425] Code: 4d 8b 04 24 65 49 8b 50 08 65 4c 03 05 01 70 20
4a 49 8b 00 48 85 c0 48 89 45 c8 0f 84 ba 01 00 00 41 8b 4c 24 28 49
8b 3c 24 <48> 8b 1c 08 48 8d 4a 01 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2
41 8b
[ 1067.716163] RSP: 0018:ffffb83c009f3ce8 EFLAGS: 00010286
[ 1067.721380] RAX: ffff9c00302d7872 RBX: 0000000000000cc0 RCX: 0000000000000000
[ 1067.728505] RDX: 000000000031bfb3 RSI: 0000000000000cc0 RDI: 000000000002f2d0
[ 1067.735629] RBP: ffffb83c009f3d28 R08: ffff9c541fcaf2d0 R09: 0000000000000000
[ 1067.742753] R10: ffffb83c009f3b98 R11: 0000000000000246 R12: ffff9c50c0042e00
[ 1067.749874] R13: 0000000000000cc0 R14: 0000000000000005 R15: ffffffffb5da0814
[ 1067.756999] FS:  00007f0aa293b480(0000) GS:ffff9c541fc80000(0000)
knlGS:0000000000000000
[ 1067.765078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1067.770813] CR2: ffff9c00302d7872 CR3: 00000001040e2006 CR4: 00000000003706e0
[ 1067.777938] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1067.785060] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1067.792185] BUG: sleeping function called from invalid context at
/usr/src/kernel/include/linux/percpu-rwsem.h:49
[ 1067.802429] in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid:
332, name: systemd-journal
[ 1067.810941] INFO: lockdep is turned off.
[ 1067.814859] irq event stamp: 16046288
[ 1067.818523] hardirqs last  enabled at (16046287):
[<ffffffffb6aef8c7>] _raw_write_unlock_irq+0x27/0x40
[ 1067.827816] hardirqs last disabled at (16046288):
[<ffffffffb6ae8724>] __schedule+0x624/0x950
[ 1067.836334] softirqs last  enabled at (16044926):
[<ffffffffb6e00308>] __do_softirq+0x308/0x42a
[ 1067.845018] softirqs last disabled at (16044919):
[<ffffffffb6c00f82>] asm_call_irq_on_stack+0x12/0x20
[ 1067.854316] CPU: 1 PID: 332 Comm: systemd-journal Tainted: G      D
W     K   5.9.0-next-20201016 #1
[ 1067.863432] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1067.870903] Call Trace:
[ 1067.873349]  dump_stack+0x7d/0x9f
[ 1067.876668]  ___might_sleep+0x163/0x250
[ 1067.880506]  __might_sleep+0x4a/0x80
[ 1067.884078]  exit_signals+0x33/0x2f0
[ 1067.887656]  do_exit+0xa9/0xcb0
[ 1067.890796]  rewind_stack_do_exit+0x17/0x20
[ 1067.894980] RIP: 0033:0x7f0aa20e26a7
[ 1067.898551] Code: 44 00 00 41 54 41 89 d4 55 48 89 f5 53 89 fb 48
83 ec 10 e8 8b eb ff ff 44 89 e2 48 89 ee 89 df 41 89 c0 b8 2f 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 c4 eb ff
ff 48
[ 1067.917294] RSP: 002b:00007ffec379aca0 EFLAGS: 00000293 ORIG_RAX:
000000000000002f
[ 1067.924852] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f0aa20e26a7
[ 1067.931975] RDX: 0000000040000040 RSI: 00007ffec379ad10 RDI: 0000000000000004
[ 1067.939100] RBP: 00007ffec379ad10 R08: 0000000000000000 R09: 000000000000042a
[ 1067.946224] R10: 00000000ffffffff R11: 0000000000000293 R12: 0000000040000040
[ 1067.953348] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[ 1067.961618] systemd[1]: systemd-journald.service: Service has no
hold-off time, scheduling restart.
[ 1067.970722] systemd[1]: systemd-journald.service: Scheduled restart
job, restart counter is at 1.
[ 1067.980063] systemd[1]: Stopped Flush Journal to Persistent Storage.
[ 1067.986435] systemd[1]: Stopping Flush Journal to Persistent Storage...
[ 1067.993060] systemd[1]: Stopped Journal Service.
[ 1067.998163] audit: type=1334 audit(1602906735.603:89090):
prog-id=43815 op=LOAD
[ 1068.005571] audit: type=1334 audit(1602906735.611:89091):
prog-id=43816 op=LOAD
[ 1068.005978] systemd[1]: Starting Journal Service...
[ 1068.014259] audit: type=1305 audit(1602906735.619:89092): op=set
audit_enabled=1 old=1 auid=4294967295 ses=4294967295 subj=kernel res=1
[ 1068.014935] systemd-journald[890]: File
/run/log/journal/b58194f5bd004118b8471b91dd8d1ce6/system.journal
corrupted or uncleanly shut down, renaming and replacing.
[ 1068.044478] audit: type=1334 audit(1602906735.624:89093):
prog-id=11 op=UNLOAD
[ 1068.051740] audit: type=1334 audit(1602906735.624:89094):
prog-id=10 op=UNLOAD
[ 1068.072184] systemd[1]: Started Journal Service.
[ 1068.077987] BUG: unable to handle page fault for address: ffff9c00302d7872
[ 1068.084862] #PF: supervisor read access in kernel mode
[ 1068.089991] #PF: error_code(0x0000) - not-present page
[ 1068.095122] PGD 2c401067 P4D 2c401067 PUD 0
[ 1068.099388] Oops: 0000 [#3] SMP PTI
[ 1068.102873] CPU: 1 PID: 891 Comm: (urnalctl) Tainted: G      D W
 K   5.9.0-next-20201016 #1
[ 1068.111562] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1068.119037] RIP: 0010:__kmalloc+0x100/0x330
[ 1068.123220] Code: 4d 8b 04 24 65 49 8b 50 08 65 4c 03 05 a1 7a 20
4a 49 8b 00 48 85 c0 48 89 45 c8 0f 84 bf 01 00 00 41 8b 4c 24 28 49
8b 3c 24 <48> 8b 1c 08 48 8d 4a 01 65 48 0f c7 0f 0f 94 c0 84 c0 74 c2
41 8b
[ 1068.141958] RSP: 0018:ffffb83c00107e20 EFLAGS: 00010286
[ 1068.147181] RAX: ffff9c00302d7872 RBX: 0000000000000cc0 RCX: 0000000000000000
[ 1068.154307] RDX: 000000000031bfb3 RSI: 0000000000000cc0 RDI: 000000000002f2d0
[ 1068.161431] RBP: ffffb83c00107e60 R08: ffff9c541fcaf2d0 R09: 0000000000000000
[ 1068.168554] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9c50c0042e00
[ 1068.175678] R13: 0000000000000cc0 R14: 0000000000000005 R15: 0000000000000000
[ 1068.182803] FS:  00007f31ad0f4840(0000) GS:ffff9c541fc80000(0000)
knlGS:0000000000000000
[ 1068.190880] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1068.196616] CR2: ffff9c00302d7872 CR3: 00000001040e2001 CR4: 00000000003706e0
[ 1068.203740] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1068.210865] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1068.217986] Call Trace:
[ 1068.220436]  ? kernfs_fop_write+0xcf/0x1c0
[ 1068.224533]  kernfs_fop_write+0xcf/0x1c0
[ 1068.228458]  vfs_write+0xed/0x240
[ 1068.231768]  ksys_write+0xad/0xf0
[ 1068.235080]  __x64_sys_write+0x1a/0x20
[ 1068.238833]  do_syscall_64+0x37/0x50
[ 1068.242411]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1068.247456] RIP: 0033:0x7f31ab8ed177
[ 1068.251033] Code: 0f 1f 00 41 54 49 89 d4 55 48 89 f5 53 89 fb 48
83 ec 10 e8 5b ad 01 00 4c 89 e2 48 89 ee 89 df 41 89 c0 b8 01 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 48 89 44 24 08 e8 94 ad 01
00 48
[ 1068.269769] RSP: 002b:00007ffe1b95a340 EFLAGS: 00000293 ORIG_RAX:
0000000000000001
[ 1068.277327] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f31ab8ed177
[ 1068.284451] RDX: 0000000000000004 RSI: 000055bf0a08e8f0 RDI: 0000000000000003
[ 1068.291575] RBP: 000055bf0a08e8f0 R08: 0000000000000000 R09: 00007ffe1b95a2a5
[ 1068.298700] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000004
[ 1068.305823] R13: 0000000000000004 R14: 00007f31abbb2760 R15: 0000000000000004
[ 1068.312951] Modules linked in: ip6table_mangle mpls_iptunnel
mpls_router sch_etf ip6table_filter xt_conntrack nf_conntrack
nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 iptable_filter
ip_tables netdevsim vrf 8021q bridge stp llc sch_fq sch_ingress veth
algif_hash x86_pkg_temp_thermal fuse [last unloaded:
test_blackhole_dev]
[ 1068.342031] CR2: ffff9c00302d7872
[ 1068.345342] ---[ end trace 47c4f9ef0796b42a ]---
[ 1068.349953] RIP: 0010:__kmalloc_track_caller+0x100/0x340

ref:
https://lkft.validation.linaro.org/scheduler/job/1851078#L11407


-- 
Linaro LKFT
https://lkft.linaro.org
