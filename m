Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2492858887A
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 10:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiHCII0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 04:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiHCIIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 04:08:25 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6592181C
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 01:08:24 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id j13-20020a056e02154d00b002de828b4b63so5875364ilu.10
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 01:08:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=DnKgHfVeryvGCNoHB1EyKn+lx8bXA1rZCbfzsbzRrB4=;
        b=bOQxlRLgAn4kpPbG3WijRhW4Vs8b/1DUJi+vx0zGY5LP1xIpGOWIpMDs65DRgmGXwU
         wyA0kVGRTdeb+GO1wP8wpp03WxAKErwc53ejwUX5mpFP0lmM2f2fCFBwyKQGwm96KtuL
         eziocIeZYOy1ozic1T+qPLepsD2wtDITJL74EvzftrkBAItRPzMT9DBssoDmhgbrUHc5
         AUimHIWnQ1Gmcys4AJqfvMyT+FLtQDUbxAS/1w1PQUuHyphW9NT4WneHhGZRK92hvBTB
         WO+ow9qeVIw+7Pd71dmwIWQ05gyBsc4S71FZ1HXiU9ym1Afxau9BOP5Bq4NLZ99BQj6v
         eHhQ==
X-Gm-Message-State: AJIora/bqo/eE2VfU0UXOFqBPMq8RTxjGCHoVvHwx7W+tptEmwWXhP/J
        lWbimUynPD6qHtlbI7o50RHT+s4FDQS8GCgIDc8J7sAtOWe2
X-Google-Smtp-Source: AGRyM1uRqF+ppfRWmGMINjlhkoAsyyiv/kcTBOB7yLp+o6LFMAl6hFsPdPtUtinskQRHxOX03PyHY8yewA3xh1ZN567i19ofbiC2
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:602:b0:2de:693:e7f4 with SMTP id
 t2-20020a056e02060200b002de0693e7f4mr10495029ils.278.1659514103476; Wed, 03
 Aug 2022 01:08:23 -0700 (PDT)
Date:   Wed, 03 Aug 2022 01:08:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a33d5b05e551bc31@google.com>
Subject: [syzbot] general protection fault in br_nf_pre_routing_finish (2)
From:   syzbot <syzbot+dc42341ea62e8eb6c1f7@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, edumazet@google.com, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, razor@blackwall.org, roopa@nvidia.com,
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

HEAD commit:    d7c4c9e075f8 ax25: fix incorrect dev_tracker usage
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=123a0cde080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26034e6fe0075dad
dashboard link: https://syzkaller.appspot.com/bug?extid=dc42341ea62e8eb6c1f7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc42341ea62e8eb6c1f7@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 32332 Comm: kworker/0:4 Not tainted 5.19.0-rc8-syzkaller-00103-gd7c4c9e075f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Workqueue: events_power_efficient neigh_managed_work
RIP: 0010:br_nf_pre_routing_finish+0x200/0x1ad0 net/bridge/br_netfilter_hooks.c:360
Code: 83 c0 01 38 d0 7c 08 84 d2 0f 85 e3 12 00 00 48 8d 7b 02 45 0f b7 74 24 3e 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 b9
RSP: 0018:ffffc90000007868 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 0000000000000000 RSI: ffffffff883fc456 RDI: 0000000000000002
RBP: ffff88801d0ee000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88807e999000
R13: 0000000000000010 R14: 00000000000005dc R15: ffff888074392800
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fde65908d64 CR3: 000000004d41b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 br_nf_pre_routing+0xae3/0x1f00 net/bridge/br_netfilter_hooks.c:531
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:255 [inline]
 br_handle_frame+0x8df/0x1280 net/bridge/br_input.c:399
 __netif_receive_skb_core+0xa13/0x3920 net/core/dev.c:5378
 __netif_receive_skb_one_core+0xae/0x180 net/core/dev.c:5482
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5598
 process_backlog+0x3a0/0x7c0 net/core/dev.c:5926
 __napi_poll+0xb3/0x6e0 net/core/dev.c:6492
 napi_poll net/core/dev.c:6559 [inline]
 net_rx_action+0x9c1/0xd90 net/core/dev.c:6670
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
 do_softirq.part.0+0xde/0x130 kernel/softirq.c:472
 </IRQ>
 <TASK>
 do_softirq kernel/softirq.c:464 [inline]
 __local_bh_enable_ip+0x102/0x120 kernel/softirq.c:396
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:br_nf_pre_routing_finish+0x200/0x1ad0 net/bridge/br_netfilter_hooks.c:360
Code: 83 c0 01 38 d0 7c 08 84 d2 0f 85 e3 12 00 00 48 8d 7b 02 45 0f b7 74 24 3e 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 b9
RSP: 0018:ffffc90000007868 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000100
RDX: 0000000000000000 RSI: ffffffff883fc456 RDI: 0000000000000002
RBP: ffff88801d0ee000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff88807e999000
R13: 0000000000000010 R14: 00000000000005dc R15: ffff888074392800
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fde65908d64 CR3: 000000004d41b000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	83 c0 01             	add    $0x1,%eax
   3:	38 d0                	cmp    %dl,%al
   5:	7c 08                	jl     0xf
   7:	84 d2                	test   %dl,%dl
   9:	0f 85 e3 12 00 00    	jne    0x12f2
   f:	48 8d 7b 02          	lea    0x2(%rbx),%rdi
  13:	45 0f b7 74 24 3e    	movzwl 0x3e(%r12),%r14d
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
  2e:	48 89 f8             	mov    %rdi,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 01             	add    $0x1,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85                   	.byte 0x85
  3f:	b9                   	.byte 0xb9


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
