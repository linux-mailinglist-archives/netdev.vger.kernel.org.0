Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8535FCA9B
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 20:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiJLS0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 14:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJLS0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 14:26:42 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9076C967
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 11:26:41 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id 75-20020a6b144e000000b006bbed69b669so7444036iou.21
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 11:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w9E4FGrgNA2t7iVK5WJAXLQ73iKqHUC0p6WTicNH5HI=;
        b=VYOQIuYKAghZHwtDjKARPx7nL1HWFFFcpXoTVP+icJsRQ+3n1kez9ig4i+TZSAnHgy
         4onY8AUPAWL9JJO4VsfCmn2arkT7gnXfRef9LUy9u5P0867XWinA2XT2e1W7QnA2UurC
         MzAnhZ3kRROkbQAyUi93drSmNcCxO/t6sI3u4QqTUWgyK7Of+31LBvQortKTbZf5h8fy
         Bk5npbOhs8zyab5KlT35LSkdP1YSYyccGQUl8E+cNo6NflutrUm+NN+kW3dnXfhUqzcF
         3MpXzweBoqn/LLc84JtgtWLt4AdezWvKDqq1XJvC+EzGWuft30IwzG7nD1k4wTU5RG4x
         fCMQ==
X-Gm-Message-State: ACrzQf2bzYI7BXswXq5X3nrfn+87+QXeG0XDkEZ6ivvcw1+yQbYA1uF2
        HvNpF258B9NhXMTJm6myc995XhbQ147yx0ioBL8pAXy/WCS0
X-Google-Smtp-Source: AMsMyM6JLuT2RuIdhxwPKrhuwo+D+YFm7PP82rP0WGBtsSpEWXCji7rBUrIPlPcKpyRlWQfDPBv1NJAxIcs1TPQg1TaczmiEcAxX
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d94:b0:35a:6828:6804 with SMTP id
 l20-20020a0566380d9400b0035a68286804mr16609925jaj.149.1665599200624; Wed, 12
 Oct 2022 11:26:40 -0700 (PDT)
Date:   Wed, 12 Oct 2022 11:26:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b1060905eada8881@google.com>
Subject: [syzbot] WARNING in ip_rt_bug (2)
From:   syzbot <syzbot+e738404dcd14b620923c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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

HEAD commit:    a0ba26f37ea0 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1594a825e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27392dd2975fd692
dashboard link: https://syzkaller.appspot.com/bug?extid=e738404dcd14b620923c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16851c6de00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f5d605e00000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1422a825e00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1622a825e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=1222a825e00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e738404dcd14b620923c@syzkaller.appspotmail.com

syz-executor857 uses obsolete (PF_INET,SOCK_PACKET)
------------[ cut here ]------------
WARNING: CPU: 1 PID: 7033 at net/ipv4/route.c:1243 ip_rt_bug+0x11/0x20 net/ipv4/route.c:1242
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7033 Comm: syz-executor857 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:ip_rt_bug+0x11/0x20 net/ipv4/route.c:1243
Code: ff ff e8 c2 d7 33 fb e9 eb fe ff ff e8 b8 d7 33 fb e9 59 ff ff ff 0f 1f 00 55 48 89 d5 e8 17 0e f7 fa 48 89 ef e8 6f 0c 8f ff <0f> 0b 31 c0 5d c3 66 0f 1f 84 00 00 00 00 00 41 54 49 89 fc e8 f6
RSP: 0018:ffffc90001937300 EFLAGS: 00010293
RAX: ffff8880a2bc2540 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff867b1711 RDI: 0000000000000286
RBP: ffff8880a31fb940 R08: 0000000000000000 R09: ffffed1015ce7074
R10: ffffed1015ce7073 R11: ffff8880ae73839b R12: ffff8880970b0e00
R13: ffff8880a31fb940 R14: ffff8880a4a71240 R15: ffff8880a31fb998
 dst_output include/net/dst.h:436 [inline]
 ip_local_out+0xaf/0x1a0 net/ipv4/ip_output.c:125
 ip_send_skb+0x3e/0xe0 net/ipv4/ip_output.c:1560
 ip_push_pending_frames+0x5f/0x80 net/ipv4/ip_output.c:1580
 icmp_push_reply+0x33f/0x490 net/ipv4/icmp.c:390
 __icmp_send+0xc44/0x14a0 net/ipv4/icmp.c:740
 icmp_send include/net/icmp.h:43 [inline]
 ip_options_compile+0xad/0xf0 net/ipv4/ip_options.c:486
 ip_rcv_options net/ipv4/ip_input.c:278 [inline]
 ip_rcv_finish_core.isra.0+0x4aa/0x1ec0 net/ipv4/ip_input.c:370
 ip_rcv_finish+0x144/0x2f0 net/ipv4/ip_input.c:426
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0xd0/0x3c0 net/ipv4/ip_input.c:538
 __netif_receive_skb_one_core+0xf5/0x160 net/core/dev.c:5187
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5301
 netif_receive_skb_internal net/core/dev.c:5391 [inline]
 netif_receive_skb+0x16e/0x960 net/core/dev.c:5450
 tun_rx_batched.isra.0+0x47b/0x7d0 drivers/net/tun.c:1553
 tun_get_user+0x134a/0x3be0 drivers/net/tun.c:1997
 tun_chr_write_iter+0xb0/0x147 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1902 [inline]
 new_sync_write+0x49c/0x700 fs/read_write.c:483
 __vfs_write+0xc9/0x100 fs/read_write.c:496
 vfs_write+0x262/0x5c0 fs/read_write.c:558
 ksys_write+0x127/0x250 fs/read_write.c:611
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440699
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fffce0515b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 0000000000440699
RDX: 000000000000100c RSI: 0000000020000240 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000002c00 R09: 00007fff0000000d
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401f20
R13: 0000000000401fb0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
