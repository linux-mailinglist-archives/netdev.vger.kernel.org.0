Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2FD5F29F9
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 09:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiJCH3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 03:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiJCH2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 03:28:50 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4900414016
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 00:19:53 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id g10-20020a056e021e0a00b002f9db676704so1227340ila.14
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 00:19:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=CkqP2d1fPEgRUJDcFTqNFXZTppAl/lOomNbbZEWiEns=;
        b=ZMC4I5gFXjVCDj/qA46KuoeryFciqUKWc7Swxu9Y7xQ3u5w8iQnAD2r2tbgKLIJ0un
         qdwpXX3BZd2OVoalTBwFlqHidUXuH+l1oA38Nuv93uWzKYgbG/A3Bi853O95XTk6GuZK
         10d7OUMeC1+FxD4lBMiKbBmwpJld4ZQp3iitqoJU+wGoYniDg1jdaplQPqLdV8Jx745t
         XLm/4IrvA00DhvTh4DICqM7IyrJ2p/TpBwBONZfdDzAn5wNWPLD0m8FR28XekTBh2Jr6
         1RPlymVYpM1pzsSYPYmZ8kuNOlfqKr3cNy5qK5IXD1j/RAUbaPlG3F1Q3UItldwZbGcA
         yKKw==
X-Gm-Message-State: ACrzQf1SoLFoHh8AgLdT0xx1zBsxTcBxB7OfC2AHPYjOVgt548+xvqH+
        scCmqVCGP7Qtt++wqstnebam3PE9TkzTujRB6RIpNGAbyUn2
X-Google-Smtp-Source: AMsMyM5C3CEbYW69hFAqUOIWkUAdFOh3SKHNxgqGN6gazoXYeXn0GqNq8xfW7R6MjfTxL/bu1rewfTuvWeLkN8RaPDihJ6A3u5LH
MIME-Version: 1.0
X-Received: by 2002:a92:cd03:0:b0:2f9:463e:279d with SMTP id
 z3-20020a92cd03000000b002f9463e279dmr7178837iln.223.1664781518584; Mon, 03
 Oct 2022 00:18:38 -0700 (PDT)
Date:   Mon, 03 Oct 2022 00:18:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000b46aa05ea1c2721@google.com>
Subject: [syzbot] possible deadlock in discov_off
From:   syzbot <syzbot+f047480b1e906b46a3f4@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    c3e0e1e23c70 Merge tag 'irq_urgent_for_v6.0' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14471d38880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=755695d26ad09807
dashboard link: https://syzkaller.appspot.com/bug?extid=f047480b1e906b46a3f4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/67576e43d5c7/disk-c3e0e1e2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e568fb42b955/vmlinux-c3e0e1e2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f047480b1e906b46a3f4@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.0.0-rc7-syzkaller-00081-gc3e0e1e23c70 #0 Not tainted
------------------------------------------------------
kworker/u5:5/3650 is trying to acquire lock:
ffff88807606c078 (&hdev->lock){+.+.}-{3:3}, at: discov_off+0x88/0x1a0 net/bluetooth/mgmt.c:1033

but task is already holding lock:
ffffc90003f5fda8 ((work_completion)(&(&hdev->discov_off)->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 ((work_completion)(&(&hdev->discov_off)->work)){+.+.}-{0:0}:
       __flush_work+0x105/0xae0 kernel/workqueue.c:3069
       __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3160
       mgmt_index_removed+0x218/0x340 net/bluetooth/mgmt.c:8952
       hci_unregister_dev+0x34f/0x4e0 net/bluetooth/hci_core.c:2688
       vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
       __fput+0x277/0x9d0 fs/file_table.c:320
       task_work_run+0xdd/0x1a0 kernel/task_work.c:177
       exit_task_work include/linux/task_work.h:38 [inline]
       do_exit+0xad5/0x29b0 kernel/exit.c:795
       do_group_exit+0xd2/0x2f0 kernel/exit.c:925
       get_signal+0x238c/0x2610 kernel/signal.c:2857
       arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
       exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
       exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
       __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
       syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
       do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
       entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> #0 (&hdev->lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3095 [inline]
       check_prevs_add kernel/locking/lockdep.c:3214 [inline]
       validate_chain kernel/locking/lockdep.c:3829 [inline]
       __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
       lock_acquire kernel/locking/lockdep.c:5666 [inline]
       lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
       __mutex_lock_common kernel/locking/mutex.c:603 [inline]
       __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
       discov_off+0x88/0x1a0 net/bluetooth/mgmt.c:1033
       process_one_work+0x991/0x1610 kernel/workqueue.c:2289
       worker_thread+0x665/0x1080 kernel/workqueue.c:2436
       kthread+0x2e4/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock((work_completion)(&(&hdev->discov_off)->work));
                               lock(&hdev->lock);
                               lock((work_completion)(&(&hdev->discov_off)->work));
  lock(&hdev->lock);

 *** DEADLOCK ***

2 locks held by kworker/u5:5/3650:
 #0: ffff88807a95e938 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff88807a95e938 ((wq_completion)hci0){+.+.}-{0:0}, at: arch_atomic_long_set include/linux/atomic/atomic-long.h:41 [inline]
 #0: ffff88807a95e938 ((wq_completion)hci0){+.+.}-{0:0}, at: atomic_long_set include/linux/atomic/atomic-instrumented.h:1280 [inline]
 #0: ffff88807a95e938 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:636 [inline]
 #0: ffff88807a95e938 ((wq_completion)hci0){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:663 [inline]
 #0: ffff88807a95e938 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work+0x87a/0x1610 kernel/workqueue.c:2260
 #1: ffffc90003f5fda8 ((work_completion)(&(&hdev->discov_off)->work)){+.+.}-{0:0}, at: process_one_work+0x8ae/0x1610 kernel/workqueue.c:2264

stack backtrace:
CPU: 0 PID: 3650 Comm: kworker/u5:5 Not tainted 6.0.0-rc7-syzkaller-00081-gc3e0e1e23c70 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
Workqueue: hci0 discov_off
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3095 [inline]
 check_prevs_add kernel/locking/lockdep.c:3214 [inline]
 validate_chain kernel/locking/lockdep.c:3829 [inline]
 __lock_acquire+0x2a43/0x56d0 kernel/locking/lockdep.c:5053
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __mutex_lock_common kernel/locking/mutex.c:603 [inline]
 __mutex_lock+0x12f/0x1350 kernel/locking/mutex.c:747
 discov_off+0x88/0x1a0 net/bluetooth/mgmt.c:1033
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
