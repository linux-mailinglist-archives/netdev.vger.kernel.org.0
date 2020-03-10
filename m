Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E192180B78
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCJWZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:25:15 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:43527 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgCJWZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:25:14 -0400
Received: by mail-il1-f198.google.com with SMTP id t9so875ilk.10
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/mGXnhXZurO4CREgFpYtZhovCFB8iVw1jhK1uRbKELA=;
        b=GNoroo3lXgVEEhSoQHWRF/8wcLJ3bK3TDO5KWezpMqI6akwrLuJt8QpMwTcsjM6TeO
         +/weMiPU40tBY/KbMBI7Dkf6Y11zv/WYTyrewLYZCs1QAz0T734hkdFX/mxPVZKxwUjI
         H7kl83d0MlZmDXujJXw2KkOTSKD7liXenuh1v9YQ+s/snoT5VawZPVF+FacWZAtmA8hj
         pcXkDoixp5dmQ6FZ/7WLeJnJzK9tiMgXglxA6yDWCkELDA+AScUC4NKFjkoPFKXsSQ7c
         uZRs2H0FzCE0wA9QxHwsK7UXN818dAH5kvR6y4ND4XbgLI0Xzft6hH9ct3cbHmRlgnLm
         S3ug==
X-Gm-Message-State: ANhLgQ3D8Iz1DvNRiEeIJ5FnXTXhVfg2SebVeLqZtYNB67+IrR6NeBVX
        ip1RH0CfgoG95BTYKSXN4oxObYSP9JYe/3IbRkyLRu1k623i
X-Google-Smtp-Source: ADFU+vuSCDa6sFDmriiZ0a0XGIM9FkUJKlP1Z4fwu89Hj8u7d6sDDMEcvTfI7GrxVA1ivCG/v+ATvnkrzGPr+j+rOHWgcOW0QdhF
MIME-Version: 1.0
X-Received: by 2002:a5e:9b09:: with SMTP id j9mr240391iok.114.1583879113910;
 Tue, 10 Mar 2020 15:25:13 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:25:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3b11305a0879723@google.com>
Subject: WARNING in kfree (2)
From:   syzbot <syzbot+50ef5e5e5ea5f812f0c2@syzkaller.appspotmail.com>
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

HEAD commit:    2c523b34 Linux 5.6-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=154b5181e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c2e311dba9a02ba9
dashboard link: https://syzkaller.appspot.com/bug?extid=50ef5e5e5ea5f812f0c2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d8ae91e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+50ef5e5e5ea5f812f0c2@syzkaller.appspotmail.com

------------[ cut here ]------------
virt_to_cache: Object is not a Slab page!
WARNING: CPU: 1 PID: 9436 at mm/slab.h:473 virt_to_cache mm/slab.h:473 [inline]
WARNING: CPU: 1 PID: 9436 at mm/slab.h:473 kfree+0x1cf/0x2b0 mm/slab.c:3749
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9436 Comm: syz-executor.0 Not tainted 5.6.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:virt_to_cache mm/slab.h:473 [inline]
RIP: 0010:kfree+0x1cf/0x2b0 mm/slab.c:3749
Code: 51 ff e9 67 fe ff ff 80 3d 8a a4 b2 08 00 75 1c 48 c7 c6 40 52 15 88 48 c7 c7 e8 03 26 89 c6 05 73 a4 b2 08 01 e8 b9 9f 95 ff <0f> 0b f6 c7 02 75 6b 48 83 3d 52 2e c5 07 00 0f 85 4e ff ff ff 0f
RSP: 0018:ffffc900020e7030 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000282 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bf4f1 RDI: fffff5200041cdf8
RBP: ffffffff8c3f7080 R08: ffff88808e97c600 R09: ffffed1015ce45c9
R10: ffffed1015ce45c8 R11: ffff8880ae722e43 R12: ffffffff8628c202
R13: dffffc0000000000 R14: ffff8880a0069c10 R15: 0000000000000000
 tcf_exts_destroy+0x62/0xc0 net/sched/cls_api.c:3002
 tcf_exts_change+0xf4/0x150 net/sched/cls_api.c:3059
 tcindex_set_parms+0xed8/0x1a00 net/sched/cls_tcindex.c:456
 tcindex_change+0x203/0x2e0 net/sched/cls_tcindex.c:518
 tc_new_tfilter+0xa59/0x20b0 net/sched/cls_api.c:2103
 rtnetlink_rcv_msg+0x810/0xad0 net/core/rtnetlink.c:5427
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2478
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6b9/0x7d0 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2430
 do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
 do_fast_syscall_32+0x270/0xe8f arch/x86/entry/common.c:408
 entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
