Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B36258883D
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 09:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237135AbiHCHsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 03:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiHCHso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 03:48:44 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E219F2ED75
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 00:48:31 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id l17-20020a056e02067100b002dc8a10b55eso9981930ilt.1
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 00:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=YSnMrHMrPsBHb/tEhxAN/h9xAYXKwmQerCYhDV4MZTc=;
        b=uKeOJ8FF/R/tJyDXRpx8dJkGJDVlDDwIqdLgHliGi5iHKmytFNz+XshJTIObPQfWTy
         pw8uJErOJ8jlGF5DvEbr1vbA9BiCBP8IUKg5n68vQWxiKZ6c2PZeSgNMMVv369nX2MKJ
         uVgvlgiSu3YuAR8pN0AsinuNXxu3mrfrEiKQevT0xt5FYLG2QaimWDFHfPq6TIRHc0mT
         82ysszyiBMcUvuQWEFVsTtdZt9eGJCWFVPYX8iWeGFjZ/dSM/P04W5J1AogEha3lyKjL
         Mp9mibzuTiSZdyjTLPap9farlGH6DtLHoWFe9hES4ataBmh3v/dJ1UNjOXEW/LgVFbwX
         jn2w==
X-Gm-Message-State: ACgBeo2gLICZDAJNRf5WYlb2vQaTUW+CaD3MtgTsKLR1D4zwatFAWWUY
        xZ3RtskpkLgVzxLrisE2B9u9tG+tiCOEEyi0r5hg8L0fBEtR
X-Google-Smtp-Source: AA6agR71T1a0cVtZLUcUJcKLcjgekUI0WZhfs7KqbxlbwGZ4RxEghGOYiX7kVlUvACZZQFi4hs5jZGhtj/3OKgiZVmWBYmCVf6Yl
MIME-Version: 1.0
X-Received: by 2002:a05:6638:ca:b0:342:7d2f:d882 with SMTP id
 w10-20020a05663800ca00b003427d2fd882mr4226214jao.220.1659512911270; Wed, 03
 Aug 2022 00:48:31 -0700 (PDT)
Date:   Wed, 03 Aug 2022 00:48:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000939c8b05e5517521@google.com>
Subject: [syzbot] linux-next test error: WARNING: ODEBUG bug in mgmt_index_removed
From:   syzbot <syzbot+b42805125f9a096b735d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        pabeni@redhat.com, sfr@canb.auug.org.au,
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

HEAD commit:    42d670bda02f Add linux-next specific files for 20220802
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17ed503a080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e2cda601d1924a
dashboard link: https://syzkaller.appspot.com/bug?extid=b42805125f9a096b735d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b42805125f9a096b735d@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 3614 at lib/debugobjects.c:509 debug_print_object+0x16e/0x250 lib/debugobjects.c:509
Modules linked in:
CPU: 0 PID: 3614 Comm: syz-executor.0 Not tainted 5.19.0-next-20220802-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:509
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 60 01 49 8a 4c 89 ee 48 c7 c7 00 f5 48 8a e8 63 95 38 05 <0f> 0b 83 05 65 62 dd 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90003c2f6e8 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff88807eefbb00 RSI: ffffffff8161ee98 RDI: fffff52000785ecf
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff89eeff60
R13: ffffffff8a48fbc0 R14: ffffffff816b2060 R15: 1ffff92000785ee8
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0006a7000 CR3: 000000001841e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:899 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:870
 debug_timer_assert_init kernel/time/timer.c:792 [inline]
 debug_assert_init kernel/time/timer.c:837 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1257
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1275
 __cancel_work_timer+0xa6/0x570 kernel/workqueue.c:3121
 mgmt_index_removed+0x187/0x2e0 net/bluetooth/mgmt.c:8939
 hci_unregister_dev+0x34f/0x4e0 net/bluetooth/hci_core.c:2688
 vhci_release+0x7c/0xf0 drivers/bluetooth/hci_vhci.c:568
 __fput+0x277/0x9d0 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xc39/0x2b60 kernel/exit.c:813
 do_group_exit+0xd0/0x2a0 kernel/exit.c:943
 get_signal+0x238c/0x2610 kernel/signal.c:2858
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f986b488b47
Code: Unable to access opcode bytes at RIP 0x7f986b488b1d.
RSP: 002b:00007ffd39d91238 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f986b488b47
RDX: 00007ffd39d91270 RSI: 00007ffd39d91270 RDI: 00007ffd39d91300
RBP: 00007ffd39d91300 R08: 0000000000000001 R09: 00007ffd39d910d0
R10: 0000555556f9a853 R11: 0000000000000206 R12: 00007f986b4e22a6
R13: 00007ffd39d923c0 R14: 0000555556f9a810 R15: 00007ffd39d92400
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
