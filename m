Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 880246E1132
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbjDMPdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbjDMPdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:33:43 -0400
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1A0359D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:33:41 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id g1-20020a056602242100b00760ba42ef80so361980iob.16
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:33:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681400020; x=1683992020;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CH/wnFKEHw/ZuUNinYZbwxexwZCPvWpvfmRYHTUngNI=;
        b=O8RPRAqmsn6oEW8Be07Ykm/iAezkBgGrzb4FdugTkPMNXmTzoBoqjkS8aXyd6UYaem
         UkjXQj9lezAOf+3cAQBEpNusy9fhfyzAVxkhzfI0D2TkxgtAUm+lBQxXwMa7XL1xsrsl
         ZDUk4+iZSfUlbOxIdyjWFceDU5uCkgKy3EhwddX/UrT9bPnHbN18s1AfrPeDUWCedIPT
         BIHQGpHxiR2XOBt03TjoaH5uvOFg8GJ/+v3BuR1+jJAMqoQ14/GHmtyadoUznidIcYZ4
         S247pZsAnViJQSzOkUBe4uk36dxchbL3xGnjFnysrdwDM1oLgJsZKUPmUtULg48twrs5
         eiBQ==
X-Gm-Message-State: AAQBX9cYDJraF8KpcxkZ81rAdTvcH6hjtiMAONqwIcXNJXcqjNrkiT1M
        l/eHC10kT5aD8+TVEN8jFWw8lfPEsFpKDjgsKUBMd9jxoo+q
X-Google-Smtp-Source: AKy350a3x3f7fQO9a3dq+ppYo28D+FGUOcXxPn1gj+dUywbekZ0BiR2BfdVO3s1CGK1hpLHwcx9y6soegnGf2R8EFT4KerjA14Lx
MIME-Version: 1.0
X-Received: by 2002:a02:850e:0:b0:40b:d54d:e5d6 with SMTP id
 g14-20020a02850e000000b0040bd54de5d6mr849776jai.5.1681400020453; Thu, 13 Apr
 2023 08:33:40 -0700 (PDT)
Date:   Thu, 13 Apr 2023 08:33:40 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1db9605f939720e@google.com>
Subject: [syzbot] [bpf?] [net?] WARNING in sock_map_del_link
From:   syzbot <syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jakub@cloudflare.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d319f344561d mm: Fix copy_from_user_nofault().
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15930c9dc80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78c9d875f0a80d33
dashboard link: https://syzkaller.appspot.com/bug?extid=49f6cef45247ff249498
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/229f3623b7df/disk-d319f344.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6da0db75c9aa/vmlinux-d319f344.xz
kernel image: https://storage.googleapis.com/syzbot-assets/01f022fb9a13/bzImage-d319f344.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+49f6cef45247ff249498@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 7921 at kernel/softirq.c:376 __local_bh_enable_ip+0xbe/0x130 kernel/softirq.c:376
Modules linked in:
CPU: 1 PID: 7921 Comm: syz-executor.4 Not tainted 6.2.0-syzkaller-13249-gd319f344561d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
RIP: 0010:__local_bh_enable_ip+0xbe/0x130 kernel/softirq.c:376
Code: 45 bf 01 00 00 00 e8 b1 44 0a 00 e8 9c 41 3d 00 fb 65 8b 05 2c 61 b5 7e 85 c0 74 58 5b 5d c3 65 8b 05 12 2f b4 7e 85 c0 75 a2 <0f> 0b eb 9e e8 e9 41 3d 00 eb 9f 48 89 ef e8 ff 30 18 00 eb a8 0f
RSP: 0018:ffffc90007bffbe8 EFLAGS: 00010046
RAX: 0000000000000000 RBX: 0000000000000201 RCX: 1ffffffff1cf0736
RDX: 0000000000000000 RSI: 0000000000000201 RDI: ffffffff882bf40a
RBP: ffffffff882bf40a R08: 0000000000000000 R09: ffff88801cc6327b
R10: ffffed100398c64f R11: 1ffffffff21917f0 R12: ffff88801cc63268
R13: ffff88801cc63268 R14: ffff8880188ef500 R15: 0000000000000000
FS:  00007f378f724700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbbc57831b8 CR3: 00000000210ad000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 spin_unlock_bh include/linux/spinlock.h:395 [inline]
 sock_map_del_link+0x2ea/0x510 net/core/sock_map.c:165
 sock_map_unref+0xb0/0x1d0 net/core/sock_map.c:184
 sock_hash_delete_elem+0x1ec/0x2a0 net/core/sock_map.c:945
 map_delete_elem kernel/bpf/syscall.c:1536 [inline]
 __sys_bpf+0x2edc/0x53e0 kernel/bpf/syscall.c:5053
 __do_sys_bpf kernel/bpf/syscall.c:5166 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5164 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5164
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f378ea8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f378f724168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f378ebabf80 RCX: 00007f378ea8c169
RDX: 0000000000000020 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007f378eae7ca1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe9737aebf R14: 00007f378f724300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
