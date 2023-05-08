Return-Path: <netdev+bounces-832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F22E6FAA08
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 12:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 544041C2095D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 10:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96ACB168D4;
	Mon,  8 May 2023 10:58:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B4D168D2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 10:58:20 +0000 (UTC)
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911BF2B43D
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 03:57:55 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-769036b47a7so293886439f.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 03:57:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683543469; x=1686135469;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z4qQuGB5Gd1At6RmxvPzh/+T+MZCmyfXc4a+BLM5Q9w=;
        b=bnfdmDSrl/f2UGI+e62AMaWmiZMzLpDni+uYyZdfX+4lWqrbdNaMNlJ49YupWbS8TQ
         HXx/HimaSwIKe4wKbORtF/7QOmEKIIT111viLStuMaiwxtWRdzVu/j6k/obdzVfrRoPp
         VkJEvvmEWWPUQFgKAwVA5W64sqCiFCDhzFfxEazNkZvw98in9NztlWe5p7AYSs98i8YK
         i9LgnnJwQncdkSxDo3DQbKYkEOlmIlxbcQHCxY2uPEnQGq6RyYSbzf+1Hg5Yg/nvRT7X
         rqw7ebx2ju8AXzLn0K9FVa+KNmUZV8FMzoDQ7TPPnv+LX/fyhVHoE9HStLUZpEa2H1Ys
         lgQw==
X-Gm-Message-State: AC+VfDzvH3i0EWgHKd97M6JRvQ941cTvWYa4S/NfxW5BJJ8HEKVg2fT8
	2PgyTG8+Ow1L7BGT1oFWpGBt/obvUDUQtfrnc4HBrZZUTKQi
X-Google-Smtp-Source: ACHHUZ7hRUvohGuXcxsd/2ky5NLQqnBo134yJZYBac/reMymj4KJ2Q+G6mM31hEWJ78rrVBaNvo2gykcXUW0yO4C6kwJ93Y7EVvB
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:93c7:0:b0:414:401d:b69a with SMTP id
 z65-20020a0293c7000000b00414401db69amr5076647jah.3.1683543469395; Mon, 08 May
 2023 03:57:49 -0700 (PDT)
Date: Mon, 08 May 2023 03:57:49 -0700
In-Reply-To: <0000000000002e17d105f02be919@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000751a2d05fb2c824a@google.com>
Subject: Re: [syzbot] [ext4?] WARNING in print_tainted
From: syzbot <syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	gregkh@linuxfoundation.org, hawk@kernel.org, john.fastabend@gmail.com, 
	kernel@pengutronix.de, kuba@kernel.org, linux-can@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mkl@pengutronix.de, netdev@vger.kernel.org, 
	pabeni@redhat.com, patches@lists.linux.dev, sashal@kernel.org, 
	socketcan@hartkopp.net, stable-commits@vger.kernel.org, 
	stable@vger.kernel.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot has found a reproducer for the following issue on:

HEAD commit:    457391b03803 Linux 6.3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=118e0b90280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=385e197a58ca4afe
dashboard link: https://syzkaller.appspot.com/bug?extid=5aed6c3aaba661f5b917
compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178650b8280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1646075a280000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/c35b5b2731d2/non_bootable_disk-457391b0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a1bf3bafeb6/vmlinux-457391b0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/21f1e3b4a5a9/zImage-457391b0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bd66e85f728b/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com

EXT4-fs (loop0): 1 truncate cleaned up
EXT4-fs (loop0): mounted filesystem 00000000-0000-0000-0000-000000000000 without journal. Quota mode: writeback.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2947 at mm/slab_common.c:935 free_large_kmalloc+0x94/0xd0 mm/slab_common.c:935
Modules linked in:
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 PID: 2947 Comm: syz-executor216 Not tainted 6.3.0-syzkaller #0
Hardware name: ARM-Versatile Express
Backtrace: 
[<817b2528>] (dump_backtrace) from [<817b261c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:256)
 r7:81d81ac0 r6:82422c04 r5:60000093 r4:81d901cc
[<817b2604>] (show_stack) from [<817cec84>] (__dump_stack lib/dump_stack.c:88 [inline])
[<817b2604>] (show_stack) from [<817cec84>] (dump_stack_lvl+0x48/0x54 lib/dump_stack.c:106)
[<817cec3c>] (dump_stack_lvl) from [<817ceca8>] (dump_stack+0x18/0x1c lib/dump_stack.c:113)
 r5:00000000 r4:8264dd14
[<817cec90>] (dump_stack) from [<817b3110>] (panic+0x11c/0x36c kernel/panic.c:340)
[<817b2ff4>] (panic) from [<802422ec>] (print_tainted+0x0/0xa0 kernel/panic.c:236)
 r3:8240c488 r2:00000001 r1:81d79fcc r0:81d81ac0
 r7:80436a2c
