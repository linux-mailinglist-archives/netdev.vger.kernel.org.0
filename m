Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429DC4B95C8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbiBQCBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:01:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiBQCBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:01:34 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC752AA381
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:01:20 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id h8-20020a056e021b8800b002ba614f7c5dso1073224ili.2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:01:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=l8hz6zbgdfZZuicmk3dNuptsWpUXXP72nyKQpZLqpbs=;
        b=0Nih4xbLDD0o3U9fVc6ExQu7yVXz8FgkSpXF5R/S8amYasO3Yuh+cFiuQhxLcsQcVK
         fPjXvPRRxmj+XOhK9jPQFeAqD5BmtfmeW5FzrmZJg5JsOzJJ5uw3pfGUHRrA3YaNce82
         lw7zTOYvvJyaWG/Zi9xIzcn9xIlL20S+sx5IMtBx/hcoJdvTLUJWKPq6WczvYLJSZd8U
         DNsmi9mLZAGwAwgm8tUceBxJj5tJpYG2Bi4spW3O45p69x1DR2uR4nTzT2c/X6+YNVCu
         SkYJbwHB6uI/sIPYjVaiYAc3nAMn9K9A3CKpNzFjXNgMxT8vYtJpXd9Y6pj/C+FkdxIj
         TiIA==
X-Gm-Message-State: AOAM530YlTF/FnyGC0YyKCNxGrA4jQrXpTYxGuJijoInovJ1VGdJcMpl
        yXxhgJAVuRJZGUk2JqhIUf9V1Nj4vHs7EcJU09nr0XykywX2
X-Google-Smtp-Source: ABdhPJxD7S/rF937d7D/q41kVwB6Pw+QP3TF2Uxtcc5e2nxGImnT4aHG7lw4g9fBuqMOQ9Fl/jq/gmuhR+Uk4ghL97dF+ZcnlhDn
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1526:b0:2bb:faba:4d77 with SMTP id
 i6-20020a056e02152600b002bbfaba4d77mr484362ilu.231.1645063279960; Wed, 16 Feb
 2022 18:01:19 -0800 (PST)
Date:   Wed, 16 Feb 2022 18:01:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f656005d82d24e2@google.com>
Subject: [syzbot] WARNING in vhost_dev_cleanup (2)
From:   syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
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

HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=132e687c700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
dashboard link: https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
Modules linked in:
CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
Code: c7 85 90 01 00 00 00 00 00 00 e8 53 6e a2 fa 48 89 ef 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 7d d6 ff ff e8 38 6e a2 fa <0f> 0b e9 46 ff ff ff 48 8b 7c 24 10 e8 87 00 ea fa e9 75 f7 ff ff
RSP: 0018:ffffc9000fe6fa18 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffff888021b63a00 RSI: ffffffff86d66fe8 RDI: ffff88801cc200b0
RBP: ffff88801cc20000 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff817f1e08 R11: 0000000000000000 R12: ffff88801cc200d0
R13: ffff88801cc20120 R14: ffff88801cc200d0 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2de25000 CR3: 000000004c9cd000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vhost_vsock_dev_release+0x36e/0x4b0 drivers/vhost/vsock.c:771
 __fput+0x286/0x9f0 fs/file_table.c:313
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xb29/0x2a30 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:935
 get_signal+0x45a/0x2490 kernel/signal.c:2863
 arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4027a46481
Code: Unable to access opcode bytes at RIP 0x7f4027a46457.
RSP: 002b:00007f402808ba68 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: fffffffffffffffc RBX: 00007f402622e700 RCX: 00007f4027a46481
RDX: 00007f402622e9d0 RSI: 00007f402622e2f0 RDI: 00000000003d0f00
RBP: 00007f402808bcb0 R08: 00007f402622e700 R09: 00007f402622e700
R10: 00007f402622e9d0 R11: 0000000000000206 R12: 00007f402808bb1e
R13: 00007f402808bb1f R14: 00007f402622e300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
