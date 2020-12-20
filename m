Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBEA42DF36B
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 04:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgLTDov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 22:44:51 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:51474 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgLTDou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Dec 2020 22:44:50 -0500
Received: by mail-il1-f200.google.com with SMTP id 1so6198125ilg.18
        for <netdev@vger.kernel.org>; Sat, 19 Dec 2020 19:44:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=UubbcTnFvAdUtoFBZ+hCLa1NkxHJbmCBB4mCfGjoNzc=;
        b=rwdq961JpKV9ykAVDulzVN6+AGKP5dGTT9fs5wbulbR97DGrHataDqpXk2DQIuzW4p
         9WrPQnZ1rEkUcF1DOixxQIsWVpsU7RSFMB6H/EVAlZ43aISmPuwSKVhSoYvoRIcgODJF
         m0iYsEFuSrQf5WtmnYN8ygIkeJsiELei6+/Z1pzvaDD1bfUesuLkQ1mwBiX+V/XXaWcH
         5onZzIZFZ/U9Qmw1C5CtG98jV2jOqSmnBFDj/u9Jp5i1FAd4JyOlbIm3ZjxCZ4NtEnUl
         Ygt2nqZJYRxrBdgdQJstdsmgWpMt/1sEUXG9mukqfAC/uUMN4E9VuGcyC51wz/VxunqK
         vl2A==
X-Gm-Message-State: AOAM531HDyhrETIE7WckkZBweUh8GRaI1pQfMU4/G0cQ8F+GR7Vwm024
        iaSqorKjmGaKXD4k7n2wO/yUFgZxSgLgN2bwmw9k8HTWg1eB
X-Google-Smtp-Source: ABdhPJwX8qhKyoJbSUGIjokthVh4nyAx842fsSvzfDHXWiEmnnqdEUEqxVEYbhdSZOaR0ktXGNs/z1Mse29eILcxDLbZtoHhmPI9
MIME-Version: 1.0
X-Received: by 2002:a02:c850:: with SMTP id r16mr10235491jao.18.1608435849939;
 Sat, 19 Dec 2020 19:44:09 -0800 (PST)
Date:   Sat, 19 Dec 2020 19:44:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007acf2605b6dd2767@google.com>
Subject: WARNING in ext4_evict_inode
From:   syzbot <syzbot+f3e5bd9358af6c9a28c5@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3db1a3fa Merge tag 'staging-5.11-rc1' of git://git.kernel...
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15c2f30f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2764fc28a92339f9
dashboard link: https://syzkaller.appspot.com/bug?extid=f3e5bd9358af6c9a28c5
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f3e5bd9358af6c9a28c5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8514 at fs/ext4/inode.c:229 ext4_evict_inode+0x112c/0x1800 fs/ext4/inode.c:229
Modules linked in:
CPU: 1 PID: 8514 Comm: syz-executor.1 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ext4_evict_inode+0x112c/0x1800 fs/ext4/inode.c:229
Code: 05 72 d6 d3 0a 01 e8 ea 75 ae 06 e9 08 f5 ff ff c7 44 24 2c 06 00 00 00 c7 44 24 28 06 00 00 00 e9 9f f6 ff ff e8 54 29 6b ff <0f> 0b e9 34 f4 ff ff e8 48 29 6b ff e8 73 07 57 ff 31 ff 41 89 c5
RSP: 0018:ffffc9000166fcb8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 1ffff920002cdf9e RCX: ffffffff8205683e
RDX: ffff8880125fb580 RSI: ffffffff8205740c RDI: 0000000000000005
RBP: ffff888059bf0338 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888015bb1070 R14: ffffffff895fec20 R15: ffff888059bf4b00
FS:  000000000258e940(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30522000 CR3: 0000000047a9c000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 evict+0x2ed/0x750 fs/inode.c:578
 iput_final fs/inode.c:1654 [inline]
 iput.part.0+0x3fe/0x820 fs/inode.c:1680
 iput+0x58/0x70 fs/inode.c:1670
 do_unlinkat+0x40b/0x660 fs/namei.c:3903
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45dea7
Code: 00 66 90 b8 58 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 8d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff0cd52098 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000045dea7
RDX: 00007fff0cd520b0 RSI: 00007fff0cd520b0 RDI: 00007fff0cd52140
RBP: 0000000000000714 R08: 0000000000000000 R09: 000000000000001b
R10: 0000000000000015 R11: 0000000000000246 R12: 00007fff0cd531d0
R13: 000000000258fa60 R14: 0000000000000000 R15: 00000000000ab9e5


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
