Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4B95E7F40
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiIWQFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiIWQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:05:43 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FDFAE87B
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:05:41 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id a8-20020a92c548000000b002f6440ff96bso494324ilj.22
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:05:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=TNsKpikZ1ZBjh21h5HyuhGoaC1RZtRCLwpayxbe9ub8=;
        b=KFACiQUP/1oHltRvHJZudYmSutMP7c9Hflpwh7fOsT1+CEy1hMhlMX4vxFjREEstsN
         EenIqFWri9ibb3OtnpOLs+nSvKvcu05rHtYYHEaV5dHriBkI1cV51Q1ZI0xHDgz1sryR
         aXgmj8JDcu55cJmERCcj8rwpjPh9qF1E7n65KGHPHmoE1MRM/+gwHPtvm/ewRC/1zTLM
         9LWziPn0O6eBo3fK/7Gh2Yh2+3lh4l88+28UE//qQPmij/w9g7BW6SNo895gIs8MqZzu
         D2ILnsKNrF9/n0AlZo1C+BQuXzHImxFXGeWKcssdUVodEJJC80sEtokTYqcnLj49k24o
         8Fgw==
X-Gm-Message-State: ACrzQf0ne8CWGA7iSW5wAZJUuNqusRebymbnJxggzwW3Hh02RwFt5Kbw
        omMYN8KdvuXPhdgXj4ZDK2ZUJ3iwbIFko+Wq1Q1B+UuQJn2j
X-Google-Smtp-Source: AMsMyM5C06VlRfRAIQIzUtiJevoUyui+Rnb+0VRKkrQ6jUfUuOn1evUbPQY6qFZvNdYweJ3XVYoj7ifHxCX/u+zywIjKaayteZGB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa3:b0:2f1:d2a4:c7c3 with SMTP id
 l3-20020a056e021aa300b002f1d2a4c7c3mr4416624ilv.292.1663949140447; Fri, 23
 Sep 2022 09:05:40 -0700 (PDT)
Date:   Fri, 23 Sep 2022 09:05:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070db2005e95a5984@google.com>
Subject: [syzbot] WARNING in wireless_send_event
From:   syzbot <syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
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

HEAD commit:    483fed3b5dc8 Add linux-next specific files for 20220921
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1154ddd5080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=849cb9f70f15b1ba
dashboard link: https://syzkaller.appspot.com/bug?extid=473754e5af963cf014cf
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=157c196f080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11f12618880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1cb3f4618323/disk-483fed3b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cc02cb30b495/vmlinux-483fed3b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com

------------[ cut here ]------------
memcpy: detected field-spanning write (size 8) of single field "&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623 wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
Modules linked in:
CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted 6.0.0-rc6-next-20220921-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2022
RIP: 0010:wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
Code: fa ff ff e8 cd b9 db f8 b9 04 00 00 00 4c 89 e6 48 c7 c2 e0 56 11 8b 48 c7 c7 20 56 11 8b c6 05 94 8e 2a 05 01 e8 b8 b0 a6 00 <0f> 0b e9 9b fa ff ff e8 6f ef 27 f9 e9 a6 fd ff ff e8 c5 ef 27 f9
RSP: 0018:ffffc90003b2fbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888021d157c0 RSI: ffffffff81620348 RDI: fffff52000765f6a
RBP: ffff88801e15c780 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 20676e696e6e6170 R12: 0000000000000008
R13: ffff888025a72640 R14: ffff8880225d402c R15: ffff8880225d4034
FS:  0000555556bd9300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbda677dfb8 CR3: 000000007b976000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
 wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
 sock_ioctl+0x285/0x640 net/socket.c:1220
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fbda6736af9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd45e80138 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbda6736af9
RDX: 0000000020000000 RSI: 0000000000008b04 RDI: 0000000000000003
RBP: 00007fbda66faca0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbda66fad30
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
