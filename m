Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFE367F39E
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjA1BOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233037AbjA1BOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:14:02 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6E48D425
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:13:51 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id l18-20020a6b7012000000b007169d5de8f9so130427ioc.9
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:13:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FKDs0CmGVz1zV9Csg+ORQChQ/H1apdgAoAiGqznBBxU=;
        b=hqldj+FfHIaN1Q2RU+HRZk+q2LN+INkKbCQiTmkRXNPMrqMGn7QgVmIamrQUrpm8U+
         PDPcwcoey+UniHvCOJqhD91DuGNPzF02Nd9aEkcgsgrsV1E82fG16gwtLomoBbIoBpMY
         WwaflBKrls6BQxa5u6eY/qdsAHNvqn6HX4/qj+TkACNvHDy4Iex/XHhpPmsCSTRr3nhL
         jeHo14UTT3GawyENp8FiWYpGOy2Zl6JeYMXCgqoPuyDZHkgneevjsVp0kpDE7of3Y9B0
         cUGPvoFLQ3l1hB0Pz/F9mgH7GgCawYwKHs9HOvvjvqM8PDw5DVw3m+E46rhRdO4gt6Kg
         8BoA==
X-Gm-Message-State: AFqh2krEcG/ReQbf9ke4zit6YL8RLeeoNo927O+URcsd6d7VuY60ibRt
        wO6VhO0XolimhAnv7NUIpNaRd37izKMhzI+cR/KDdSsTlNtj
X-Google-Smtp-Source: AMrXdXugFjcG4UZvQwwWFUpX+psNCaIYHlAjZQyCPWvzf1DWxAOPPX/IZIIF22x2ISTL4OjmJxLTLQhcDXDR1BhRX2W+Pk3QLtVQ
MIME-Version: 1.0
X-Received: by 2002:a02:2a4b:0:b0:38c:886a:219a with SMTP id
 w72-20020a022a4b000000b0038c886a219amr5778973jaw.133.1674868430690; Fri, 27
 Jan 2023 17:13:50 -0800 (PST)
Date:   Fri, 27 Jan 2023 17:13:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db685605f348b1f9@google.com>
Subject: [syzbot] possible deadlock in pppoe_device_event
From:   syzbot <syzbot+0ba232cc2253a6604b95@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mostrows@earthlink.net,
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

HEAD commit:    7bf70dbb1882 Merge tag 'vfio-v6.2-rc6' of https://github.c..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1599c5e5480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=23330449ad10b66f
dashboard link: https://syzkaller.appspot.com/bug?extid=0ba232cc2253a6604b95
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1fae9956ebf4/disk-7bf70dbb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f5d23d32df00/vmlinux-7bf70dbb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8447d3427ad4/bzImage-7bf70dbb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0ba232cc2253a6604b95@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.2.0-rc5-syzkaller-00020-g7bf70dbb1882 #0 Not tainted
------------------------------------------------------
syz-executor.3/8543 is trying to acquire lock:
ffff88802d3f0130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1725 [inline]
ffff88802d3f0130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppoe_flush_dev drivers/net/ppp/pppoe.c:304 [inline]
ffff88802d3f0130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppoe_device_event+0x329/0x980 drivers/net/ppp/pppoe.c:346

