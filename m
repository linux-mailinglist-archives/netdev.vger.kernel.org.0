Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2AA14165B
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 08:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgARHrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 02:47:12 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:38986 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgARHrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 02:47:12 -0500
Received: by mail-io1-f70.google.com with SMTP id w22so11831009ior.6
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 23:47:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rACzx1KS5lzpKZSs02VIS9cY8o5PBuG1ezgSd659A74=;
        b=d+w3YcWs1u8fKFUWVhLIPas8ZjFuW4KKo2cjIESCskF+CFaHPRU5AQYNCKzc2SIQHf
         RI/RcgFbzcFChHq80WYFKPS8h9e3Wzovsio9OPvO02Wn0sgKZqOjrEp6VQyY7BvjPTXM
         J2IGOiFnROGaFq/u+f8LjY9PoYI/PFLJl5zgXUtd1y0ahk+iPEWcknGTA4Ug+42dBMQg
         Dc8uC668QnpNtDgYGT350gNUPXKjfIasRypd114toDj+UwHgXoUjKT6R7w4t7M5teJRz
         NxYdRmFpfZRHf6R2ok3+4vUMM5VmBVBzVMf/32u92h5PPg/vJu6juVnZ5tMiSc2wzaws
         nDzA==
X-Gm-Message-State: APjAAAVuJk4DmeSdgJeJq3VfzBKaD+HcopWxZUr0TBIUOuyPoahi2ULe
        /nrUJfI5kl0uATNeZXgadueLQCD/7Y/+/7BbPg3l4swxDUY0
X-Google-Smtp-Source: APXvYqzvQXzrhIK9hc/iUMcXsD8cK73nG9tFAbAt9xFxmyGlNX5o0/+hcRCBgDlrSkcc5Y8oho7Xoo4Oh6BT0uJTL9sgL4192ERQ
MIME-Version: 1.0
X-Received: by 2002:a92:8307:: with SMTP id f7mr2198310ild.73.1579333631387;
 Fri, 17 Jan 2020 23:47:11 -0800 (PST)
Date:   Fri, 17 Jan 2020 23:47:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000014b040059c654481@google.com>
Subject: WARNING in nf_tables_table_destroy
From:   syzbot <syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    5a9ef194 net: systemport: Fixed queue mapping in internal ..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1549ccc9e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=2a3b1b28cad90c608e20
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15338966e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1667d8d6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2a3b1b28cad90c608e20@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9693 at net/netfilter/nf_tables_api.c:1155 nf_tables_table_destroy.isra.0+0x100/0x150 net/netfilter/nf_tables_api.c:1155
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9693 Comm: syz-executor142 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:nf_tables_table_destroy.isra.0+0x100/0x150 net/netfilter/nf_tables_api.c:1155
Code: 00 00 00 00 fc ff df 48 c1 ea 03 80 3c 02 00 75 52 48 8b 3b e8 b1 8c 4d fb e8 9c 1c 10 fb 5b 41 5c 41 5d 5d c3 e8 90 1c 10 fb <0f> 0b e8 89 1c 10 fb 5b 41 5c 41 5d 5d c3 e8 dd db 4d fb e9 40 ff
RSP: 0018:ffffc900022b7478 EFLAGS: 00010293
RAX: ffff8880a936a580 RBX: ffff8880a2c9e1a0 RCX: ffffffff8664d86a
RDX: 0000000000000000 RSI: ffffffff8664d900 RDI: 0000000000000005
RBP: ffffc900022b7490 R08: ffff8880a936a580 R09: ffffc900022b73c0
R10: fffffbfff165e7b2 R11: ffffffff8b2f3d97 R12: ffff8880a729f400
R13: 0000000000000001 R14: 0000000000000000 R15: ffff8880a72f7380
 nf_tables_abort_release net/netfilter/nf_tables_api.c:7216 [inline]
 __nf_tables_abort+0x1bad/0x2a50 net/netfilter/nf_tables_api.c:7360
 nf_tables_abort+0x17/0x30 net/netfilter/nf_tables_api.c:7373
 nfnetlink_rcv_batch+0xa5d/0x17a0 net/netfilter/nfnetlink.c:494
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 ____sys_sendmsg+0x753/0x880 net/socket.c:2330
 ___sys_sendmsg+0x100/0x170 net/socket.c:2384
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
 __do_sys_sendmsg net/socket.c:2426 [inline]
 __se_sys_sendmsg net/socket.c:2424 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446c39
Code: e8 8c e7 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 07 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f39f091ad98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000006dbc28 RCX: 0000000000446c39
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000004
RBP: 00000000006dbc20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc2c
R13: 00000000200002c0 R14: 00000000004aec20 R15: 0000000000000000
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
