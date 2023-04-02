Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4C06D37B1
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 13:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjDBLgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 07:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDBLgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 07:36:38 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55730E19A
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 04:36:37 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id l7-20020a0566022dc700b0074cc9aba965so16091595iow.11
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 04:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680435396; x=1683027396;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KDR00WI8adt3It+AZvLimFN4Ze4oquIjR3Cgls2HzAw=;
        b=vc0Fr9LMA/lUguQ9E+I3luGYDWM5AMWTbchw5HrtFfL8RDdtm7nHqRisqF87/ImaVX
         FJRQbj9NhVShYvWY4vI0FvvjIbzpszSi5InFsHcdD8Gz8qzE1e75U+g+/itswEjXV+GM
         hMFQEgInIPSNdl536CjKeg1v6+WliTfFEfXk7zAiTGwtBDc/zkbSEh5bNGZW0gZINSfE
         4iXX/mtiy7LQKYiDYRqgz6eU3eVYWxtKBMQPCw8nYenuXkhULk4Wj/riwy+XIxn71517
         BIaMEEAhG9nG4KNoDF4TSHI/gXw/PSXijMFV7B3BGcUAQL9/N2f9osDaFz4weR/f+BMl
         0lXQ==
X-Gm-Message-State: AAQBX9cB36CazDt8eDo6oo8Lf1Pi7+2knjKDN79OqFohx0+PNo84fvx0
        9hsnNwKAJ2QHpv2Nk5PB9ISSMmgC63gm46ymSehxbkf3o4pg
X-Google-Smtp-Source: AKy350brbZFG1xfbhgyRK1Njxr/aWa1kAWa23UJdkJc32ueeSQn2KBKSTsc0G+RPPGSIPdziEFDaJn6mRis8pDjVZsRPM7HoFP/Y
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c5:b0:326:4af5:28b5 with SMTP id
 i5-20020a056e0212c500b003264af528b5mr3475109ilm.3.1680435396655; Sun, 02 Apr
 2023 04:36:36 -0700 (PDT)
Date:   Sun, 02 Apr 2023 04:36:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e2bfa805f858da13@google.com>
Subject: [syzbot] [net?] possible deadlock in hsr_dev_xmit
From:   syzbot <syzbot+f411520c77f8faef228d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fcd476ea6a88 Merge tag 'urgent-rcu.2023.03.28a' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ea8fa9c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d40b592130bb7abb
dashboard link: https://syzkaller.appspot.com/bug?extid=f411520c77f8faef228d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e7a4a2e02801/disk-fcd476ea.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/765c66dcaa7e/vmlinux-fcd476ea.xz
kernel image: https://storage.googleapis.com/syzbot-assets/de23bded3dd6/bzImage-fcd476ea.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f411520c77f8faef228d@syzkaller.appspotmail.com

