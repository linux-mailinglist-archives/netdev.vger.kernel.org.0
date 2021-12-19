Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C949E47A110
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 15:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhLSO60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 09:58:26 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:36579 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbhLSO6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 09:58:25 -0500
Received: by mail-il1-f199.google.com with SMTP id y15-20020a056e02174f00b002a4222f24a5so3823051ill.3
        for <netdev@vger.kernel.org>; Sun, 19 Dec 2021 06:58:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=CY/9VdSz1ThPgCrPjZ1XFd+/699S54NLZB3w9+WFkH4=;
        b=v3kUid3LnSyvu6qJTSr1vHl4juCsV2UWYXGxE9GRjq4NV3MlZUbExUznfjyhbXJnE/
         JDQD2UlklnFi9pzo7EsS5zi+Hw1LwNhwfBCiWBlLAD7FtRa/3eD7XYVEf4c6E2kF0a5u
         gUcrq20yNnAYW0Kmj0gPeo+MGH/TyjYFiFpbM49rdpZZVjR/1YhDrkuCk8vcBY2wkSVy
         dUOlH8+eiYJkvpA7nTbNoZq20UkAu6FleKWwCXDJth3hyQFPiETQLNTOwFIrfJYEd0jV
         dXBTKGi/mBz/nCQGrXrMnZ+7EB96nkXRSyzo4jDrW83SLhlvJ+zpr46Pv5uD/jqt5Vgr
         LZEw==
X-Gm-Message-State: AOAM533L17r7L1yCFhnzxoBbNrQgaZr5Izh3F9Y+cOu6MFrUHhjziVC5
        SuzdU/fz6Q/QRF8qsBwxaNFWTTE6Szn/PlxmCCLl9nY9WElY
X-Google-Smtp-Source: ABdhPJwzNLsoeeAfdmwjWTnf9uSyo0WhvDuBeMw2KN9Mm6jfVFvRlaP/Wnf8+5Xjhj1th0EaajGUokTibZG78sb05v5gRQpVsF56
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1541:: with SMTP id j1mr6201080ilu.100.1639925904927;
 Sun, 19 Dec 2021 06:58:24 -0800 (PST)
Date:   Sun, 19 Dec 2021 06:58:24 -0800
In-Reply-To: <00000000000062b41d05a2ea82b0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000005721f05d3810165@google.com>
Subject: Re: [syzbot] kernel BUG at net/phonet/socket.c:LINE!
From:   syzbot <syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com>
To:     courmisch@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    60ec7fcfe768 qlcnic: potential dereference null pointer of..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11b3505db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa556098924b78f0
dashboard link: https://syzkaller.appspot.com/bug?extid=2dc91e7fc3dea88b1e8a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168791cdb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a0cbcdb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com

netlink: 'syz-executor185': attribute type 2 has an invalid length.
------------[ cut here ]------------
kernel BUG at net/phonet/socket.c:213!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 3620 Comm: syz-executor185 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline] net/phonet/socket.c:202
RIP: 0010:pn_socket_autobind+0x13c/0x160 net/phonet/socket.c:202 net/phonet/socket.c:202
Code: 44 05 00 00 00 00 00 48 8b 44 24 58 65 48 2b 04 25 28 00 00 00 75 26 48 83 c4 60 44 89 e0 5b 5d 41 5c 41 5d c3 e8 64 60 1e f9 <0f> 0b e8 2d 25 65 f9 eb 9f e8 46 25 65 f9 e9 6d ff ff ff e8 8c 2b
RSP: 0018:ffffc90001bafc40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801c748000 RSI: ffffffff8859516c RDI: 0000000000000003
RBP: 1ffff92000375f88 R08: 00000000ffffffea R09: 0000000000000000
R10: ffffffff8859512c R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88801c748000
FS:  0000555556878300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000740 CR3: 0000000018a78000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 pn_socket_connect+0xfc/0x970 net/phonet/socket.c:227 net/phonet/socket.c:227
 __sys_connect_file+0x155/0x1a0 net/socket.c:1896 net/socket.c:1896
 __sys_connect+0x161/0x190 net/socket.c:1913 net/socket.c:1913
 __do_sys_connect net/socket.c:1923 [inline]
 __se_sys_connect net/socket.c:1920 [inline]
 __do_sys_connect net/socket.c:1923 [inline] net/socket.c:1920
 __se_sys_connect net/socket.c:1920 [inline] net/socket.c:1920
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1920 net/socket.c:1920
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_x64 arch/x86/entry/common.c:50 [inline] arch/x86/entry/common.c:80
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9bf1080159
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 41 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1adca428 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007f9bf1080159
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000013355
R13: 00007fff1adca490 R14: 00007fff1adca480 R15: 00007fff1adca44c
 </TASK>
Modules linked in:
---[ end trace 16a4e3e11e1ba5b9 ]---
RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline] net/phonet/socket.c:202
RIP: 0010:pn_socket_autobind+0x13c/0x160 net/phonet/socket.c:202 net/phonet/socket.c:202
Code: 44 05 00 00 00 00 00 48 8b 44 24 58 65 48 2b 04 25 28 00 00 00 75 26 48 83 c4 60 44 89 e0 5b 5d 41 5c 41 5d c3 e8 64 60 1e f9 <0f> 0b e8 2d 25 65 f9 eb 9f e8 46 25 65 f9 e9 6d ff ff ff e8 8c 2b
RSP: 0018:ffffc90001bafc40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801c748000 RSI: ffffffff8859516c RDI: 0000000000000003
RBP: 1ffff92000375f88 R08: 00000000ffffffea R09: 0000000000000000
R10: ffffffff8859512c R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88801c748000
FS:  0000555556878300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000740 CR3: 0000000018a78000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

