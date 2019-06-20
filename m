Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2144CE76
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbfFTNRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 09:17:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44624 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731954AbfFTNRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 09:17:06 -0400
Received: by mail-io1-f70.google.com with SMTP id i133so5170915ioa.11
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 06:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pFl57I7Gu7LJtpS4kZ7e5rZsSSBo5xMttzXo6P3hq6Y=;
        b=gDU1kBvgq430ZSEj3MYWeavx2i3BnOrffrYoyuUI2f+YGLyd0lAR8XoOo/r/qe/8o2
         jTdHRrk1Skwk7XN8lX/JA/bqwst+fN2sMTx+eGfWlIVMxQp2xTzDRTXvSwDBaq8N/6Fp
         ksaJpA+Rano0mXgnqoT7IQXVRkr0cl/iFOtijzmk21Mydt9JVHR/t4tCVC116kkNYsyw
         +50oNfLk6qFao30UKTewu/ufPW2z8eJmOgoI8MZThW4pXoItLXac9VPa3CxJT5JXzxol
         BnLvzGn+hYv8m9JJXdO6VkfcX7ljuH/E60u7wIA8CxaOn+UJZ6qppEjXhZnbhC0KNZcV
         YeWQ==
X-Gm-Message-State: APjAAAXjPYpb8oD3s0hui6RSHL/TOB7tKa6faHjcaPn+T88+N/U+adDq
        IpIt0v0hxBhGI8FvqaFWP29CSXfTHk0MC0pBdOAJR4EF8i+x
X-Google-Smtp-Source: APXvYqwLnQfND50vIn2AJG13GUkJ3L6wdGfUhNSiK9/TZfF1gRHnqct2uCCZoIge4fY7fgOyrrONXpJorYI3kaD1zSbhdUhm7tSO
MIME-Version: 1.0
X-Received: by 2002:a5d:9ec4:: with SMTP id a4mr955576ioe.125.1561036625845;
 Thu, 20 Jun 2019 06:17:05 -0700 (PDT)
Date:   Thu, 20 Jun 2019 06:17:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090ae7a058bc12946@google.com>
Subject: WARNING in debug_check_no_obj_freed
From:   syzbot <syzbot+b972214bb803a343f4fe@syzkaller.appspotmail.com>
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

HEAD commit:    bed3c0d8 Merge tag 'for-5.2-rc5-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13cc2c3aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=b972214bb803a343f4fe
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fcf0b2a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a22ad6a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b972214bb803a343f4fe@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint:  
smc_tx_work+0x0/0x260 net/smc/smc_tx.c:264
WARNING: CPU: 0 PID: 8158 at lib/debugobjects.c:328 debug_print_object  
lib/debugobjects.c:325 [inline]
WARNING: CPU: 0 PID: 8158 at lib/debugobjects.c:328  
__debug_check_no_obj_freed lib/debugobjects.c:785 [inline]
WARNING: CPU: 0 PID: 8158 at lib/debugobjects.c:328  
debug_check_no_obj_freed+0x5c0/0x740 lib/debugobjects.c:817
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8158 Comm: syz-executor878 Not tainted 5.2.0-rc5+ #3
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x28a/0x7c9 kernel/panic.c:219
  __warn+0x216/0x220 kernel/panic.c:576
  report_bug+0x190/0x290 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x450 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:debug_print_object lib/debugobjects.c:325 [inline]
RIP: 0010:__debug_check_no_obj_freed lib/debugobjects.c:785 [inline]
RIP: 0010:debug_check_no_obj_freed+0x5c0/0x740 lib/debugobjects.c:817
Code: 96 5c 4e fe 4c 89 fa 48 8b 4d b8 4c 8b 01 48 c7 c7 9c 55 66 88 48 c7  
c6 ec 63 7e 88 44 89 e1 4c 8b 4d b0 31 c0 e8 30 05 e7 fd <0f> 0b 48 8b 4d  
d0 48 8b 55 c8 ff 05 e8 b2 7c 05 48 b8 00 00 00 00
RSP: 0018:ffff888084ba7b60 EFLAGS: 00010046
RAX: ff4ab4ef149ca600 RBX: 1ffff110152b3acd RCX: ffff88808a330040
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: ffff888084ba7c00 R08: ffffffff815e87e4 R09: ffffed1015d440c2
R10: ffffed1015d440c2 R11: 1ffff11015d440c1 R12: 0000000000000000
R13: 1ffff110152b3acf R14: ffff888085381798 R15: dffffc0000000000
  kmem_cache_free+0xb9/0x170 mm/slab.c:3697
  sk_prot_free net/core/sock.c:1637 [inline]
  __sk_destruct+0x558/0x660 net/core/sock.c:1725
  sk_destruct net/core/sock.c:1733 [inline]
  __sk_free+0x307/0x3d0 net/core/sock.c:1744
  sk_free+0x2a/0x40 net/core/sock.c:1755
  sock_put include/net/sock.h:1725 [inline]
  smc_release+0x4b3/0x620 net/smc/af_smc.c:182
  __sock_release net/socket.c:601 [inline]
  sock_close+0xdb/0x280 net/socket.c:1273
  __fput+0x2e4/0x740 fs/file_table.c:280
  ____fput+0x15/0x20 fs/file_table.c:313
  task_work_run+0x17e/0x1b0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:185 [inline]
  exit_to_usermode_loop arch/x86/entry/common.c:168 [inline]
  prepare_exit_to_usermode+0x402/0x4f0 arch/x86/entry/common.c:199
  syscall_return_slowpath+0x110/0x440 arch/x86/entry/common.c:279
  do_syscall_64+0x126/0x140 arch/x86/entry/common.c:304
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x402720
Code: 01 f0 ff ff 0f 83 40 0d 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d 0d 94 2d 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 14 0d 00 00 c3 48 83 ec 08 e8 7a 02 00 00
RSP: 002b:00007ffda70c1198 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000402720
RDX: 0000000000000001 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000028 R09: 00000000004aa1df
R10: 0000000020000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000403950 R14: 0000000000000000 R15: 0000000000000000

======================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
