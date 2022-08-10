Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EB758F068
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 18:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiHJQ2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 12:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbiHJQ2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 12:28:35 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA4B82757
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:28:33 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id o5-20020a056e02102500b002ddcc65029cso10830814ilj.8
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 09:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=cHi1+WEQljuM36ekuvI0X9IV++jgfJuO61bfzFoT5DA=;
        b=NWqvGrCRoXKWwDq7kjOqSeVxaQxskjaE8Y125tuIIwNueDJjtZ9bJ8RS9QPPom+Wb0
         sqCOsYYl3Masi0oErJi9HSeUjZ0z7dGpdZJ7YQjB3g7y0KrFiVf3smtufobfUM82o9AY
         r17C9jpn/KVlk7J2XT+Go+WvW0cr+mzZxoGWuKKK8Otm4Z9RtLm8dfckEZTJLFf6D9b4
         fUHtK0r39bv+hwLplMppgik391Xe+oBYZxT/de89N0D1BzpRfsYxtgeaQbpSiboMykgI
         zt3hoWpQLeaPT5hS/Th9WQeOib2K8oBtS3c08H728/n5INPw0xRkD0fORlvYlJZvqAzB
         6NBQ==
X-Gm-Message-State: ACgBeo2KCEbzZxn76REkro/4RWL3n2oexQ8/9hdnR2YULVj6/LQ5J4M8
        UrfWhrXaqrfI+o9XACQ7PBHiN7kalxWkUUEVbL6+jTPtoPbB
X-Google-Smtp-Source: AA6agR7OFUfKy2byAZlVa7eK9bU6cv1r76k73pgnJHk+wVc1veAbUYwKIj6wkdc5eoch2UgQa5uly3eI7CZjL1bdpNxqrTCHiOJT
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3a1a:b0:343:4ae3:9c0f with SMTP id
 cn26-20020a0566383a1a00b003434ae39c0fmr755814jab.271.1660148912487; Wed, 10
 Aug 2022 09:28:32 -0700 (PDT)
Date:   Wed, 10 Aug 2022 09:28:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000034029905e5e58ac0@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in add_v4_addrs
From:   syzbot <syzbot+27aad254a5e7479997ed@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0966d385830d riscv: Fix auipc+jalr relocation range checks
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.git fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=17b4436a080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6295d67591064921
dashboard link: https://syzkaller.appspot.com/bug?extid=27aad254a5e7479997ed
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+27aad254a5e7479997ed@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.17.0-rc1-syzkaller-00002-g0966d385830d #0 Not tainted
-----------------------------
net/ipv6/addrconf.c:3140 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.1/2048:
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2fe/0x9a0 net/core/rtnetlink.c:5589

