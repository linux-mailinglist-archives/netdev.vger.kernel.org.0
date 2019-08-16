Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C59907CE
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 20:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfHPSiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 14:38:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:51630 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbfHPSiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 14:38:06 -0400
Received: by mail-io1-f70.google.com with SMTP id a13so2866951ioh.18
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 11:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=e+PpDr2V5juOVFqyDrSXmdwTl7F7MomLEjKAO8N9nHE=;
        b=Be+SisqaHK1zUeOtLsFy5ja+oBUKVNal5GWzwbcGS9m0gi06ZzuHoxtoQ2QmvVAl7n
         5y4wwXMQiYuhuwX2c71STiDpz5iTrXddBLgLmuiMad+eScVjgZ49Oz3x47sIoFClmNmK
         PEEj3IWU2ss7gtqCUCJsTSOyiGSIAAv1A0ZkW/4nOFfx+StNXD0IhKhRu27JXwxPiONG
         hpBEJVUz8MWGuZWCOAVq890YQdPOKrj+ZIDSK/lvo71jRb/LCU69VSVJK4TULDQaWZ3S
         ESPvoYXeu3N72idlS/kkUyNaWe047FtHega8Fo4odTL0GMY+H8zFdmBcy8SSoOxyGDJq
         EDeA==
X-Gm-Message-State: APjAAAXfyJWVslKpmskMq3VsG2QjWQzmExFIq16mh+QbPDkfSpzCpc07
        DM5iLNR9moO1IDjfBwQ+4tcfNkMMR43U9ACA+cx3r52s2tWP
X-Google-Smtp-Source: APXvYqztCTnJ1XN8Ogox+HQMGaETd1ve60ILEmNYDv6FMhvpwpTgbF5o54dyXD4/u88ixVkGMSOa7OzqRlekj79K/l5EBrL9Obk7
MIME-Version: 1.0
X-Received: by 2002:a5e:8e08:: with SMTP id a8mr12191314ion.94.1565980685858;
 Fri, 16 Aug 2019 11:38:05 -0700 (PDT)
