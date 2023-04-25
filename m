Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63CA6EDD97
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjDYIFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbjDYIFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:05:00 -0400
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CC49FA
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:04:59 -0700 (PDT)
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-32b532ee15bso201687395ab.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:04:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682409898; x=1685001898;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oDbboGji8S9RFRkieJ6BiDoqNdOz27qLK7fsOLzCHr4=;
        b=gXcll0NiqnTLutujaf7sfgjx08sBehr/nChahbD1S4tzBiViebFRVz3M/EtOYKrN0/
         BhW8YEVK2nLZ5tU+4jhvAPCQ0OzOI022QIqVO7wWIeA9hS2SNm4La/fuLPKqfARRRZMq
         EcCSwm91sUNuQGFvONsAx2ZxMcVbLMmbaCfzvosU2OEYvjKuezcH15rbfJrzgQn5wWwk
         8itMJhUJbtYJ0Vt1v9DEE7ICLZDkSC+ym+8Vxmg5tk5gTQXcb+HmRMGybxjjJdwejz9l
         DXiy+UAo9c6CRQDG/SoGGk5NxpFABD399ZAsfdxbjv3lQa3JXBCtYX+bEC2KVufp+XLX
         Vvkw==
X-Gm-Message-State: AAQBX9d82KO1wV/He/+bKfvYD0i7rLmUb/pmx29wU7DayuHXOLjHBTif
        YG1lPGiWk7j2eZjetcZHMDehzcMutqBOK6MzEiNR36TKoK0y
X-Google-Smtp-Source: AKy350b0Vn8qRA/kq9zT/VbbUS4MsOHoIXUfffRq2twtfLFiGMj7gJK+xVkrpcuY2tByzTKrp6PGKIFmoEKkgH1gnDbR/SK8biLz
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1504:b0:3c2:c1c9:8bca with SMTP id
 b4-20020a056638150400b003c2c1c98bcamr11438606jat.2.1682409898235; Tue, 25 Apr
 2023 01:04:58 -0700 (PDT)
Date:   Tue, 25 Apr 2023 01:04:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000059e1b705fa2494e4@google.com>
Subject: [syzbot] [can?] KCSAN: data-race in bcm_can_tx / bcm_tx_setup (3)
From:   syzbot <syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, pabeni@redhat.com,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1a0beef98b58 Merge tag 'tpmdd-v6.4-rc1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1485f1dbc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=501f7c86f7a05a13
dashboard link: https://syzkaller.appspot.com/bug?extid=e1786f049e71693263bf
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f06c11683242/disk-1a0beef9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5c0a1cd5a059/vmlinux-1a0beef9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e4c318183ce3/bzImage-1a0beef9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e1786f049e71693263bf@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in bcm_can_tx / bcm_tx_setup

write to 0xffff888137fcff10 of 4 bytes by task 10792 on cpu 0:
 bcm_tx_setup+0x698/0xd30 net/can/bcm.c:995
 bcm_sendmsg+0x38b/0x470 net/can/bcm.c:1355
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg net/socket.c:747 [inline]
 ____sys_sendmsg+0x375/0x4c0 net/socket.c:2501
 ___sys_sendmsg net/socket.c:2555 [inline]
 __sys_sendmsg+0x1e3/0x270 net/socket.c:2584
 __do_sys_sendmsg net/socket.c:2593 [inline]
 __se_sys_sendmsg net/socket.c:2591 [inline]
 __x64_sys_sendmsg+0x46/0x50 net/socket.c:2591
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

write to 0xffff888137fcff10 of 4 bytes by interrupt on cpu 1:
 bcm_can_tx+0x38a/0x410
 bcm_tx_timeout_handler+0xdb/0x260
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x217/0x700 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0xd6/0x120 kernel/time/hrtimer.c:1766
 __do_softirq+0xc1/0x265 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x57/0xa0 kernel/softirq.c:650
 sysvec_apic_timer_interrupt+0x6d/0x80 arch/x86/kernel/apic/apic.c:1107
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:645
 kcsan_setup_watchpoint+0x3fe/0x410 kernel/kcsan/core.c:696
 string_nocheck lib/vsprintf.c:648 [inline]
 string+0x16c/0x200 lib/vsprintf.c:726
 vsnprintf+0xa09/0xe20 lib/vsprintf.c:2796
 add_uevent_var+0xf0/0x1c0 lib/kobject_uevent.c:665
 kobject_uevent_env+0x225/0x5b0 lib/kobject_uevent.c:539
 kobject_uevent+0x1c/0x20 lib/kobject_uevent.c:642
 __loop_clr_fd+0x1e0/0x3b0 drivers/block/loop.c:1167
 lo_release+0xe4/0xf0 drivers/block/loop.c:1745
 blkdev_put+0x3fb/0x470
 kill_block_super+0x83/0xa0 fs/super.c:1410
 deactivate_locked_super+0x6b/0xd0 fs/super.c:331
 deactivate_super+0x9b/0xb0 fs/super.c:362
 cleanup_mnt+0x272/0x2e0 fs/namespace.c:1177
 __cleanup_mnt+0x19/0x20 fs/namespace.c:1184
 task_work_run+0x123/0x160 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0xd1/0xe0 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0x6c/0xb0 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00000059 -> 0x00000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 3096 Comm: syz-executor.5 Not tainted 6.3.0-syzkaller-00113-g1a0beef98b58 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
