Return-Path: <netdev+bounces-20-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0B06F4BA7
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:54:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27D51280C6F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15546A926;
	Tue,  2 May 2023 20:54:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A32233C0
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:54:46 +0000 (UTC)
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3853E19A2
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:54:44 -0700 (PDT)
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-33154d104a6so254505ab.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 13:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683060883; x=1685652883;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkYVUFuKh9nwdXQ926QybofeOdFAJ5WNJPZtBiCzT74=;
        b=QdzDxfjANCX+lVPEvaML8bWqk1rcyCwKFIg6blc4KawxGesBAn+8KY1pBGdwLxDl73
         1xiGrVXzXVy5FhRSThlFM3VNY7bOKXCV/rLuBsBKYDGPh/KLfP7yFpS6TI1D6igqaLYM
         2Vi9NVLYXeClIrZAd3PFDV/up0FiENarYDV0bmHCJe4p4VzmO+AI8gp3vVB6ZbOUb83P
         VO22OYTggLWLMiEyjcnMmjb694Lesf7Evt8eXCBkSSF/B391XEabb1TCpTrLskFVMNp+
         vAgdZWrBb8JyB8IzxihkE+NJMKMA97m+QqwGEo75xH+KqGk6kKgHHpCmMkjUepiHkO6O
         5DmQ==
X-Gm-Message-State: AC+VfDybqFNiqScuPc8PwM5D0hgIaRwOAsuej5zcpwN1IbyrkXjPfsa1
	pJFR/gLG5yglj4JBkH8Yb7lU8P69ol6nMm+Q+1PixUY+rDB5
X-Google-Smtp-Source: ACHHUZ7gMKcA/e1mhBJO5h64lGGqWVK5gWi5dkamH+zB3ROaDPhMjAFZGXN9VPQCal4It55twEyYZW0nCWlsBSMQCqKBnbC3hVZv
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d08a:0:b0:329:5faf:cbc0 with SMTP id
 h10-20020a92d08a000000b003295fafcbc0mr10098702ilh.2.1683060883542; Tue, 02
 May 2023 13:54:43 -0700 (PDT)
Date: Tue, 02 May 2023 13:54:43 -0700
In-Reply-To: <00000000000090900c05fa656913@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001958d505fabc269f@google.com>
Subject: Re: [syzbot] [mm?] [udf?] KASAN: null-ptr-deref Read in filemap_fault
From: syzbot <syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, jack@suse.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot has found a reproducer for the following issue on:

HEAD commit:    865fdb08197e Merge tag 'input-for-v6.4-rc0' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=133efa8c280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d1c8518c09009bad
dashboard link: https://syzkaller.appspot.com/bug?extid=48011b86c8ea329af1b9
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=137594c4280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10cfd602280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c667de87f318/disk-865fdb08.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f5d4a94eb2fa/vmlinux-865fdb08.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2b0950e1688b/bzImage-865fdb08.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/21df08f169b8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com

Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb7ca8738 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f56c0f9bd69
RDX: 000000000208e24b RSI: 0000000020000000 RDI: 0000000000000005
RBP: 00007ffdb7ca8740 R08: 0000000000000001 R09: 00007f56c0f50032
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in page_ref_count include/linux/page_ref.h:67 [inline]
BUG: KASAN: null-ptr-deref in put_page_testzero include/linux/mm.h:996 [inline]
BUG: KASAN: null-ptr-deref in folio_put_testzero include/linux/mm.h:1002 [inline]
BUG: KASAN: null-ptr-deref in folio_put include/linux/mm.h:1429 [inline]
BUG: KASAN: null-ptr-deref in filemap_fault+0x121e/0x1810 mm/filemap.c:3382
Read of size 4 at addr 0000000000000028 by task syz-executor223/4990

