Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F91689E3A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjBCP0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBCP0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:26:14 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A62D6E9E
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 07:25:57 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id d24-20020a5d9bd8000000b006ee2ddf6d77so3144415ion.6
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 07:25:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EHjP5dfR9Ow+ioYk300iIkLbnvj6S7nts5OSIV/AWLo=;
        b=Us1KAEkVxADcFtLRytwc67wd8xDjz/2uTGOLmdEX+iEy5//ZHvQyp6KzAuEZQqR94k
         w+a+cI9W7B8Xyy2zXWjjJAdJAg/qdrExrE3EhxmLvNu0VwjXCJRP4fD36a/5smOuI+ZT
         8BJInqptJIrVi+HAR2zEgtw2gpwhc+h60TY6PbcoUdYqLugLiiqaTlJe3VJGmUhslxM9
         SC+oF68pRz9U3/1ZbeuwSQBEwupQylloyv6zh7VUSevkp9x5kD96DldfnhsLQUGa4Zj6
         zBq6mk0Q+kaMQu46giNYebBibYqgDCEFrioehWqpL8cclUUr23IVS8t6RMxVtYWQTRyc
         lWxg==
X-Gm-Message-State: AO0yUKWwfOgD6cxS8m/ixULppy+N0zGtgkqIPIejIxdLkfRb7oZobYt+
        qNNSvyMIcgmssQarovMw10LQpc6hwEQh4ssR1Z9pqf+hQrHL
X-Google-Smtp-Source: AK7set/6IYC+8ZQxOxNb14K20UaJ1fy11pZ+vBk85CZKBR4NfoIx7IokcmN6WMKGuYhtH1u8dsXM88ykcnqpkBt746aX+QHqVBVE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1bab:b0:310:d663:22ec with SMTP id
 n11-20020a056e021bab00b00310d66322ecmr2483609ili.123.1675437956410; Fri, 03
 Feb 2023 07:25:56 -0800 (PST)
Date:   Fri, 03 Feb 2023 07:25:56 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003c36aa05f3cd4c0d@google.com>
Subject: [syzbot] WARNING: locking bug in nci_close_device
From:   syzbot <syzbot+4f51fcf4157a3fc6e591@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6d796c50f84c Linux 6.2-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1575b409480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94f93727847d4d81
dashboard link: https://syzkaller.appspot.com/bug?extid=4f51fcf4157a3fc6e591
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/195f64fbd733/disk-6d796c50.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9c7a9e02d9de/vmlinux-6d796c50.xz
kernel image: https://storage.googleapis.com/syzbot-assets/edf369edf5c2/bzImage-6d796c50.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f51fcf4157a3fc6e591@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 1 PID: 5158 at kernel/locking/lockdep.c:231 hlock_class kernel/locking/lockdep.c:231 [inline]
WARNING: CPU: 1 PID: 5158 at kernel/locking/lockdep.c:231 hlock_class kernel/locking/lockdep.c:220 [inline]
WARNING: CPU: 1 PID: 5158 at kernel/locking/lockdep.c:231 check_deadlock kernel/locking/lockdep.c:3016 [inline]
WARNING: CPU: 1 PID: 5158 at kernel/locking/lockdep.c:231 validate_chain kernel/locking/lockdep.c:3818 [inline]
WARNING: CPU: 1 PID: 5158 at kernel/locking/lockdep.c:231 __lock_acquire+0x2679/0x56d0 kernel/locking/lockdep.c:5055
Modules linked in:
CPU: 1 PID: 5158 Comm: kworker/1:5 Not tainted 6.2.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Workqueue: events rfkill_sync_work
RIP: 0010:hlock_class kernel/locking/lockdep.c:231 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:220 [inline]
RIP: 0010:check_deadlock kernel/locking/lockdep.c:3016 [inline]
RIP: 0010:validate_chain kernel/locking/lockdep.c:3818 [inline]
RIP: 0010:__lock_acquire+0x2679/0x56d0 kernel/locking/lockdep.c:5055
Code: c0 03 38 d0 7c 08 84 d2 0f 85 00 2b 00 00 83 3d c4 5e 0f 0d 00 75 c6 48 c7 c6 a0 51 4c 8a 48 c7 c7 00 4b 4c 8a e8 31 00 5c 08 <0f> 0b 31 c0 e9 6a fe ff ff e8 f9 b7 a4 02 89 c3 e8 82 5d ff ff 85
RSP: 0018:ffffc900047bf858 EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffffffff91342f60 RCX: 0000000000000000
RDX: ffff888025f69d40 RSI: ffffffff816680ec RDI: fffff520008f7efd
RBP: ffff888025f6a778 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000001 R12: ffff888025f6a840
R13: 0000000000000dd1 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555555aaa848 CR3: 000000007ec38000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __flush_workqueue+0x118/0x13a0 kernel/workqueue.c:2809
 nci_close_device+0xcb/0x370 net/nfc/nci/core.c:567
 nfc_dev_down+0x19a/0x2d0 net/nfc/core.c:161
 nfc_rfkill_set_block+0x33/0xd0 net/nfc/core.c:179
 rfkill_set_block+0x1f9/0x540 net/rfkill/core.c:345
 rfkill_sync_work+0x8e/0xc0 net/rfkill/core.c:1042
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
