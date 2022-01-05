Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BDB485710
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbiAERHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:07:20 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:51040 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242145AbiAERHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 12:07:20 -0500
Received: by mail-il1-f198.google.com with SMTP id w1-20020a056e021c8100b002b545cce322so794ill.17
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 09:07:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=LT9mjlWKUcOxEoDHLR8Lx02AdDDKYTNX5FyA18BMsYg=;
        b=Y9Bfzejiok4NnNWRHAJGT8+Y95pHd5ZryZYej0DUX/9dk+VscnFCxIT5JJf91SOPhU
         9llPSLjiR+X96G5/bhdrY2Is6rO2/PqsfH1TlUhofn6QqfwiaTdgNTc++Kz0SDX9rR6E
         RRYan4pWwM/Xx71AqI962Vln96WOGTphosuSyQg6Wb+ej7blgJ2lWPH/P12+4GAqRgKW
         xbk4K2n46o+wsZS7C+H/zXhQ2+Y197Zpc/35P7gLmEpC74DS4Fc4WufPTmllvPVmfDa6
         BWVIfRIX7GCVUmGXp+qFvvWw2/0zYexJjtSmPMR7YSjyjLKDI++6brgrQvOb343bgbMY
         33Kw==
X-Gm-Message-State: AOAM533u0jlhwih+L7oiQciK8325xUfJNwOfCm7LTNTBkmAQ4JpPIy3o
        NSnlG85qzX4MZqy6S7HoqBZbO5KkrDJ7AL0sqPfVKZgrIu7w
X-Google-Smtp-Source: ABdhPJzez4IwyI7mFVbzEive5MPPzk2HT3jOx5a5V3+bmuQLKp9Nw7HZlaQIOtkhZ2P1MUB+iA8r5DQv1ygxJcoyOSUSKz4jMA0h
MIME-Version: 1.0
X-Received: by 2002:a5d:9d92:: with SMTP id ay18mr26063533iob.130.1641402439542;
 Wed, 05 Jan 2022 09:07:19 -0800 (PST)
Date:   Wed, 05 Jan 2022 09:07:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057aae805d4d8c9c7@google.com>
Subject: [syzbot] WARNING in fixup_exception
From:   syzbot <syzbot+d9a0f6db5058ce56e260@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bp@alien8.de,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, peterz@infradead.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, x86@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    800829388818 mm: vmscan: reduce throttling due to a failur..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100bafc3b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1a86c22260afac2f
dashboard link: https://syzkaller.appspot.com/bug?extid=d9a0f6db5058ce56e260
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154be92bb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112fd30bb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d9a0f6db5058ce56e260@syzkaller.appspotmail.com

------------[ cut here ]------------
General protection fault in user access. Non-canonical address?
WARNING: CPU: 0 PID: 2529 at arch/x86/mm/extable.c:57 ex_handler_uaccess arch/x86/mm/extable.c:57 [inline]
WARNING: CPU: 0 PID: 2529 at arch/x86/mm/extable.c:57 fixup_exception+0x5da/0x690 arch/x86/mm/extable.c:140
Modules linked in:
CPU: 0 PID: 2529 Comm: syz-executor223 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ex_handler_uaccess arch/x86/mm/extable.c:57 [inline]
RIP: 0010:fixup_exception+0x5da/0x690 arch/x86/mm/extable.c:140
Code: 0c 31 ff 89 de e8 06 f5 42 00 84 db 0f 85 9b fc ff ff e8 19 f1 42 00 48 c7 c7 20 59 a9 89 c6 05 49 33 48 0c 01 e8 52 cf cb 07 <0f> 0b e9 7c fc ff ff e8 fa f0 42 00 48 89 de 48 c7 c7 c0 59 a9 89
RSP: 0018:ffffc90003bf7bf0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801dbd0000 RSI: ffffffff815f0948 RDI: fffff5200077ef70
RBP: ffffffff8b6d0044 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815ea6ee R11: 0000000000000000 R12: ffffc90003bf7cc8
R13: 000000000000000d R14: ffffc90003bf7d48 R15: 0000000000000000
FS:  00007f46f7487700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f46f7d44190 CR3: 0000000022544000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __exc_general_protection arch/x86/kernel/traps.c:601 [inline]
 exc_general_protection+0xed/0x300 arch/x86/kernel/traps.c:562
 asm_exc_general_protection+0x1e/0x30 arch/x86/include/asm/idtentry.h:562
RIP: 0010:__put_user_nocheck_2+0x3/0x11
Code: 00 00 48 39 d9 73 74 0f 01 cb 88 01 31 c9 0f 01 ca c3 66 0f 1f 44 00 00 48 bb ff ef ff ff ff 7f 00 00 48 39 d9 73 54 0f 01 cb <66> 89 01 31 c9 0f 01 ca c3 0f 1f 44 00 00 48 bb fd ef ff ff ff 7f
RSP: 0018:ffffc90003bf7d78 EFLAGS: 00050293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0006020200000004
RDX: ffff88801dbd0000 RSI: ffffffff86d1fba8 RDI: 0000000000000003
RBP: ffff888077ff01a8 R08: 0000000000000002 R09: 0000000000000001
R10: ffffffff86d1fb95 R11: 0000000000000000 R12: 0006020200000004
R13: ffff888077ff0258 R14: 0000000000000000 R15: 0000000000000000
 vhost_put_used_flags drivers/vhost/vhost.c:969 [inline]
 vhost_update_used_flags+0x1a3/0x3d0 drivers/vhost/vhost.c:1969
 vhost_vq_init_access+0x114/0x5c0 drivers/vhost/vhost.c:2013
 vhost_net_set_backend drivers/vhost/net.c:1548 [inline]
 vhost_net_ioctl+0xbad/0x1740 drivers/vhost/net.c:1705
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f46f7d02839
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 31 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f46f7487208 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f46f7d8a278 RCX: 00007f46f7d02839
RDX: 0000000020000000 RSI: 000000004008af30 RDI: 0000000000000003
RBP: 00007f46f7d8a270 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f46f7d8a27c
R13: 00007ffc8471e10f R14: 00007f46f7487300 R15: 0000000000022000
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	48 39 d9             	cmp    %rbx,%rcx
   5:	73 74                	jae    0x7b
   7:	0f 01 cb             	stac
   a:	88 01                	mov    %al,(%rcx)
   c:	31 c9                	xor    %ecx,%ecx
   e:	0f 01 ca             	clac
  11:	c3                   	retq
  12:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  18:	48 bb ff ef ff ff ff 	movabs $0x7fffffffefff,%rbx
  1f:	7f 00 00
  22:	48 39 d9             	cmp    %rbx,%rcx
  25:	73 54                	jae    0x7b
  27:	0f 01 cb             	stac
* 2a:	66 89 01             	mov    %ax,(%rcx) <-- trapping instruction
  2d:	31 c9                	xor    %ecx,%ecx
  2f:	0f 01 ca             	clac
  32:	c3                   	retq
  33:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  38:	48                   	rex.W
  39:	bb fd ef ff ff       	mov    $0xffffeffd,%ebx
  3e:	ff                   	(bad)
  3f:	7f                   	.byte 0x7f


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
