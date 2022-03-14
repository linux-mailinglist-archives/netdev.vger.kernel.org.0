Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC4A4D7D74
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 09:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237640AbiCNISi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 04:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiCNISh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 04:18:37 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5493EF0B
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:17:27 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id s4-20020a92c5c4000000b002c7884b8608so2785365ilt.21
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 01:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QteVMReY+Pe/hdBa+IV+wFqcX7jlUZ75N7BHg5eqI+Y=;
        b=KndM22WjpyYnLgt9JNoahhXrC+ucyqvc0zoFN6V0ljrvjW7iw08cpsBPZnyB2nIWE1
         AkjoSFvrllkrJLxDCqGKSJQc9ezAh9ZOpMWZF7NTpi9sWO+psZd1IB2l3WTEj/ND6WwT
         2Y3oyOyX36ybNSkf9nfAXiOtB2eBQoyYj0zKoEVzmOeHa4qqAyRYjKmj3jCUEViqZOaw
         h658biVt0srBxqapTEOTx40KG5SoGSSP6otexPEaEvJ43n4f6DaPRjcm8wZGx9R+UaTC
         DZTqJAda5m72uRrmvm4q9c1soVcZ+z5WbtrQVr/t47wvc0WlTVgh9xgHnybcWCdYe+nl
         3idw==
X-Gm-Message-State: AOAM532Q95dcKA3IjctKh9mgIfapjrwgS/vWLc2o3hYnVAfBdmMI9AF3
        URLj3wvcJFToyB4ZwrT03x6PDCyXmTPRn/3CMU6KXQWPUc/F
X-Google-Smtp-Source: ABdhPJw5/i2qmkjyzfDtsuwoNGzecJ+zB8QhKcmQFD2WAA6uTcN+AFujqiu2TO2TUKSOE3amkIn2njdeMLc4y+MWdrC3m7DH6bru
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2387:b0:314:7ce4:1be8 with SMTP id
 q7-20020a056638238700b003147ce41be8mr20308521jat.286.1647245846823; Mon, 14
 Mar 2022 01:17:26 -0700 (PDT)
Date:   Mon, 14 Mar 2022 01:17:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008ec53005da294fe9@google.com>
Subject: [syzbot] kernel panic: corrupted stack end in rtnl_newlink
From:   syzbot <syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
console output: https://syzkaller.appspot.com/x/log.txt?x=17fe80c5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6295d67591064921
dashboard link: https://syzkaller.appspot.com/bug?extid=0600986d88e2d4d7ebb8
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0600986d88e2d4d7ebb8@syzkaller.appspotmail.com

Kernel panic - not syncing: corrupted stack end detected inside scheduler
CPU: 0 PID: 2049 Comm: syz-executor.0 Not tainted 5.17.0-rc1-syzkaller-00002-g0966d385830d #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000a228>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.c:113
[<ffffffff831668cc>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:119
[<ffffffff831756ba>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff831756ba>] dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:106
[<ffffffff83175742>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff83166fa8>] panic+0x24a/0x634 kernel/panic.c:233
[<ffffffff831a688a>] schedule_debug kernel/sched/core.c:5541 [inline]
[<ffffffff831a688a>] schedule+0x0/0x14c kernel/sched/core.c:6187
[<ffffffff831a6b00>] preempt_schedule_common+0x4e/0xde kernel/sched/core.c:6462
[<ffffffff831a6bc4>] preempt_schedule+0x34/0x36 kernel/sched/core.c:6487
[<ffffffff831afd78>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
[<ffffffff831afd78>] _raw_spin_unlock_irqrestore+0x8c/0x98 kernel/locking/spinlock.c:194
[<ffffffff80b09fdc>] __debug_check_no_obj_freed lib/debugobjects.c:1002 [inline]
[<ffffffff80b09fdc>] debug_check_no_obj_freed+0x14c/0x24a lib/debugobjects.c:1023
[<ffffffff80410994>] free_pages_prepare mm/page_alloc.c:1358 [inline]
[<ffffffff80410994>] free_pcp_prepare+0x24e/0x45e mm/page_alloc.c:1404
[<ffffffff804142fe>] free_unref_page_prepare mm/page_alloc.c:3325 [inline]
[<ffffffff804142fe>] free_unref_page+0x6a/0x31e mm/page_alloc.c:3404
[<ffffffff8041471e>] free_the_page mm/page_alloc.c:706 [inline]
[<ffffffff8041471e>] __free_pages+0xe2/0x112 mm/page_alloc.c:5474
[<ffffffff8046d728>] __free_slab+0x122/0x27c mm/slub.c:2028
[<ffffffff8046d8ce>] free_slab mm/slub.c:2043 [inline]
[<ffffffff8046d8ce>] discard_slab+0x4c/0x7a mm/slub.c:2049
[<ffffffff8046deec>] __unfreeze_partials+0x16a/0x18e mm/slub.c:2536
[<ffffffff8046e006>] put_cpu_partial+0xf6/0x162 mm/slub.c:2612
[<ffffffff8046d0ec>] __slab_free+0x166/0x29c mm/slub.c:3378
[<ffffffff8047258c>] do_slab_free mm/slub.c:3497 [inline]
[<ffffffff8047258c>] ___cache_free+0x17c/0x354 mm/slub.c:3516
[<ffffffff8047692e>] qlink_free mm/kasan/quarantine.c:157 [inline]
[<ffffffff8047692e>] qlist_free_all+0x7c/0x132 mm/kasan/quarantine.c:176
[<ffffffff80476ed4>] kasan_quarantine_reduce+0x14c/0x1c8 mm/kasan/quarantine.c:283
[<ffffffff804742b2>] __kasan_slab_alloc+0x5c/0x98 mm/kasan/common.c:446
[<ffffffff8046fa8a>] kasan_slab_alloc include/linux/kasan.h:260 [inline]
[<ffffffff8046fa8a>] slab_post_alloc_hook mm/slab.h:732 [inline]
[<ffffffff8046fa8a>] slab_alloc_node mm/slub.c:3230 [inline]
[<ffffffff8046fa8a>] slab_alloc mm/slub.c:3238 [inline]
[<ffffffff8046fa8a>] __kmalloc+0x156/0x318 mm/slub.c:4420
[<ffffffff82bde908>] kmalloc include/linux/slab.h:586 [inline]
[<ffffffff82bde908>] kzalloc include/linux/slab.h:715 [inline]
[<ffffffff82bde908>] fib_create_info+0xade/0x2d8e net/ipv4/fib_semantics.c:1464
[<ffffffff82becedc>] fib_table_insert+0x1a0/0xebe net/ipv4/fib_trie.c:1224
[<ffffffff82bd1222>] fib_magic+0x3f4/0x438 net/ipv4/fib_frontend.c:1087
[<ffffffff82bd6178>] fib_add_ifaddr+0xd2/0x2e2 net/ipv4/fib_frontend.c:1109
[<ffffffff82bd66ea>] fib_netdev_event+0x362/0x4b0 net/ipv4/fib_frontend.c:1466
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
SMP: stopping secondary CPUs
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
