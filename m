Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41F66DAB9F
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240596AbjDGKso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 06:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjDGKsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 06:48:43 -0400
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84E8A6B
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 03:48:40 -0700 (PDT)
Received: by mail-il1-f208.google.com with SMTP id l10-20020a056e0205ca00b00322fdda7261so27398146ils.6
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 03:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680864520; x=1683456520;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BAuuzHM2ZZ1qgOBKBHermM1gtIcX6DrejC87Vc77SWs=;
        b=CtCG4/w/wEQalODMN/dswlRV8JIWqaxAxKwaE10XZg/e67Hc90ocpfVZNdoEHldMo8
         VwtiNrG22UGaeY1xtuH4p0K+/QnvRyrmbaWxQqKCzRHaY5/c5yEiwV4T3qhXylxcIYO0
         6V9vbD22q3uyRnHlp5wxMCI1hA6YZ0e/ZQ5+VEU3UZ1tYNeekL6LDBAt/e/EGM5RpSwY
         rPn2LNQ1N7fcSwyBDeDhdzTsL9m60nQR84XeZ0zYeb3tx8oU53ayBJuw+D6VDrylsXN9
         huUCr1ilFz5zGL82K+IzX1oMfs0+L0x4jtH7xUecDy6I9lY6td3FgDxFnHX/zeOnrmaA
         D6mQ==
X-Gm-Message-State: AAQBX9d9Ubh3fseEE0uLJpD4pv4Wto7CA8VGdG0ivXjOvP4r/euC3YsD
        4mY1eYWD8kaem7ukjYrBo3ZxO1Tj/VwJbX/bdQiTu3boeBhE
X-Google-Smtp-Source: AKy350ZbnV0ItjWeqXRkukr8Bb70dQOxc2dsvFm1+L72OE1HukCIOjbVA+JWikgs9HjAJ0FwjG/XGUcWI0ondppXFWxS7EeCpDIi
MIME-Version: 1.0
X-Received: by 2002:a02:9426:0:b0:406:2cd0:a668 with SMTP id
 a35-20020a029426000000b004062cd0a668mr510401jai.2.1680864520168; Fri, 07 Apr
 2023 03:48:40 -0700 (PDT)
Date:   Fri, 07 Apr 2023 03:48:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a3f51805f8bcc43a@google.com>
Subject: [syzbot] [net?] WARNING in cleanup_net (2)
From:   syzbot <syzbot+7e1e1bdb852961150198@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f33642224e38 ptp_qoriq: fix memory leak in probe()
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=172977b1c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea09b0836073ee4
dashboard link: https://syzkaller.appspot.com/bug?extid=7e1e1bdb852961150198
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12d98a05c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170668b6c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/78d8ce56ac20/disk-f3364222.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7b38fccf6cb4/vmlinux-f3364222.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9cbf8fd0a81b/bzImage-f3364222.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7e1e1bdb852961150198@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 75 at lib/ref_tracker.c:39 spin_unlock_irqrestore include/linux/spinlock.h:405 [inline]
WARNING: CPU: 0 PID: 75 at lib/ref_tracker.c:39 ref_tracker_dir_exit+0x3a2/0x600 lib/ref_tracker.c:38
Modules linked in:
CPU: 0 PID: 75 Comm: kworker/u4:4 Not tainted 6.3.0-rc3-syzkaller-00148-gf33642224e38 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: netns cleanup_net
RIP: 0010:ref_tracker_dir_exit+0x3a2/0x600 lib/ref_tracker.c:39
Code: 0f 84 c3 fe ff ff e8 2d 3d 44 fd 44 89 ff e8 c5 f9 ff ff e9 b1 fe ff ff e8 1b 3d 44 fd 48 8b 74 24 10 4c 89 ef e8 de 99 c6 05 <0f> 0b e8 07 3d 44 fd 49 8d 6d 44 be 04 00 00 00 48 89 ef e8 e6 4e
RSP: 0018:ffffc90001577c00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff888075d29ed0 R08: 0000000000000001 R09: ffffffff914d9c6f
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888075d29ed0
R13: ffff888075d29e80 R14: ffff888075d29ed0 R15: ffff88802879edc8
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff1bdf8960 CR3: 000000002bed0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 net_free net/core/net_namespace.c:447 [inline]
 net_free net/core/net_namespace.c:441 [inline]
 cleanup_net+0x8bb/0xb10 net/core/net_namespace.c:634
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