Date:   Fri, 16 Aug 2019 11:38:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008182a50590404a02@google.com>
Subject: kernel BUG at include/linux/skbuff.h:LINE! (2)
From:   syzbot <syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    459c5fb4 Merge branch 'mscc-PTP-support'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13f2d33c600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d4cf1ffb87d590d7
dashboard link: https://syzkaller.appspot.com/bug?extid=eb349eeee854e389c36d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111849e2600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1442c25a600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+eb349eeee854e389c36d@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at include/linux/skbuff.h:2225!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9030 Comm: syz-executor649 Not tainted 5.3.0-rc3+ #134
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
RIP: 0010:__skb_pull include/linux/skbuff.h:2222 [inline]
RIP: 0010:skb_pull_inline include/linux/skbuff.h:2231 [inline]
RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
Code: 9d c8 00 00 00 49 89 dc 49 89 9d c8 00 00 00 e8 9c e5 dd fb 4c 89 e0  
5b 41 5c 41 5d 41 5e 5d c3 45 31 e4 eb ea e8 86 e5 dd fb <0f> 0b e8 df 13  
18 fc e9 44 ff ff ff e8 d5 13 18 fc eb 8a e8 ee 13
RSP: 0018:ffff88808ac96e10 EFLAGS: 00010293
RAX: ffff88809c546000 RBX: 0000000000000004 RCX: ffffffff8594a3a6
RDX: 0000000000000000 RSI: ffffffff8594a3fa RDI: 0000000000000004
RBP: ffff88808ac96e30 R08: ffff88809c546000 R09: fffffbfff14a8f4f
R10: fffffbfff14a8f4e R11: ffffffff8a547a77 R12: 0000000095e28bcc
R13: ffff88808ac97478 R14: 00000000ffff8880 R15: ffff88808ac97478
FS:  0000555556549880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 0000000089c3c000 CR4: 00000000001406f0
Call Trace:
  sctp_inq_pop+0x2f1/0xd80 net/sctp/inqueue.c:202
  sctp_endpoint_bh_rcv+0x184/0x8d0 net/sctp/endpointola.c:385
  sctp_inq_push+0x1e4/0x280 net/sctp/inqueue.c:80
  sctp_rcv+0x2807/0x3590 net/sctp/input.c:256
  sctp6_rcv+0x17/0x30 net/sctp/ipv6.c:1049
  ip6_protocol_deliver_rcu+0x2fe/0x1660 net/ipv6/ip6_input.c:397
  ip6_input_finish+0x84/0x170 net/ipv6/ip6_input.c:438
  NF_HOOK include/linux/netfilter.h:305 [inline]
  NF_HOOK include/linux/netfilter.h:299 [inline]
  ip6_input+0xe4/0x3f0 net/ipv6/ip6_input.c:447
  dst_input include/net/dst.h:442 [inline]
  ip6_sublist_rcv_finish+0x98/0x1e0 net/ipv6/ip6_input.c:84
  ip6_list_rcv_finish net/ipv6/ip6_input.c:118 [inline]
  ip6_sublist_rcv+0x80c/0xcf0 net/ipv6/ip6_input.c:282
  ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:316
  __netif_receive_skb_list_ptype net/core/dev.c:5049 [inline]
  __netif_receive_skb_list_core+0x5fc/0x9d0 net/core/dev.c:5097
  __netif_receive_skb_list net/core/dev.c:5149 [inline]
  netif_receive_skb_list_internal+0x7eb/0xe60 net/core/dev.c:5244
  gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5757
  gro_normal_list net/core/dev.c:5755 [inline]
  gro_normal_one net/core/dev.c:5769 [inline]
  napi_frags_finish net/core/dev.c:5782 [inline]
  napi_gro_frags+0xa6a/0xea0 net/core/dev.c:5855
  tun_get_user+0x2e98/0x3fa0 drivers/net/tun.c:1974
  tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2020
  call_write_iter include/linux/fs.h:1870 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
  do_writev+0x15b/0x330 fs/read_write.c:1058
  __do_sys_writev fs/read_write.c:1131 [inline]
  __se_sys_writev fs/read_write.c:1128 [inline]
  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441b10
Code: 05 48 3d 01 f0 ff ff 0f 83 5d 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00  
00 66 90 83 3d 01 95 29 00 00 75 14 b8 14 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 34 09 fc ff c3 48 83 ec 08 e8 ba 2b 00 00
RSP: 002b:00007ffe63706b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007ffe63706ba0 RCX: 0000000000441b10
RDX: 0000000000000001 RSI: 00007ffe63706bd0 RDI: 00000000000000f0
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000004
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000122cb
R13: 0000000000402960 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace c37566c1c02066db ]---
RIP: 0010:__skb_pull include/linux/skbuff.h:2225 [inline]
RIP: 0010:__skb_pull include/linux/skbuff.h:2222 [inline]
RIP: 0010:skb_pull_inline include/linux/skbuff.h:2231 [inline]
RIP: 0010:skb_pull+0xea/0x110 net/core/skbuff.c:1902
Code: 9d c8 00 00 00 49 89 dc 49 89 9d c8 00 00 00 e8 9c e5 dd fb 4c 89 e0  
5b 41 5c 41 5d 41 5e 5d c3 45 31 e4 eb ea e8 86 e5 dd fb <0f> 0b e8 df 13  
18 fc e9 44 ff ff ff e8 d5 13 18 fc eb 8a e8 ee 13
RSP: 0018:ffff88808ac96e10 EFLAGS: 00010293
RAX: ffff88809c546000 RBX: 0000000000000004 RCX: ffffffff8594a3a6
RDX: 0000000000000000 RSI: ffffffff8594a3fa RDI: 0000000000000004
RBP: ffff88808ac96e30 R08: ffff88809c546000 R09: fffffbfff14a8f4f
R10: fffffbfff14a8f4e R11: ffffffff8a547a77 R12: 0000000095e28bcc
R13: ffff88808ac97478 R14: 00000000ffff8880 R15: ffff88808ac97478
FS:  0000555556549880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000100 CR3: 0000000089c3c000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
