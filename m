Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378E14BC710
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 10:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiBSJSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 04:18:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbiBSJSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 04:18:43 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794534969E
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 01:18:25 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id d194-20020a6bcdcb000000b0063a4e3b9da6so6109103iog.6
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 01:18:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GpEXurb/S08muFuH03jM5Ro3DWfUqzEGOWNpjHYvW64=;
        b=T16XZzcMB1G/qQ0yPT2YLxhBCu8cu3eu56atRRGzqJDYM+eVwKd4usAFyBaKXmuKUe
         PUsyheQ/fXtpqDR3qBpRIY84cAGTjf9LkgXXKtekDxVBHU4zX6O9u/X/CgUgz63sszbH
         SVoKHJBsn5hCwVeWyyl9u/pLGoSmcs9ERvNAPW9M5HBAKoDR4Zq8yYxYrBiJDK9PAVVI
         VjSCKfYYdAsceu1yESGD7gkrde7zhbrCZbcKyGyAfOWQK+ruwQMUNC664eWiMt+KXf9U
         0xaYFxJXuYRmKgzuZQj532pmg2SdUe8eNDimUUsP0VMBnWJSakGL/MczQ6pX4MSYGsss
         HoYQ==
X-Gm-Message-State: AOAM5300Ja6px9YXGKHX13LSE4jgN6RhuXBNAaFxzABiFRPN+in3W2ny
        sd5/KsQUnagTADHzc8mn3KOlmu8ep+9npXFy+Qw9NkrxvyVm
X-Google-Smtp-Source: ABdhPJy7o5V/bFBQz2imOBcrDumDi+pVL5Q7QH7hQubElYJ+VI+abvTgyXM7ya+foBKe3TBq5Xb+CdElFM80pygMpLGrta3hCrO/
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a66:b0:2c1:888d:b9cb with SMTP id
 w6-20020a056e021a6600b002c1888db9cbmr7494872ilv.74.1645262304803; Sat, 19 Feb
 2022 01:18:24 -0800 (PST)
Date:   Sat, 19 Feb 2022 01:18:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003d82b405d85b7be9@google.com>
Subject: [syzbot] general protection fault in vhost_iotlb_itree_first
From:   syzbot <syzbot+bbb030fc51d6f3c5d067@syzkaller.appspotmail.com>
To:     jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
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

HEAD commit:    359303076163 tty: n_tty: do not look ahead for EOL charact..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b34b54700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da674567f7b6043d
dashboard link: https://syzkaller.appspot.com/bug?extid=bbb030fc51d6f3c5d067
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bbb030fc51d6f3c5d067@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 17981 Comm: vhost-17980 Not tainted 5.17.0-rc4-syzkaller-00052-g359303076163 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vhost_iotlb_itree_iter_first drivers/vhost/iotlb.c:19 [inline]
RIP: 0010:vhost_iotlb_itree_first+0x29/0x280 drivers/vhost/iotlb.c:169
Code: 00 41 57 41 56 41 55 49 89 d5 41 54 55 48 89 fd 53 48 89 f3 e8 e8 eb a0 fa 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 e8 01 00 00 4c 8b 65 00 4d 85 e4 0f 84 b3 01 00
RSP: 0018:ffffc90004f57ac8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 30303030320a0028 RCX: ffffc900103dc000
RDX: 0000000000000000 RSI: ffffffff86d72738 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
R10: ffffffff86d62d88 R11: 0000000000000000 R12: ffff8880260e4d68
R13: 303030305f3a3057 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2d46121901 CR3: 000000001d652000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 translate_desc+0x11e/0x3e0 drivers/vhost/vhost.c:2054
 vhost_get_vq_desc+0x662/0x22c0 drivers/vhost/vhost.c:2300
 vhost_vsock_handle_tx_kick+0x277/0xa20 drivers/vhost/vsock.c:522
 vhost_worker+0x23d/0x3d0 drivers/vhost/vhost.c:372
 kthread+0x2e9/0x3a0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:vhost_iotlb_itree_iter_first drivers/vhost/iotlb.c:19 [inline]
RIP: 0010:vhost_iotlb_itree_first+0x29/0x280 drivers/vhost/iotlb.c:169
Code: 00 41 57 41 56 41 55 49 89 d5 41 54 55 48 89 fd 53 48 89 f3 e8 e8 eb a0 fa 48 89 ea 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f 85 e8 01 00 00 4c 8b 65 00 4d 85 e4 0f 84 b3 01 00
RSP: 0018:ffffc90004f57ac8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 30303030320a0028 RCX: ffffc900103dc000
RDX: 0000000000000000 RSI: ffffffff86d72738 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000002
R10: ffffffff86d62d88 R11: 0000000000000000 R12: ffff8880260e4d68
R13: 303030305f3a3057 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2d449f6718 CR3: 000000001d652000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 41 57             	add    %al,0x57(%rcx)
   3:	41 56                	push   %r14
   5:	41 55                	push   %r13
   7:	49 89 d5             	mov    %rdx,%r13
   a:	41 54                	push   %r12
   c:	55                   	push   %rbp
   d:	48 89 fd             	mov    %rdi,%rbp
  10:	53                   	push   %rbx
  11:	48 89 f3             	mov    %rsi,%rbx
  14:	e8 e8 eb a0 fa       	callq  0xfaa0ec01
  19:	48 89 ea             	mov    %rbp,%rdx
  1c:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  23:	fc ff df
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 e8 01 00 00    	jne    0x21c
  34:	4c 8b 65 00          	mov    0x0(%rbp),%r12
  38:	4d 85 e4             	test   %r12,%r12
  3b:	0f                   	.byte 0xf
  3c:	84                   	.byte 0x84
  3d:	b3 01                	mov    $0x1,%bl


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