CPU: 0 PID: 4990 Comm: syz-executor223 Not tainted 6.3.0-syzkaller-12423-g865fdb08197e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1e7/0x2d0 lib/dump_stack.c:106
 print_report+0xe6/0x540 mm/kasan/report.c:465
 kasan_report+0x176/0x1b0 mm/kasan/report.c:572
 kasan_check_range+0x283/0x290 mm/kasan/generic.c:187
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 page_ref_count include/linux/page_ref.h:67 [inline]
 put_page_testzero include/linux/mm.h:996 [inline]
 folio_put_testzero include/linux/mm.h:1002 [inline]
 folio_put include/linux/mm.h:1429 [inline]
 filemap_fault+0x121e/0x1810 mm/filemap.c:3382
 __do_fault+0x136/0x500 mm/memory.c:4176
 do_read_fault mm/memory.c:4530 [inline]
 do_fault mm/memory.c:4659 [inline]
 do_pte_missing mm/memory.c:3647 [inline]
 handle_pte_fault mm/memory.c:4947 [inline]
 __handle_mm_fault mm/memory.c:5089 [inline]
 handle_mm_fault+0x41a8/0x5860 mm/memory.c:5243
 do_user_addr_fault arch/x86/mm/fault.c:1440 [inline]
 handle_page_fault arch/x86/mm/fault.c:1534 [inline]
 exc_page_fault+0x7d2/0x910 arch/x86/mm/fault.c:1590
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:570
RIP: 0010:fault_in_readable+0x1db/0x350 mm/gup.c:1863
Code: bf ff 48 89 d8 4c 8d ab ff 0f 00 00 4d 01 e5 49 81 e5 00 f0 ff ff 49 39 c5 72 70 e8 6f b5 bf ff 4c 39 eb 74 73 4c 89 64 24 10 <44> 8a 23 43 0f b6 04 3e 84 c0 75 18 44 88 64 24 40 48 81 c3 00 10
RSP: 0018:ffffc90003aaf9c0 EFLAGS: 00050287
RAX: ffffffff81cbda01 RBX: 0000000020000000 RCX: ffff888027d3bb80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003aafa78 R08: ffffffff81cbd9a3 R09: ffffffff84310069
R10: 0000000000000002 R11: ffff888027d3bb80 R12: 0000000000001000
R13: 0000000020001000 R14: 1ffff92000755f40 R15: dffffc0000000000
 fault_in_iov_iter_readable+0xdf/0x280 lib/iov_iter.c:362
 generic_perform_write+0x20b/0x5e0 mm/filemap.c:3913
 __generic_file_write_iter+0x17a/0x400 mm/filemap.c:4051
 udf_file_write_iter+0x2fc/0x660 fs/udf/file.c:115
 call_write_iter include/linux/fs.h:1868 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x7ec/0xc10 fs/read_write.c:584
 ksys_write+0x1a0/0x2c0 fs/read_write.c:637
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f56c0f9bd69
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 51 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdb7ca8738 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f56c0f9bd69
RDX: 000000000208e24b RSI: 0000000020000000 RDI: 0000000000000005
RBP: 00007ffdb7ca8740 R08: 0000000000000001 R09: 00007f56c0f50032
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
==================================================================
----------------
Code disassembly (best guess):
   0:	28 00                	sub    %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	75 05                	jne    0xb
   6:	48 83 c4 28          	add    $0x28,%rsp
   a:	c3                   	retq
   b:	e8 51 14 00 00       	callq  0x1461
  10:	90                   	nop
  11:	48 89 f8             	mov    %rdi,%rax
  14:	48 89 f7             	mov    %rsi,%rdi
  17:	48 89 d6             	mov    %rdx,%rsi
  1a:	48 89 ca             	mov    %rcx,%rdx
  1d:	4d 89 c2             	mov    %r8,%r10
  20:	4d 89 c8             	mov    %r9,%r8
  23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
  28:	0f 05                	syscall
* 2a:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax <-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	retq
  33:	48 c7 c1 c0 ff ff ff 	mov    $0xffffffffffffffc0,%rcx
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

