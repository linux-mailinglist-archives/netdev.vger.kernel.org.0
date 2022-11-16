Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEA962CD6C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 23:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbiKPWMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 17:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiKPWMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 17:12:48 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F71F6A764
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:12:47 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id f25-20020a5d8799000000b006a44e33ddb6so35189ion.1
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 14:12:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wwkn7rTXlAk99V4Ga9mjelyFQlUTwFAAzOyAoCfQ2Rw=;
        b=2mMW82Vwfi0r9l4GAgYulVxvuZLGaW1BBWCeycGqRO/7eDwuIAe2sjgxXv027EQz1J
         Mgws1z3zd46ZdYuZzQI9yGiBHb6y6SgvOsov8gYzVZ0x0TsJ8KIXDJ81XRYfNDk5wbvI
         XFObKb9j1Gy99FZ9cPX3iEqN2ShuRFgXw1p2vk1D6eKyW/vOncSmhPHN6dZHJ1Zum/iU
         tbDZDUOooFdP8owLSXaRhv1FmXDAA75AZ2yUbnuo/RBQvq/GYNtm2YTyB3iQGSGuWITC
         tT6NBDAR2P7AyXQ44D/rz484sxeLsRxWgJrJ2VVl1g8AkuHbGuJkoeB7+uAhjAonqkBA
         cbxg==
X-Gm-Message-State: ANoB5pkVhismzh1gSaKgo+Io3SUILJ+AYrotJ1hhq2NgZXfMuD/TpV2O
        eLYsz66fxLMVkaUeNWdBK+VX+J58xn0/8FEuj3Ij+gb8EHif
X-Google-Smtp-Source: AA0mqf4G7sIom4lHW741nUPeSJyHWsaJ6nR/WSmbUjLrYfInseYIPZNSJiZOpXEsIuEWGtv5+o+FD/LSr6dTsak6bI3HSUEqscw5
MIME-Version: 1.0
X-Received: by 2002:a05:6638:33a0:b0:373:83fe:19c0 with SMTP id
 h32-20020a05663833a000b0037383fe19c0mr11173076jav.156.1668636767019; Wed, 16
 Nov 2022 14:12:47 -0800 (PST)
Date:   Wed, 16 Nov 2022 14:12:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c1e64305ed9dc5e8@google.com>
Subject: [syzbot] BUG: MAX_LOCKDEP_ENTRIES too low! (3)
From:   syzbot <syzbot+b04c9ffbbd2f303d00d9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
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

HEAD commit:    094226ad94f4 Linux 6.1-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b21801880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e9039cbe1d7613aa
dashboard link: https://syzkaller.appspot.com/bug?extid=b04c9ffbbd2f303d00d9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/655851ef7ce3/disk-094226ad.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f1e7de729009/vmlinux-094226ad.xz
kernel image: https://storage.googleapis.com/syzbot-assets/849adc218fa0/bzImage-094226ad.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b04c9ffbbd2f303d00d9@syzkaller.appspotmail.com

BUG: MAX_LOCKDEP_ENTRIES too low!
turning off the locking correctness validator.
CPU: 1 PID: 26581 Comm: syz-executor.4 Not tainted 6.1.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 alloc_list_entry.cold+0x11/0x18 kernel/locking/lockdep.c:1402
 add_lock_to_list kernel/locking/lockdep.c:1423 [inline]
 check_prev_add kernel/locking/lockdep.c:3167 [inline]
 check_prevs_add kernel/locking/lockdep.c:3216 [inline]
 validate_chain kernel/locking/lockdep.c:3831 [inline]
 __lock_acquire+0x3626/0x56d0 kernel/locking/lockdep.c:5055
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1df/0x630 kernel/locking/lockdep.c:5633
 local_lock_acquire include/linux/local_lock_internal.h:29 [inline]
 ___slab_alloc+0xe1/0x1400 mm/slub.c:3099
 __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
 slab_alloc_node mm/slub.c:3364 [inline]
 __kmem_cache_alloc_node+0x191/0x3e0 mm/slub.c:3437
 kmalloc_trace+0x22/0x60 mm/slab_common.c:1045
 kmalloc include/linux/slab.h:553 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 ref_tracker_alloc+0x14c/0x550 lib/ref_tracker.c:85
 __netdev_tracker_alloc include/linux/netdevice.h:3995 [inline]
 netdev_hold include/linux/netdevice.h:4024 [inline]
 netdev_hold include/linux/netdevice.h:4019 [inline]
 qdisc_alloc+0x7b2/0xb00 net/sched/sch_generic.c:974
 qdisc_create_dflt+0x75/0x540 net/sched/sch_generic.c:996
 attach_one_default_qdisc net/sched/sch_generic.c:1151 [inline]
 netdev_for_each_tx_queue include/linux/netdevice.h:2440 [inline]
 attach_default_qdiscs net/sched/sch_generic.c:1169 [inline]
 dev_activate+0x760/0xcd0 net/sched/sch_generic.c:1228
 __dev_open+0x393/0x4d0 net/core/dev.c:1441
 dev_open net/core/dev.c:1468 [inline]
 dev_open+0xe8/0x150 net/core/dev.c:1461
 team_port_add drivers/net/team/team.c:1215 [inline]
 team_add_slave+0x9ff/0x1b80 drivers/net/team/team.c:1984
 do_set_master+0x1c8/0x220 net/core/rtnetlink.c:2578
 rtnl_newlink_create net/core/rtnetlink.c:3381 [inline]
 __rtnl_newlink+0x13ac/0x17e0 net/core/rtnetlink.c:3581
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3594
 rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6091
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2540
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe8c728b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe8c7f81168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe8c73ac120 RCX: 00007fe8c728b639
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000004
RBP: 00007fe8c72e6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe8c74cfb1f R14: 00007fe8c7f81300 R15: 0000000000022000
 </TASK>
8021q: adding VLAN 0 to HW filter on device batadv159
device batadv159 entered promiscuous mode
team83: Port device batadv159 added


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
