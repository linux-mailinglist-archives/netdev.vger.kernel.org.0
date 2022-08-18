Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6AE597ED4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243531AbiHRGyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243323AbiHRGyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:54:32 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226EF5F235
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:54:31 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id z30-20020a05660217de00b00688bd42dc1dso408212iox.15
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:54:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=mbKOrYZyWFLRbX6wKHcAdeItOh4MyQXTN8N19xwN808=;
        b=kDW//5kJT5mukLYubJqfgPRR86BFFnlSbqXp3YXYPsypRDkhHdD9H5mK3heHbHIaKV
         W5uEFQX4ZWdY3ftfJyXyLtkErKsWtvhu49LQ10sFU/79fvLVCEj6pW8CL78LNk7MtNYz
         VMEIAonbLegHcdPrsXUK8LOBhTj2NQzgcftsaOiPkvWRMt5Puf56I1HZoau6M6J0+wg3
         x45E19u5W75WSMlxWkOz0GTL257anMFxSURGzE1kKoFc1M4GbdUwnG4QUSGcg+/6/69w
         8BMGwSWhfh9FTDYn2GJrel7X5U6hSXDxPJYGLQ7UDosQX3Cg+efEeZIhrnqr4e/Tpk3E
         ka1A==
X-Gm-Message-State: ACgBeo3P0qbH5mRZA0GCdlTjLQlX1j/I5Qdnj+nHVGziRSFeUVA6GZa5
        9G3qtmELre/YsUrldJ+n6en1IcQGGdbY5v/qUjqDD3brqpLy
X-Google-Smtp-Source: AA6agR7W8W1iFYrka1GoA6jhbjHyzIaN9HihBhgzPg4web5i0xn3MVpG7nIpU2HC5SNTs3qUWhVlzfpfbQciZNMxz8xKrDHbDHUh
MIME-Version: 1.0
X-Received: by 2002:a6b:e816:0:b0:688:c999:d08c with SMTP id
 f22-20020a6be816000000b00688c999d08cmr874708ioh.100.1660805670466; Wed, 17
 Aug 2022 23:54:30 -0700 (PDT)
Date:   Wed, 17 Aug 2022 23:54:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000077caa05e67e7461@google.com>
Subject: [syzbot] general protection fault in tls_strp_load_anchor_with_queue
From:   syzbot <syzbot+7b9133d0ed61f27a4f7d@syzkaller.appspotmail.com>
To:     borisp@nvidia.com, davem@davemloft.net, edumazet@google.com,
        john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7ebfc85e2cd7 Merge tag 'net-6.0-rc1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1750b16b080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=924833c12349a8c0
dashboard link: https://syzkaller.appspot.com/bug?extid=7b9133d0ed61f27a4f7d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b9133d0ed61f27a4f7d@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 PID: 9070 Comm: syz-executor.1 Not tainted 5.19.0-syzkaller-13930-g7ebfc85e2cd7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:tls_strp_load_anchor_with_queue+0x111/0x360 net/tls/tls_strp.c:329
Code: 48 c1 ea 03 80 3c 02 00 0f 85 26 02 00 00 4c 8b 73 18 41 01 f4 48 b8 00 00 00 00 00 fc ff df 49 8d 7e 70 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e e3 01 00 00 48 b8 00 00 00 00
RSP: 0018:ffffc900051c7b88 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: ffff88801fe3f0d0 RCX: ffffc9000ac99000
RDX: 000000000000000e RSI: 0000000000000000 RDI: 0000000000000070
RBP: ffff8880174dcb40 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 1ffff92000a38f72 R14: 0000000000000000 R15: ffff88801fe3f0e8
FS:  00007fc847b72700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc847b71ff8 CR3: 0000000079991000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 tls_strp_read_sock+0x3a4/0x840 net/tls/tls_strp.c:379
 tls_strp_check_rcv+0x79/0xb0 net/tls/tls_strp.c:404
 do_tls_setsockopt_conf net/tls/tls_main.c:731 [inline]
 do_tls_setsockopt net/tls/tls_main.c:801 [inline]
 tls_setsockopt+0xecb/0x1240 net/tls/tls_main.c:829
 __sys_setsockopt+0x2d6/0x690 net/socket.c:2252
 __do_sys_setsockopt net/socket.c:2263 [inline]
 __se_sys_setsockopt net/socket.c:2260 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2260
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fc846a89279
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc847b72168 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fc846b9bf80 RCX: 00007fc846a89279
RDX: 0000000000000002 RSI: 000000000000011a RDI: 0000000000000003
RBP: 00007fc847b721d0 R08: 0000000000000038 R09: 0000000000000000
R10: 00000000200004c0 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fffd9012e3f R14: 00007fc847b72300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:tls_strp_load_anchor_with_queue+0x111/0x360 net/tls/tls_strp.c:329
Code: 48 c1 ea 03 80 3c 02 00 0f 85 26 02 00 00 4c 8b 73 18 41 01 f4 48 b8 00 00 00 00 00 fc ff df 49 8d 7e 70 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e e3 01 00 00 48 b8 00 00 00 00
RSP: 0018:ffffc900051c7b88 EFLAGS: 00010212
RAX: dffffc0000000000 RBX: ffff88801fe3f0d0 RCX: ffffc9000ac99000
RDX: 000000000000000e RSI: 0000000000000000 RDI: 0000000000000070
RBP: ffff8880174dcb40 R08: 0000000000000004 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 1ffff92000a38f72 R14: 0000000000000000 R15: ffff88801fe3f0e8
FS:  00007fc847b72700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc280ded718 CR3: 0000000079991000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess):
   0:	48 c1 ea 03          	shr    $0x3,%rdx
   4:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   8:	0f 85 26 02 00 00    	jne    0x234
   e:	4c 8b 73 18          	mov    0x18(%rbx),%r14
  12:	41 01 f4             	add    %esi,%r12d
  15:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  1c:	fc ff df
  1f:	49 8d 7e 70          	lea    0x70(%r14),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	74 08                	je     0x3a
  32:	3c 03                	cmp    $0x3,%al
  34:	0f 8e e3 01 00 00    	jle    0x21d
  3a:	48                   	rex.W
  3b:	b8 00 00 00 00       	mov    $0x0,%eax


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
