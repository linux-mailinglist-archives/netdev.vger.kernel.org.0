Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F5023E5D6
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 04:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgHGC0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 22:26:42 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51193 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgHGC02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 22:26:28 -0400
Received: by mail-io1-f70.google.com with SMTP id k5so509146ion.17
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 19:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yHSo/kuS5ZP8bar2nScAn5lqkwqHBJnis2OUjlmiGf8=;
        b=pmgA3zuYOb+FroJvOGMjtOWlKqvv+CZfKnpkMK5qKT3ZDF9EexrgPMYC6EwCV1+MnX
         wyoWYM/ksB2Mqt2cPRDe8WDq79S+N5i0T072zzN8niBTuq/SVttMobTXhcwxAOGZ+bFG
         SF1Vdpdypmaw942n4WW9y/V5Ha1cX0RVVPAjRkSGSyFjUGx+xbj9uEoKAiFNbGCNDA2e
         kHsa54BhrjDDlu0xf5yWvtGoKdvUaYcUWK73A8vo0H4FbQ0pzDZ6olTe07QJPJo9AXoP
         PJBujs/1KoJ4HJehhj6prjaP5dhlS2tLgRgCxpv7Kl1g/onMyPIOJumEZmCY1/wW5Jti
         +cKg==
X-Gm-Message-State: AOAM533UJLZKVGOVITmOdznMTF+Ty36HpTze8EYJlsUccy3Mjes1NABH
        mpNrqcQbgu0ax5XcB64Zh3RGvyS+bIaJ2QtZ6zMJQMhaiR5w
X-Google-Smtp-Source: ABdhPJzWqZlpXxseUdPBQtg4h5n7fncG9tig9ZWsF3MR1GAU9dFy4z0l4sIfNL+g6FoISGc69bCA7oL5MMsm3vF5TUDs1Qt2wrPD
MIME-Version: 1.0
X-Received: by 2002:a92:981d:: with SMTP id l29mr2298152ili.178.1596767186248;
 Thu, 06 Aug 2020 19:26:26 -0700 (PDT)
Date:   Thu, 06 Aug 2020 19:26:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ece9db05ac4054e8@google.com>
Subject: WARNING in compat_do_ebt_get_ctl
From:   syzbot <syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e92e76900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7c06047f622c5724
dashboard link: https://syzkaller.appspot.com/bug?extid=5accb5c62faa1d346480
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 copy_overflow include/linux/thread_info.h:134 [inline]
WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 check_copy_size include/linux/thread_info.h:143 [inline]
WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 copy_to_user include/linux/uaccess.h:151 [inline]
WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 compat_do_ebt_get_ctl+0x47e/0x500 net/bridge/netfilter/ebtables.c:2270
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 783 Comm: syz-executor.2 Not tainted 5.8.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:copy_overflow include/linux/thread_info.h:134 [inline]
RIP: 0010:check_copy_size include/linux/thread_info.h:143 [inline]
RIP: 0010:copy_to_user include/linux/uaccess.h:151 [inline]
RIP: 0010:compat_do_ebt_get_ctl+0x47e/0x500 net/bridge/netfilter/ebtables.c:2270
Code: ba fd ff ff 4c 89 f7 e8 a0 11 a4 fa e9 ad fd ff ff e8 06 0f 64 fa 4c 89 e2 be 50 00 00 00 48 c7 c7 00 4e 0e 89 e8 64 20 35 fa <0f> 0b e9 dc fd ff ff 41 bc f2 ff ff ff e9 4f fe ff ff e8 7b 11 a4
RSP: 0018:ffffc900047b7ae8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 1ffff920008f6f5e RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815d8eb7 RDI: fffff520008f6f4f
RBP: ffffffff8a8f3460 R08: 0000000000000001 R09: ffff88802ce31927
R10: 0000000000000000 R11: 0000000033383754 R12: 000000000000ffab
R13: 0000000020000100 R14: ffffc900047b7d80 R15: ffffc900047b7b20
 do_ebt_get_ctl+0x2b4/0x790 net/bridge/netfilter/ebtables.c:2317
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1778 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1757
 raw_getsockopt+0x1a1/0x1d0 net/ipv4/raw.c:876
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2179
 __do_sys_getsockopt net/socket.c:2194 [inline]
 __se_sys_getsockopt net/socket.c:2191 [inline]
 __ia32_sys_getsockopt+0xb9/0x150 net/socket.c:2191
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f24569
Code: c4 01 10 03 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f551e0bc EFLAGS: 00000296 ORIG_RAX: 000000000000016d
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000082 RSI: 0000000020000100 RDI: 0000000020000180
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
