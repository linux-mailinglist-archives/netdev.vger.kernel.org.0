Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9BE40BEB6
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 06:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbhIOEGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 00:06:43 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42985 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhIOEGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 00:06:42 -0400
Received: by mail-io1-f71.google.com with SMTP id i78-20020a6b3b51000000b005b8dd0f9e76so875920ioa.9
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 21:05:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nBZctcuA6PoSbBL+JbZ6XlzKTsiTUDX/XLRhUzSrPzc=;
        b=lx7AT/mOLObJQihljDp7XvvKJ/Dm22C8hkqYhZoKeyLpA6/2B9MS787bW+7SRMOij8
         xH0QG1zjb+pYp/UTUbG4uGHxcZpGqzl1/+kOeIkOoyTgJNvTMRIPQKnPtj5tJRGra+2b
         fxZTMW1eY645ip0BSqGcXOmuGFGsYCu2feLFQ7Lq3hfm4RtzK+aja+50Ir9LyqEm20aY
         HncFOA55Y30fEqjg456jj2UR9nUyMT8qHZaS8K+5MBGYessKZjOmDmr1iJFnRu4OPfur
         WuAWvDsa4Cl3F5MAB7N3ehBcbPpiizwgfBic1iMIwdcWNNLPZWzYSGzKAbPuxrhG8/pR
         mnUw==
X-Gm-Message-State: AOAM532dMqpUgQ46ERE7F/LlTf8wxulP0FQWfTY/SDPBWp7WIkaqns4Q
        VxuKke6hFRgghFjWsHOZb9ZR4Do3QA2iWO/tvg6cXhVALgCA
X-Google-Smtp-Source: ABdhPJyMGSMwy5x4QqGsQDE0jQwry0QdwUVwIjXi7gFrYW8cbZlls3cakaBu+Fy5boFQjTl9UOHLHeiukPTXC7mZd37cTarhp8Ur
MIME-Version: 1.0
X-Received: by 2002:a6b:7f42:: with SMTP id m2mr17096295ioq.86.1631678724242;
 Tue, 14 Sep 2021 21:05:24 -0700 (PDT)
Date:   Tue, 14 Sep 2021 21:05:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf031105cc00ced8@google.com>
Subject: [syzbot] WARNING in mptcp_sendmsg_frag
From:   syzbot <syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f306b90c69ce Merge tag 'smp-urgent-2021-09-12' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10694371300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2bfb13fa4527da4e
dashboard link: https://syzkaller.appspot.com/bug?extid=263a248eec3e875baa7b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 810 at net/mptcp/protocol.c:1366 mptcp_sendmsg_frag+0x1362/0x1bc0 net/mptcp/protocol.c:1366
Modules linked in:
CPU: 1 PID: 810 Comm: syz-executor.4 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mptcp_sendmsg_frag+0x1362/0x1bc0 net/mptcp/protocol.c:1366
Code: ff 4c 8b 74 24 50 48 8b 5c 24 58 e9 0f fb ff ff e8 13 44 8b f8 4c 89 e7 45 31 ed e8 98 57 2e fe e9 81 f4 ff ff e8 fe 43 8b f8 <0f> 0b 41 bd ea ff ff ff e9 6f f4 ff ff 4c 89 e7 e8 b9 8e d2 f8 e9
RSP: 0018:ffffc9000531f6a0 EFLAGS: 00010216
RAX: 000000000000697f RBX: 0000000000000000 RCX: ffffc90012107000
RDX: 0000000000040000 RSI: ffffffff88eac9e2 RDI: 0000000000000003
RBP: ffff888078b15780 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff88eac017 R11: 0000000000000000 R12: ffff88801de0a280
R13: 0000000000006b58 R14: ffff888066278280 R15: ffff88803c2fe9c0
FS:  00007fd9f866e700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faebcb2f718 CR3: 00000000267cb000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __mptcp_push_pending+0x1fb/0x6b0 net/mptcp/protocol.c:1547
 mptcp_release_cb+0xfe/0x210 net/mptcp/protocol.c:3003
 release_sock+0xb4/0x1b0 net/core/sock.c:3206
 sk_stream_wait_memory+0x604/0xed0 net/core/stream.c:145
 mptcp_sendmsg+0xc39/0x1bc0 net/mptcp/protocol.c:1749
 inet6_sendmsg+0x99/0xe0 net/ipv6/af_inet6.c:643
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 sock_write_iter+0x2a0/0x3e0 net/socket.c:1057
 call_write_iter include/linux/fs.h:2163 [inline]
 new_sync_write+0x40b/0x640 fs/read_write.c:507
 vfs_write+0x7cf/0xae0 fs/read_write.c:594
 ksys_write+0x1ee/0x250 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665f9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd9f866e188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665f9
RDX: 00000000000e7b78 RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 0000000000a9fb1f R14: 00007fd9f866e300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
