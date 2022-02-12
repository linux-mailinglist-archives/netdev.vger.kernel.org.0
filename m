Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54444B3403
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 10:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiBLJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 04:25:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiBLJZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 04:25:23 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2CE26573
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:25:20 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id b3-20020a056e020c8300b002be19f9e043so7468734ile.13
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:25:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZtL5i1t9klk+YLV1HnkewFTh9taQxRMyB5UUQJAQ2zM=;
        b=gWMrhU0XQoW9X7cW/K7WRDPC6nNgvQmLhhbz8Bb0t5QODMUMumM4XJ7FcLX4CwHnL2
         ju69XufBZM1jpIU90lbLANCS9dgKPVqCYIlm9O+pC3gkInQVVF+U8UUwMfNOjSPX3OXw
         zPjCEKjkGsEziuwFnCRdx2LGTxyLjjwszjdiy1ywglh4D6l1HumMX/26C3UwqQ0x1D1V
         V5E+LbOW679Okg/4ZqxMM7qHx9mO8nuQ3OxLwHY8A1/IGpk73fVDzV8bcFSioTwRjSfM
         yNazlWL5LPOFc7cUyNZb41eAXMquI4TyxgYQXzrExao7RPHsTZ9Q2xLq58dZ5+M+St16
         Y56w==
X-Gm-Message-State: AOAM532R0gKu6VW9cuufVLVN+O1PIoB1y8N+igq+o9eQO+GOc039KlWg
        jRQNPoQ1rNEq3v6AQazK9GpDNbtEX90Uq20Jrrysq/SJyFQR
X-Google-Smtp-Source: ABdhPJx8ow+/awsXjC1xOnCUNufZuulCq8reGoQuVmsW8S+jHNRrZXiNyWPyUuWPW8OEUsUcJ4vvBdL9aXl0aE6yVyAtlHnpvlBw
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a46:: with SMTP id u6mr2938187ilv.245.1644657919465;
 Sat, 12 Feb 2022 01:25:19 -0800 (PST)
Date:   Sat, 12 Feb 2022 01:25:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000111f7f05d7cec3bd@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in hci_dev_close_sync
From:   syzbot <syzbot+45bff639f729e5f15653@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    555f3d7be91a Merge tag '5.17-rc3-ksmbd-server-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16e61b78700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5707221760c00a20
dashboard link: https://syzkaller.appspot.com/bug?extid=45bff639f729e5f15653
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+45bff639f729e5f15653@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 1 PID: 15929 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 1 PID: 15929 Comm: syz-executor.5 Not tainted 5.17.0-rc3-syzkaller-00020-g555f3d7be91a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 40 d4 05 8a 4c 89 ee 48 c7 c7 40 c8 05 8a e8 a4 34 24 05 <0f> 0b 83 05 35 4a b1 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90002c37938 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88805689c200 RSI: ffffffff815ee378 RDI: fffff52000586f19
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815e80de R11: 0000000000000000 R12: ffffffff89ae3aa0
R13: ffffffff8a05cec0 R14: ffffffff81660040 R15: 1ffff92000586f32
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 000000005c7e8000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:895 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
 debug_timer_assert_init kernel/time/timer.c:739 [inline]
 debug_assert_init kernel/time/timer.c:784 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1204
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1285
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3139
 hci_dev_close_sync+0xb01/0x1120 net/bluetooth/hci_sync.c:4084
 hci_dev_do_close+0x32/0x70 net/bluetooth/hci_core.c:553
 hci_unregister_dev+0x1d0/0x550 net/bluetooth/hci_core.c:2686
 vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x286/0x9f0 fs/file_table.c:311
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xb29/0x2a30 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:935
 __do_sys_exit_group kernel/exit.c:946 [inline]
 __se_sys_exit_group kernel/exit.c:944 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:944
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fe461979059
Code: Unable to access opcode bytes at RIP 0x7fe46197902f.
RSP: 002b:00007ffe7d025b08 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000064 RCX: 00007fe461979059
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00007fe4619d225c R08: 000000000000000c R09: 000055555596c3b8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000016
R13: 00007ffe7d026de0 R14: 000055555596c3b8 R15: 00007ffe7d027ee0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
