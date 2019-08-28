Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D19AB9FAAA
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfH1GiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:38:08 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44228 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfH1GiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 02:38:07 -0400
Received: by mail-io1-f70.google.com with SMTP id f5so2434835ioo.11
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 23:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yCd41CNyR60VpDYw3udqbf0xP5cuEnDdTZQAfL1rzYM=;
        b=V7gIRKRt8CQC6W7hkBrDHR+04KWUTfmNob2oimGjffdTq+zbWo+Y0xAqvLd6FvDry6
         T7E9Umc6HuX3DKFN1B+0y9pZKinjrSAXdTgmZsIitWJ0YdPdqOdpL7j12FPKu1/FrImC
         sioM+JUlq34MZwSZf95+WS2iYXN0ff9DtyWr9VcVWMDU5/Fn/ZPYk5E7afgZSkp61kj6
         KPt7mfrWTzKoEJTSEEZdJ51LafQRuHtMmx7WKhH5aoSqqyDFu2GZc3lO5U1Ahv/U1ASB
         C08H6mdTJ0l44MHHKF9W8VxFaOP91WGInNbYtw+VVMKtwxas/TNyQardaj42tz+yvqNj
         Qeqw==
X-Gm-Message-State: APjAAAUZwSXB/QBIgiR0QUm4tAsGLoi7UQ/NtF2RkY9snE80A/x/H5Vi
        gySxW2XXNOVZL1ZNs7UPCWqZcGBH5D/goWupoUjNyo26aLtj
X-Google-Smtp-Source: APXvYqx8FgeCT4z0Sh6kWHCipmMG+aA+vKVax/R/fpauuxDh94FISFhSgUVyrIa/NW5nkUPhsUAUYglzhkZwgT5Ipg6q6PIOkqJH
MIME-Version: 1.0
X-Received: by 2002:a5d:9d89:: with SMTP id 9mr2471525ion.212.1566974286853;
 Tue, 27 Aug 2019 23:38:06 -0700 (PDT)
Date:   Tue, 27 Aug 2019 23:38:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd9241059127a1eb@google.com>
Subject: WARNING in smc_unhash_sk (3)
From:   syzbot <syzbot+8488cc4cf1c9e09b8b86@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a55aa89a Linux 5.3-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112dd212600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=58485246ad14eafe
dashboard link: https://syzkaller.appspot.com/bug?extid=8488cc4cf1c9e09b8b86
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15426ebc600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=116aca7a600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8488cc4cf1c9e09b8b86@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 9198 at ./include/net/sock.h:666 sk_del_node_init  
include/net/sock.h:666 [inline]
WARNING: CPU: 0 PID: 9198 at ./include/net/sock.h:666  
smc_unhash_sk+0x21b/0x240 net/smc/af_smc.c:96
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9198 Comm: syz-executor057 Not tainted 5.3.0-rc6 #93
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x25c/0x799 kernel/panic.c:219
  __warn+0x22f/0x230 kernel/panic.c:576
  report_bug+0x190/0x290 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:sk_del_node_init include/net/sock.h:666 [inline]
RIP: 0010:smc_unhash_sk+0x21b/0x240 net/smc/af_smc.c:96
Code: 48 89 df e8 07 b1 39 00 48 83 c4 20 5b 41 5c 41 5d 41 5e 41 5f 5d c3  
e8 03 d7 31 fa 48 c7 c7 f2 c3 3a 88 31 c0 e8 28 1d 1b fa <0f> 0b eb 85 44  
89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff 4c
RSP: 0018:ffff888094177b68 EFLAGS: 00010246
RAX: 0000000000000024 RBX: 0000000000000001 RCX: b964ece25f6b7c00
RDX: 0000000000000000 RSI: 0000000000000201 RDI: 0000000000000000
RBP: ffff888094177bb0 R08: ffffffff815cf7d4 R09: ffffed1015d46088
R10: ffffed1015d46088 R11: 0000000000000000 R12: ffff888098ccb240
R13: dffffc0000000000 R14: ffff888098ccb2c0 R15: ffff888098ccb268
  __smc_release+0x1f8/0x3a0 net/smc/af_smc.c:146
  smc_release+0x15b/0x2c0 net/smc/af_smc.c:185
  __sock_release net/socket.c:590 [inline]
  sock_close+0xe1/0x260 net/socket.c:1268
  __fput+0x2e4/0x740 fs/file_table.c:280
  ____fput+0x15/0x20 fs/file_table.c:313
  task_work_run+0x17e/0x1b0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x5e8/0x21a0 kernel/exit.c:879
  do_group_exit+0x15c/0x2b0 kernel/exit.c:983
  __do_sys_exit_group+0x17/0x20 kernel/exit.c:994
  __se_sys_exit_group+0x14/0x20 kernel/exit.c:992
  __x64_sys_exit_group+0x3b/0x40 kernel/exit.c:992
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43ff28
Code: 00 00 be 3c 00 00 00 eb 19 66 0f 1f 84 00 00 00 00 00 48 89 d7 89 f0  
0f 05 48 3d 00 f0 ff ff 77 21 f4 48 89 d7 44 89 c0 0f 05 <48> 3d 00 f0 ff  
ff 76 e0 f7 d8 64 41 89 01 eb d8 0f 1f 84 00 00 00
RSP: 002b:00007ffefacce238 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ff28
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf750 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 00000000200000c0 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
