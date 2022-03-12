Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339854D700A
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 17:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiCLQ4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 11:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiCLQ4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 11:56:33 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E180C7030F
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 08:55:26 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id y18-20020a927d12000000b002c2e830dc22so6893584ilc.20
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 08:55:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mMqMjZRMdNsB5TgI8nqWKShNVoqokosTf5CqHmMYKW8=;
        b=1Q0dywqaE1A0dogE+JXEK+p8WkEpiKavFAOwAYeVAJuiJ04yQpUAMt/UMvPYQrievs
         Y3fH6wuBd6wt4v5wSmMiJgBNMVDwtSypshzyc/QrdlhrXmyLHP1+Reufi9MSnzISdh5m
         FTWQtBwlVTiXqogr9eXcJ9B8XMliFOztfFNIX6o+X3AaAQZ/w0JZpepo/rrJVsWA/z52
         KXqPayaZleCwASggGydCQZluEFw/o0MEq6FQufKpJDwSwrlEq3od58NgebHpfpuDtPee
         jO0DQTPH3d3RrO/COjrMTYau51TicEh8qJdTMRmuluYfQ7ygNxRHA0RU3KmlCX81JMb/
         /7Tw==
X-Gm-Message-State: AOAM533A3WTz0+nrhV4VNCEwOhj7y7vzOKI28Qzc7MntIjXHwDhGPLWU
        qh08OKsMYlkMp3vya7L5ys5KmAgVckjRn8OMdqZAyXOSr1L+
X-Google-Smtp-Source: ABdhPJxatX9MYmENW7/94qECJTfa+7KlO9kOOWvXR4aTZaOb1avXBVgGLdJ3rGX8IoMA+/oNkZ1Mq6I5lb6/1LYJXsrfVD1KFGgg
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:490:b0:2c7:94bc:8f1f with SMTP id
 b16-20020a056e02049000b002c794bc8f1fmr978692ils.227.1647104125455; Sat, 12
 Mar 2022 08:55:25 -0800 (PST)
Date:   Sat, 12 Mar 2022 08:55:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004e53a505da08501e@google.com>
Subject: [syzbot] WARNING in isotp_tx_timer_handler (2)
From:   syzbot <syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    46b348fd2d81 alx: acquire mutex for alx_reinit in alx_chan..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=15da96e5700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=442f8ac61e60a75e
dashboard link: https://syzkaller.appspot.com/bug?extid=2339c27f5c66c652843e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165c76ad700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=143da461700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 19 at net/can/isotp.c:852 isotp_tx_timer_handler+0x717/0xcd0 net/can/isotp.c:852
Modules linked in:
CPU: 1 PID: 19 Comm: ksoftirqd/1 Not tainted 5.17.0-rc7-syzkaller-00198-g46b348fd2d81 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:isotp_tx_timer_handler+0x717/0xcd0 net/can/isotp.c:852
Code: f9 44 0f b6 25 3b 23 56 05 31 ff 44 89 e6 e8 f0 56 4f f9 45 84 e4 0f 85 9d fa ff ff e9 4e 01 20 01 85 ed 75 52 e8 59 54 4f f9 <0f> 0b 45 31 e4 e8 4f 54 4f f9 48 8b 74 24 40 48 b8 00 00 00 00 00
RSP: 0018:ffffc90000d97c40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88806f490568 RCX: 0000000000000100
RDX: ffff888011945700 RSI: ffffffff88296bd7 RDI: 0000000000000003
RBP: 0000000000000000 R08: ffffffff8ac3c440 R09: ffffffff8829656f
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9d2a880 R14: ffff8880b9d2a600 R15: ffffffff882964c0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5c3133d1d8 CR3: 000000006b70d000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __run_hrtimer kernel/time/hrtimer.c:1685 [inline]
 __hrtimer_run_queues+0x609/0xe50 kernel/time/hrtimer.c:1749
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1766
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
