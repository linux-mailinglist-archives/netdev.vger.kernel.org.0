Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB991B0CD
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 09:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfEMHHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 03:07:08 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:53087 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfEMHHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 03:07:06 -0400
Received: by mail-it1-f200.google.com with SMTP id 73so11407886itl.2
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 00:07:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=HS7eXqtSjToahbF+8YGfUVULm5QmPVdr7jt+lugTFD0=;
        b=dQFHbH6uhIpb43FqRpjUXqN0xKQF8FOGvA0YA54hSWhPGNqtl9zIusPIVDbY7TS2lv
         YDP5BHwDkR8iBoIa5b/xjPxAEed9vsM0oohBxg9t1RbdkykMpi2DoTuGIFdIvxoDbO6D
         9V82+KmIdNt2yWmSLDnlyNN/RKSBwn0esGRe25/Fom6UNxB1un8KLD43yL3PHHEhkUti
         C8Pb9T6tPABIjCpzE8b0aszdrucUgFYcIkyJ7KjELxsqnbQbAkGbOYRNkMGwXdsPCb9p
         vtFkIRR7r8sj8bffAIuAhqJv7L4vZhif26igW6GdTjPcQBV5fPmuGzUzTnhEXJe1F9ka
         4dsQ==
X-Gm-Message-State: APjAAAW/X1mdzFpsL9VI/lzXzU0JK9hnQeCgv445K1pi0uE21a5QGOup
        AaXbK4JuiIC/bm7tKDh8O2KrNNJf6dqS5zH179fdVHpD+U0i
X-Google-Smtp-Source: APXvYqxaG5duQ7HGiFc3gBEuHKSxI56NFqET64FcR9HPXB9WBzlCxAVv84TLU/32UsUNJ0ZOe+9LaDT6i+7In6KbmbgvVFdOkeY2
MIME-Version: 1.0
X-Received: by 2002:a02:8585:: with SMTP id d5mr18222190jai.69.1557731225226;
 Mon, 13 May 2019 00:07:05 -0700 (PDT)
Date:   Mon, 13 May 2019 00:07:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000055d6590588bf90bf@google.com>
Subject: linux-next test error: WARNING in remove_proc_entry
From:   syzbot <syzbot+4887e9dd9042fae2a9c2@syzkaller.appspotmail.com>
To:     anna.schumaker@netapp.com, bfields@fieldses.org,
        davem@davemloft.net, jlayton@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    04c4b677 Add linux-next specific files for 20190513
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10a413c8a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8e08a763b62ad3a
dashboard link: https://syzkaller.appspot.com/bug?extid=4887e9dd9042fae2a9c2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4887e9dd9042fae2a9c2@syzkaller.appspotmail.com

------------[ cut here ]------------
remove_proc_entry: removing non-empty directory 'net/rpc', leaking at  
least 'use-gss-proxy'
WARNING: CPU: 0 PID: 26 at fs/proc/generic.c:681  
remove_proc_entry+0x367/0x410 fs/proc/generic.c:681
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 26 Comm: kworker/u4:2 Not tainted 5.1.0-next-20190513 #6
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: netns cleanup_net
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x75a kernel/panic.c:218
  __warn.cold+0x20/0x47 kernel/panic.c:575
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:972
RIP: 0010:remove_proc_entry+0x367/0x410 fs/proc/generic.c:681
Code: 00 00 00 48 89 fa 48 c1 ea 03 80 3c 02 00 75 4c 49 8b 95 d0 00 00 00  
48 c7 c6 80 85 97 87 48 c7 c7 00 85 97 87 e8 c7 b1 6d ff <0f> 0b e9 4b fe  
ff ff e8 6d 54 d4 ff e9 b5 fd ff ff e8 23 55 d4 ff
RSP: 0018:ffff8880a9a8fb10 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 1ffff11015351f64 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815b20a6 RDI: ffffed1015351f54
RBP: ffff8880a9a8fbc0 R08: ffff8880a9a7c6c0 R09: ffff8880a9a7cfb0
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888099b87280
R13: ffff8880a55c77c0 R14: ffff888099b87330 R15: dffffc0000000000
  rpc_proc_exit+0x3e/0x50 net/sunrpc/stats.c:335
  sunrpc_exit_net+0x187/0x2d0 net/sunrpc/sunrpc_syms.c:73
  ops_exit_list.isra.0+0xb0/0x160 net/core/net_namespace.c:153
  cleanup_net+0x3fb/0x960 net/core/net_namespace.c:552
  process_one_work+0x98e/0x1790 kernel/workqueue.c:2268
  worker_thread+0x98/0xe40 kernel/workqueue.c:2414
  kthread+0x357/0x430 kernel/kthread.c:254
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
