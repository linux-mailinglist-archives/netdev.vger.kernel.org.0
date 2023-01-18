Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01DE672BE1
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 23:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjARW4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 17:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjARWz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 17:55:58 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F9B654FE
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 14:55:36 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id 9-20020a056e0220c900b0030f1b0dfa9dso407962ilq.4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 14:55:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tZWZiMaCXIdxIWmeRzQU9O1u+AEKQjRT7eLBv9Ehjo4=;
        b=W9Sz8EkVQebLiIsBy9HizoN9ESYYqxn1xFmhSYD6NFbyKCm7SuQzJ/AO4RvHBswi5l
         /w1lYOmFu9byegRt+iA2KWEW9iwFDwFS8f0L+L71wkz3wR5kheYIWKCGUJi6WUpmuNHm
         QazoNfCdyr15pikut4KY1QZxmcLGlurEg97tZs+ST5Gz8not/iBAJCV/fvdxBrch/Mxa
         MZK2PSVXIXp5lGkNNCpezquffk7SAAoXUO8cDG8b3yCinDy0a8oh7zEuGkJZ+qq7X9B7
         wrhfuHGHDkzUjNiVZ/K7NxlMnZaoHGU6cqze7UYLYktG1PHUJrcK45YERAsqQczBE/Bq
         2UVA==
X-Gm-Message-State: AFqh2kqhAV3CPyL8Ciq6xmI9Zu/c2T/NfVdL8YBo9EU5TLKkDKK4AhAE
        SlatgtROHr/NMCiQ2MHdes0n942KR9vm/G07vxPvDI8wV9UE
X-Google-Smtp-Source: AMrXdXuej+qR00Ve3/UBAIgge4+XHVBW/ZokG+Bn60WrLlxWZe+0tU95zLxvY/pDO60bLWWcBdCYOEefyhdnLjzNYh1afkcr4yZn
MIME-Version: 1.0
X-Received: by 2002:a02:23c5:0:b0:3a6:d2c:2dcb with SMTP id
 u188-20020a0223c5000000b003a60d2c2dcbmr209661jau.166.1674082535464; Wed, 18
 Jan 2023 14:55:35 -0800 (PST)
Date:   Wed, 18 Jan 2023 14:55:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9e4f805f291b693@google.com>
Subject: [syzbot] INFO: trying to register non-static key in nr_release (3)
From:   syzbot <syzbot+969e048807b4567c3255@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
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

HEAD commit:    9598c377d828 Merge branch 'for-next/core', remote-tracking..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15734136480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2573056c6a11f00d
dashboard link: https://syzkaller.appspot.com/bug?extid=969e048807b4567c3255
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cacd91af9835/disk-9598c377.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2cf38950caf5/vmlinux-9598c377.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bedf1643e06b/Image-9598c377.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+969e048807b4567c3255@syzkaller.appspotmail.com

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 PID: 14579 Comm: syz-executor.5 Not tainted 6.2.0-rc3-syzkaller-16387-g9598c377d828 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 assign_lock_key+0x134/0x140 kernel/locking/lockdep.c:981
 register_lock_class+0xc4/0x2f8 kernel/locking/lockdep.c:1294
 __lock_acquire+0xa8/0x3084 kernel/locking/lockdep.c:4934
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
 __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
 _raw_write_lock_bh+0x54/0x6c kernel/locking/spinlock.c:334
 sock_orphan include/net/sock.h:2094 [inline]
 nr_release+0x70/0x274 net/netrom/af_netrom.c:521
 __sock_release net/socket.c:650 [inline]
 sock_close+0x50/0xf0 net/socket.c:1365
 __fput+0x198/0x3e4 fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:348
 task_work_run+0x100/0x148 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x2b8/0xc2c kernel/exit.c:867
 do_group_exit+0x98/0xcc kernel/exit.c:1012
 get_signal+0xac4/0xb34 kernel/signal.c:2859
 do_signal+0x128/0x438 arch/arm64/kernel/signal.c:1081
 do_notify_resume+0xc0/0x1f0 arch/arm64/kernel/signal.c:1134
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
Unable to handle kernel paging request at virtual address ffff80280d4860a4
Mem abort info:
  ESR = 0x0000000096000045
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000045
  CM = 0, WnR = 1
swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001c5270000
[ffff80280d4860a4] pgd=100000023ffff003, p4d=100000023ffff003, pud=0000000000000000
Internal error: Oops: 0000000096000045 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 14579 Comm: syz-executor.5 Not tainted 6.2.0-rc3-syzkaller-16387-g9598c377d828 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
pstate: 00400005 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x198/0x394 kernel/locking/qspinlock.c:474
lr : queued_spin_lock_slowpath+0x114/0x394 kernel/locking/qspinlock.c:405
sp : ffff8000210a3a30
x29: ffff8000210a3a30 x28: 00000000002e0003 x27: 00000000000008a0
x26: ffff00011e099750 x25: 0000000000000000 x24: ffff0001feff1080
x23: 0000000000000000 x22: ffff80000d51d068 x21: ffff80000d486080
x20: 0000000000000001 x19: ffff000119aef898 x18: 00000000000003ae
x17: ffff80000c15d8bc x16: 00000000000003b4 x15: 0000000000000001
x14: 0000000000000000 x13: 000000000000003c x12: 0000002800000024
x11: ffff80000d486080 x10: 0000000000080000 x9 : ffff0001feff1088
x8 : ffff0001feff1080 x7 : 7f7f7f7f7f7f7f7f x6 : ffff80000b29d7bc
x5 : 0000000000000000 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000001 x1 : ffff80000d017f93 x0 : 0000000000000001
Call trace:
 decode_tail kernel/locking/qspinlock.c:131 [inline]
 queued_spin_lock_slowpath+0x198/0x394 kernel/locking/qspinlock.c:471
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x10c/0x110 kernel/locking/spinlock_debug.c:115
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:127 [inline]
 _raw_spin_lock_bh+0x5c/0x6c kernel/locking/spinlock.c:178
 spin_lock_bh include/linux/spinlock.h:355 [inline]
 lock_sock_nested+0x88/0xd8 net/core/sock.c:3473
 lock_sock include/net/sock.h:1725 [inline]
 nr_release+0x98/0x274 net/netrom/af_netrom.c:522
 __sock_release net/socket.c:650 [inline]
 sock_close+0x50/0xf0 net/socket.c:1365
 __fput+0x198/0x3e4 fs/file_table.c:320
 ____fput+0x20/0x30 fs/file_table.c:348
 task_work_run+0x100/0x148 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0x2b8/0xc2c kernel/exit.c:867
 do_group_exit+0x98/0xcc kernel/exit.c:1012
 get_signal+0xac4/0xb34 kernel/signal.c:2859
 do_signal+0x128/0x438 arch/arm64/kernel/signal.c:1081
 do_notify_resume+0xc0/0x1f0 arch/arm64/kernel/signal.c:1134
 prepare_exit_to_user_mode arch/arm64/kernel/entry-common.c:137 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:142 [inline]
 el0_svc+0x9c/0x150 arch/arm64/kernel/entry-common.c:638
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
Code: 8b2c4ecc f85f818c 1200056b 8b2b52ab (f82b6988) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	8b2c4ecc 	add	x12, x22, w12, uxtw #3
   4:	f85f818c 	ldur	x12, [x12, #-8]
   8:	1200056b 	and	w11, w11, #0x3
   c:	8b2b52ab 	add	x11, x21, w11, uxtw #4
* 10:	f82b6988 	str	x8, [x12, x11] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
