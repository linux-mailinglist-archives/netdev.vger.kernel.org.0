Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B208610EE24
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 18:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfLBR1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 12:27:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:49534 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfLBR1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 12:27:10 -0500
Received: by mail-il1-f200.google.com with SMTP id t13so256447ilk.16
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 09:27:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TtI8iuODHAY3u2DEuOOaACvhCMI2l1BthLHP25nKwao=;
        b=deSAj1uWVKig3tJ2Xj4e1f002fTiLpZqzUt2VU6tHqND+njYhSS2eyDY68jYV0PGYg
         kZ/4fd7qBiZ6oAWGtSQvQyb3hlAHJw4CYcfHJ8t2trTxWsentOE7dtH3cBjRlCD9fHQx
         +bAeaiMJAdQd09/C1nV3+FZN2P+gXuxyBoXNRH75QmCrDncR8g2b2w8I4YCwQFUih0iE
         ZZPyORiZJOZa0YXDybzpURnlSPg2HWwnuon3un9reX0lFbya2H/HC4EF88SA/mLlKEZJ
         p+2LUgD0Cixf7IeDoV30d2HOsWuVRPJfsB5SAsetwZ4sXFxm3KKXK2571UFWKudAfjaf
         W9rw==
X-Gm-Message-State: APjAAAWY5VhcimxGMWgEisvqQekxGUVgc3I2sMjEnPNnijZY4VhcN279
        Fvd73KoZwQfYNhfc9uVY461XFu6M+ztTb8VaEu4t2qmUdueG
X-Google-Smtp-Source: APXvYqzUBK8l/nEEBz5DGClMhxGuP7KONlyXZ38j9ZDhKJcotxY5eRC7fYZQz1ryOHK1m0i9QwHV21qsGAKHHh0jtTCyTH+SHdUH
MIME-Version: 1.0
X-Received: by 2002:a5d:9f05:: with SMTP id q5mr6659087iot.295.1575307629224;
 Mon, 02 Dec 2019 09:27:09 -0800 (PST)
Date:   Mon, 02 Dec 2019 09:27:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a6f2030598bbe38c@google.com>
Subject: WARNING in wp_page_copy
From:   syzbot <syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a6ed68d6 Merge tag 'drm-next-2019-11-27' of git://anongit...
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1181e536e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6349516b24252b37
dashboard link: https://syzkaller.appspot.com/bug?extid=9301f2f33873407d5b33
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9301f2f33873407d5b33@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 22897 at mm/memory.c:2223 cow_user_page  
mm/memory.c:2223 [inline]
WARNING: CPU: 0 PID: 22897 at mm/memory.c:2223 wp_page_copy+0x123c/0x1860  
mm/memory.c:2393
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 22897 Comm: syz-executor.4 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:cow_user_page mm/memory.c:2223 [inline]
RIP: 0010:wp_page_copy+0x123c/0x1860 mm/memory.c:2393
Code: 4c 89 f7 ba 00 10 00 00 48 81 e6 00 f0 ff ff e8 7a 52 c0 05 31 ff 41  
89 c7 89 c6 e8 be 9e d3 ff 45 85 ff 74 0f e8 34 9d d3 ff <0f> 0b 4c 89 f7  
e8 aa 44 c0 05 e8 25 9d d3 ff 65 4c 8b 34 25 c0 1e
RSP: 0018:ffff88806c99f8d0 EFLAGS: 00010202
RAX: 0000000000040000 RBX: ffff88806c99fb78 RCX: ffffc9000ed9c000
RDX: 0000000000000230 RSI: ffffffff81a0b77c RDI: 0000000000000005
RBP: ffff88806c99fa18 R08: ffff888068576680 R09: 0000000000000000
R10: ffffed100faee7ff R11: ffff88807d773fff R12: ffff88808a082420
R13: ffffea0001f5dcc0 R14: ffff88807d773000 R15: 0000000000001000
  do_wp_page+0x543/0x15c0 mm/memory.c:2702
  handle_pte_fault mm/memory.c:3939 [inline]
  __handle_mm_fault+0x23ec/0x4040 mm/memory.c:4047
  handle_mm_fault+0x3b2/0xa50 mm/memory.c:4084
  do_user_addr_fault arch/x86/mm/fault.c:1441 [inline]
  __do_page_fault+0x536/0xd80 arch/x86/mm/fault.c:1506
  do_page_fault+0x38/0x590 arch/x86/mm/fault.c:1530
  page_fault+0x39/0x40 arch/x86/entry/entry_64.S:1203
RIP: 0010:__put_user_4+0x1c/0x30 arch/x86/lib/putuser.S:70
Code: 1f 00 c3 90 66 2e 0f 1f 84 00 00 00 00 00 65 48 8b 1c 25 c0 1e 02 00  
48 8b 9b 90 14 00 00 48 83 eb 03 48 39 d9 73 4a 0f 1f 00 <89> 01 31 c0 0f  
1f 00 c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 65 48
RSP: 0018:ffff88806c99fe18 EFLAGS: 00010297
RAX: 0000000000000009 RBX: 00007fffffffeffd RCX: 0000000020003ac0
RDX: 0000000000000058 RSI: ffffffff81a08021 RDI: 0000000000000286
RBP: ffff88806c99fee0 R08: 0000000000000001 R09: ffff888068576f10
R10: fffffbfff13cf9e8 R11: ffffffff89e7cf47 R12: 0000000000000006
R13: 0000000000000009 R14: 000000000000000a R15: 0000000000000000
  __do_sys_socketpair net/socket.c:1623 [inline]
  __se_sys_socketpair net/socket.c:1620 [inline]
  __x64_sys_socketpair+0x97/0xf0 net/socket.c:1620
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45a679
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f42bfff6c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000035
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000000045a679
RDX: 00000000000000be RSI: 0000000000000006 RDI: 0000000000000006
RBP: 000000000075c118 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000020003ac0 R11: 0000000000000246 R12: 00007f42bfff76d4
R13: 00000000004c9e66 R14: 00000000004e2240 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
