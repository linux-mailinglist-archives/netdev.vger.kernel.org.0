Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55F2B5827A9
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbiG0N12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbiG0N11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:27:27 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBCC275F6
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 06:27:26 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id z11-20020a05660217cb00b0067c63cf0236so5837099iox.13
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 06:27:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/OsG81id+thzUuw3/IQ3pX805IzReT+1axT06GNhNfI=;
        b=KHkcfwvRdb3PIY7STUy7m5w8aSV6mDAcP1KBPgMRpKhluE/j/Oce/X2C7BBUrzyCtl
         BiVjDzpAJ/BeXvnSDRWzhDkRuUPfOBcBMh81gfYSKRaH4zS1ysYeSmzHq+aeH8s2tBF4
         e1/vivx/k9EPug8aPXEMJYTCA7OrGfVshKRvwmifJ7My2DXmUe0bEix7b5q3VO43eelm
         gv3bSDMFS46euhFySE72kX1ofqKDW2fLphvaG+KjE6DFdxdXsbKVCsbVSxAKUwAAc/aF
         yvY8Fgr70VfQOVdcH4QE8ZiBrtvoA27/VuHg0x9swqOmhRfT1SJ7ay6jnuKhOy8G/itf
         yOWQ==
X-Gm-Message-State: AJIora9mjJe6RrXWvOBYqLH2ezGxbyaXe7OQWQHS74la5yLrwp8Ll4VY
        T3BKO5QKaZ49vs39jrgmUvTPgTDJHMk62NWJ+YW46ykexeyu
X-Google-Smtp-Source: AGRyM1vcDr5E/VcbeSSrOxrfQ9EAAueP0+rQF9ND8vTZweD2N7iLVxHEU8dKhBSn489SZE9J2y08+qOo1/skuLR+PeekVA+oB9QA
MIME-Version: 1.0
X-Received: by 2002:a05:6602:395:b0:67b:d0c6:50cb with SMTP id
 f21-20020a056602039500b0067bd0c650cbmr8150634iov.110.1658928445836; Wed, 27
 Jul 2022 06:27:25 -0700 (PDT)
Date:   Wed, 27 Jul 2022 06:27:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b8d26905e4c96064@google.com>
Subject: [syzbot] net-next test error: WARNING: ODEBUG bug in mgmt_index_removed
From:   syzbot <syzbot+e6fedd64b4d23cc9185c@syzkaller.appspotmail.com>
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

HEAD commit:    5ffcba41de55 Merge branch 'smc-updates'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13ca0752080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c904647431ba900b
dashboard link: https://syzkaller.appspot.com/bug?extid=e6fedd64b4d23cc9185c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e6fedd64b4d23cc9185c@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 3610 at lib/debugobjects.c:502 debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Modules linked in:
CPU: 0 PID: 3610 Comm: syz-executor.0 Not tainted 5.19.0-rc7-syzkaller-01937-g5ffcba41de55 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 60 88 48 8a 4c 89 ee 48 c7 c7 40 7c 48 8a e8 fe e8 36 05 <0f> 0b 83 05 75 b3 db 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000427f6e0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88807d233b00 RSI: ffffffff8160d9c8 RDI: fffff5200084fece
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffffffff89eed480
R13: ffffffff8a4882c0 R14: ffffffff8169b640 R15: 1ffff9200084fee7
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00074d000 CR3: 000000001cceb000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:892 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:863
 debug_timer_assert_init kernel/time/timer.c:792 [inline]
 debug_assert_init kernel/time/timer.c:837 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1257
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1275
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3121
 mgmt_index_removed+0x187/0x2e0 net/bluetooth/mgmt.c:8940
 hci_unregister_dev+0x467/0x550 net/bluetooth/hci_core.c:2688
 vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xade/0x29d0 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 get_signal+0x2542/0x2600 kernel/signal.c:2857
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f443528a677
Code: Unable to access opcode bytes at RIP 0x7f443528a64d.
RSP: 002b:00007ffc080f4ed8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: ffffffffffffffea RBX: 0000000000000003 RCX: 00007f443528a677
RDX: 00007ffc080f4fac RSI: 000000000000000a RDI: 00007ffc080f4fa0
RBP: 00007ffc080f4fa0 R08: 00000000ffffffff R09: 00007ffc080f4d70
R10: 0000555556dcc853 R11: 0000000000000246 R12: 00007f44352e22a6
R13: 00007ffc080f6060 R14: 0000555556dcc810 R15: 00007ffc080f60a0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
