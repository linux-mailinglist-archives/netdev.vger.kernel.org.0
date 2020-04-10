Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3B61A42D8
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 09:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgDJHQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 03:16:19 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:55491 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDJHQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 03:16:18 -0400
Received: by mail-io1-f72.google.com with SMTP id k5so1242271ioa.22
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 00:16:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Va41vCtvpJZisksuHvVDpuLd/Rd1sssyCkB242NnNGQ=;
        b=KQXgDOhW1pm28rydM86q+0/x5SbUKgm9gDbZ0m/we6uuiIudhjCncZ0oNtYm/V16Q5
         TiHDdO/q+BwsOJQz/e3nIuQT3y1rLrIgx4abMhqzEKu6MjzZpRV/ioRHWy9fBDlqHZ0a
         svgP+AqjhRZdDbIWPi9GL/Fi5WlzJuepXknJneTCyFu+Bo0KptC2Gaw08CPuw+FZD+LT
         lf+nYF8j5kc+wfhmGFEvbQ5wlqk5olBFA40Uf8cmNjFpRiIj9TkFu65pMtLg4PBercQA
         OH4WuLV5yxiY28iOl56TxYCR+R9GBYs5DLU01USDonQW55h4l/Rk+eC6shkO4f8n0wYB
         cbYQ==
X-Gm-Message-State: AGi0PuYrwiykTsmDgOjf1QJNe4hja8VVbw4Pm9S5TRq4o22KjCjebfF8
        bNPOuept4uzZZpIKVaD9nnC35YT2xhqZkTH9F+bXlTWHk3dt
X-Google-Smtp-Source: APiQypJsBLCzuIkaeKYVj/JlyPLH02vMu9k+P5xojN8On9gjQIs7qU4oaOBRVKQO2oxrTjw+nk8AnO5BAoZFDNfMMH+ydMj1so2c
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2402:: with SMTP id s2mr3083214ioa.69.1586502977104;
 Fri, 10 Apr 2020 00:16:17 -0700 (PDT)
Date:   Fri, 10 Apr 2020 00:16:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000062b41d05a2ea82b0@google.com>
Subject: kernel BUG at net/phonet/socket.c:LINE!
From:   syzbot <syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com>
To:     courmisch@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b93cfb9c net: icmp6: do not select saddr from iif when rou..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13501d2be00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94a7f1dec460ee83
dashboard link: https://syzkaller.appspot.com/bug?extid=2dc91e7fc3dea88b1e8a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2dc91e7fc3dea88b1e8a@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at net/phonet/socket.c:213!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8394 Comm: syz-executor.4 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
RIP: 0010:pn_socket_autobind+0x13c/0x160 net/phonet/socket.c:202
Code: 44 05 00 00 00 00 00 44 89 e0 48 8b 4c 24 58 65 48 33 0c 25 28 00 00 00 75 23 48 83 c4 60 5b 5d 41 5c 41 5d c3 e8 b4 ad 41 fa <0f> 0b e8 9d 56 7f fa eb 9f e8 b6 56 7f fa e9 6d ff ff ff e8 0c dd
RSP: 0018:ffffc900034cfda8 EFLAGS: 00010212
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90011d66000
RDX: 0000000000000081 RSI: ffffffff873183dc RDI: 0000000000000003
RBP: 1ffff92000699fb5 R08: ffff8880620f61c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f84223c9700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004d8730 CR3: 000000005cce0000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 pn_socket_listen+0x40/0x200 net/phonet/socket.c:399
 __sys_listen+0x17d/0x250 net/socket.c:1696
 __do_sys_listen net/socket.c:1705 [inline]
 __se_sys_listen net/socket.c:1703 [inline]
 __x64_sys_listen+0x50/0x70 net/socket.c:1703
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f84223c8c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000032
RAX: ffffffffffffffda RBX: 00007f84223c96d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 000000000000007d RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000712 R14: 00000000004c9e2d R15: 000000000076bf0c
Modules linked in:
---[ end trace 65d6f1331216c544 ]---
RIP: 0010:pn_socket_autobind net/phonet/socket.c:213 [inline]
RIP: 0010:pn_socket_autobind+0x13c/0x160 net/phonet/socket.c:202
Code: 44 05 00 00 00 00 00 44 89 e0 48 8b 4c 24 58 65 48 33 0c 25 28 00 00 00 75 23 48 83 c4 60 5b 5d 41 5c 41 5d c3 e8 b4 ad 41 fa <0f> 0b e8 9d 56 7f fa eb 9f e8 b6 56 7f fa e9 6d ff ff ff e8 0c dd
RSP: 0018:ffffc900034cfda8 EFLAGS: 00010212
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90011d66000
RDX: 0000000000000081 RSI: ffffffff873183dc RDI: 0000000000000003
RBP: 1ffff92000699fb5 R08: ffff8880620f61c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f84223c9700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000076c000 CR3: 000000005cce0000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
