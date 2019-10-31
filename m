Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE9FEB876
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729757AbfJaUjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:39:10 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:44791 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728095AbfJaUjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:39:10 -0400
Received: by mail-il1-f199.google.com with SMTP id 13so6340811iln.11
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 13:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=BfvGwbaIFFN0El2d0LgRz+jgyXk+CNV/Nzo+FOawyc0=;
        b=RLUbaCvEsbKKcvZUVVtyeRwXfEb58MweYQ61UOgxdqu/auK0jadUQn96lTUB/b42Tx
         TUcidpcsbhg0uRP7PAMt4GlQlHeRqzXYFKccolVrR50dMD9tzODmALV6+eMaSvfG8cPu
         5jOA3/NmJ6WNa7OBZQ4VBAhC+AcGspt1xTQqBADSCUvRQKCvv19WZMDnT+T8rwibjq5f
         Pa7DTFloYabyMfmrxbsoSRWjIX30ZhWrWVrfVGRlZ4VJ7aZLwrXqihStF+WXKfc07jGP
         T08b9Q1HCOLyd9d0o6UQTpH4DJ73iGQS5mTaok60rLfTtlyc1/2/YmZ10WqX8fmcilzS
         6Yxg==
X-Gm-Message-State: APjAAAVYvmiRa/LffJb9KE9vmhLTzbGozyZ0X1njCcWOy0LztIjm0ouE
        knCrNACOSK9cZJznqmn/1ZvGS5rNs3PDOtIsNs24WWd74mP+
X-Google-Smtp-Source: APXvYqx1ZmxVlWFAkRa+zO6CcVQUSZCrWb+H/yGltFq8jZNpW/0YRPG06BT7UuDimWtyRVxkqe1MzIJYircp/aN3keSHOxslfOa8
MIME-Version: 1.0
X-Received: by 2002:a5e:a819:: with SMTP id c25mr2729233ioa.117.1572554348592;
 Thu, 31 Oct 2019 13:39:08 -0700 (PDT)
Date:   Thu, 31 Oct 2019 13:39:08 -0700
In-Reply-To: <000000000000d73b12059608812b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000568a9105963ad7ac@google.com>
Subject: Re: WARNING in print_bfs_bug
From:   syzbot <syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@gmail.com, f.fainelli@gmail.com,
        hawk@kernel.org, idosch@mellanox.com, jakub.kicinski@netronome.com,
        jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, petrm@mellanox.com,
        roopa@cumulusnetworks.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    49afce6d Add linux-next specific files for 20191031
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11eea36ce00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c5f119b33031056
dashboard link: https://syzkaller.appspot.com/bug?extid=62ebe501c1ce9a91f68c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c162f4e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131b5eb8e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+62ebe501c1ce9a91f68c@syzkaller.appspotmail.com

