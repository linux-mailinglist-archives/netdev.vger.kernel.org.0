Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E423F437A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 04:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhHWCqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 22:46:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42806 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhHWCp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 22:45:58 -0400
Received: by mail-io1-f70.google.com with SMTP id i78-20020a6b3b51000000b005b8dd0f9e76so7834142ioa.9
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 19:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=12ChNrzyjq/zJnCMsVciMv+4Lk5vVaEtBYYOuXO0/HE=;
        b=hyrvYNj/tIM/lo7un2IYVffXZ3bY2RpFVCegyVNhHDekOo2uUEZ60Ts4Qgo+TEc+XO
         HAMzVD78eK/JL71vGXrZeQQCItxm2HvEdXbm0LeHCg6E3D3Lwr4BqxZEfd12WvTBjqml
         WE2x/fe0IL7ZQRhuRUQQocFzha4heid52mN4H9ObWQBShLOA7Ix2uu+MLoEbgACx5cH3
         w/aP29C+Pj2luJfiXIAmnaGOZa8e2cfEXmZdK2TG5kX+HmruIrJNNfxY++KSU+6dAk5U
         YrAFoSeCCzZsbhkMRsYNMnwVl3GF3OJ4TlsbhBngKGP23AfEdVVhfaHFUODJ6fy9fIV9
         ovtg==
X-Gm-Message-State: AOAM531aqqjf9QkE7gsRn6zRnr4VWCbtVhwcXX9U3V+siiHJ4KXjUI8V
        MiSD1bo6edgFaHyh0x0a8cFwPvnSTA1WPpDL991tc2jFHXgC
X-Google-Smtp-Source: ABdhPJyK1L9ecY2RHqZ2YApoHKf7WDABJgrljfic2U1KM0hnNRpB0KPr9oHXiu2RQTvqTmmYmeBpbB9uqTNcipa0DJm+s9kbRsR/
MIME-Version: 1.0
X-Received: by 2002:a92:c081:: with SMTP id h1mr12312160ile.193.1629686716628;
 Sun, 22 Aug 2021 19:45:16 -0700 (PDT)
Date:   Sun, 22 Aug 2021 19:45:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7055905ca3101a4@google.com>
Subject: [syzbot] WARNING in timerqueue_del (2)
From:   syzbot <syzbot+ae14beb9462a89054786@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3349d3625d62 Merge branch '40GbE' of git://git.kernel.org/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11282731300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a03b1e3ef878f6c1
dashboard link: https://syzkaller.appspot.com/bug?extid=ae14beb9462a89054786
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ae14beb9462a89054786@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3780 at lib/timerqueue.c:55 timerqueue_del+0xf2/0x140 lib/timerqueue.c:55
Modules linked in:
CPU: 1 PID: 3780 Comm: syz-executor.5 Not tainted 5.14.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:timerqueue_del+0xf2/0x140 lib/timerqueue.c:55
Code: 48 89 df e8 c0 7c ff ff 4c 89 e1 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 75 40 48 89 45 08 eb 82 e8 0e b8 82 fd <0f> 0b e9 4c ff ff ff 48 89 df e8 1f 51 c9 fd eb 93 4c 89 e7 e8 95
RSP: 0000:ffffc9000101f370 EFLAGS: 00010046
RAX: 0000000000040000 RBX: ffffe8ffffd3fce0 RCX: ffffc900145f4000
RDX: 0000000000040000 RSI: ffffffff83f2f1a2 RDI: 0000000000000003
RBP: ffff8880b9d42490 R08: ffffe8ffffd3fce0 R09: 0000000000000001
R10: ffffffff83f2f0ec R11: 0000000000000000 R12: ffffe8ffffd3fce0
R13: 0000000000000001 R14: ffff8880b9d423c0 R15: 0000000000000000
FS:  00007f8847706700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f333ef09f80 CR3: 0000000064822000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __remove_hrtimer+0xa1/0x2a0 kernel/time/hrtimer.c:1014
 remove_hrtimer+0x19f/0x410 kernel/time/hrtimer.c:1054
 hrtimer_try_to_cancel kernel/time/hrtimer.c:1186 [inline]
 hrtimer_try_to_cancel+0x102/0x1e0 kernel/time/hrtimer.c:1168
 hrtimer_cancel+0x13/0x40 kernel/time/hrtimer.c:1295
 napi_disable+0xc3/0x110 net/core/dev.c:6909
 gro_cells_destroy net/core/gro_cells.c:101 [inline]
 gro_cells_destroy+0x10d/0x360 net/core/gro_cells.c:92
 ip_tunnel_dev_free+0x15/0x60 net/ipv4/ip_tunnel.c:1010
 netdev_run_todo+0x6b4/0xa80 net/core/dev.c:10589
 rtnl_unlock net/core/rtnetlink.c:112 [inline]
 rtnetlink_rcv_msg+0x420/0xb80 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x331/0x810 net/socket.c:2403
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2457
 __sys_sendmmsg+0x195/0x470 net/socket.c:2543
 __do_sys_sendmmsg net/socket.c:2572 [inline]
 __se_sys_sendmmsg net/socket.c:2569 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2569
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665e9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8847706188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000056c0f0 RCX: 00000000004665e9
RDX: 040000000000024a RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000003c6ac R11: 0000000000000246 R12: 000000000056c0f0
R13: 00007ffe1cc9787f R14: 00007f8847706300 R15: 0000000000022000
----------------
Code disassembly (best guess):
   0:	48 89 df             	mov    %rbx,%rdi
   3:	e8 c0 7c ff ff       	callq  0xffff7cc8
   8:	4c 89 e1             	mov    %r12,%rcx
   b:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  12:	fc ff df 
  15:	48 c1 e9 03          	shr    $0x3,%rcx
  19:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
  1d:	75 40                	jne    0x5f
  1f:	48 89 45 08          	mov    %rax,0x8(%rbp)
  23:	eb 82                	jmp    0xffffffa7
  25:	e8 0e b8 82 fd       	callq  0xfd82b838
  2a:	0f 0b                	ud2     <-- trapping instruction
  2c:	e9 4c ff ff ff       	jmpq   0xffffff7d
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 1f 51 c9 fd       	callq  0xfdc95158
  39:	eb 93                	jmp    0xffffffce
  3b:	4c 89 e7             	mov    %r12,%rdi
  3e:	e8                   	.byte 0xe8
  3f:	95                   	xchg   %eax,%ebp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
