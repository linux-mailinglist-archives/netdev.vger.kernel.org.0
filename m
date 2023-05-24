Return-Path: <netdev+bounces-5166-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40FD870FEA9
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E619128139A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A6B21085;
	Wed, 24 May 2023 19:44:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2915060862
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 19:44:23 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B3D139
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:44:20 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-76c5c78bc24so214526039f.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684957460; x=1687549460;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GXM0OJBa2Xe7YCAQJqSdK/TYdEJX3LTPFYVv2SjRziU=;
        b=eHb0uxbwoV4QJSrQgAniJqQhN/VxQkXkctKLTdwCEDnjQ+u1N8GpuCdPgZamnxhf2F
         ovQcIqinUWXy8P5t1Jtgd2GqaLNNi6aQnQq3nLbANsuBDVZLaUHIDM4XhpstJ0CCLhf1
         OCiaRh0AQ7NN4iCkoAJ6hWNBziQza6Rx+q1seGvD1chT9BR+SX7Mj1gsYU2pr2bp9NSu
         e/WJXG0AO7CFOIB8k5PO8+qG4PuYMnY6yCuI3VahLXb5NlOZD7jUGcDwUWZPYy3pOeDu
         dx0pr61Ie3Ife/k5ISDb8cjP7aAlZ6LvjOwT2tYeUhuGpei4g4ciVx/2aLnlxPOCatt6
         m7nQ==
X-Gm-Message-State: AC+VfDxkIF4GBOYqdwBrxrzDUcrmxrX0PCO1SZ9PHJbhfuIHhtSYrMbK
	k/udRmMYZkyyCFuddS3j8nrQiMkqnoFqRJtDIphNFSvF/hLp
X-Google-Smtp-Source: ACHHUZ5AaKXnI1J1H+PH8SthQs4AC6Rc+pFC3KEwRguEG7pGu6xa0diRM/rUzLHYh0RRXdQtOAuql2wUl2OfGeX36t/Idoyzq9Ny
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:9625:0:b0:416:5075:372f with SMTP id
 c34-20020a029625000000b004165075372fmr9389784jai.3.1684957460223; Wed, 24 May
 2023 12:44:20 -0700 (PDT)
Date: Wed, 24 May 2023 12:44:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e0df8d05fc75ba86@google.com>
Subject: [syzbot] [bpf?] WARNING in btf_type_id_size (2)
From: syzbot <syzbot+958967f249155967d42a@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com, hawk@kernel.org, 
	john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com, 
	netdev@vger.kernel.org, sdf@google.com, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    0613d8ca9ab3 bpf: Fix mask generation for 32-bit narrow lo..
git tree:       bpf
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12d7f219280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bc832f563d8bf38
dashboard link: https://syzkaller.appspot.com/bug?extid=958967f249155967d42a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162a2555280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129ce341280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d08fd262c806/disk-0613d8ca.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/43cddf0d3788/vmlinux-0613d8ca.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e2583f3d15eb/bzImage-0613d8ca.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+958967f249155967d42a@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5005 at kernel/bpf/btf.c:1988 btf_type_id_size+0x2d9/0x9d0 kernel/bpf/btf.c:1988
Modules linked in:
CPU: 0 PID: 5005 Comm: syz-executor387 Not tainted 6.4.0-rc1-syzkaller-00096-g0613d8ca9ab3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
RIP: 0010:btf_type_id_size+0x2d9/0x9d0 kernel/bpf/btf.c:1988
Code: ef e8 6b 58 e2 ff 41 83 ff 0b 77 28 f6 44 24 10 18 75 3f e8 f9 5b e2 ff 44 89 fe bf 0e 00 00 00 e8 0c 58 e2 ff e8 e7 5b e2 ff <0f> 0b 45 31 f6 e9 98 02 00 00 41 83 ff 12 74 18 e8 d2 5b e2 ff 44
RSP: 0018:ffffc90003a9fb68 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801f7ebb80 RSI: ffffffff81a1e8f9 RDI: 0000000000000005
RBP: ffff888020813400 R08: 0000000000000005 R09: 000000000000000e
R10: 0000000000000011 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000011 R14: ffff88802101f418 R15: 0000000000000011
FS:  00005555567b2300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000001a4b398 CR3: 000000002c9c3000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 map_check_btf kernel/bpf/syscall.c:1024 [inline]
 map_create+0x1157/0x1860 kernel/bpf/syscall.c:1198
 __sys_bpf+0x127f/0x5420 kernel/bpf/syscall.c:5040
 __do_sys_bpf kernel/bpf/syscall.c:5162 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5160 [inline]
 __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5160
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f379d511d09
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffea061b348 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f379d511d09
RDX: 0000000000000048 RSI: 0000000020000180 RDI: 0000000000000000
RBP: 00007f379d4d5eb0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f379d4d5f40
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

