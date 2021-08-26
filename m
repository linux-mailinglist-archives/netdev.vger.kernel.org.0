Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A513F8C30
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhHZQa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 12:30:26 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:50738 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242049AbhHZQaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 12:30:12 -0400
Received: by mail-io1-f72.google.com with SMTP id b202-20020a6bb2d3000000b005b7fb465c4aso2045755iof.17
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 09:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=zgq0pv0+Yigczdn03yiYXF2cPH8aPynvUP+aMt5Zh0U=;
        b=Ipfk3Z82NIhlKkt7BB+EH+UK+wJuH1IU9Pu6UgeXCVI2Uc+230CqxJQy0MniTtE0qy
         qu3kH4N1GeJk5y1EWqTiwdOsfVIXepmx/9A4zQgbfvmsCKoAv5S2bg1XBKYxKAROmD4X
         snACOIw/KufTfPMONeJP07cT9wouT0KwhGhlsMyhidCAW2zig0fSPoDMfvgZ2NGVyD+9
         HOp5kbto+ux859o4KP1lSptf/9pyH2ZOKGoo8l14J5XzNXLzorez8vEka1CzTOxEJLsp
         yzR1O/FQL4i3m/QMGYdXMVcP8nD2iNFsR5qHE5GlMyhwn/CZH0KLLJSDWmqVe+EoOdCx
         b9PA==
X-Gm-Message-State: AOAM5325ZBGO7z4+IzLoaWZbd8RzUZqAsutYLwybu+opOzall+PrXB4m
        JwhrXQrtEzWwRm6gpyfF2szQ7mkRTO5Y7Zx9egGKWwp2dfQK
X-Google-Smtp-Source: ABdhPJzqKuFT4WKixvqXWZZ0Q3b908WTYvlKCZ5m9V+CePhE/JmJV7h5ehEhAirVcG13fhIOfrdzA4CF5DpFLh0ilnaEE/wM2VXP
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1294:: with SMTP id y20mr3160461ilq.42.1629995364930;
 Thu, 26 Aug 2021 09:29:24 -0700 (PDT)
Date:   Thu, 26 Aug 2021 09:29:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6599705ca78de28@google.com>
Subject: [syzbot] BUG: please report to dccp@vger.kernel.org => prev = NUM,
 last = NUM at net/dccp/ccids/lib/packet_history.c:LINE/tfrc_rx
From:   syzbot <syzbot+d9bd66f8d352f7eb1955@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, davem@davemloft.net, dccp@vger.kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    e3f30ab28ac8 Merge branch 'pktgen-samples-next'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13a18a59300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ef482942966bf763
dashboard link: https://syzkaller.appspot.com/bug?extid=d9bd66f8d352f7eb1955
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bfe5d5300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d9bd66f8d352f7eb1955@syzkaller.appspotmail.com

BUG: please report to dccp@vger.kernel.org => prev = 0, last = 0 at net/dccp/ccids/lib/packet_history.c:414/tfrc_rx_hist_sample_rtt()
CPU: 1 PID: 13730 Comm: syz-executor.2 Not tainted 5.14.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 tfrc_rx_hist_sample_rtt+0x4a5/0x4b0 net/dccp/ccids/lib/packet_history.c:414
 ccid3_hc_rx_packet_recv+0x5b8/0xe90 net/dccp/ccids/ccid3.c:760
 ccid_hc_rx_packet_recv net/dccp/ccid.h:182 [inline]
 dccp_deliver_input_to_ccids+0xd9/0x250 net/dccp/input.c:176
 dccp_rcv_established net/dccp/input.c:374 [inline]
 dccp_rcv_established+0x107/0x160 net/dccp/input.c:364
 dccp_v4_do_rcv+0x130/0x190 net/dccp/ipv4.c:667
 sk_backlog_rcv include/net/sock.h:1024 [inline]
 __release_sock+0x134/0x3b0 net/core/sock.c:2669
 release_sock+0x54/0x1b0 net/core/sock.c:3201
 dccp_sendmsg+0x67a/0xc90 net/dccp/proto.c:796
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
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
RSP: 002b:00007f94cb63e188 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 000000000056c0f0 RCX: 00000000004665e9
RDX: 0000000000000002 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 00000000004bfcc4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c0f0
R13: 00007ffd68749c0f R14: 00007f94cb63e300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
