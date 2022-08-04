Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E75C4589A09
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 11:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbiHDJmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 05:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiHDJmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 05:42:31 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813225725F
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 02:42:30 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id s5-20020a056e02216500b002dde8b02f62so11867577ilv.15
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 02:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=VIarYWYlHVbetuT3fQo7MQDnfy7UGZgzt3E3AwEAwHQ=;
        b=LU6FENSI9fZunl+6myceKiW9XvWA7CNvq1Jusc9L1SIFkURSF33/cgiAPZRiKaB31/
         KIK1vY22OI9dsOweRn3IH/j/rq7+XFUx4iJ94rrsm5c8KW0dGOh4Ownz4EaXMNmqWgJ+
         tTrww8fdhK+pJgNbzSLVPx4LoMRTmHfe+7aqXAc9AAJP7pfc2+T29f7ZpReZpSXAqTCz
         ZCihp67wfBv+Rg66cNNJAmetjw7lALv5uRT3+n7FOjebRXPoXqM6KfmURkpKATF4ncCL
         b86T857R89ErJvxZ3gao5CcqpO96BTQc4HiShP1wpLDz4nq0QDjxPrtRIZxRN9u5r+Vn
         yZWg==
X-Gm-Message-State: ACgBeo3hl43hniNDW/0ApU4E7wZLRJNsQQJbolXXZnfezDG868jeSBfK
        f2XwrajZg+trpGXtLfTe/Tr5UURCG8XscjRexAKeWU6aUdYx
X-Google-Smtp-Source: AA6agR5RZJNBoy2XZ8I12zLYINc2r7W5zZnzG7Ch4g9D1cFwvyfXmiE06Lm3inFV/ASdGr6KnZ/WLG1woBsHyuzSPV8sBVDsyn60
MIME-Version: 1.0
X-Received: by 2002:a05:6638:264d:b0:33f:5cb4:935f with SMTP id
 n13-20020a056638264d00b0033f5cb4935fmr447679jat.98.1659606149944; Thu, 04 Aug
 2022 02:42:29 -0700 (PDT)
Date:   Thu, 04 Aug 2022 02:42:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000008dcfa05e5672b3a@google.com>
Subject: [syzbot] upstream test error: WARNING: ODEBUG bug in mgmt_index_removed
From:   syzbot <syzbot+b8ddd338a8838e581b1c@syzkaller.appspotmail.com>
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

HEAD commit:    b44f2fd87919 Merge tag 'drm-next-2022-08-03' of git://anon..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12099eb6080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4dcc926c2745b9bc
dashboard link: https://syzkaller.appspot.com/bug?extid=b8ddd338a8838e581b1c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b8ddd338a8838e581b1c@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 2 PID: 3677 at lib/debugobjects.c:502 debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Modules linked in:
CPU: 2 PID: 3677 Comm: syz-executor.0 Not tainted 5.19.0-syzkaller-07280-gb44f2fd87919 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 80 6d 28 8a 4c 89 ee 48 c7 c7 60 61 28 8a e8 c5 6c 37 05 <0f> 0b 83 05 f5 4d bc 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90002e976e0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88801b79a1c0 RSI: ffffffff81604db8 RDI: fffff520005d2ece
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffffffff89cec7e0
R13: ffffffff8a2867e0 R14: ffffffff81694bf0 R15: 1ffff920005d2ee7
FS:  0000000000000000(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d5e4cfad58 CR3: 0000000015303000 CR4: 0000000000150ee0
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
 mgmt_index_removed+0x187/0x2e0 net/bluetooth/mgmt.c:8939
 hci_unregister_dev+0x467/0x550 net/bluetooth/hci_core.c:2688
 vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x277/0x9d0 fs/file_table.c:320
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
RIP: 0033:0x7f283b03bdbc
Code: Unable to access opcode bytes at RIP 0x7f283b03bd92.
RSP: 002b:00007ffec8e73250 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: fffffffffffffe00 RBX: 00007ffec8e73300 RCX: 00007f283b03bdbc
RDX: 0000000000000040 RSI: 00007f283b198020 RDI: 00000000000000f9
RBP: 0000000000000003 R08: 0000000000000000 R09: ff00000000000000
R10: 00007f283b16d6c0 R11: 0000000000000246 R12: 0000000000000032
R13: 000000000000e5af R14: 0000000000000003 R15: 00007ffec8e73340
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