stack backtrace:
CPU: 0 PID: 2048 Comm: syz-executor.1 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff831689d2>] lockdep_rcu_suspicious+0x106/0x118 kernel/locking/lockdep.c:6563
[<ffffffff82d414d0>] add_v4_addrs+0x566/0x640 net/ipv6/addrconf.c:3140
[<ffffffff82d4e322>] addrconf_gre_config net/ipv6/addrconf.c:3425 [inline]
[<ffffffff82d4e322>] addrconf_notify+0x784/0x1360 net/ipv6/addrconf.c:3605
[<ffffffff800aac84>] notifier_call_chain+0xb8/0x188 kernel/notifier.c:84
[<ffffffff800aad7e>] raw_notifier_call_chain+0x2a/0x38 kernel/notifier.c:392
[<ffffffff8271d086>] call_netdevice_notifiers_info+0x9e/0x10c net/core/dev.c:1919
[<ffffffff827422c8>] call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
[<ffffffff827422c8>] call_netdevice_notifiers net/core/dev.c:1945 [inline]
[<ffffffff827422c8>] __dev_notify_flags+0x108/0x1fa net/core/dev.c:8179
[<ffffffff827436f6>] dev_change_flags+0x9c/0xba net/core/dev.c:8215
[<ffffffff82767e16>] do_setlink+0x5d6/0x21c4 net/core/rtnetlink.c:2729
[<ffffffff8276a6a2>] __rtnl_newlink+0x99e/0xfa0 net/core/rtnetlink.c:3412
[<ffffffff8276ad04>] rtnl_newlink+0x60/0x8c net/core/rtnetlink.c:3527
[<ffffffff8276b46c>] rtnetlink_rcv_msg+0x338/0x9a0 net/core/rtnetlink.c:5592
[<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
[<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
[<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
[<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
[<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
[<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
[<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
[<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
[<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
[<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
[<ffffffff80005716>] ret_from_syscall+0x0/0x2

=============================
WARNING: suspicious RCU usage
5.17.0-rc1-syzkaller-00002-g0966d385830d #0 Not tainted
-----------------------------
include/linux/inetdevice.h:249 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.1/2048:
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2fe/0x9a0 net/core/rtnetlink.c:5589

stack backtrace:
CPU: 0 PID: 2048 Comm: syz-executor.1 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff831689d2>] lockdep_rcu_suspicious+0x106/0x118 kernel/locking/lockdep.c:6563
[<ffffffff82d412fe>] __in_dev_get_rtnl include/linux/inetdevice.h:249 [inline]
[<ffffffff82d412fe>] add_v4_addrs+0x394/0x640 net/ipv6/addrconf.c:3135
[<ffffffff82d4e322>] addrconf_gre_config net/ipv6/addrconf.c:3425 [inline]
[<ffffffff82d4e322>] addrconf_notify+0x784/0x1360 net/ipv6/addrconf.c:3605
[<ffffffff800aac84>] notifier_call_chain+0xb8/0x188 kernel/notifier.c:84
[<ffffffff800aad7e>] raw_notifier_call_chain+0x2a/0x38 kernel/notifier.c:392
[<ffffffff8271d086>] call_netdevice_notifiers_info+0x9e/0x10c net/core/dev.c:1919
[<ffffffff827422c8>] call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
[<ffffffff827422c8>] call_netdevice_notifiers net/core/dev.c:1945 [inline]
[<ffffffff827422c8>] __dev_notify_flags+0x108/0x1fa net/core/dev.c:8179
[<ffffffff827436f6>] dev_change_flags+0x9c/0xba net/core/dev.c:8215
[<ffffffff82767e16>] do_setlink+0x5d6/0x21c4 net/core/rtnetlink.c:2729
[<ffffffff8276a6a2>] __rtnl_newlink+0x99e/0xfa0 net/core/rtnetlink.c:3412
[<ffffffff8276ad04>] rtnl_newlink+0x60/0x8c net/core/rtnetlink.c:3527
[<ffffffff8276b46c>] rtnetlink_rcv_msg+0x338/0x9a0 net/core/rtnetlink.c:5592
[<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
[<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
[<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
[<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
[<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
[<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
[<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
[<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
[<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
[<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
[<ffffffff80005716>] ret_from_syscall+0x0/0x2

=============================
WARNING: suspicious RCU usage
5.17.0-rc1-syzkaller-00002-g0966d385830d #0 Not tainted
-----------------------------
net/ipv6/addrconf.c:3140 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.1/2048:
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2fe/0x9a0 net/core/rtnetlink.c:5589

stack backtrace:
CPU: 0 PID: 2048 Comm: syz-executor.1 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff831689d2>] lockdep_rcu_suspicious+0x106/0x118 kernel/locking/lockdep.c:6563
[<ffffffff82d4154c>] add_v4_addrs+0x5e2/0x640 net/ipv6/addrconf.c:3140
[<ffffffff82d4e322>] addrconf_gre_config net/ipv6/addrconf.c:3425 [inline]
[<ffffffff82d4e322>] addrconf_notify+0x784/0x1360 net/ipv6/addrconf.c:3605
[<ffffffff800aac84>] notifier_call_chain+0xb8/0x188 kernel/notifier.c:84
[<ffffffff800aad7e>] raw_notifier_call_chain+0x2a/0x38 kernel/notifier.c:392
[<ffffffff8271d086>] call_netdevice_notifiers_info+0x9e/0x10c net/core/dev.c:1919
[<ffffffff827422c8>] call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
[<ffffffff827422c8>] call_netdevice_notifiers net/core/dev.c:1945 [inline]
[<ffffffff827422c8>] __dev_notify_flags+0x108/0x1fa net/core/dev.c:8179
[<ffffffff827436f6>] dev_change_flags+0x9c/0xba net/core/dev.c:8215
[<ffffffff82767e16>] do_setlink+0x5d6/0x21c4 net/core/rtnetlink.c:2729
[<ffffffff8276a6a2>] __rtnl_newlink+0x99e/0xfa0 net/core/rtnetlink.c:3412
[<ffffffff8276ad04>] rtnl_newlink+0x60/0x8c net/core/rtnetlink.c:3527
[<ffffffff8276b46c>] rtnetlink_rcv_msg+0x338/0x9a0 net/core/rtnetlink.c:5592
[<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
[<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
[<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
[<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
[<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
[<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
[<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
[<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
[<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
[<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
[<ffffffff80005716>] ret_from_syscall+0x0/0x2

=============================
WARNING: suspicious RCU usage
5.17.0-rc1-syzkaller-00002-g0966d385830d #0 Not tainted
-----------------------------
include/net/addrconf.h:313 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.1/2048:
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2fe/0x9a0 net/core/rtnetlink.c:5589

stack backtrace:
CPU: 0 PID: 2048 Comm: syz-executor.1 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff831689d2>] lockdep_rcu_suspicious+0x106/0x118 kernel/locking/lockdep.c:6563
[<ffffffff82db8b04>] __in6_dev_get include/net/addrconf.h:313 [inline]
[<ffffffff82db8b04>] __in6_dev_get include/net/addrconf.h:311 [inline]
[<ffffffff82db8b04>] ipv6_mc_netdev_event+0x29c/0x4a8 net/ipv6/mcast.c:2842
[<ffffffff800aac84>] notifier_call_chain+0xb8/0x188 kernel/notifier.c:84
[<ffffffff800aad7e>] raw_notifier_call_chain+0x2a/0x38 kernel/notifier.c:392
[<ffffffff8271d086>] call_netdevice_notifiers_info+0x9e/0x10c net/core/dev.c:1919
[<ffffffff827422c8>] call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
[<ffffffff827422c8>] call_netdevice_notifiers net/core/dev.c:1945 [inline]
[<ffffffff827422c8>] __dev_notify_flags+0x108/0x1fa net/core/dev.c:8179
[<ffffffff827436f6>] dev_change_flags+0x9c/0xba net/core/dev.c:8215
[<ffffffff82767e16>] do_setlink+0x5d6/0x21c4 net/core/rtnetlink.c:2729
[<ffffffff8276a6a2>] __rtnl_newlink+0x99e/0xfa0 net/core/rtnetlink.c:3412
[<ffffffff8276ad04>] rtnl_newlink+0x60/0x8c net/core/rtnetlink.c:3527
[<ffffffff8276b46c>] rtnetlink_rcv_msg+0x338/0x9a0 net/core/rtnetlink.c:5592
[<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
[<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
[<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
[<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
[<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
[<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
[<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
[<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
[<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
[<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
[<ffffffff80005716>] ret_from_syscall+0x0/0x2

=============================
WARNING: suspicious RCU usage
5.17.0-rc1-syzkaller-00002-g0966d385830d #0 Not tainted
-----------------------------
net/8021q/vlan.c:392 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.1/2048:
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2fe/0x9a0 net/core/rtnetlink.c:5589

stack backtrace:
CPU: 0 PID: 2048 Comm: syz-executor.1 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff831689d2>] lockdep_rcu_suspicious+0x106/0x118 kernel/locking/lockdep.c:6563
[<ffffffff82f0e32e>] vlan_device_event+0x364/0x1434 net/8021q/vlan.c:392
[<ffffffff800aac84>] notifier_call_chain+0xb8/0x188 kernel/notifier.c:84
[<ffffffff800aad7e>] raw_notifier_call_chain+0x2a/0x38 kernel/notifier.c:392
[<ffffffff8271d086>] call_netdevice_notifiers_info+0x9e/0x10c net/core/dev.c:1919
[<ffffffff827422c8>] call_netdevice_notifiers_extack net/core/dev.c:1931 [inline]
[<ffffffff827422c8>] call_netdevice_notifiers net/core/dev.c:1945 [inline]
[<ffffffff827422c8>] __dev_notify_flags+0x108/0x1fa net/core/dev.c:8179
[<ffffffff827436f6>] dev_change_flags+0x9c/0xba net/core/dev.c:8215
[<ffffffff82767e16>] do_setlink+0x5d6/0x21c4 net/core/rtnetlink.c:2729
[<ffffffff8276a6a2>] __rtnl_newlink+0x99e/0xfa0 net/core/rtnetlink.c:3412
[<ffffffff8276ad04>] rtnl_newlink+0x60/0x8c net/core/rtnetlink.c:3527
[<ffffffff8276b46c>] rtnetlink_rcv_msg+0x338/0x9a0 net/core/rtnetlink.c:5592
[<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
[<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
[<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
[<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
[<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
[<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
[<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
[<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
[<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
[<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
[<ffffffff80005716>] ret_from_syscall+0x0/0x2

=====================================
WARNING: bad unlock balance detected!
5.17.0-rc1-syzkaller-00002-g0966d385830d #0 Not tainted
-------------------------------------
syz-executor.1/2048 is trying to release lock (rtnl_mutex) at:
[<ffffffff827745dc>] __rtnl_unlock+0x34/0x80 net/core/rtnetlink.c:98
but there are no more locks to release!

other info that might help us debug this:
1 lock held by syz-executor.1/2048:
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
 #0: 000000c00135d600 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x2fe/0x9a0 net/core/rtnetlink.c:5589

stack backtrace:
CPU: 0 PID: 2048 Comm: syz-executor.1 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff8316887a>] print_unlock_imbalance_bug.part.0+0xc4/0xd2 kernel/locking/lockdep.c:5080
[<ffffffff80115d78>] print_unlock_imbalance_bug kernel/locking/lockdep.c:5062 [inline]
[<ffffffff80115d78>] __lock_release kernel/locking/lockdep.c:5316 [inline]
[<ffffffff80115d78>] lock_release+0x4fe/0x614 kernel/locking/lockdep.c:5659
[<ffffffff831a7d4c>] __mutex_unlock_slowpath+0xa4/0x3a2 kernel/locking/mutex.c:893
[<ffffffff831a8058>] mutex_unlock+0xe/0x16 kernel/locking/mutex.c:540
[<ffffffff827745dc>] __rtnl_unlock+0x34/0x80 net/core/rtnetlink.c:98
[<ffffffff82746ef4>] netdev_run_todo+0x1ee/0x752 net/core/dev.c:9929
[<ffffffff8276b47a>] rtnl_unlock net/core/rtnetlink.c:112 [inline]
[<ffffffff8276b47a>] rtnetlink_rcv_msg+0x346/0x9a0 net/core/rtnetlink.c:5593
[<ffffffff8296ded2>] netlink_rcv_skb+0xf8/0x2be net/netlink/af_netlink.c:2494
[<ffffffff827624f4>] rtnetlink_rcv+0x26/0x30 net/core/rtnetlink.c:5610
[<ffffffff8296cbcc>] netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
[<ffffffff8296cbcc>] netlink_unicast+0x40e/0x5fe net/netlink/af_netlink.c:1343
[<ffffffff8296d29c>] netlink_sendmsg+0x4e0/0x994 net/netlink/af_netlink.c:1919
[<ffffffff826d264e>] sock_sendmsg_nosec net/socket.c:705 [inline]
[<ffffffff826d264e>] sock_sendmsg+0xa0/0xc4 net/socket.c:725
[<ffffffff826d7026>] __sys_sendto+0x1f2/0x2e0 net/socket.c:2040
[<ffffffff826d7152>] __do_sys_sendto net/socket.c:2052 [inline]
[<ffffffff826d7152>] sys_sendto+0x3e/0x52 net/socket.c:2048
[<ffffffff80005716>] ret_from_syscall+0x0/0x2
8021q: adding VLAN 0 to HW filter on device bond0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
