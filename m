Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8591F3C8443
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbhGNMKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 08:10:11 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38819 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbhGNMKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 08:10:11 -0400
Received: by mail-io1-f71.google.com with SMTP id y8-20020a5e87080000b029050cfd126a26so1084101ioj.5
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 05:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=PcjvOVN6qCyIv1/fl9MgyXde4qoSrkYo4xHcDWPqJyE=;
        b=lzKPdCAhzGWZ7gcFeMqQQXBmaFJqtrKh4qJjg+I0ylyRYQ6+iWODj4SPYCnso/MkpN
         2KXipNwjZHZIs2TKzOTPIsaX7Cl3i1aI0RQC81G/m06UnCmdtDKl7RVJy8Mp5xV4hIor
         cssmpdRLdcRfUsmV6ALcxFox6vToqRZsPB4mgeNRFXkAUYqHbxFEMlsCFPZNHAl457bN
         NsQFGssZ7doyqRGB31TpFoJQjYF8qu7QMIdCZcDotwdzNwiBky+nO4KFTXSNKEw6cQ/O
         Ipf8Auunni0LkDjftLOyYBaxvTNc+92E1RCt7wFca4Ud4vkScW2tuf+TH7SS5NrtajqA
         x9ig==
X-Gm-Message-State: AOAM53107MmHSaJD08ZbCO+Alh9Xu3np0OgtCdvP26T1mvUW9i6+POXF
        fCjItCcp9baVBoRkz9BMsEJ0SYqoJVvy33kqXum5/3HMb7FL
X-Google-Smtp-Source: ABdhPJz57yC1sHnIwLiEslTVL3igJLY28gGHjev9aTUb9D8ixma2il2Ss92QcCo6YP5rfZ1y0dfYGQLFAbtKdjPfTY1FQFu5gVw9
MIME-Version: 1.0
X-Received: by 2002:a05:6638:25c7:: with SMTP id u7mr4155293jat.26.1626264439681;
 Wed, 14 Jul 2021 05:07:19 -0700 (PDT)
Date:   Wed, 14 Jul 2021 05:07:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cf65205c71432d0@google.com>
Subject: [syzbot] WARNING in vmap_pages_range_noflush
From:   syzbot <syzbot+4f4d23fa0b2b2bb23e38@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3dbdb38e Merge branch 'for-5.14' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1528f19c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=90b227e3653ac0d7
dashboard link: https://syzkaller.appspot.com/bug?extid=4f4d23fa0b2b2bb23e38

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f4d23fa0b2b2bb23e38@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 21050 at mm/vmalloc.c:448 vmap_pages_pte_range mm/vmalloc.c:448 [inline]
WARNING: CPU: 0 PID: 21050 at mm/vmalloc.c:448 vmap_pages_pmd_range mm/vmalloc.c:471 [inline]
WARNING: CPU: 0 PID: 21050 at mm/vmalloc.c:448 vmap_pages_pud_range mm/vmalloc.c:489 [inline]
WARNING: CPU: 0 PID: 21050 at mm/vmalloc.c:448 vmap_pages_p4d_range mm/vmalloc.c:507 [inline]
WARNING: CPU: 0 PID: 21050 at mm/vmalloc.c:448 vmap_small_pages_range_noflush mm/vmalloc.c:529 [inline]
WARNING: CPU: 0 PID: 21050 at mm/vmalloc.c:448 vmap_pages_range_noflush+0x653/0x8c0 mm/vmalloc.c:558
Modules linked in:
CPU: 0 PID: 21050 Comm: syz-executor.3 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:vmap_pages_pte_range mm/vmalloc.c:448 [inline]
RIP: 0010:vmap_pages_pmd_range mm/vmalloc.c:471 [inline]
RIP: 0010:vmap_pages_pud_range mm/vmalloc.c:489 [inline]
RIP: 0010:vmap_pages_p4d_range mm/vmalloc.c:507 [inline]
RIP: 0010:vmap_small_pages_range_noflush mm/vmalloc.c:529 [inline]
RIP: 0010:vmap_pages_range_noflush+0x653/0x8c0 mm/vmalloc.c:558
Code: c5 ff 4c 89 f8 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 62 02 00 00 49 8b 1f e9 6d fd ff ff e8 4d 37 c5 ff <0f> 0b 41 bc f4 ff ff ff e9 62 ff ff ff e8 3b 37 c5 ff 31 ff 48 89
RSP: 0018:ffffc900025979b8 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff888000100220 RCX: ffffc9000f762000
RDX: 0000000000040000 RSI: ffffffff81af8783 RDI: 0000000000000003
RBP: ffffea0002472c00 R08: 0000000000000000 R09: ffffffff90a01847
R10: ffffffff81af85bf R11: 0000000000000001 R12: ffffc9002ac00000
R13: 0000070700000000 R14: ffffc9002aa44000 R15: 8000000000000163
FS:  00007f4f610c4700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000544038 CR3: 000000001eaa7000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vmap_pages_range mm/vmalloc.c:592 [inline]
 __vmalloc_area_node mm/vmalloc.c:2861 [inline]
 __vmalloc_node_range+0x659/0x960 mm/vmalloc.c:2947
 __bpf_map_area_alloc+0xd5/0x150 kernel/bpf/syscall.c:311
 queue_stack_map_alloc+0xf0/0x1d0 kernel/bpf/queue_stack_maps.c:76
 find_and_alloc_map kernel/bpf/syscall.c:127 [inline]
 map_create+0x4a0/0x14c0 kernel/bpf/syscall.c:833
 __sys_bpf+0x8bc/0x4750 kernel/bpf/syscall.c:4451
 __do_sys_bpf kernel/bpf/syscall.c:4573 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4571 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4571
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4f610c4188 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000040 RSI: 00000000200001c0 RDI: 0000000000000000
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffff9d98a9f R14: 00007f4f610c4300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
