Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E011C658E9D
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 16:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiL2Pwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 10:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbiL2Pv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 10:51:58 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2A5140EA
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 07:51:39 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id l13-20020a056e021c0d00b003034e24b866so12216558ilh.22
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 07:51:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zSDbzxWAzJuRcWytmEq8mtAWp2Ew3sUJubFv6e3Eplk=;
        b=QYwUp/73+TwOWJtwRuF+BfhaYm9lowQe78bG4eeh5W/mkbbEhNY21djYs6MvYmUPfA
         A8KjuT4q2wuRSPkzCGgE9B1ntGT16mExwCo/LZhSAetvr5xadns/n2ZyiM2eXik8tu03
         rZ5Kgj9n+xhKB1GbFNiRsrdD3zd34OSgYCaWY7qRNHSU+SEj1mEbHJvX3HEQuzQIYDV5
         hah6npowBF4e2cs2CjomSRzTi5r8/7sawCvWXD/xPtAlv6o3O4N3Bw2ohf2zmT+Zr+5H
         1jRiT/jSlPPvlUNIk5S+IaG4YcC3jbRduDOyCLMvIyoaamFBYWqGTlwN0CsAaFmwHonA
         ywnA==
X-Gm-Message-State: AFqh2kraBr1bHWmz5PmFKiFzFeo/gytFxvN0h7bsRtA3BEsCbv9Wy5Gb
        w3olZEV5EQb8+CavplnSUcdekOdZ9PsPaP1w49Wa7jztfIuV
X-Google-Smtp-Source: AMrXdXtJJQq4j3qyywaHZ2fnHBIb+Z0/lWXX+jBJhdb4j4F5bo/mEPjjvoDtdSjHzklg5hEXFVGIUuJdjKOqwthWHwb+Uc/Uvltd
MIME-Version: 1.0
X-Received: by 2002:a02:ac02:0:b0:39d:7353:149b with SMTP id
 a2-20020a02ac02000000b0039d7353149bmr2209764jao.7.1672329099076; Thu, 29 Dec
 2022 07:51:39 -0800 (PST)
Date:   Thu, 29 Dec 2022 07:51:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5ee7305f0f975e8@google.com>
Subject: [syzbot] WARNING in print_bfs_bug (2)
From:   syzbot <syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    72a85e2b0a1e Merge tag 'spi-fix-v6.2-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10127b44480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e81c4eb13a67cd
dashboard link: https://syzkaller.appspot.com/bug?extid=630f83b42d801d922b8b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bf5b7ea54f05/disk-72a85e2b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd3c30b473ee/vmlinux-72a85e2b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/df9aad922f68/bzImage-72a85e2b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+630f83b42d801d922b8b@syzkaller.appspotmail.com

device team1929 entered promiscuous mode
8021q: adding VLAN 0 to HW filter on device team1929
------------[ cut here ]------------
lockdep bfs error:-1
WARNING: CPU: 0 PID: 17604 at kernel/locking/lockdep.c:2066 print_bfs_bug+0x22/0x30 kernel/locking/lockdep.c:2066
Modules linked in:
CPU: 0 PID: 17604 Comm: syz-executor.2 Not tainted 6.1.0-syzkaller-14594-g72a85e2b0a1e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:print_bfs_bug+0x22/0x30 kernel/locking/lockdep.c:2066
Code: 84 00 00 00 00 00 66 90 55 89 fd 53 e8 17 67 a5 02 89 c3 e8 60 fd ff ff 85 db 74 10 89 ee 48 c7 c7 20 42 4c 8a e8 c3 48 5c 08 <0f> 0b 5b 5d c3 66 0f 1f 84 00 00 00 00 00 41 57 be fd ff 0f 00 41
RSP: 0018:ffffc90016386800 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8165927c RDI: fffff52002c70cf2
RBP: 00000000ffffffff R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000002 R11: 207065646b636f6c R12: ffff8881bee94d08
R13: ffff8881bee94d30 R14: ffff8881bee94280 R15: ffffc90016386910
FS:  00007f3023c34700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f589d7a6cc4 CR3: 00000001b2879000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 check_irq_usage+0x69a/0xab0 kernel/locking/lockdep.c:2791
 check_prev_add kernel/locking/lockdep.c:3101 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x2a5b/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 do_write_seqcount_begin_nested include/linux/seqlock.h:516 [inline]
 do_write_seqcount_begin include/linux/seqlock.h:541 [inline]
 psi_group_change+0x138/0xc10 kernel/sched/psi.c:775
 psi_task_switch+0x582/0x930 kernel/sched/psi.c:926
 psi_sched_switch kernel/sched/stats.h:185 [inline]
 __schedule+0x379b/0x5450 kernel/sched/core.c:6550
 preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:6724
 preempt_schedule_thunk+0x1a/0x20 arch/x86/entry/thunk_64.S:34
 __mutex_lock_common kernel/locking/mutex.c:728 [inline]
 __mutex_lock+0xfff/0x1360 kernel/locking/mutex.c:747
 team_vlan_rx_add_vid+0x3c/0x1e0 drivers/net/team/team.c:1906
 vlan_add_rx_filter_info+0x149/0x1d0 net/8021q/vlan_core.c:211
 __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
 vlan_vid_add+0x3f6/0x7f0 net/8021q/vlan_core.c:336
 vlan_device_event.cold+0x28/0x2d net/8021q/vlan.c:385
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 __dev_notify_flags+0x120/0x2d0 net/core/dev.c:8569
 rtnl_configure_link+0x181/0x260 net/core/rtnetlink.c:3241
 rtnl_newlink_create net/core/rtnetlink.c:3415 [inline]
 __rtnl_newlink+0x10f6/0x1840 net/core/rtnetlink.c:3624
 rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
 rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f3022e8c0a9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3023c34168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f3022fabf80 RCX: 00007f3022e8c0a9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000007
RBP: 00007f3022ee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffeb966cb2f R14: 00007f3023c34300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
