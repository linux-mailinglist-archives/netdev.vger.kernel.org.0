Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C560591F7D
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 12:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiHNKPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 06:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiHNKPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 06:15:31 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52F062E4
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 03:15:24 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id g22-20020a056602249600b0067caba4f24bso2816741ioe.4
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 03:15:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=w0hoHg3TbMYWdBZvCWa1MXVGk3Q6OCdDphfaLKbCXns=;
        b=NA7emVkcUF8qTn2/xnjGeFRmti4l6II6EQDoex5m03b+mrXbL9jJKPTcXlnoE/Uidf
         s3yF3AgotfsZ9NYlnsWAqLwt9ND9b+lN2NsUzwJApjImNMKp5f2ckqLzsXa+gVhTJvBm
         8AHvbN61bts6hJSsw2iL8P8uxW2D/hfVcuvk6xE+vF02cK+dWAdEy/QUftTOfjmiGY77
         sAsb6H8+q1v+f5RFfl1H4fCGILpoIfNqunD3xvB2NALSr1LjtETmtKyNU0SMSDUpjVuX
         CQwOTrRr7/M/wwyKRmjT9A9w9spGhst3pOYRMUC032REeHtBAgIa7QjqXyDv43NRf0gj
         u+jw==
X-Gm-Message-State: ACgBeo3zcceGcEEqyZ2dAvPsM14P5YftYGXyq4/2QMTbb6zL3anuFLem
        3WCSmyprdfOrloNVBulHPYyBQHrORrdnxy7h+WULkZGMLZ0I
X-Google-Smtp-Source: AA6agR6WSWmJvOc2lFzZuiT+Cgj9AhTkS6f88868nMz89N8y/eMHHUYWQajSeUTKC8y5D/kVD4NBM6A0LZlgQ5Cqk8n/h6sTjf8g
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3c8:b0:672:4e60:7294 with SMTP id
 g8-20020a05660203c800b006724e607294mr4631837iov.17.1660472124022; Sun, 14 Aug
 2022 03:15:24 -0700 (PDT)
Date:   Sun, 14 Aug 2022 03:15:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ca53e05e630cb63@google.com>
Subject: [syzbot] WARNING in tls_strp_done
From:   syzbot <syzbot+abd45eb849b05194b1b6@syzkaller.appspotmail.com>
To:     borisp@nvidia.com, davem@davemloft.net, edumazet@google.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10545c6b080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=924833c12349a8c0
dashboard link: https://syzkaller.appspot.com/bug?extid=abd45eb849b05194b1b6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164c98cb080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15497dc3080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+abd45eb849b05194b1b6@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3611 at kernel/workqueue.c:3066 __flush_work+0x926/0xb10 kernel/workqueue.c:3066
Modules linked in:
CPU: 0 PID: 3611 Comm: syz-executor165 Not tainted 5.19.0-syzkaller-13930-g7ebfc85e2cd7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:__flush_work+0x926/0xb10 kernel/workqueue.c:3066
Code: 00 48 c7 c6 0b 12 4f 81 48 c7 c7 40 92 f8 8b e8 30 61 10 00 e9 66 fc ff ff e8 d6 f4 2c 00 0f 0b e9 5a fc ff ff e8 ca f4 2c 00 <0f> 0b 45 31 f6 e9 4b fc ff ff e8 0b 4c 79 00 e9 3a fb ff ff e8 b1
RSP: 0018:ffffc900038bf948 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888020f0a8f0 RCX: 0000000000000000
RDX: ffff88801bd50000 RSI: ffffffff814f1246 RDI: 0000000000000001
RBP: ffffc900038bfae0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: 1ffff92000717f5f R14: 0000000000000001 R15: ffff888020f0a908
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555559cb5d0 CR3: 000000000bc8e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __cancel_work_timer+0x3f9/0x570 kernel/workqueue.c:3162
 tls_strp_done+0x66/0x230 net/tls/tls_strp.c:478
 tls_sk_proto_close+0x40d/0xaf0 net/tls/tls_main.c:328
 inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:482
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x277/0x9d0 fs/file_table.c:320
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xad5/0x29b0 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0b52a2fdf9
Code: Unable to access opcode bytes at RIP 0x7f0b52a2fdcf.
RSP: 002b:00007fffd86d4c68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f0b52aa43f0 RCX: 00007f0b52a2fdf9
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000001
R10: 00000000200004c0 R11: 0000000000000246 R12: 00007f0b52aa43f0
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
