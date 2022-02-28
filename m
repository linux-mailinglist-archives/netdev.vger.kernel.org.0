Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88E804C605A
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 01:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbiB1AyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 19:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiB1AyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 19:54:14 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F7D4507C
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 16:53:30 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id e14-20020a92d74e000000b002c2dcf05a5aso2172751ilq.2
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 16:53:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=AX3Pc5AO8XiRxdqF0xaFF6Qbje5dgUlOCE3Rs5VFqVI=;
        b=KpxGJJ6FUx75f5A3QXb3RRAMSvqHc48UFDx5k8ZRdXl98UcdZ2SJn72LYDPmKap6zZ
         Ee9n8iedmIXUgIZKqRh4R/V/frqVzpYQx+oUbR6otFL8mbTPv7G+fXvNdBTCE0BpVMFz
         TL1endnm1U42wQ6Z4z/FwpyhvIYLeAgRWh4+BsLywPsJKLB1W8kpoastwa0tm75HUxAa
         dzvy9JmQJzQueIkEsVAmOKanGJk3DFACxv8fXvG6k0b2CXmMnSMadZT47HjqgK8ZUUlA
         2+lRfqNIndpicazucXoTsBbLKi7YKT4UeWnXz/k4G8EHRtdddKAAKt9v2iMuYjtiq5ME
         pjYg==
X-Gm-Message-State: AOAM532ZIfMgz3F+PEnmIqEf+TsOznbcnb2RLZ4sebZjBO84hXAZpCv/
        dj+macGsxiExYd/0WyqMljJQxjA9Xfr0b4POm5bcKcF/jWmW
X-Google-Smtp-Source: ABdhPJzowtiUs7pxMmgZkREdzThcRlYPZXMRC4wyI+xkJyhxP5lHi4wPMJbHPzurk9inE/5cVLYhGqwKcPFDdVYR8Lgh/0KJkAQ3
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2b8b:b0:608:c584:a1b0 with SMTP id
 r11-20020a0566022b8b00b00608c584a1b0mr13607483iov.159.1646009609480; Sun, 27
 Feb 2022 16:53:29 -0800 (PST)
Date:   Sun, 27 Feb 2022 16:53:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011f0c905d9097a62@google.com>
Subject: [syzbot] WARNING in p9_client_destroy
From:   syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>
To:     asmadeus@codewreck.org, davem@davemloft.net, ericvh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux_oss@crudebyte.com, lucho@ionkov.net, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        v9fs-developer@lists.sourceforge.net
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

HEAD commit:    23d04328444a Merge tag 'for-5.17/parisc-4' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1614a812700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2a8c25b60d49d24
dashboard link: https://syzkaller.appspot.com/bug?extid=5e28cdb7ebd0f2389ca4
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com

kmem_cache_destroy 9p-fcall-cache: Slab cache still has objects when called from p9_client_destroy+0x213/0x370 net/9p/client.c:1100
WARNING: CPU: 1 PID: 3701 at mm/slab_common.c:502 kmem_cache_destroy mm/slab_common.c:502 [inline]
WARNING: CPU: 1 PID: 3701 at mm/slab_common.c:502 kmem_cache_destroy+0x13b/0x140 mm/slab_common.c:490
Modules linked in:
CPU: 1 PID: 3701 Comm: syz-executor.3 Not tainted 5.17.0-rc5-syzkaller-00021-g23d04328444a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:kmem_cache_destroy mm/slab_common.c:502 [inline]
RIP: 0010:kmem_cache_destroy+0x13b/0x140 mm/slab_common.c:490
Code: da a8 0e 48 89 ee e8 44 6e 15 00 eb c1 c3 48 8b 55 58 48 c7 c6 60 cd b6 89 48 c7 c7 30 83 3a 8b 48 8b 4c 24 18 e8 9b 30 60 07 <0f> 0b eb a0 90 41 55 49 89 d5 41 54 49 89 f4 55 48 89 fd 53 48 83
RSP: 0018:ffffc90002767cf0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 1ffff920004ecfa5 RCX: 0000000000000000
RDX: ffff88801e56a280 RSI: ffffffff815f4b38 RDI: fffff520004ecf90
RBP: ffff888020ba8b00 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ef1ce R11: 0000000000000000 R12: 0000000000000001
R13: ffffc90002767d68 R14: dffffc0000000000 R15: 0000000000000000
FS:  00005555561b0400(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555556ead708 CR3: 0000000068b97000 CR4: 0000000000150ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 p9_client_destroy+0x213/0x370 net/9p/client.c:1100
 v9fs_session_close+0x45/0x2d0 fs/9p/v9fs.c:504
 v9fs_kill_super+0x49/0x90 fs/9p/vfs_super.c:226
 deactivate_locked_super+0x94/0x160 fs/super.c:332
 deactivate_super+0xad/0xd0 fs/super.c:363
 cleanup_mnt+0x3a2/0x540 fs/namespace.c:1173
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f5ff63ed4c7
Code: ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff01862e98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f5ff63ed4c7
RDX: 00007fff01862f6c RSI: 000000000000000a RDI: 00007fff01862f60
RBP: 00007fff01862f60 R08: 00000000ffffffff R09: 00007fff01862d30
R10: 00005555561b18b3 R11: 0000000000000246 R12: 00007f5ff64451ea
R13: 00007fff01864020 R14: 00005555561b1810 R15: 00007fff01864060
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
