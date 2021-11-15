Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD17D4517C3
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241860AbhKOWq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:46:27 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:35748 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237995AbhKOWaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 17:30:22 -0500
Received: by mail-io1-f71.google.com with SMTP id x11-20020a0566022c4b00b005e702603028so11710081iov.2
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:27:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kIpSl7OTDOLHk20ReymEq1RTk5wHjvJPF9rqkcV16TU=;
        b=YI7e+OxU4c7nOUEaCsxb9jTAd1nSSQdUEF6QG+Lfoo0YhWjCRe3IdB0UOFE6zyeROv
         lERs/8xjmMDHD2/J4eFUdzJ2S5xxEdv6VGkx7OIgXs2nvD4JkuhRFxx3xbg6P2u5XK90
         zO6NgZC12jdUH9FzCKYAvfpC5DI96YalD6K8nV/U3/zRurl1Yjv9iLFTWoMRncGp4cSh
         dyLEVcgbM2+BbrWjfiyMQzirXSLXtimX98PpDwEuyygbcYGIL85UH+8dn0J9WFk5OJAx
         iduV4roZcczG4hnUpedYRCDh/8JPFYAu5pZZvxY0hMEVSjPbNNhM9UPo8HCW6RK/1pTc
         HyCw==
X-Gm-Message-State: AOAM532Mha/Q2dV3mt7GvTxcrQQuuRJK80i8vloNRf7MTPZJ6O1vN1Ha
        NFG63Jear8P9MeaShAMlgp81ywB8NK+vz8lwUo1SfuxBgvO3
X-Google-Smtp-Source: ABdhPJy6tnPSbbeVXiUhnfpdq4GWAwFnOefCVem4X3H2LWQuOSWfKmyuyet81M11GbYIOR9vlM6+eyXDYKYkf/fhlWF8tEG/FZ79
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c47:: with SMTP id d7mr1511320ilg.195.1637015246514;
 Mon, 15 Nov 2021 14:27:26 -0800 (PST)
Date:   Mon, 15 Nov 2021 14:27:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000042b02105d0db5037@google.com>
Subject: [syzbot] WARNING in mntput_no_expire (3)
From:   syzbot <syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fceb07950a7a Merge https://git.kernel.org/pub/scm/linux/ke..
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=16f9e61ab00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5d447cdc3ae81d9
dashboard link: https://syzkaller.appspot.com/bug?extid=5b1e53987f858500ec00
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 13724 at fs/namespace.c:1187 mntput_no_expire+0xada/0xcd0 fs/namespace.c:1187
Modules linked in:
CPU: 0 PID: 13724 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mntput_no_expire+0xada/0xcd0 fs/namespace.c:1187
Code: 30 84 c0 0f 84 b9 fe ff ff 3c 03 0f 8f b1 fe ff ff 4c 89 44 24 10 e8 45 3e ec ff 4c 8b 44 24 10 e9 9d fe ff ff e8 d6 d1 a5 ff <0f> 0b e9 19 fd ff ff e8 ca d1 a5 ff e8 b5 e1 65 07 31 ff 89 c5 89
RSP: 0018:ffffc90003fffc18 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 1ffff920007fff89 RCX: 0000000000000000
RDX: ffff8880746c3a00 RSI: ffffffff81d1a0ba RDI: 0000000000000003
RBP: ffff88807324ad80 R08: 0000000000000000 R09: ffffffff8fd39a0f
R10: ffffffff81d19dd1 R11: 0000000000000000 R12: 0000000000000008
R13: ffffc90003fffc68 R14: 00000000ffffffff R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fee49cd9c18 CR3: 0000000030b77000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 mntput fs/namespace.c:1233 [inline]
 namespace_unlock+0x26b/0x410 fs/namespace.c:1452
 drop_collected_mounts fs/namespace.c:1935 [inline]
 put_mnt_ns fs/namespace.c:4344 [inline]
 put_mnt_ns+0x106/0x140 fs/namespace.c:4340
 free_nsproxy+0x43/0x4c0 kernel/nsproxy.c:191
 put_nsproxy include/linux/nsproxy.h:105 [inline]
 switch_task_namespaces+0xad/0xc0 kernel/nsproxy.c:249
 do_exit+0xba5/0x2a20 kernel/exit.c:825
 do_group_exit+0x125/0x310 kernel/exit.c:923
 __do_sys_exit_group kernel/exit.c:934 [inline]
 __se_sys_exit_group kernel/exit.c:932 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:932
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fee49bf8ae9
Code: Unable to access opcode bytes at RIP 0x7fee49bf8abf.
RSP: 002b:00007ffe70646608 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000029 RCX: 00007fee49bf8ae9
RDX: 00007fee49bfa13a RSI: 0000000000000000 RDI: 0000000000000007
RBP: 0000000000000007 R08: ffffffffffff0000 R09: 0000000000000029
R10: 00000000000003b8 R11: 0000000000000246 R12: 00007ffe70646c70
R13: 0000000000000003 R14: 00007ffe70646c0c R15: 00007fee49cd9b60
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
