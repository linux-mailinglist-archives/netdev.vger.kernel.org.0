Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A5468056F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 06:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbjA3FLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 00:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjA3FLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 00:11:42 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2522384D
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 21:11:40 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id y22-20020a5d94d6000000b007076e06ba3dso6139460ior.20
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 21:11:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QHbnXHc39TxrcWLc6tS8BkNwGdSDnL/ioDZmOaIm8yc=;
        b=rQ9F3b+XwB4CUkJHKLiISsf9G2H2+T7Nw+ERBkhGolgvKnM0yGCa8e9vykHRK7TvfL
         bRPMsiaIp371n7cMODKCPeevfz/ChCeywHA0cZ6gGapvRpQ31TavaMWAKNkgz36anUJQ
         N/Y+UKboK+AhFHGn3J2HwOnxE6pDuUeEUNjz/ixECAmqhmCf+iplSHFK9MJohIKwo+kd
         XAqDIosMyYEZbGq2olbah1Xw9lx8+eP87oPqo/+PNvvjIR+1m4lKOOve0fl1NR1mZTvx
         5GVTFU8bVPji84K53GTMjUNuznFa2b0CYEFzM5SGfDCNRsp2MKJKaW0Y+q4vQX85ICfI
         oFeA==
X-Gm-Message-State: AO0yUKV9uPau0CkV40BESwKzy4H178/hjckaUxdzVREu3o/Lio5RPSWS
        WDtwdRnSyouUHziur8xTSk91LWZq+JhIwktxIOGwZkihPLrN
X-Google-Smtp-Source: AK7set8kKh9c2+Ezf3VDubhZHTx0AfLgtR3fMFAkAX4wUIW0o/ahFo3aOilDeSnbmqwYfSIIFImC1PLtWDlYFAI4aBBnS+KT2D7H
MIME-Version: 1.0
X-Received: by 2002:a92:8e4e:0:b0:310:fb90:b61a with SMTP id
 k14-20020a928e4e000000b00310fb90b61amr146213ilh.15.1675055499581; Sun, 29 Jan
 2023 21:11:39 -0800 (PST)
Date:   Sun, 29 Jan 2023 21:11:39 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000008229305f374404a@google.com>
Subject: [syzbot] possible deadlock in team_del_slave (2)
From:   syzbot <syzbot+1c71587a1a09de7fbde3@syzkaller.appspotmail.com>
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

