Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F891DE2FE
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 11:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgEVJ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 05:26:17 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:39601 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729561AbgEVJ0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 05:26:17 -0400
Received: by mail-il1-f200.google.com with SMTP id q2so8132550ild.6
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 02:26:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lnDnkHH8eIGRot84QQm9EkjYLwd2UTiQf0hCf63v5y0=;
        b=kTcncG9GvVy1jOWqmAltqVJj8OscA0C6Jx6MsdTNfogBD6ND8p1rVwt9MNqhJd8Hn9
         7beArh1NxYl+DyHx0YyfgwzlI5+MghcO8dMdIxrMknDaoCN3VcFRRfohSWJ5Eva9H7Z2
         jxtDe99oTtsOHlLdBYwJZA3j7xWI39gSATvofQQRWSaXKL9GUJ5SYFulPx9WkNRmiBox
         hIf/Zbnc69lclQj75prmvaRV1iSr7TRe+T6FcZbG/CWfdkU8nv48/37pkQ+hsbbIpXEA
         1+iQtfl0ZPyfIEbAqJeJj1T2wxzoMPv1jE8u7Q5hE1AfsCOpgxaPSJ0Yk70i5MKCqGI5
         Kztg==
X-Gm-Message-State: AOAM532p1fPzNqijyyvPNYIQEvlG8fzpNMnXWSWiApnuG4NVFdMk4+8h
        cCnz/gUIOxb953I9PT0uzZ/ncJ2mlFzYIGd0mPTeg+4uXHMs
X-Google-Smtp-Source: ABdhPJy5UwqNw5v0J/MMiDXS19aWx4ShtWQFpiylMBDvCxAMBOYoglvvPQiKE4Lo8qNgPNjryfgLvwpjiZrZwhEMDuvrVsReB4Ef
MIME-Version: 1.0
X-Received: by 2002:a92:8c4a:: with SMTP id o71mr12894641ild.130.1590139574866;
 Fri, 22 May 2020 02:26:14 -0700 (PDT)
Date:   Fri, 22 May 2020 02:26:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080db0d05a639389e@google.com>
Subject: WARNING in __queue_work (2)
From:   syzbot <syzbot+8ceb187b741280aa5611@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    ac935d22 Add linux-next specific files for 20200415
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13666a22100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bc498783097e9019
dashboard link: https://syzkaller.appspot.com/bug?extid=8ceb187b741280aa5611
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+8ceb187b741280aa5611@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 20232 at kernel/workqueue.c:1412 __queue_work+0xe4e/0x1280 kernel/workqueue.c:1412
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 20232 Comm: syz-executor.4 Not tainted 5.7.0-rc1-next-20200415-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:__queue_work+0xe4e/0x1280 kernel/workqueue.c:1412
Code: 03 38 d0 7c 09 84 d2 74 05 e8 9e c3 65 00 8b 5b 24 31 ff 83 e3 20 89 de e8 6f a4 27 00 85 db 0f 85 ce 00 00 00 e8 c2 a2 27 00 <0f> 0b e9 33 f7 ff ff e8 b6 a2 27 00 0f 0b e9 ac f6 ff ff e8 aa a2
RSP: 0018:ffffc90006e67a08 EFLAGS: 00010012
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc900115d4000
RDX: 00000000000001e4 RSI: ffffffff814b91ce RDI: 0000000000000005
RBP: 0000000000000040 R08: ffff88804de08480 R09: fffffbfff191fae9
R10: ffffffff8c8fd743 R11: fffffbfff191fae8 R12: ffff88804c7d4aa0
R13: ffff88809c6f3000 R14: ffff88809c6f3000 R15: 0000000000000040
 queue_work_on+0x18b/0x200 kernel/workqueue.c:1517
 queue_work include/linux/workqueue.h:507 [inline]
 hci_sock_sendmsg+0x1339/0x2020 net/bluetooth/hci_sock.c:1812
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x289/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1907 [inline]
 new_sync_write+0x4a2/0x700 fs/read_write.c:484
 __vfs_write+0xc9/0x100 fs/read_write.c:497
 vfs_write+0x268/0x5d0 fs/read_write.c:559
 ksys_write+0x1ee/0x250 fs/read_write.c:612
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f776510fc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000050d580 RCX: 000000000045ca29
RDX: 0000000000000004 RSI: 0000000020000100 RDI: 000000000000000b
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000d1d R14: 00000000004cf706 R15: 00007f77651106d4
Shutting down cpus with NMI
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
