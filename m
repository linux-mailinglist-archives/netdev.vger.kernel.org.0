Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131C1561312
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiF3HP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiF3HPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:15:23 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C18C1A39D
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:15:22 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id i16-20020a6b3b10000000b00674d8768dc7so9767145ioa.6
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 00:15:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=lE9BzIUKICukc8SkmFItW47IxQiNAFrwrpfhpRR3fjc=;
        b=RmGZpjcTPnV2fPk/ipsZwWi4q3CXHtkQttOIDM+S1tOO3/GkIvbSY7FBq3InuLcqiI
         uBNIgEZFZKXPpcuzUItuJ7fnUZ/yx13r3P/1Uae7S8USOaDDsv4sXJhdp2tRARjGwI98
         lodhtWvjh5LJJlt8XQHfr+GzCE5RMLtUCzb9oAveuZHsqtpvT9pf5ZzrPn95hsGM5xlK
         itm0pRnUywrcNGJQ9qE3gwJGkVQMv5/Y57jT/SOJBN8mlPSKclORCuBNo+M1XfZEJeD7
         EPXi5ge4iplhRIot4ture4jYSXYpsTeiIyBROCkdyswXgomQWsbl5/Ea8pIHi1OALcaF
         0u9g==
X-Gm-Message-State: AJIora/AyGXBfPVowNGWq04NjqECl3rNjpRqFfqtQSxwPQ9KWofvn9Qu
        0JxpWc/vKMcCsEN8uvAhsmPbE3KCtVlLC5oTG6rKfxy7qUN2
X-Google-Smtp-Source: AGRyM1u9Z9qHeCLmVnrmXKqh9AQp03JFR04fxqjyrZZ1SKnXsEJ7Iit1qoWniE/jXnml7mOPNgXzySQgdcCz9tVqpn4CWNmsHJ+i
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1446:b0:331:e0cc:bd15 with SMTP id
 l6-20020a056638144600b00331e0ccbd15mr4463824jad.89.1656573321832; Thu, 30 Jun
 2022 00:15:21 -0700 (PDT)
Date:   Thu, 30 Jun 2022 00:15:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000064700605e2a508c0@google.com>
Subject: [syzbot] general protection fault in rose_transmit_link (3)
From:   syzbot <syzbot+677921bcd8c3a67a3df3@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, ralf@linux-mips.org,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    cb8092d70a6f tipc: move bc link creation back to tipc_node..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=115d4c18080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=542d3d75f0e6f36f
dashboard link: https://syzkaller.appspot.com/bug?extid=677921bcd8c3a67a3df3
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+677921bcd8c3a67a3df3@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 1 PID: 4101 Comm: syz-executor.0 Not tainted 5.19.0-rc3-syzkaller-00134-gcb8092d70a6f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:rose_transmit_link+0x2e/0x5e0 net/rose/rose_link.c:263
Code: 41 55 41 54 49 89 fc 55 48 89 f5 53 48 83 ec 08 e8 a7 5c 30 f9 48 8d 7d 32 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 ce 04 00 00
RSP: 0018:ffffc90005887a40 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff88803022c85a RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff884a18e9 RDI: 0000000000000032
RBP: 0000000000000000 R08: 0000000000000005 R09: 000000000000001f
R10: 0000000000000013 R11: 0000000000000000 R12: ffff888047e9f780
R13: 0000000000000010 R14: 0000000000000013 R15: ffff88807a854000
FS:  00007f000df57700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002000f038 CR3: 0000000037cae000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rose_write_internal+0x272/0x1890 net/rose/rose_subr.c:198
 rose_release+0x1ba/0x4c0 net/rose/af_rose.c:634
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1365
 __fput+0x277/0x9d0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:177
 get_signal+0x1c5/0x2600 kernel/signal.c:2634
 arch_do_signal_or_restart+0x82/0x2300 arch/x86/kernel/signal.c:869
 exit_to_user_mode_loop kernel/entry/common.c:166 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:201
 __syscall_exit_to_user_mode_work kernel/entry/common.c:283 [inline]
 syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:294
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f000ce89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f000df57168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: 0000000000000000 RBX: 00007f000cf9c030 RCX: 00007f000ce89109
RDX: 0000000000000040 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 00007f000cee305d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffda3cdf48f R14: 00007f000df57300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rose_transmit_link+0x2e/0x5e0 net/rose/rose_link.c:263
Code: 41 55 41 54 49 89 fc 55 48 89 f5 53 48 83 ec 08 e8 a7 5c 30 f9 48 8d 7d 32 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 ce 04 00 00
RSP: 0018:ffffc90005887a40 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffff88803022c85a RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffffff884a18e9 RDI: 0000000000000032
RBP: 0000000000000000 R08: 0000000000000005 R09: 000000000000001f
R10: 0000000000000013 R11: 0000000000000000 R12: ffff888047e9f780
R13: 0000000000000010 R14: 0000000000000013 R15: ffff88807a854000
FS:  00007f000df57700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e925000 CR3: 0000000037cae000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	41 55                	push   %r13
   2:	41 54                	push   %r12
   4:	49 89 fc             	mov    %rdi,%r12
   7:	55                   	push   %rbp
   8:	48 89 f5             	mov    %rsi,%rbp
   b:	53                   	push   %rbx
   c:	48 83 ec 08          	sub    $0x8,%rsp
  10:	e8 a7 5c 30 f9       	callq  0xf9305cbc
  15:	48 8d 7d 32          	lea    0x32(%rbp),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	48 89 fa             	mov    %rdi,%rdx
  31:	83 e2 07             	and    $0x7,%edx
  34:	38 d0                	cmp    %dl,%al
  36:	7f 08                	jg     0x40
  38:	84 c0                	test   %al,%al
  3a:	0f 85 ce 04 00 00    	jne    0x50e


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
