Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC825EBDC3
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiI0Itq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiI0Itl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:49:41 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F751F2DF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:49:39 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id q3-20020a056e0220e300b002f5e648e02eso7037124ilv.3
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 01:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=VcrBPx8xfJ9lVz+FClYVuo7si9Glw5I9QGikXlKH2Ug=;
        b=Tjc30jHfACLubEMDoUrQgBZj04ROPh4Nb3fGwvlhJ5zm8SaJe450gvAok3hDxMLNLD
         sFPz15Ag/qhG76+EtcmiEzCuWe0I+gf5gnZIed0VCzjYhHcok8Ww2MhFPJgHRHdrHkSo
         AqMjQHbdIVQ52ukLgSjYvtAjhEqhnsvj1155zQ/Ch8kWCa8vOpMqES0AZJIwgWgHlqH0
         tbPd4pFuwA6j/QbT1HxwTMoawqsCv4DatjffJVuhV4CT9Kj6hDbSXBesXiGGw3elZt0z
         rasTDjzX8b6z6eeG7EUWt/zl7HFXnLpDk+14RdFz2K6iwIpa83QVP6cZQ3o5BhudDSQ1
         nsNg==
X-Gm-Message-State: ACrzQf1TwqpwyY32ZdaKcftjcuJTVEhBgamfCslNcG8uI+3yVkRIfIMw
        6BMUCTBm6mADDCVeC9vdNdR8cwNO88zUqGCodV53VkZAbZ6D
X-Google-Smtp-Source: AMsMyM70AyRb0r7TXdF58Jm1rV5VBRv2D9KicVc0GeCv407F6+C7NHIjnxuPK8o4LraWCWiSU02rF4XmeVZN2JIw3U1gEMly8IGz
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b45:b0:2f8:ab79:fc70 with SMTP id
 f5-20020a056e020b4500b002f8ab79fc70mr2146818ilu.214.1664268578426; Tue, 27
 Sep 2022 01:49:38 -0700 (PDT)
Date:   Tue, 27 Sep 2022 01:49:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d989105e9a4b916@google.com>
Subject: [syzbot] general protection fault in kernel_accept (5)
From:   syzbot <syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com>
To:     bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    bf682942cd26 Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117fc3ac880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7db7ad17eb14cb7
dashboard link: https://syzkaller.appspot.com/bug?extid=c5ce866a8d30f4be0651
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 3 PID: 12841 Comm: kworker/u16:2 Not tainted 6.0.0-rc6-syzkaller-00210-gbf682942cd26 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Workqueue: tipc_rcv tipc_topsrv_accept
RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 20 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ee 00 00 00 48 8b 7b 08 e8 a0 36 1c fa e8 8b ff
RSP: 0018:ffffc9000494fc28 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff874c37b2 RDI: 0000000000000008
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000449 R12: 0000000000000000
R13: ffff888027a7b980 R14: ffff888028bc08e0 R15: 1ffff92000929f90
FS:  0000000000000000(0000) GS:ffff88802cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa6e1a8c920 CR3: 000000004bba0000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 e3 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 20 48 8d 7b 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 ee 00 00 00 48 8b 7b 08 e8 a0 36 1c fa e8 8b ff
RSP: 0018:ffffc9000494fc28 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff874c37b2 RDI: 0000000000000008
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000449 R12: 0000000000000000
R13: ffff888027a7b980 R14: ffff888028bc08e0 R15: 1ffff92000929f90
FS:  0000000000000000(0000) GS:ffff88802ca00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0154d8000 CR3: 000000006fb4b000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	48 c1 ea 03          	shr    $0x3,%rdx
   7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   b:	0f 85 e3 00 00 00    	jne    0xf4
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	48 8b 5b 20          	mov    0x20(%rbx),%rbx
  1f:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 ee 00 00 00    	jne    0x122
  34:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  38:	e8 a0 36 1c fa       	callq  0xfa1c36dd
  3d:	e8                   	.byte 0xe8
  3e:	8b ff                	mov    %edi,%edi


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
