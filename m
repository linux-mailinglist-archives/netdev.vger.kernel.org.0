Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DEC1AD5B6
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 07:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgDQFgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 01:36:13 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:47440 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgDQFgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 01:36:12 -0400
Received: by mail-il1-f198.google.com with SMTP id a15so1429856ild.14
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 22:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RG1OjG9ZdHjWBn7iqio0bdclmjO74pm7jn+YvPQidL0=;
        b=FC21SD3ybWz5YdLSsVJ8SqVsesEqrgKfgbpFC08ffrhOYFo+GtADcUsw/eqBrWavmW
         nEMW/lDUFqUhDL1AlUf6T8HPKrIvqb9TR9w92HGC5QVP+ww15mPV6r+FelXppYDiEZ1V
         XjTBv3nLvUemeh3tdkwSfdsKKG4kr/cd+TNs0ijXTflEjZ8kNt0x9KzwWCVdUI82T950
         1YSJIIX5ifG2iWSihvRmQR3mgdWU7pHQ+xTGrWaOPt7eLqnCF25eriwDuoJsAFiFzk4B
         Q6KXCtmrsiyxop3fm/QINJhHOSTg8WnUtSXBIQZeDdiRnmxrraQXFurAA667uq2BUADK
         7raA==
X-Gm-Message-State: AGi0Puayh77PZmaeZCdIwA7WPyAUAvk2U3Vs3XHAqXtmyNTHbWn7s78Q
        tlGtUwDniTpyfCHpKEqoNv8mOJXckBUIUWUKgFQkVNFEG1Ud
X-Google-Smtp-Source: APiQypLvXl9tpCF4fnR+aei09iO499VlF+wR3/zjHxkwGFgHuFkXtq6v3vVfMQ5Dhd/rSCQ0GcFMPJIUbFK3kwrTdjVYsyin7M4F
MIME-Version: 1.0
X-Received: by 2002:a02:4445:: with SMTP id o66mr1759803jaa.36.1587101771040;
 Thu, 16 Apr 2020 22:36:11 -0700 (PDT)
Date:   Thu, 16 Apr 2020 22:36:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000490f1005a375ed34@google.com>
Subject: WARNING in nf_nat_unregister_fn
From:   syzbot <syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63bef48f Merge branch 'akpm' (patches from Andrew)
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11e41777e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94a7f1dec460ee83
dashboard link: https://syzkaller.appspot.com/bug?extid=33e06702fd6cffc24c40
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+33e06702fd6cffc24c40@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 19934 at net/netfilter/nf_nat_core.c:1106 nf_nat_unregister_fn+0x532/0x5c0 net/netfilter/nf_nat_core.c:1106
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 19934 Comm: syz-executor.5 Not tainted 5.6.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:nf_nat_unregister_fn+0x532/0x5c0 net/netfilter/nf_nat_core.c:1106
Code: ff df 48 c1 ea 03 80 3c 02 00 75 75 48 8b 44 24 10 4c 89 ef 48 c7 00 00 00 00 00 e8 e8 f8 53 fb e9 4d fe ff ff e8 ee 9c 16 fb <0f> 0b e9 41 fe ff ff e8 e2 45 54 fb e9 b5 fd ff ff 48 8b 7c 24 20
RSP: 0018:ffffc90005487208 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000004 RCX: ffffc9001444a000
RDX: 0000000000040000 RSI: ffffffff865c94a2 RDI: 0000000000000005
RBP: ffff88808b5cf000 R08: ffff8880a2620140 R09: fffffbfff14bcd79
R10: ffffc90005487208 R11: fffffbfff14bcd78 R12: 0000000000000000
R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
 nf_nat_ipv6_unregister_fn net/netfilter/nf_nat_proto.c:1017 [inline]
 nf_nat_inet_register_fn net/netfilter/nf_nat_proto.c:1038 [inline]
 nf_nat_inet_register_fn+0xfc/0x140 net/netfilter/nf_nat_proto.c:1023
 nf_tables_register_hook net/netfilter/nf_tables_api.c:224 [inline]
 nf_tables_addchain.constprop.0+0x82e/0x13c0 net/netfilter/nf_tables_api.c:1981
 nf_tables_newchain+0xf68/0x16a0 net/netfilter/nf_tables_api.c:2235
 nfnetlink_rcv_batch+0x83a/0x1610 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3af/0x420 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c889
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f2d5a3c6c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2d5a3c76d4 RCX: 000000000045c889
RDX: 0000000000000000 RSI: 000000002000c2c0 RDI: 0000000000000003
RBP: 000000000076bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 000000000000095d R14: 00000000004cc151 R15: 000000000000000c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