HEAD commit:    83abd4d4c4be Merge tag 'platform-drivers-x86-v6.2-3' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1169c315480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1adb0905dddc79ba
dashboard link: https://syzkaller.appspot.com/bug?extid=1c71587a1a09de7fbde3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/27a2378a1d32/disk-83abd4d4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/311b7677d1f2/vmlinux-83abd4d4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eac6c271be29/bzImage-83abd4d4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1c71587a1a09de7fbde3@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.2.0-rc5-syzkaller-00108-g83abd4d4c4be #0 Not tainted
------------------------------------------------------
syz-executor.5/19937 is trying to acquire lock:
ffff88801ed2ecf8 (team->team_lock_key#2){+.+.}-{3:3}, at: team_del_slave+0x31/0x1c0 drivers/net/team/team.c:1998

but task is already holding lock:
ffff888036730728 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_del_interface+0xfb/0x190 net/wireless/nl80211.c:4328

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&rdev->wiphy.mtx){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
       wiphy_lock include/net/cfg80211.h:5633 [inline]
       ieee80211_open net/mac80211/iface.c:437 [inline]
       ieee80211_open+0x193/0x250 net/mac80211/iface.c:424
       __dev_open+0x297/0x4d0 net/core/dev.c:1417
       dev_open net/core/dev.c:1453 [inline]
       dev_open+0xec/0x150 net/core/dev.c:1446
       team_port_add drivers/net/team/team.c:1215 [inline]
       team_add_slave+0xa03/0x1c70 drivers/net/team/team.c:1984
       do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2617
       do_setlink+0x89b/0x3bb0 net/core/rtnetlink.c:2820
       __rtnl_newlink+0xd69/0x1840 net/core/rtnetlink.c:3590
       rtnl_newlink+0x68/0xa0 net/core/rtnetlink.c:3637
       rtnetlink_rcv_msg+0x43e/0xca0 net/core/rtnetlink.c:6141
       netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
       netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
       netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
       netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xd3/0x120 net/socket.c:734
       ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
       ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
       __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (team->team_lock_key#2){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3097 [inline]
       check_prevs_add kernel/locking/lockdep.c:3216 [inline]
       validate_chain kernel/locking/lockdep.c:3831 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5055
       lock_acquire kernel/locking/lockdep.c:5668 [inline]
       lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
       team_del_slave+0x31/0x1c0 drivers/net/team/team.c:1998
       team_device_event+0xd7/0xad0 drivers/net/team/team.c:3022
       notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
       call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
       call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
       call_netdevice_notifiers net/core/dev.c:1996 [inline]
       unregister_netdevice_many_notify+0xa2b/0x19e0 net/core/dev.c:10839
       unregister_netdevice_many net/core/dev.c:10895 [inline]
       unregister_netdevice_queue+0x2e5/0x3c0 net/core/dev.c:10776
       unregister_netdevice include/linux/netdevice.h:3059 [inline]
       _cfg80211_unregister_wdev+0x64a/0x830 net/wireless/core.c:1157
       ieee80211_if_remove+0x1e3/0x390 net/mac80211/iface.c:2228
       ieee80211_del_iface+0x16/0x20 net/mac80211/cfg.c:202
       rdev_del_virtual_intf net/wireless/rdev-ops.h:62 [inline]
       cfg80211_remove_virtual_intf+0x10a/0x3b0 net/wireless/util.c:2497
       nl80211_del_interface+0x106/0x190 net/wireless/nl80211.c:4330
       genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
       genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
       genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
       netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
       netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
       netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
       netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
       sock_sendmsg_nosec net/socket.c:714 [inline]
       sock_sendmsg+0xd3/0x120 net/socket.c:734
       ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
       ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
       __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rdev->wiphy.mtx);
                               lock(team->team_lock_key#2);
                               lock(&rdev->wiphy.mtx);
  lock(team->team_lock_key#2);

 *** DEADLOCK ***

3 locks held by syz-executor.5/19937:
 #0: ffffffff8e14f8d0 (cb_lock){++++}-{3:3}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1075
 #1: ffffffff8e0b4328 (rtnl_mutex){+.+.}-{3:3}, at: nl80211_pre_doit+0xb4/0xab0 net/wireless/nl80211.c:16161
 #2: ffff888036730728 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: nl80211_del_interface+0xfb/0x190 net/wireless/nl80211.c:4328

stack backtrace:
CPU: 0 PID: 19937 Comm: syz-executor.5 Not tainted 6.2.0-rc5-syzkaller-00108-g83abd4d4c4be #0
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
 __mutex_lock_common kernel/locking/mutex.c:603 [inline]
 __mutex_lock+0x12f/0x1360 kernel/locking/mutex.c:747
 team_del_slave+0x31/0x1c0 drivers/net/team/team.c:1998
 team_device_event+0xd7/0xad0 drivers/net/team/team.c:3022
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1944
 call_netdevice_notifiers_extack net/core/dev.c:1982 [inline]
 call_netdevice_notifiers net/core/dev.c:1996 [inline]
 unregister_netdevice_many_notify+0xa2b/0x19e0 net/core/dev.c:10839
 unregister_netdevice_many net/core/dev.c:10895 [inline]
 unregister_netdevice_queue+0x2e5/0x3c0 net/core/dev.c:10776
 unregister_netdevice include/linux/netdevice.h:3059 [inline]
 _cfg80211_unregister_wdev+0x64a/0x830 net/wireless/core.c:1157
 ieee80211_if_remove+0x1e3/0x390 net/mac80211/iface.c:2228
 ieee80211_del_iface+0x16/0x20 net/mac80211/cfg.c:202
 rdev_del_virtual_intf net/wireless/rdev-ops.h:62 [inline]
 cfg80211_remove_virtual_intf+0x10a/0x3b0 net/wireless/util.c:2497
 nl80211_del_interface+0x106/0x190 net/wireless/nl80211.c:4330
 genl_family_rcv_msg_doit.isra.0+0x1e6/0x2d0 net/netlink/genetlink.c:968
 genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
 genl_rcv_msg+0x4ff/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1942
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2476
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2530
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2559
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbab9c8c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbaba92a168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbab9dabf80 RCX: 00007fbab9c8c0c9
RDX: 0000000000000000 RSI: 0000000020001000 RDI: 0000000000000004
RBP: 00007fbab9ce7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffff9cf40df R14: 00007fbaba92a300 R15: 0000000000022000
 </TASK>
team0: Port device wlan0 removed


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
