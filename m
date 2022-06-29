Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1733C56077B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiF2Rlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiF2Rla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:41:30 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024601FCFC
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 10:41:29 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id b5-20020a05660214c500b0067530b15cc1so5526461iow.9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 10:41:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=6SDrSV416B2lGD7UV7KuwPHR6Q1+M9ms85DHow9ZgVA=;
        b=uaGyvNBw3XM/Inr3fX4EQpfjjuc9viaACHN4aPCXRTP9EkjHmw1azCy71HN79QPZDe
         F3bCQM/i9ZCVDQ5w+bqEesLJMNuGSVQ/7NJHIEJy9pa1F893NUG1MQ6TdjdnR0Rj7eXj
         jUO15g6YgQu4q5bInXqu+lQtkzgOvIrButF8jnqTWz6zt9SmzF+DEPIQg84rdaIGjWlH
         X5azDr++mqzibNzyoHM0vs3+95Xx0Hhjsos9AFTmdPgM1DXhTm7CfnVcbZnpjP4HCCmG
         5LQiF4QhIvatf7A2Fqnuo1CnujR8wwBTjFPOF9otdW+AmknjI0CH7V6IonGG3hvOpUFJ
         zYjA==
X-Gm-Message-State: AJIora93tdUWy1j8c4gLOaHtgfb4IY8HV+/IKg5xyO0263pvWwyKgaco
        o+3G65pmY1GTVgu6bmqtXKVE51uO0TTlskaNXMJlSnElG4Se
X-Google-Smtp-Source: AGRyM1tWdVD/H6uOCMDyLnxGYUFAvs/eFZNjE24T/iHrbgfmyDNUlJff8paoMPSkgL8Oc/kqKuwui5fASzt8pNLzyCUUxZyYvi4l
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180d:b0:2d9:26a6:d016 with SMTP id
 a13-20020a056e02180d00b002d926a6d016mr2548662ilv.170.1656524488336; Wed, 29
 Jun 2022 10:41:28 -0700 (PDT)
Date:   Wed, 29 Jun 2022 10:41:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b06e5505e299a9b6@google.com>
Subject: [syzbot] WARNING in sk_stream_kill_queues (8)
From:   syzbot <syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        weiwan@google.com
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

HEAD commit:    aab35c3d5112 Add linux-next specific files for 20220627
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=126fef90080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a874f114a1e4a6b
dashboard link: https://syzkaller.appspot.com/bug?extid=a0e6f8738b58f7654417
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae0c98080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145124f4080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a0e6f8738b58f7654417@syzkaller.appspotmail.com

nf_conntrack: default automatic helper assignment has been turned off for security reasons and CT-based firewall rule not found. Use the iptables CT target to attach helpers instead.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 3601 at net/core/stream.c:205 sk_stream_kill_queues+0x2ee/0x3d0 net/core/stream.c:205
Modules linked in:
CPU: 1 PID: 3601 Comm: syz-executor340 Not tainted 5.19.0-rc4-next-20220627-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:sk_stream_kill_queues+0x2ee/0x3d0 net/core/stream.c:205
Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e ec 00 00 00 8b ab 28 02 00 00 e9 60 ff ff ff e8 3b 9a 29 fa 0f 0b eb 97 e8 32 9a 29 fa <0f> 0b eb a0 e8 29 9a 29 fa 0f 0b e9 6a fe ff ff e8 0d a1 75 fa e9
RSP: 0018:ffffc90002e6fbf0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801e90ba80 RSI: ffffffff87511cce RDI: 0000000000000005
RBP: 0000000000000b00 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000b00 R11: 0000000000000004 R12: ffff88801e0c8e28
R13: ffffffff913121c0 R14: ffff88801e0c8c28 R15: ffff88801e0c8db8
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000045b630 CR3: 000000000ba8e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 inet_csk_destroy_sock+0x1a5/0x440 net/ipv4/inet_connection_sock.c:1013
 __tcp_close+0xb92/0xf50 net/ipv4/tcp.c:2963
 tcp_close+0x29/0xc0 net/ipv4/tcp.c:2975
 inet_release+0x12e/0x270 net/ipv4/af_inet.c:428
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xaf1/0x29f0 kernel/exit.c:795
 do_group_exit+0xd2/0x2f0 kernel/exit.c:925
 __do_sys_exit_group kernel/exit.c:936 [inline]
 __se_sys_exit_group kernel/exit.c:934 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f080e760989
Code: Unable to access opcode bytes at RIP 0x7f080e76095f.
RSP: 002b:00007ffcee785818 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f080e7d4270 RCX: 00007f080e760989
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000010
R10: 0000000000000010 R11: 0000000000000246 R12: 00007f080e7d4270
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
