Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BE26DE608
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjDKUxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjDKUxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:53:06 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAC81BE6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:53:05 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id b3-20020a056602274300b007603d89cdc9so10685925ioe.2
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681246384; x=1683838384;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5FraGnenFeAHzE7pcyamjrVHwZFel3GRzsifdZZaBZA=;
        b=1+KYeGp1HoFS/iga+I7ElW9S32z+yEuEMWeoR2X+PrYHj4MwGIwUzYomTQ7U9YS6P+
         R/SyVst8hp+UGuuA3JMrSRJUhvaPD2cSQCP827/EzvmPPRz8CJFql92UqbuLdK06EPGc
         X2tv5BOfbpT5deiv+EBKnf8zExKfJgYHNYuXIgs2YLjFP6dGWuDgAA5AFd8lc6x0m4kM
         MheFIQL/J7IxE14YXny0NmaHKY4EaVOJSOYSyBgtycQmIZWs//gSJh46TgDgDpCrcZPx
         NB8t0sOFoTMTgea6uJFk5j3F09rXZaMzUJbTxrHQHdzKol7guxLLaskaufWgw+EDfhls
         hAJg==
X-Gm-Message-State: AAQBX9cHRScnA+MUHWj0/oPs2bKrxVqIYQVpzI6plxbvx3EaHNSjcOPe
        B55VWUPKw88HiiWoN2wf5QzJ9q0VHFYsa2WL4XXuPOwKfeFm
X-Google-Smtp-Source: AKy350a7rCOrUZbqRJzVQnelk1N+sOACB0HgSXGmodSV8jnGfJWPcTRqKf8bo2bKBsq849HWHQgGG7N2UXYD9lO76wpbblzK6C26
MIME-Version: 1.0
X-Received: by 2002:a02:8563:0:b0:3c5:1971:1b7b with SMTP id
 g90-20020a028563000000b003c519711b7bmr1537580jai.1.1681246384070; Tue, 11 Apr
 2023 13:53:04 -0700 (PDT)
Date:   Tue, 11 Apr 2023 13:53:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000080c6c805f915ade0@google.com>
Subject: [syzbot] [rds?] WARNING in rds_conn_connect_if_down
From:   syzbot <syzbot+d4faee732755bba9838e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        rds-devel@oss.oracle.com, santosh.shilimkar@oracle.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    b9881d9a761a Merge branch 'bonding-ns-validation-fixes'
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=123c531dc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d3500b143c204867
dashboard link: https://syzkaller.appspot.com/bug?extid=d4faee732755bba9838e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4b4a5a4a2f01/disk-b9881d9a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3d2bf6e2e9e/vmlinux-b9881d9a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/26469aa699ef/bzImage-b9881d9a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d4faee732755bba9838e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 21117 at net/rds/connection.c:933 rds_conn_connect_if_down+0x97/0xb0 net/rds/connection.c:933
Modules linked in:
CPU: 1 PID: 21117 Comm: syz-executor.3 Not tainted 6.3.0-rc5-syzkaller-00143-gb9881d9a761a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
RIP: 0010:rds_conn_connect_if_down+0x97/0xb0 net/rds/connection.c:933
Code: 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 25 48 8b bb 90 00 00 00 5b 5d e9 be fa ff ff e8 49 f9 2c f8 <0f> 0b eb c6 e8 f0 05 7e f8 eb aa e8 49 06 7e f8 eb 80 e8 42 06 7e
RSP: 0018:ffffc900055d7910 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880526ba5f0 RCX: 0000000000000000
RDX: ffff888027cb9d40 RSI: ffffffff8955de77 RDI: 0000000000000001
RBP: 0000000000000002 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: 00000000fffffff5
R13: 0000000000000008 R14: ffff88806fd2db00 R15: ffff88807644e4c0
FS:  00007f9b3b641700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002001e000 CR3: 0000000027523000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rds_sendmsg+0x2366/0x31a0 net/rds/send.c:1319
 sock_sendmsg_nosec net/socket.c:724 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:747
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9b3a88c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9b3b641168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9b3a9abf80 RCX: 00007f9b3a88c169
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007f9b3a8e7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe6c474d8f R14: 00007f9b3b641300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
