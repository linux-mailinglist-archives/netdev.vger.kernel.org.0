Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B815910DCE0
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 08:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfK3HTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 02:19:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:39445 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfK3HTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 02:19:10 -0500
Received: by mail-io1-f71.google.com with SMTP id u13so19416339iol.6
        for <netdev@vger.kernel.org>; Fri, 29 Nov 2019 23:19:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=NH7tpAHELzxk/UfVmDatDAWXns7669WAP7vdJ5fhSaU=;
        b=UILQBfkIvo6RTJ/lJNvI3hY0ciO8OeIEshjlRRP+5sTK17Si4kkWRkfXLsErJ2lboC
         2Y1slAwP8zP8mCy1Jg7ajfNPoUbNNFW0s+WrF4feBJp+8ROFRvSTi1wVbuQHH96Xxk05
         EgexbBl+6BdAEIlbaiu4svB0fBJ/aBNqGzICAn3rd5LQOCZiFXhzqnLmYlAWx60jJ8sP
         Xyak/rrfg1UZEgL5Vze0FT8KO1aSdjMwEIfo0rWVJGhWIGTN1mj6pEEszvM4H9+kvto2
         0PQX+30QBTcnsTbx3OmPCIBVUCrz8uwxkIsif5AQ6R3C9mf34vBYWpNWJSnA8aLwK9oJ
         ZdjQ==
X-Gm-Message-State: APjAAAWsm4b5irEKem+d8izv+z99hdeoyxLDoFBTWinNcWpOajtZhUXr
        4jaRUubqYt4Sg9oy5QzGS05pqgGGuq2PX2zumX4rInN0w/sg
X-Google-Smtp-Source: APXvYqyb+xnqjU7qMCYcbRW40EATfkt3T1JPj3hrphILwsgi10O9VY2aj0RLDbGgH95QnkFZUJaY4FVAzQcBla/ERhdPpdAN9r3i
MIME-Version: 1.0
X-Received: by 2002:a5d:8184:: with SMTP id u4mr45057762ion.155.1575098348491;
 Fri, 29 Nov 2019 23:19:08 -0800 (PST)
Date:   Fri, 29 Nov 2019 23:19:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008c5bfa05988b29dd@google.com>
Subject: general protection fault in j1939_jsk_del (2)
From:   syzbot <syzbot+99e9e1b200a1e363237d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kernel@pengutronix.de,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, mkl@pengutronix.de, netdev@vger.kernel.org,
        robin@protonic.nl, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    81b6b964 Merge branch 'master' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=134af786e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=773597fe8d7cb41a
dashboard link: https://syzkaller.appspot.com/bug?extid=99e9e1b200a1e363237d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+99e9e1b200a1e363237d@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 18385 Comm: syz-executor.1 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__lock_acquire+0x1254/0x4a00 kernel/locking/lockdep.c:3828
Code: 00 0f 85 96 24 00 00 48 81 c4 f0 00 00 00 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 48 b8 00 00 00 00 00 fc ff df 4c 89 f2 48 c1 ea 03 <80> 3c 02 00 0f  
85 0b 28 00 00 49 81 3e 20 59 2a 8a 0f 84 5f ee ff
RSP: 0018:ffff8880a0397b38 EFLAGS: 00010006
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000218 RSI: 0000000000000000 RDI: 0000000000000001
RBP: ffff8880a0397c50 R08: 0000000000000001 R09: 0000000000000001
R10: fffffbfff13d4e58 R11: ffff888093b044c0 R12: 00000000000010c0
R13: 0000000000000000 R14: 00000000000010c0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0063) knlGS:00000000f5dcfb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002e521000 CR3: 0000000097a51000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
  _raw_spin_lock_bh+0x33/0x50 kernel/locking/spinlock.c:175
  spin_lock_bh include/linux/spinlock.h:343 [inline]
  j1939_jsk_del+0x32/0x210 net/can/j1939/socket.c:89
  j1939_sk_bind+0x2ea/0x8f0 net/can/j1939/socket.c:448
  __sys_bind+0x239/0x290 net/socket.c:1648
  __do_sys_bind net/socket.c:1659 [inline]
  __se_sys_bind net/socket.c:1657 [inline]
  __ia32_sys_bind+0x72/0xb0 net/socket.c:1657
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7ff4a39
Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c  
24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f5dcf0cc EFLAGS: 00000296 ORIG_RAX: 0000000000000169
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020000000
RDX: 0000000000000018 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
------------[ cut here ]------------
WARNING: CPU: 0 PID: 18385 at kernel/locking/mutex.c:1419  
mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
