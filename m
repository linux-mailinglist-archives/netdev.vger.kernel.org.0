Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744A85F2BAC
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 10:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJCIYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 04:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiJCIYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 04:24:00 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0321B78B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 00:58:36 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id i21-20020a056e021d1500b002f9e4f8eab7so1045121ila.7
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 00:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=r2viLVPjnSHunJS5AMToNZyoSKI7yDr8nQFXgPohi0Q=;
        b=SVCOYiIUqTRQN/Y+Yr9Qih4/oke23ncRKENOZctwtVWUEn2fInnUUBXxJVq1u1oKOn
         gItKM8QwtkTH+HeA8XizdICFuIIXQ/omROfvsxO4ajFD/Az+VO3/CsukcYivXHck3hA/
         VEsxnu/OsDImyN7Mxrd5jwGx/rxI/QxwIM9SsI/LBFy6gQL99TmUKB9iWKKh/QReYNIR
         ViOd3EH2lKD2ryBZeQsKBjAizG8ztccLy/Uogd0svS0CecTxzAUBoH/lGD+iOFtmYkVE
         cf52ydhe/t1DC3+wzN4HLDwIbjJYWi+OBAATla8KY5bHnASI9SrzKVAID+goF2GT2wSh
         QR/g==
X-Gm-Message-State: ACrzQf3YAseb1wUtewXH6tMIg+ut8xNZJA5pxKWOTg9g4PoVXq/p2+x5
        GDx8JZmqOw3xHFRogfZWsiSitBKx5XQCIW7KZZj8i3uzw5aE
X-Google-Smtp-Source: AMsMyM5DvDjqQ2hB5GvaVhDBENn7N+ou2fyn/cEIKaByb2wSXTPS1saI5r7mYAK6fKn0hKlI4A8xY+5ZPUvnXF8kAtm7s59/5iyd
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2402:b0:35a:1e83:e43b with SMTP id
 z2-20020a056638240200b0035a1e83e43bmr9870205jat.146.1664783853237; Mon, 03
 Oct 2022 00:57:33 -0700 (PDT)
Date:   Mon, 03 Oct 2022 00:57:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000333b8205ea1cb208@google.com>
Subject: [syzbot] general protection fault in mpls_dev_notify
From:   syzbot <syzbot+8bc17b3c5f031a4f9c7a@syzkaller.appspotmail.com>
To:     bigeasy@linutronix.de, bpoirier@nvidia.com, davem@davemloft.net,
        edumazet@google.com, gongruiqi1@huawei.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        victor.erminpour@oracle.com
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

HEAD commit:    87dbdc230d16 libbpf: Don't require full struct enum64 in U..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12b84b40880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42e1b6f9cf3a9e87
dashboard link: https://syzkaller.appspot.com/bug?extid=8bc17b3c5f031a4f9c7a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bc17b3c5f031a4f9c7a@syzkaller.appspotmail.com

bond0 (unregistering): (slave bond_slave_1): Releasing backup interface
bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves
general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 0 PID: 1188 Comm: kworker/u4:5 Not tainted 6.0.0-rc3-syzkaller-00907-g87dbdc230d16 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Workqueue: netns cleanup_net
RIP: 0010:mpls_dev_sysctl_unregister net/mpls/af_mpls.c:1440 [inline]
RIP: 0010:mpls_dev_notify+0x5b1/0x9b0 net/mpls/af_mpls.c:1653
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 d2 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 18 48 8d 7d 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e4 03 00 00 4c 8b 75 20 48 89 ef e8 d9 8f dd ff
RSP: 0018:ffffc900053ef988 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888025615480 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff892de450 RDI: 0000000000000020
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888021f38378
R13: ffff88804c6b0000 R14: 0000000000000000 R15: ffff888021f38000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f24d03faa70 CR3: 0000000075674000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:87
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1945
 call_netdevice_notifiers_extack net/core/dev.c:1983 [inline]
 call_netdevice_notifiers net/core/dev.c:1997 [inline]
 unregister_netdevice_many+0xa62/0x1980 net/core/dev.c:10860
 default_device_exit_batch+0x449/0x590 net/core/dev.c:11354
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:168
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:595
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:mpls_dev_sysctl_unregister net/mpls/af_mpls.c:1440 [inline]
RIP: 0010:mpls_dev_notify+0x5b1/0x9b0 net/mpls/af_mpls.c:1653
Code: 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 d2 03 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6b 18 48 8d 7d 20 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 e4 03 00 00 4c 8b 75 20 48 89 ef e8 d9 8f dd ff
RSP: 0018:ffffc900053ef988 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888025615480 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff892de450 RDI: 0000000000000020
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888021f38378
R13: ffff88804c6b0000 R14: 0000000000000000 R15: ffff888021f38000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005587a8b96950 CR3: 00000000257b2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	48 c1 ea 03          	shr    $0x3,%rdx
   7:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   b:	0f 85 d2 03 00 00    	jne    0x3e3
  11:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  18:	fc ff df
  1b:	48 8b 6b 18          	mov    0x18(%rbx),%rbp
  1f:	48 8d 7d 20          	lea    0x20(%rbp),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 e4 03 00 00    	jne    0x418
  34:	4c 8b 75 20          	mov    0x20(%rbp),%r14
  38:	48 89 ef             	mov    %rbp,%rdi
  3b:	e8 d9 8f dd ff       	callq  0xffdd9019


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
