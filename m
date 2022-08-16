Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40C35956FC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiHPJsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbiHPJsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:48:06 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7A4DB7D1
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:41:35 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id d6-20020a056e020c0600b002deca741bc2so6672858ile.18
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=QoJU5GGMy8v8yEZNFxM99bTCjQW1eFlhk+iiG3fJdLI=;
        b=pLUvQG7RaBg4kku0X9elKN60FPwM2vCAOfIvXfqKLBR3eD3j08jpaAJYwIRA8bcx1Q
         5NiOV7e/WPytOdZuWhhY99a8b8fFxh5ApBDuyG8KIPjdsR0BuwEaPVzew2EwB5FFSdQg
         j0tqKfs1trke7OO5jIKQhYBSrUqwDPxJXx4eusRGGtjO9re2ArU6EFibUYDcaTrotQxF
         MRpxsdjpTqQONJXp7v/aZQrZHPDU2+gzIezb7qdVTCLjjshZbSpB1iiTJT7PwQoKYH0w
         Oy0FfDcsMJcJsKJ17GaLPNT2+5n6VwFpT3TdCXN6SpmMls+7wvLoj72Ejl7uYA+2Qohg
         +ShQ==
X-Gm-Message-State: ACgBeo364/QHnVCIODhWFrVZ6hjbOeA8fBnnLO6fAeuY0w8qPurQHLEg
        KCOZfVEc2KB9oTUiNelWyGX1dlkAM5l7EMvx4pAu9Ks+nJyy
X-Google-Smtp-Source: AA6agR72pfTFc5Nk70AuqknQizPu6jLKL7iJFFPqgDk7a5kQ7izKd/NlV+VSVv6WZrRf/Lm1ZySMpdIMRZk6PsLGPasFpCgAOzQH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2145:b0:2e4:b2f3:d6fb with SMTP id
 d5-20020a056e02214500b002e4b2f3d6fbmr7270506ilv.163.1660639294552; Tue, 16
 Aug 2022 01:41:34 -0700 (PDT)
Date:   Tue, 16 Aug 2022 01:41:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000040801b05e657b77f@google.com>
Subject: [syzbot] upstream boot error: BUG: unable to handle kernel paging
 request in __rhashtable_lookup
From:   syzbot <syzbot+6fccf62d7c237e1b4c85@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, harshit.m.mogalapalli@oracle.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    4a9350597aff Merge tag 'sound-fix-6.0-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16259e35080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d647c9572405910
dashboard link: https://syzkaller.appspot.com/bug?extid=6fccf62d7c237e1b4c85
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6fccf62d7c237e1b4c85@syzkaller.appspotmail.com

8021q: adding VLAN 0 to HW filter on device bond0
eql: remember to turn off Van-Jacobson compression on your slave devices
BUG: unable to handle page fault for address: ffffdbffffffffc8
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 11825067 P4D 11825067 PUD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3187 Comm: dhcpcd Not tainted 5.19.0-syzkaller-14090-g4a9350597aff #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:netlink_compare net/netlink/af_netlink.c:500 [inline]
RIP: 0010:__rhashtable_lookup.constprop.0+0x2ae/0x5e0 include/linux/rhashtable.h:601
Code: 01 44 89 e6 e8 83 19 e8 f9 45 84 e4 0f 85 8f 01 00 00 e8 f5 1c e8 f9 4d 8d 24 1f 49 8d bc 24 00 05 00 00 48 89 f8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 9c 02 00 00 45 8b ac 24 00
RSP: 0018:ffffc9000351f818 EFLAGS: 00010a02
RAX: 1fffdfffffffffc8 RBX: fffffffffffff940 RCX: 0000000000000000
RDX: ffff88807cc7c140 RSI: ffffffff879318cb RDI: fffefffffffffe40
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: fffefffffffff940
R13: ffffffff9152ccc0 R14: dffffc0000000000 R15: ffff000000000000
FS:  00007fbe244b5740(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffdbffffffffc8 CR3: 0000000021e67000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rhashtable_lookup include/linux/rhashtable.h:638 [inline]
 rhashtable_lookup_fast include/linux/rhashtable.h:664 [inline]
 __netlink_lookup net/netlink/af_netlink.c:518 [inline]
 netlink_lookup+0x130/0x470 net/netlink/af_netlink.c:538
 netlink_getsockbyportid net/netlink/af_netlink.c:1154 [inline]
 netlink_unicast+0x244/0x7f0 net/netlink/af_netlink.c:1339
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbe245ad163
Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
RSP: 002b:00007ffd4a7738f8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbe244b56c8 RCX: 00007fbe245ad163
RDX: 0000000000000000 RSI: 00007ffd4a787aa8 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 00007ffd4a787aa8
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 00007ffd4a787aa8 R14: 0000000000000030 R15: 0000000000000001
 </TASK>
Modules linked in:
CR2: ffffdbffffffffc8
---[ end trace 0000000000000000 ]---
RIP: 0010:netlink_compare net/netlink/af_netlink.c:500 [inline]
RIP: 0010:__rhashtable_lookup.constprop.0+0x2ae/0x5e0 include/linux/rhashtable.h:601
Code: 01 44 89 e6 e8 83 19 e8 f9 45 84 e4 0f 85 8f 01 00 00 e8 f5 1c e8 f9 4d 8d 24 1f 49 8d bc 24 00 05 00 00 48 89 f8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 74 08 3c 03 0f 8e 9c 02 00 00 45 8b ac 24 00
RSP: 0018:ffffc9000351f818 EFLAGS: 00010a02
RAX: 1fffdfffffffffc8 RBX: fffffffffffff940 RCX: 0000000000000000
RDX: ffff88807cc7c140 RSI: ffffffff879318cb RDI: fffefffffffffe40
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: fffefffffffff940
R13: ffffffff9152ccc0 R14: dffffc0000000000 R15: ffff000000000000
FS:  00007fbe244b5740(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffdbffffffffc8 CR3: 0000000021e67000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	01 44 89 e6          	add    %eax,-0x1a(%rcx,%rcx,4)
   4:	e8 83 19 e8 f9       	callq  0xf9e8198c
   9:	45 84 e4             	test   %r12b,%r12b
   c:	0f 85 8f 01 00 00    	jne    0x1a1
  12:	e8 f5 1c e8 f9       	callq  0xf9e81d0c
  17:	4d 8d 24 1f          	lea    (%r15,%rbx,1),%r12
  1b:	49 8d bc 24 00 05 00 	lea    0x500(%r12),%rdi
  22:	00
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	74 08                	je     0x3b
  33:	3c 03                	cmp    $0x3,%al
  35:	0f 8e 9c 02 00 00    	jle    0x2d7
  3b:	45                   	rex.RB
  3c:	8b                   	.byte 0x8b
  3d:	ac                   	lods   %ds:(%rsi),%al
  3e:	24 00                	and    $0x0,%al


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
