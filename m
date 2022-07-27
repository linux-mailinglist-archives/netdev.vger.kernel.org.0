Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B58558336E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 21:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiG0TWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 15:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiG0TVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 15:21:37 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E97C9251
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 12:19:34 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id n20-20020a6b8b14000000b0067c00777874so6466511iod.15
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 12:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=o43XWvJVL8LwKlq5bumFX0EQAFLVg3mZ27QbfKs8DQc=;
        b=GpfOElJMMz6laGK61xE1cuxruNuHMdWwNq7+7R+fyj2rtnh/gFEyR6vCodJCkYeG1s
         dQ++nn1D3GYQAxnoArtDVv6tU/gXHlLEGFwBX4HyNOgfVU+Xt8P84iKXL1oyYuSe+/CP
         3iJUAksdKIcez7yNrV6DSPgWd8x4G3n3vLuJwm60vXB5QQ0WinbJ2ZQwYnlC40oHt9kM
         jr6sMJoyyhZd+9XuxMGRtCCLxdN3bfAhKntxSjMHS1m8fmEWI8K+cIbKrGQeiqk97N08
         OG44vYoT8rfVlVFsbngMzSxETMpwqnPnaaShRZMmHlMa1d3Rp7qu5UUIbAZwtJX2ABz5
         pZBA==
X-Gm-Message-State: AJIora99cJATuQuSI9Agm8bQWX9RAVPxU94d8lAe858xgehs5axPgWkz
        yMcPTInGDz50fLhYxOkXhPW9E3jsEQaM0BXeMdn9DduJT1Z1
X-Google-Smtp-Source: AGRyM1v5uCM0Wuc6zGYRo8FNpjNaavvdu4uhgQHYq5S/47WubisEac7MsJsjRlNCKDbzhQfhRVrcKH5YkA5hR+OgRgueFTZAgP4P
MIME-Version: 1.0
X-Received: by 2002:a02:970a:0:b0:33f:42a8:a63f with SMTP id
 x10-20020a02970a000000b0033f42a8a63fmr9638103jai.115.1658949572807; Wed, 27
 Jul 2022 12:19:32 -0700 (PDT)
Date:   Wed, 27 Jul 2022 12:19:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fcd12c05e4ce4bde@google.com>
Subject: [syzbot] bpf-next test error: WARNING: ODEBUG bug in mgmt_index_removed
From:   syzbot <syzbot+1f966ab7943f7bc5441a@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    40b09653b197 selftests/bpf: Adjust vmtest.sh to use local ..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1283ab26080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c904647431ba900b
dashboard link: https://syzkaller.appspot.com/bug?extid=1f966ab7943f7bc5441a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1f966ab7943f7bc5441a@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 3608 at lib/debugobjects.c:502 debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Modules linked in:
CPU: 0 PID: 3608 Comm: syz-executor.0 Not tainted 5.19.0-rc7-syzkaller-01906-g40b09653b197 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 60 88 28 8a 4c 89 ee 48 c7 c7 40 7c 28 8a e8 de 95 36 05 <0f> 0b 83 05 55 ac bb 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc9000397f6e0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff888021ea0000 RSI: ffffffff8160d9c8 RDI: fffff5200072fece
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffffffff89ced480
R13: ffffffff8a2882c0 R14: ffffffff8169b640 R15: 1ffff9200072fee7
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000335010 CR3: 000000001ca55000 CR4: 00000000003506f0
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
RIP: 0033:0x7f4086088b77
Code: Unable to access opcode bytes at RIP 0x7f4086088b4d.
RSP: 002b:00007fffcc0f9c08 EFLAGS: 00000207 ORIG_RAX: 0000000000000107
RAX: 0000000000000000 RBX: 0000000000000065 RCX: 00007f4086088b77
RDX: 0000000000000200 RSI: 00007fffcc0fad90 RDI: 00000000ffffff9c
RBP: 00007fffcc0f9cd0 R08: 0000000000000000 R09: 00007fffcc0f9aa0
R10: 0000555556a578e3 R11: 0000000000000207 R12: 00007f40860e22a6
R13: 00007fffcc0fad90 R14: 0000555556a57810 R15: 00007fffcc0fadd0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