but task is already holding lock:
ffffffff8e0b13d0 (dev_addr_sem){++++}-{3:3}, at: dev_set_mac_address_user+0x23/0x50 net/core/dev.c:8804

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (dev_addr_sem){++++}-{3:3}:
       down_write+0x94/0x220 kernel/locking/rwsem.c:1562
       dev_set_mac_address_user+0x23/0x50 net/core/dev.c:8804
       do_setlink+0x18c4/0x3bb0 net/core/rtnetlink.c:2775
       __rtnl_newlink+0xd69/0x1840 net/core/rtnetlink.c:3590
       rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
       rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
       netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
       netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
       netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
       netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xd3/0x120 net/socket.c:734
       __sys_sendto+0x23a/0x340 net/socket.c:2117
       __do_sys_sendto net/socket.c:2129 [inline]
       __se_sys_sendto net/socket.c:2125 [inline]
       __x64_sys_sendto+0xe1/0x1b0 net/socket.c:2125
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #2 (rtnl_mutex){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
       prb_calc_retire_blk_tmo+0x7d/0x1e0 net/packet/af_packet.c:576
       init_prb_bdqc net/packet/af_packet.c:634 [inline]
       packet_set_ring+0x158f/0x1980 net/packet/af_packet.c:4439
       packet_setsockopt+0x1a32/0x3a30 net/packet/af_packet.c:3808
       __sys_setsockopt+0x2c6/0x5b0 net/socket.c:2246
       __do_sys_setsockopt net/socket.c:2257 [inline]
       __se_sys_setsockopt net/socket.c:2254 [inline]
       __x64_sys_setsockopt+0xbe/0x160 net/socket.c:2254
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #1 (sk_lock-AF_PACKET){+.+.}-{0:0}:
       lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
       lock_sock include/net/sock.h:1725 [inline]
       l2tp_tunnel_register+0x2aa/0x11e0 net/l2tp/l2tp_core.c:1483
       pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
       __sys_connect_file+0x153/0x1a0 net/socket.c:1976
       __sys_connect+0x165/0x1a0 net/socket.c:1993
       __do_sys_connect net/socket.c:2003 [inline]
       __se_sys_connect net/socket.c:2000 [inline]
       __x64_sys_connect+0x73/0xb0 net/socket.c:2000
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (sk_lock-AF_PPPOX){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
       lock_acquire kernel/locking/lockdep.c:5668 [inline]
       lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
       lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
       lock_sock include/net/sock.h:1725 [inline]
       pppoe_flush_dev drivers/net/ppp/pppoe.c:304 [inline]
       pppoe_device_event+0x329/0x980 drivers/net/ppp/pppoe.c:346
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
       call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
       call_netdevice_notifiers net/core/dev.c:1996 [inline]
       dev_set_mac_address+0x2d7/0x3e0 net/core/dev.c:8791
       bond_set_mac_address+0x359/0x7a0 drivers/net/bonding/bond_main.c:4743
       dev_set_mac_address+0x26b/0x3e0 net/core/dev.c:8787
       dev_set_mac_address_user+0x31/0x50 net/core/dev.c:8805
       do_setlink+0x18c4/0x3bb0 net/core/rtnetlink.c:2775
       __rtnl_newlink+0xd69/0x1840 net/core/rtnetlink.c:3590
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

other info that might help us debug this:

Chain exists of:
  sk_lock-AF_PPPOX --> rtnl_mutex --> dev_addr_sem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(dev_addr_sem);
                               lock(rtnl_mutex);
                               lock(dev_addr_sem);
  lock(sk_lock-AF_PPPOX);

 *** DEADLOCK ***

2 locks held by syz-executor.3/8543:
 #0: ffffffff8e0be1a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:75 [inline]
 #0: ffffffff8e0be1a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3e9/0xca0 net/core/rtnetlink.c:6138
 #1: ffffffff8e0b13d0 (dev_addr_sem){++++}-{3:3}, at: dev_set_mac_address_user+0x23/0x50 net/core/dev.c:8804

stack backtrace:
CPU: 0 PID: 8543 Comm: syz-executor.3 Not tainted 6.2.0-rc5-syzkaller-00020-g7bf70dbb1882 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2177
 check_prev_add kernel/locking/lockdep.c:3097 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 lock_sock_nested+0x3a/0xf0 net/core/sock.c:3470
 lock_sock include/net/sock.h:1725 [inline]
 pppoe_flush_dev drivers/net/ppp/pppoe.c:304 [inline]
 pppoe_device_event+0x329/0x980 drivers/net/ppp/pppoe.c:346
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 dev_set_mac_address+0x2d7/0x3e0 net/core/dev.c:8791
 bond_set_mac_address+0x359/0x7a0 drivers/net/bonding/bond_main.c:4743
 dev_set_mac_address+0x26b/0x3e0 net/core/dev.c:8787
 dev_set_mac_address_user+0x31/0x50 net/core/dev.c:8805
 do_setlink+0x18c4/0x3bb0 net/core/rtnetlink.c:2775
 __rtnl_newlink+0xd69/0x1840 net/core/rtnetlink.c:3590
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
RIP: 0033:0x7f777ee8c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f777fbfd168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f777efabf80 RCX: 00007f777ee8c0c9
RDX: 0000000000000000 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 00007f777eee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f777f0cfb1f R14: 00007f777fbfd300 R15: 0000000000022000
 </TASK>
device bond0 entered promiscuous mode
device bond_slave_0 entered promiscuous mode
device bond_slave_1 entered promiscuous mode


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
