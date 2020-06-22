Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D76202F81
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 07:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgFVFbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 01:31:12 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44328 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728473AbgFVFbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 01:31:11 -0400
Received: by mail-il1-f197.google.com with SMTP id l11so11277652ils.11
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 22:31:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aQtYKQkkKYuteeNYG+2Awb4ARDJtZy19+odkppRd09I=;
        b=Y2NEnfQ0FCYW0Imf6A4ZH38U8Px2kXuFV/67nxXIo/ySzlO1TbiAeYf/TPfcFDZ1SN
         kKeKNVf8mYpltLOI3/Xka+CjL3Ig8MqKqdGY0jA/5zatDiQv37olVfcY7X8kdy6/yaSU
         AfbCLMjrAsTDa22b6hHGGqlQQb7f9lZHqP+59iuO2npYuDBIftu9C0N/d5gu42xka3/2
         erzVsHzEHYcR0OFiBzxwml4MTXfyoVsOHEopsnfHO5Gggt2jR9of7TWp93oF8WJNsWoa
         2plSnP7ag+OsxBZzWbqYoq6ajv8ULVmc7yMIFKpItAne7eSwNo7hTL3TT1Ghyde972AE
         sEkg==
X-Gm-Message-State: AOAM533edhIkHudXIoa6U/IryzqueMphZzMe6JUwNge+03TvDGdOLFlT
        h/6yKYI9RCnOQVrLm4OrCWA6fzDmjeH4MDwvmTaM+oTusdV3
X-Google-Smtp-Source: ABdhPJyW7RuXSwMiKUJB9D+k4K8gv+o3ui2u2HhK4Bkh8euurHOIiSsergkhBiOmiHVQ+ImuoHBGVz/lpI5KeeAoXX9y29sOMDKe
MIME-Version: 1.0
X-Received: by 2002:a02:2c5:: with SMTP id 188mr16250393jau.3.1592803870624;
 Sun, 21 Jun 2020 22:31:10 -0700 (PDT)
Date:   Sun, 21 Jun 2020 22:31:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7d00f05a8a58cdc@google.com>
Subject: WARNING in tcf_chain0_head_change_cb_del
From:   syzbot <syzbot+438750324c752008e890@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1630b4d1100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d195fe572fb15312
dashboard link: https://syzkaller.appspot.com/bug?extid=438750324c752008e890
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+438750324c752008e890@syzkaller.appspotmail.com

Free swap  = 0kB
Total swap = 0kB
1965979 pages RAM
0 pages HighMem/MovableOnly
349378 pages reserved
0 pages cma reserved
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 1 PID: 3326 at kernel/locking/mutex.c:938 __mutex_lock_common kernel/locking/mutex.c:938 [inline]
WARNING: CPU: 1 PID: 3326 at kernel/locking/mutex.c:938 __mutex_lock+0xd75/0x13c0 kernel/locking/mutex.c:1103
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 3326 Comm: syz-executor.2 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:105 [inline]
 fixup_bug arch/x86/kernel/traps.c:100 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:197
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:216
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:938 [inline]
RIP: 0010:__mutex_lock+0xd75/0x13c0 kernel/locking/mutex.c:1103
Code: d2 0f 85 98 05 00 00 44 8b 05 07 44 ae 02 45 85 c0 0f 85 c1 f3 ff ff 48 c7 c6 c0 8b 2b 88 48 c7 c7 80 89 2b 88 e8 e3 78 67 f9 <0f> 0b e9 a7 f3 ff ff 65 48 8b 1c 25 00 1f 02 00 be 08 00 00 00 48
RSP: 0018:ffffc9001675f200 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815d5ba7 RDI: fffff52002cebe32
RBP: ffffc9001675f370 R08: ffff88808823a5c0 R09: 0000000000000000
R10: ffffffff899b2823 R11: fffffbfff1336504 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff88809d5e9000 R15: ffff88809d5e9000
 tcf_chain0_head_change_cb_del.isra.0+0x31/0x3c0 net/sched/cls_api.c:803
 tcf_block_put_ext.part.0+0x25/0x80 net/sched/cls_api.c:1375
 tcf_block_put_ext net/sched/cls_api.c:1373 [inline]
 tcf_block_put+0xb3/0x100 net/sched/cls_api.c:1388
 cake_destroy+0x3f/0x80 net/sched/sch_cake.c:2667
 qdisc_create+0xd93/0x1430 net/sched/sch_api.c:1295
 tc_modify_qdisc+0x4c5/0x1a00 net/sched/sch_api.c:1662
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5461
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e6/0x810 net/socket.c:2352
 ___sys_sendmsg+0x100/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45ca59
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6a1c91fc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000501a60 RCX: 000000000045ca59
RDX: 0000000000000000 RSI: 00000000200007c0 RDI: 0000000000000004
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
R13: 0000000000000a22 R14: 00000000004cd04d R15: 00007f6a1c9206d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