------------[ cut here ]------------
lockdep bfs error:-1
WARNING: CPU: 0 PID: 12077 at kernel/locking/lockdep.c:1696  
print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 12077 Comm: syz-executor941 Not tainted 5.4.0-rc5-next-20191031  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
Code: 07 00 74 2d 48 c7 c7 00 5f ac 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b  
41 5c 5d c3 44 89 e6 48 c7 c7 60 1e ac 87 e8 fc ba eb ff <0f> 0b 5b 41 5c  
5d c3 0f 0b 48 c7 c7 58 23 f3 88 e8 1f 95 56 00 eb
RSP: 0018:ffff88813c747288 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815d0816 RDI: ffffed10278e8e43
RBP: ffff88813c747298 R08: ffff8880935244c0 R09: fffffbfff11f41ed
R10: fffffbfff11f41ec R11: ffffffff88fa0f63 R12: 00000000ffffffff
R13: ffff888093524d88 R14: ffff88813c747310 R15: 00000000000000de
  check_path+0x36/0x40 kernel/locking/lockdep.c:1772
  check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
  check_prev_add kernel/locking/lockdep.c:2476 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  igmp6_group_dropped+0x15b/0x8c0 net/ipv6/mcast.c:704
  ipv6_mc_down+0x64/0xf0 net/ipv6/mcast.c:2541
  ipv6_mc_destroy_dev+0x21/0x180 net/ipv6/mcast.c:2603
  addrconf_ifdown+0xca2/0x1220 net/ipv6/addrconf.c:3842
  addrconf_notify+0x5db/0x23b0 net/ipv6/addrconf.c:3633
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
  call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
  call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
  call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
  call_netdevice_notifiers net/core/dev.c:1919 [inline]
  rollback_registered_many+0x850/0x10d0 net/core/dev.c:8743
  rollback_registered+0x109/0x1d0 net/core/dev.c:8788
  register_netdevice+0xbac/0x1020 net/core/dev.c:9347
  register_netdev+0x30/0x50 net/core/dev.c:9437
  ip6gre_init_net+0x3ac/0x5f0 net/ipv6/ip6_gre.c:1582
  ops_init+0xb3/0x420 net/core/net_namespace.c:137
  setup_net+0x2d5/0x8b0 net/core/net_namespace.c:335
  copy_net_ns+0x29e/0x520 net/core/net_namespace.c:476
  create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
  unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
  ksys_unshare+0x444/0x980 kernel/fork.c:2889
  __do_sys_unshare kernel/fork.c:2957 [inline]
  __se_sys_unshare kernel/fork.c:2955 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:2955
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4439c9
Code: Bad RIP value.
RSP: 002b:00007ffc2b2cd878 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004439c9
RDX: 00000000004439c9 RSI: 0000000000000000 RDI: 000000006c060000
RBP: 0000000000000000 R08: 00000000004aaeff R09: 00000000004aaeff
R10: 00000000004aaeff R11: 0000000000000246 R12: 0000000000000b5b
R13: 00000000004047d0 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
WARNING: CPU: 0 PID: 12077 at kernel/locking/mutex.c:1419  
mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427
Modules linked in:
CPU: 0 PID: 12077 Comm: syz-executor941 Not tainted 5.4.0-rc5-next-20191031  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1419
Code: c9 41 b8 01 00 00 00 31 c9 ba 01 00 00 00 31 f6 e8 3c b8 03 fa 58 48  
8d 65 d8 b8 01 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 0c fe  
ff ff 48 c7 c7 a0 a1 b0 8a 48 89 4d d0 e8 f0 78 59
RSP: 0018:ffff88813c746e48 EFLAGS: 00010006
RAX: 0000000080000403 RBX: 1ffff110278e8dd1 RCX: 0000000000000004
RDX: 0000000000000000 RSI: ffffffff816a6cf5 RDI: ffffffff88fc9fa0
RBP: ffff88813c746e78 R08: 0000000000000001 R09: fffffbfff11f4751
R10: fffffbfff11f4750 R11: ffffffff88fa3a83 R12: ffffffff8ab0a1a0
R13: 0000000000000000 R14: ffffffff8158bb00 R15: ffffffff88fc9fa0
FS:  00000000013d6940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000044399f CR3: 000000013c5bf000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __crash_kexec+0x91/0x200 kernel/kexec_core.c:948
  panic+0x308/0x75c kernel/panic.c:241
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
Code: 07 00 74 2d 48 c7 c7 00 5f ac 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b  
41 5c 5d c3 44 89 e6 48 c7 c7 60 1e ac 87 e8 fc ba eb ff <0f> 0b 5b 41 5c  
5d c3 0f 0b 48 c7 c7 58 23 f3 88 e8 1f 95 56 00 eb
RSP: 0018:ffff88813c747288 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815d0816 RDI: ffffed10278e8e43
RBP: ffff88813c747298 R08: ffff8880935244c0 R09: fffffbfff11f41ed
R10: fffffbfff11f41ec R11: ffffffff88fa0f63 R12: 00000000ffffffff
R13: ffff888093524d88 R14: ffff88813c747310 R15: 00000000000000de
  check_path+0x36/0x40 kernel/locking/lockdep.c:1772
  check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
  check_prev_add kernel/locking/lockdep.c:2476 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  igmp6_group_dropped+0x15b/0x8c0 net/ipv6/mcast.c:704
  ipv6_mc_down+0x64/0xf0 net/ipv6/mcast.c:2541
  ipv6_mc_destroy_dev+0x21/0x180 net/ipv6/mcast.c:2603
  addrconf_ifdown+0xca2/0x1220 net/ipv6/addrconf.c:3842
  addrconf_notify+0x5db/0x23b0 net/ipv6/addrconf.c:3633
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
  call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
  call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
  call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
  call_netdevice_notifiers net/core/dev.c:1919 [inline]
  rollback_registered_many+0x850/0x10d0 net/core/dev.c:8743
  rollback_registered+0x109/0x1d0 net/core/dev.c:8788
  register_netdevice+0xbac/0x1020 net/core/dev.c:9347
  register_netdev+0x30/0x50 net/core/dev.c:9437
  ip6gre_init_net+0x3ac/0x5f0 net/ipv6/ip6_gre.c:1582
  ops_init+0xb3/0x420 net/core/net_namespace.c:137
  setup_net+0x2d5/0x8b0 net/core/net_namespace.c:335
  copy_net_ns+0x29e/0x520 net/core/net_namespace.c:476
  create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
  unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
  ksys_unshare+0x444/0x980 kernel/fork.c:2889
  __do_sys_unshare kernel/fork.c:2957 [inline]
  __se_sys_unshare kernel/fork.c:2955 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:2955
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4439c9
Code: Bad RIP value.
RSP: 002b:00007ffc2b2cd878 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004439c9
RDX: 00000000004439c9 RSI: 0000000000000000 RDI: 000000006c060000
RBP: 0000000000000000 R08: 00000000004aaeff R09: 00000000004aaeff
R10: 00000000004aaeff R11: 0000000000000246 R12: 0000000000000b5b
R13: 00000000004047d0 R14: 0000000000000000 R15: 0000000000000000
irq event stamp: 149354
hardirqs last  enabled at (149353): [<ffffffff8146110a>]  
__local_bh_enable_ip+0x15a/0x270 kernel/softirq.c:194
hardirqs last disabled at (149351): [<ffffffff814610ca>]  
__local_bh_enable_ip+0x11a/0x270 kernel/softirq.c:171
softirqs last  enabled at (149352): [<ffffffff864ee3d4>]  
ipv6_ac_destroy_dev+0x144/0x1b0 net/ipv6/anycast.c:402
softirqs last disabled at (149354): [<ffffffff865cbc13>]  
ipv6_mc_down+0x23/0xf0 net/ipv6/mcast.c:2538
---[ end trace c8d5cabde4ea777a ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 12077 at kernel/locking/mutex.c:737  
mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:744
Modules linked in:
CPU: 0 PID: 12077 Comm: syz-executor941 Tainted: G        W          
5.4.0-rc5-next-20191031 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:737
Code: 4c 89 ff e8 45 84 59 fa e9 8c fb ff ff 55 65 8b 05 80 31 ac 78 a9 00  
ff 1f 00 48 89 e5 75 0b 48 8b 75 08 e8 45 f9 ff ff 5d c3 <0f> 0b 48 8b 75  
08 e8 38 f9 ff ff 5d c3 66 0f 1f 44 00 00 48 b8 00
RSP: 0018:ffff88813c746e78 EFLAGS: 00010006
RAX: 0000000080000403 RBX: 1ffff110278e8dd1 RCX: ffffffff816a6d0d
RDX: 0000000000000000 RSI: ffffffff816a6d6f RDI: ffffffff88fc9fa0
RBP: ffff88813c746e78 R08: ffff8880935244c0 R09: 0000000000000000
R10: fffffbfff11f93f4 R11: ffffffff88fc9fa7 R12: 0000000000000001
R13: 0000000000000000 R14: ffffffff8158bb00 R15: 00000000000006a0
FS:  00000000013d6940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000044399f CR3: 000000013c5bf000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __crash_kexec+0x10b/0x200 kernel/kexec_core.c:957
  panic+0x308/0x75c kernel/panic.c:241
  __warn.cold+0x2f/0x35 kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:print_bfs_bug+0x5c/0x80 kernel/locking/lockdep.c:1696
Code: 07 00 74 2d 48 c7 c7 00 5f ac 8a c6 07 00 0f 1f 40 00 85 db 75 05 5b  
41 5c 5d c3 44 89 e6 48 c7 c7 60 1e ac 87 e8 fc ba eb ff <0f> 0b 5b 41 5c  
5d c3 0f 0b 48 c7 c7 58 23 f3 88 e8 1f 95 56 00 eb
RSP: 0018:ffff88813c747288 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815d0816 RDI: ffffed10278e8e43
RBP: ffff88813c747298 R08: ffff8880935244c0 R09: fffffbfff11f41ed
R10: fffffbfff11f41ec R11: ffffffff88fa0f63 R12: 00000000ffffffff
R13: ffff888093524d88 R14: ffff88813c747310 R15: 00000000000000de
  check_path+0x36/0x40 kernel/locking/lockdep.c:1772
  check_noncircular+0x16d/0x3e0 kernel/locking/lockdep.c:1797
  check_prev_add kernel/locking/lockdep.c:2476 [inline]
  check_prevs_add kernel/locking/lockdep.c:2581 [inline]
  validate_chain kernel/locking/lockdep.c:2971 [inline]
  __lock_acquire+0x2596/0x4a00 kernel/locking/lockdep.c:3955
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4487
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  igmp6_group_dropped+0x15b/0x8c0 net/ipv6/mcast.c:704
  ipv6_mc_down+0x64/0xf0 net/ipv6/mcast.c:2541
  ipv6_mc_destroy_dev+0x21/0x180 net/ipv6/mcast.c:2603
  addrconf_ifdown+0xca2/0x1220 net/ipv6/addrconf.c:3842
  addrconf_notify+0x5db/0x23b0 net/ipv6/addrconf.c:3633
  notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
  __raw_notifier_call_chain kernel/notifier.c:361 [inline]
  raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
  call_netdevice_notifiers_info net/core/dev.c:1893 [inline]
  call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1878
  call_netdevice_notifiers_extack net/core/dev.c:1905 [inline]
  call_netdevice_notifiers net/core/dev.c:1919 [inline]
  rollback_registered_many+0x850/0x10d0 net/core/dev.c:8743
  rollback_registered+0x109/0x1d0 net/core/dev.c:8788
  register_netdevice+0xbac/0x1020 net/core/dev.c:9347
  register_netdev+0x30/0x50 net/core/dev.c:9437
  ip6gre_init_net+0x3ac/0x5f0 net/ipv6/ip6_gre.c:1582
  ops_init+0xb3/0x420 net/core/net_namespace.c:137
  setup_net+0x2d5/0x8b0 net/core/net_namespace.c:335
  copy_net_ns+0x29e/0x520 net/core/net_namespace.c:476
  create_new_namespaces+0x400/0x7b0 kernel/nsproxy.c:103
  unshare_nsproxy_namespaces+0xc2/0x200 kernel/nsproxy.c:202
  ksys_unshare+0x444/0x980 kernel/fork.c:2889
  __do_sys_unshare kernel/fork.c:2957 [inline]
  __se_sys_unshare kernel/fork.c:2955 [inline]
  __x64_sys_unshare+0x31/0x40 kernel/fork.c:2955
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4439c9
Code: Bad RIP value.
RSP: 002b:00007ffc2b2cd878 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004439c9
RDX: 00000000004439c9 RSI: 0000000000000000 RDI: 000000006c060000
RBP: 0000000000000000 R08: 00000000004aaeff R09: 00000000004aaeff
R10: 00000000004aaeff R11: 0000000000000246 R12: 0000000000000b5b
R13: 00000000004047d0 R14: 0000000000000000 R15: 0000000000000000
irq event stamp: 149354
hardirqs last  enabled at (149353): [<ffffffff8146110a>]  
__local_bh_enable_ip+0x15a/0x270 kernel/softirq.c:194
hardirqs last disabled at (149351): [<ffffffff814610ca>]  
__local_bh_enable_ip+0x11a/0x270 kernel/softirq.c:171
softirqs last  enabled at (149352): [<ffffffff864ee3d4>]  
ipv6_ac_destroy_dev+0x144/0x1b0 net/ipv6/anycast.c:402
softirqs last disabled at (149354): [<ffffffff865cbc13>]  
ipv6_mc_down+0x23/0xf0 net/ipv6/mcast.c:2538
---[ end trace c8d5cabde4ea777b ]---
Kernel Offset: disabled
Rebooting in 86400 seconds..