[<80242268>] (check_panic_on_warn) from [<802424e0>] (__warn+0x7c/0x180 kernel/panic.c:673)
[<80242464>] (__warn) from [<802426bc>] (warn_slowpath_fmt+0xd8/0x1d8 kernel/panic.c:697)
 r8:00000009 r7:000003a7 r6:81da3124 r5:8240c954 r4:822ab6bc
[<802425e8>] (warn_slowpath_fmt) from [<80436a2c>] (free_large_kmalloc+0x94/0xd0 mm/slab_common.c:935)
 r10:823e75a4 r9:00000704 r8:8436d7c0 r7:825dfc70 r6:823e75a4 r5:dde49c7c
 r4:dde49c7c
[<80436998>] (free_large_kmalloc) from [<80436bb0>] (kfree+0x148/0x14c mm/slab_common.c:1013)
 r7:8436d880 r6:804292ac r5:dde49c7c r4:823e75a4
[<80436a68>] (kfree) from [<804292ac>] (kvfree+0x2c/0x30 mm/util.c:649)
 r7:8436d880 r6:8436d700 r5:00000400 r4:823e75a4
[<80429280>] (kvfree) from [<80619f90>] (ext4_xattr_move_to_block fs/ext4/xattr.c:2680 [inline])
[<80429280>] (kvfree) from [<80619f90>] (ext4_xattr_make_inode_space fs/ext4/xattr.c:2743 [inline])
[<80429280>] (kvfree) from [<80619f90>] (ext4_expand_extra_isize_ea+0x558/0x808 fs/ext4/xattr.c:2835)
 r5:00000400 r4:823e75a4
[<80619a38>] (ext4_expand_extra_isize_ea) from [<805c514c>] (__ext4_expand_extra_isize+0xdc/0x148 fs/ext4/inode.c:5960)
 r10:8455e368 r9:8455e360 r8:00000001 r7:8455e5e4 r6:823e7500 r5:8455e3e8
 r4:00000040
[<805c5070>] (__ext4_expand_extra_isize) from [<805cc188>] (ext4_try_to_expand_extra_isize fs/ext4/inode.c:6003 [inline])
[<805c5070>] (__ext4_expand_extra_isize) from [<805cc188>] (__ext4_mark_inode_dirty+0x158/0x270 fs/ext4/inode.c:6081)
 r8:00000040 r7:00000cb7 r6:df969df4 r5:00000001 r4:8455e3e8
[<805cc030>] (__ext4_mark_inode_dirty) from [<805ee79c>] (__ext4_unlink+0x2e0/0x370 fs/ext4/namei.c:3255)
 r10:df969e58 r9:82c9ac50 r8:00000000 r7:836ee3c0 r6:00000001 r5:8455e3e8
 r4:8455f0a8
[<805ee4bc>] (__ext4_unlink) from [<805ee980>] (ext4_unlink+0x154/0x1e4 fs/ext4/namei.c:3298)
 r10:82c9ac38 r9:8455f130 r8:df969f3c r7:8455f0a8 r6:82c9ac38 r5:8455e3e8
 r4:00000000
[<805ee82c>] (ext4_unlink) from [<804cc41c>] (vfs_unlink+0x13c/0x2e0 fs/namei.c:4250)
 r7:8455f0a8 r6:8455e3e8 r5:82c9ac38 r4:00000000
[<804cc2e0>] (vfs_unlink) from [<804d0fa8>] (do_unlinkat+0x198/0x2b4 fs/namei.c:4316)
 r9:df969f38 r8:00000003 r7:8290b000 r6:00000000 r5:8455f0a8 r4:00000000
[<804d0e10>] (do_unlinkat) from [<804d10fc>] (__do_sys_unlinkat fs/namei.c:4359 [inline])
[<804d0e10>] (do_unlinkat) from [<804d10fc>] (sys_unlinkat+0x38/0x5c fs/namei.c:4352)
 r10:00000148 r9:831bae00 r8:80200288 r7:00000148 r6:00000000 r5:00000000
 r4:00000003
[<804d10c4>] (sys_unlinkat) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:66)
Exception stack(0xdf969fa8 to 0xdf969ff0)
9fa0:                   00000000 00000000 00000003 20000000 00000000 00001015
9fc0: 00000000 00000000 00000000 00000148 00000000 200002a2 20000276 00000000
9fe0: 7ecdec50 7ecdec40 0001085c 0002bb80
 r5:00000000 r4:00000000
Rebooting in 86400 seconds..


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

