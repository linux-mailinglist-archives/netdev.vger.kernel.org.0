Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BDC2C02B2
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgKWJzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:55:18 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:51484 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbgKWJzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:55:17 -0500
Received: by mail-il1-f200.google.com with SMTP id f8so13251358ilj.18
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 01:55:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lMLTt/SuwLRf4ocvmFFvLONW25I25f5Nz49bfqZG5UE=;
        b=BvjBwTC6vq6On0MypEFn8AQ/dgt/R3py3DW6oL6ZmdgbbQUAHDEfGWrNRQz1Oq+t9t
         VTose39sKh6HVxdPS5PysUNJ0xKX/Y15TfeZUwcvgmUp7qYHBCnkhREnDwhxB1dSbTai
         zZEYvUKOyW80XvWAn5asP43fEMOLmF/HS3I8YJTrI6i118HjrOIA+v3jFHSSaZ852H20
         3Neyfxv+ua7FzKF/eoQkj+VPbprUbHAqM2/cBLZrGKW0QMqTCjwb3T6n0mzB0F2xIg+u
         5vgcxXsD2g4T3jVjQ6OlhkDkA4VxT5fLu4GGfIsx1gp5gDc6Fm/RHikO569CMojHZC+r
         lKow==
X-Gm-Message-State: AOAM531/500PXjN0HZXOLQ3u0zBi9em5mZh1WW3zkFdv4WebShr2go7v
        sLfDRa8zomb9Y6bDIYJg/R7aOIlwjRoai9mtOFcfTnEgIV8L
X-Google-Smtp-Source: ABdhPJwSytCrqYpdxaZQeFkbjDR+bnEkGRaDCDTj3gF/G42XrvV7MUqRE9i6xZBywlsAEDfC28y/9zLSpdLUXKdyTMNOSXPsTD5m
MIME-Version: 1.0
X-Received: by 2002:a92:b512:: with SMTP id f18mr1892806ile.27.1606125316656;
 Mon, 23 Nov 2020 01:55:16 -0800 (PST)
Date:   Mon, 23 Nov 2020 01:55:16 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6d4dd05b4c330e0@google.com>
Subject: BUG: receive list entry not found for dev vcan0, id 001, mask C00007FF
From:   syzbot <syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b9ad3e9f bonding: wait for sysfs kobject destruction befor..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1195c5cd500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=330f3436df12fd44
dashboard link: https://syzkaller.appspot.com/bug?extid=d0ddd88c9a7432f041e6
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c409cd500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1349ced1500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 00007fffc0827800 RCX: 0000000000443749
RDX: 0000000000000018 RSI: 0000000020000300 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000001bbbbbb
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
BUG: receive list entry not found for dev vcan0, id 001, mask C00007FF
WARNING: CPU: 0 PID: 8495 at net/can/af_can.c:546 can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
Modules linked in:
CPU: 0 PID: 8495 Comm: syz-executor608 Not tainted 5.10.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:can_rx_unregister+0x5a4/0x700 net/can/af_can.c:546
Code: 8b 7c 24 78 44 8b 64 24 68 49 c7 c5 a0 ae 56 8a e8 11 58 97 f9 44 89 f9 44 89 e2 4c 89 ee 48 c7 c7 e0 ae 56 8a e8 76 ab d3 00 <0f> 0b 48 8b 7c 24 28 e8 90 22 0f 01 e9 54 fb ff ff e8 06 cf d8 f9
RSP: 0018:ffffc9000182f9f0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801ffe8000 RSI: ffffffff8158f3c5 RDI: fffff52000305f30
RBP: 0000000000000118 R08: 0000000000000001 R09: ffff8880b9e30627
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff88801ab00000 R14: 1ffff92000305f45 R15: 00000000c00007ff
FS:  0000000000000000(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004c8928 CR3: 000000000b08e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 isotp_notifier+0x2a7/0x540 net/can/isotp.c:1303
 call_netdevice_notifier net/core/dev.c:1735 [inline]
 call_netdevice_unregister_notifiers+0x156/0x1c0 net/core/dev.c:1763
 call_netdevice_unregister_net_notifiers net/core/dev.c:1791 [inline]
 unregister_netdevice_notifier+0xcd/0x170 net/core/dev.c:1870
 isotp_release+0x136/0x600 net/can/isotp.c:1011
 __sock_release+0xcd/0x280 net/socket.c:596
 sock_close+0x18/0x20 net/socket.c:1277
 __fput+0x285/0x920 fs/file_table.c:281
 task_work_run+0xdd/0x190 kernel/task_work.c:151
 exit_task_work include/linux/task_work.h:30 [inline]
 do_exit+0xb64/0x29b0 kernel/exit.c:809
 do_group_exit+0x125/0x310 kernel/exit.c:906
 __do_sys_exit_group kernel/exit.c:917 [inline]
 __se_sys_exit_group kernel/exit.c:915 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:915
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x442388
Code: Unable to access opcode bytes at RIP 0x44235e.
RSP: 002b:00007fffc0827768 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000442388
RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
RBP: 00000000004c88f0 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006dd240 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
