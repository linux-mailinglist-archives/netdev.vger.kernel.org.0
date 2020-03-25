Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E427C1934C4
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgCYXxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:53:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:55681 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727420AbgCYXxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:53:17 -0400
Received: by mail-il1-f199.google.com with SMTP id h10so3653298ilq.22
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 16:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=UNj2qoNp2EDsJduyq1HEeQOiY3pxbpZumTQii8yfjlU=;
        b=gXhgUgh4iW1RjZfG653oivFs0/gFQH5T4pxfTUTpvpeTEBA+mvXES6VZ0FOzywHNrn
         2+F2lb7LjaE7XpdWFLQoZQcsxd+xkJDXBW/sSqWU2mYjHXmTENS/I0JZ3XVbzfEDOq7m
         qt3tOcZnBJmXcySmI3pDHjrQ898ocvr6oVhPHqKkgn0x+ouuwpIHtIhohdiJZ+MnkSZS
         asSvFSP0Xm+oS7wgxk1591/CUiJq+iw6AlgYQgz9HHNKO9TmzKDOFNK8mM4bTIBd8Lpf
         KmVfkpRRWGUWsz8VoClzy2X8Bei1fX6AxQKqasT+2ZUNEtwu9kWLKU/Xx0eZNnBDCPQv
         p9AA==
X-Gm-Message-State: ANhLgQ1m5bMaMqlmOxl1825YuzU+4gUJqNzZrq5dmkR2al+CE3rzsdai
        h2dXzCkXqhc2+JbBXoXSmZDw2NJ2eWvETkbq64k9YYwi0qJR
X-Google-Smtp-Source: ADFU+vvagsNoX0oJkZQjuoypra4R0dtpTSblri6+fSiMlfyRYg9bqvbHPwT+F5fSS7hidwGJX6GAKOdsLZyJ7UUGiWnLEGRrgUDL
MIME-Version: 1.0
X-Received: by 2002:a02:740d:: with SMTP id o13mr5164814jac.113.1585180395611;
 Wed, 25 Mar 2020 16:53:15 -0700 (PDT)
Date:   Wed, 25 Mar 2020 16:53:15 -0700
In-Reply-To: <000000000000269a1405a12fdc77@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000062ad2005a1b69253@google.com>
Subject: Re: WARNING in kcm_write_msgs
From:   syzbot <syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com>
To:     andriin@fb.com, anenbupt@gmail.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, info@metux.net, jonathan.lemon@gmail.com,
        jslaby@suse.cz, kafai@fb.com, kstewart@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, samitolvanen@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, willy@infradead.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    29f3490b net: use indirect call wrappers for skb_copy_data..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12876b91e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8d5bbd990b8ab319
dashboard link: https://syzkaller.appspot.com/bug?extid=52624bdfbf2746d37d70
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1394bd39e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10da50ade00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+52624bdfbf2746d37d70@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 11822 at net/kcm/kcmsock.c:628 kcm_write_msgs+0xfb6/0x1760 net/kcm/kcmsock.c:628
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 11822 Comm: syz-executor408 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:kcm_write_msgs+0xfb6/0x1760 net/kcm/kcmsock.c:628
Code: fa 48 c1 ea 03 80 3c 02 00 0f 85 5e 05 00 00 48 8b 44 24 50 45 31 e4 48 8b 74 24 08 48 89 70 10 e9 95 f4 ff ff e8 7a 8a 53 fa <0f> 0b 41 bc ea ff ff ff e9 83 f4 ff ff e8 68 8a 53 fa 0f 0b e9 1c
RSP: 0018:ffffc900015e7978 EFLAGS: 00010293
RAX: ffff888085688240 RBX: ffff88808571e800 RCX: ffffffff871e8c3c
RDX: 0000000000000000 RSI: ffffffff871e9496 RDI: 0000000000000001
RBP: 0000000000000000 R08: ffff888085688240 R09: fffffbfff185158c
R10: fffffbfff185158b R11: ffffffff8c28ac5f R12: 0000000000008000
R13: ffff8880a65b96c0 R14: 00000000000000c0 R15: ffff8880a6fe6d40
 kcm_sendmsg+0x1b67/0x2129 net/kcm/kcmsock.c:1034
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 sock_write_iter+0x283/0x3c0 net/socket.c:1004
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x49c/0x700 fs/read_write.c:483
 __vfs_write+0xc9/0x100 fs/read_write.c:496
 vfs_write+0x262/0x5c0 fs/read_write.c:558
 ksys_write+0x1e8/0x250 fs/read_write.c:611
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446b79
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 5b 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2e8f3e5d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00000000006dbc48 RCX: 0000000000446b79
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00000000006dbc40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc4c
R13: 00000000200003c0 R14: 00000000004aea28 R15: 000000000000d4f5
Kernel Offset: disabled
Rebooting in 86400 seconds..