============================================
WARNING: possible recursive locking detected
6.3.0-rc4-syzkaller-00034-gfcd476ea6a88 #0 Not tainted
--------------------------------------------
ksoftirqd/0/15 is trying to acquire lock:
ffff888044caed80 (&hsr->seqnr_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
ffff888044caed80 (&hsr->seqnr_lock){+.-.}-{2:2}, at: hsr_dev_xmit+0x176/0x270 net/hsr/hsr_device.c:222

but task is already holding lock:
ffff88807e08ad80 (&hsr->seqnr_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
ffff88807e08ad80 (&hsr->seqnr_lock){+.-.}-{2:2}, at: send_prp_supervision_frame+0x17b/0x620 net/hsr/hsr_device.c:351

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&hsr->seqnr_lock);
  lock(&hsr->seqnr_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

10 locks held by ksoftirqd/0/15:
 #0: ffffc90000147c60 ((&hsr->announce_timer)){+.-.}-{0:0}, at: lockdep_copy_map include/linux/lockdep.h:31 [inline]
 #0: ffffc90000147c60 ((&hsr->announce_timer)){+.-.}-{0:0}, at: call_timer_fn+0xd5/0x580 kernel/time/timer.c:1690
 #1: ffffffff8c7955c0 (rcu_read_lock){....}-{1:2}, at: hsr_announce+0x4/0x370 net/hsr/hsr_device.c:373
 #2: ffff88807e08ad80 (&hsr->seqnr_lock){+.-.}-{2:2}, at: spin_lock_bh include/linux/spinlock.h:355 [inline]
 #2: ffff88807e08ad80 (&hsr->seqnr_lock){+.-.}-{2:2}, at: send_prp_supervision_frame+0x17b/0x620 net/hsr/hsr_device.c:351
 #3: ffffffff8c7955c0 (rcu_read_lock){....}-{1:2}, at: hsr_forward_skb+0x4/0x1f40 net/hsr/hsr_forward.c:612
 #4: ffffffff8c795560 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x23f/0x3c40 net/core/dev.c:4163
 #5: ffffffff8c7955c0 (rcu_read_lock){....}-{1:2}, at: geneve_xmit+0xe2/0x4970 drivers/net/geneve.c:1099
 #6: ffffffff8c795560 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #6: ffffffff8c795560 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x2a9/0x1590 net/ipv6/ip6_output.c:112
 #7: ffffffff8c7955c0 (rcu_read_lock){....}-{1:2}, at: ip6_nd_hdr net/ipv6/ndisc.c:467 [inline]
 #7: ffffffff8c7955c0 (rcu_read_lock){....}-{1:2}, at: ndisc_send_skb+0x830/0x1850 net/ipv6/ndisc.c:502
 #8: ffffffff8c795560 (rcu_read_lock_bh){....}-{1:2}, at: lwtunnel_xmit_redirect include/net/lwtunnel.h:95 [inline]
 #8: ffffffff8c795560 (rcu_read_lock_bh){....}-{1:2}, at: ip6_finish_output2+0x2a9/0x1590 net/ipv6/ip6_output.c:112
 #9: ffffffff8c795560 (rcu_read_lock_bh){....}-{1:2}, at: __dev_queue_xmit+0x23f/0x3c40 net/core/dev.c:4163

stack backtrace:
CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 6.3.0-rc4-syzkaller-00034-gfcd476ea6a88 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/17/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_deadlock_bug kernel/locking/lockdep.c:2991 [inline]
 check_deadlock kernel/locking/lockdep.c:3034 [inline]
 validate_chain kernel/locking/lockdep.c:3819 [inline]
 __lock_acquire+0x1362/0x5d40 kernel/locking/lockdep.c:5056
 lock_acquire kernel/locking/lockdep.c:5669 [inline]
 lock_acquire+0x1af/0x520 kernel/locking/lockdep.c:5634
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
 _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:355 [inline]
 hsr_dev_xmit+0x176/0x270 net/hsr/hsr_device.c:222
 __netdev_start_xmit include/linux/netdevice.h:4883 [inline]
 netdev_start_xmit include/linux/netdevice.h:4897 [inline]
 xmit_one net/core/dev.c:3580 [inline]
 dev_hard_start_xmit+0x187/0x700 net/core/dev.c:3596
 __dev_queue_xmit+0x2ce4/0x3c40 net/core/dev.c:4246
 dev_queue_xmit include/linux/netdevice.h:3053 [inline]
 neigh_connected_output+0x3c2/0x550 net/core/neighbour.c:1612
 neigh_output include/net/neighbour.h:546 [inline]
 ip6_finish_output2+0x56c/0x1590 net/ipv6/ip6_output.c:134
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:444 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 ndisc_send_skb+0xa63/0x1850 net/ipv6/ndisc.c:508
 ndisc_send_ns+0xaa/0x130 net/ipv6/ndisc.c:666
 ndisc_solicit+0x2c8/0x4e0 net/ipv6/ndisc.c:758
 neigh_probe+0xc2/0x110 net/core/neighbour.c:1095
 __neigh_event_send+0xa74/0x1430 net/core/neighbour.c:1262
 neigh_event_send_probe include/net/neighbour.h:470 [inline]
 neigh_event_send include/net/neighbour.h:476 [inline]
 neigh_event_send include/net/neighbour.h:474 [inline]
 neigh_resolve_output+0x54a/0x870 net/core/neighbour.c:1567
 neigh_output include/net/neighbour.h:546 [inline]
 ip6_finish_output2+0x56c/0x1590 net/ipv6/ip6_output.c:134
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x694/0x1170 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1f1/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:444 [inline]
 ip6_local_out+0xb3/0x1a0 net/ipv6/output_core.c:155
 ip6tunnel_xmit include/net/ip6_tunnel.h:161 [inline]
 udp_tunnel6_xmit_skb+0x740/0xbd0 net/ipv6/ip6_udp_tunnel.c:109
 geneve6_xmit_skb drivers/net/geneve.c:1076 [inline]
 geneve_xmit+0x9f0/0x4970 drivers/net/geneve.c:1105
 __netdev_start_xmit include/linux/netdevice.h:4883 [inline]
 netdev_start_xmit include/linux/netdevice.h:4897 [inline]
 xmit_one net/core/dev.c:3580 [inline]
 dev_hard_start_xmit+0x187/0x700 net/core/dev.c:3596
 __dev_queue_xmit+0x2ce4/0x3c40 net/core/dev.c:4246
 dev_queue_xmit include/linux/netdevice.h:3053 [inline]
 hsr_xmit net/hsr/hsr_forward.c:382 [inline]
 hsr_forward_do net/hsr/hsr_forward.c:473 [inline]
 hsr_forward_skb+0xa7d/0x1f40 net/hsr/hsr_forward.c:620
 send_prp_supervision_frame+0x3e1/0x620 net/hsr/hsr_device.c:366
 hsr_announce+0x10d/0x370 net/hsr/hsr_device.c:382
 call_timer_fn+0x1a0/0x580 kernel/time/timer.c:1700
 expire_timers+0x29b/0x4b0 kernel/time/timer.c:1751
 __run_timers kernel/time/timer.c:2022 [inline]
 __run_timers kernel/time/timer.c:1995 [inline]
 run_timer_softirq+0x326/0x910 kernel/time/timer.c:2035
 __do_softirq+0x1d4/0x905 kernel/softirq.c:571
 run_ksoftirqd kernel/softirq.c:934 [inline]
 run_ksoftirqd+0x31/0x60 kernel/softirq.c:926
 smpboot_thread_fn+0x659/0x9e0 kernel/smpboot.c:164
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
net_ratelimit: 31165 callbacks suppressed
ICMPv6: NA: 24:02:48:ff:05:00 advertised our address fe80::2602:48ff:feff:500 on bridge0!
bridge0: received packet on veth0_to_bridge with own address as source address (addr:24:02:48:ff:05:00, vlan:0)
ICMPv6: NA: 24:02:48:ff:05:00 advertised our address fe80::2602:48ff:feff:500 on bridge0!
bridge0: received packet on bridge_slave_0 with own address as source address (addr:24:02:48:ff:05:00, vlan:0)
ICMPv6: NA: 24:02:48:ff:05:00 advertised our address fe80::2602:48ff:feff:500 on bridge0!


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
