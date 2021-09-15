Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D650F40CA8B
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhIOQlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:41:47 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51914 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhIOQlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:41:45 -0400
Received: by mail-io1-f70.google.com with SMTP id i11-20020a056602134b00b005be82e3028bso2333268iov.18
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 09:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=JKOXM3JGzxLlPHPJi+XJmgy9wU3yxfezlaCgrIxp3Y8=;
        b=GbXc3ZH3FKrWTXZ83vC2+wk3TdAEQRxd95hir0YXPtsoZkIL360BQnIP4qnwxDYdxr
         ZQZHKJSIzwOoUJEt1/Mk56Qa9Zr6ChjpRM6ql93Uuvr6btXS/O0JFpMb2PxwyUEEEBU7
         RNuBVkGoYqY/uIzylFhGjxKDmYemWdGo1aU5aHKhIiYsh08XJGGnYTkw/0K+YGNknDUz
         fFvyfUSVi7jztvOAU/knJUURqAXQIOX8Bdv804HpsyewKjpDE/eV3CMNNHM4zgDm6unX
         i6DTtopKRALVDoMdIBgxj1E0oMiF1z/oFKCzSgLpj6nL+XJR6xHhT02zxEDAcUQktXv3
         BzaQ==
X-Gm-Message-State: AOAM532ifu3lqg53QTWvPvHDphA99lEr0WV0dvIbvr+fyjFLVN+d/tuC
        p48B4+TLe4tyt4hDttZLKo9Q/28tOXNOC/ACTBOpi+JWueXx
X-Google-Smtp-Source: ABdhPJyfqKzWRBgw+12y6+VHdVaoIy7XpOGr2lePCKUrkJy7xgLzyNCOwECznCI/W7pcCr8UgXom5LAutbz4R+udP8SWJr6ak7Lf
MIME-Version: 1.0
X-Received: by 2002:a6b:5c0c:: with SMTP id z12mr764703ioh.171.1631724026177;
 Wed, 15 Sep 2021 09:40:26 -0700 (PDT)
Date:   Wed, 15 Sep 2021 09:40:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3aadf05cc0b5a3d@google.com>
Subject: [syzbot] WARNING in ext4_evict_inode (2)
From:   syzbot <syzbot+80d413b5e0bdc4e192ba@syzkaller.appspotmail.com>
To:     adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    08dad2f4d541 net: stmmac: allow CSR clock of 300MHz
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=159f1853300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e23f04679ec35e
dashboard link: https://syzkaller.appspot.com/bug?extid=80d413b5e0bdc4e192ba
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80d413b5e0bdc4e192ba@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9028 at fs/ext4/inode.c:230 ext4_evict_inode+0xf9a/0x1950 fs/ext4/inode.c:230
Modules linked in:
CPU: 1 PID: 9028 Comm: syz-executor.5 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ext4_evict_inode+0xf9a/0x1950 fs/ext4/inode.c:230
Code: 28 41 bc 01 00 00 00 48 89 04 24 e9 60 f6 ff ff c7 44 24 24 06 00 00 00 c7 44 24 20 06 00 00 00 e9 df f6 ff ff e8 56 ad 62 ff <0f> 0b e9 c6 f5 ff ff e8 7a ee a9 ff e9 60 f1 ff ff 48 89 cf e8 6d
RSP: 0018:ffffc90000f2fca0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 1ffff920001e5f9a RCX: 0000000000000000
RDX: ffff88807ef11c80 RSI: ffffffff8213640a RDI: 0000000000000003
RBP: ffff888042a282a0 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff821359ce R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: ffff88814050ab60 R15: ffff8880414e4038
FS:  000000000230a400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32643000 CR3: 000000005087c000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 evict+0x2ed/0x6b0 fs/inode.c:586
 iput_final fs/inode.c:1662 [inline]
 iput.part.0+0x539/0x850 fs/inode.c:1688
 iput+0x58/0x70 fs/inode.c:1678
 do_unlinkat+0x418/0x650 fs/namei.c:4176
 __do_sys_unlink fs/namei.c:4217 [inline]
 __se_sys_unlink fs/namei.c:4215 [inline]
 __x64_sys_unlink+0xc6/0x110 fs/namei.c:4215
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465f37
Code: 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd277ea528 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000465f37
RDX: 00007ffd277ea560 RSI: 00007ffd277ea560 RDI: 00007ffd277ea5f0
RBP: 00007ffd277ea5f0 R08: 0000000000000001 R09: 00007ffd277ea3c0
R10: 000000000230b89b R11: 0000000000000206 R12: 00000000004bee90
R13: 00007ffd277eb6c0 R14: 000000000230b810 R15: 00007ffd277eb700


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
