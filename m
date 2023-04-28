Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C4C6F195D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 15:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346219AbjD1NZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 09:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjD1NZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 09:25:55 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD3C173E
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 06:25:53 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-760ed929d24so1374429039f.2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 06:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682688353; x=1685280353;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3yq9rEjt6j/Grlqag7wuS/2mUAkFSJI6s+U6/7TuIJI=;
        b=GoYiu7CBlZr5ELT/+UNIQG28/LRbUidNR9UEm5IyCzfiB6/xR/VSrP4rkpSZc1jnJ3
         4ct49tNtR0sdHcWuvoLfZ1NekKw+iQK645ZBU1IQ3BVhrVGLr2FdBfMCju85h4XOxz2r
         jLz+9s9+ywDMdw/yOrKEjFAHwYm9dfbyL1Pv1rMNJxUJDGiqJjdQUrH88mhKD6KsbXub
         jKIGtuJ3pdf2B+nj16QOCPMRRPOgxcKDM/0I3ncr6gzFeUD2oJrpZfnkkXaYMYEIJzev
         LRgjXdkDgmYhdDfIBPdLy0UezTLRDlbg4FMbKKCyWHVWw5xogXBhFpEZ+X53LFbyJUy3
         iRNQ==
X-Gm-Message-State: AC+VfDymO8Q25WN1ZbUMyD0KUXRFm8cmXzoiFgGK1++zCAaNXAeCGFdJ
        q9qVbhwgq32OOH9Vloci2l6Hbdv/k/48TiEuxTvMh5W7dev4
X-Google-Smtp-Source: ACHHUZ6MnE/JgqBmivx4QQnhYuUax80Nj5PF5TRhT6lU1SjA8npOjQKyM/bfSmyJBgYPRrP9m88zwPvomu5ONPVhcDvzOaf/IXuH
MIME-Version: 1.0
X-Received: by 2002:a02:b1d2:0:b0:40f:a8e9:96ab with SMTP id
 u18-20020a02b1d2000000b0040fa8e996abmr2540325jah.5.1682688353273; Fri, 28 Apr
 2023 06:25:53 -0700 (PDT)
Date:   Fri, 28 Apr 2023 06:25:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090900c05fa656913@google.com>
Subject: [syzbot] [mm?] [net?] KASAN: null-ptr-deref Read in filemap_fault
From:   syzbot <syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    33afd4b76393 Merge tag 'mm-nonmm-stable-2023-04-27-16-01' ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bc1008280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=70288413d8a92398
dashboard link: https://syzkaller.appspot.com/bug?extid=48011b86c8ea329af1b9
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: null-ptr-deref in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
BUG: KASAN: null-ptr-deref in page_ref_count include/linux/page_ref.h:67 [inline]
BUG: KASAN: null-ptr-deref in put_page_testzero include/linux/mm.h:1007 [inline]
BUG: KASAN: null-ptr-deref in folio_put_testzero include/linux/mm.h:1013 [inline]
BUG: KASAN: null-ptr-deref in folio_put include/linux/mm.h:1440 [inline]
BUG: KASAN: null-ptr-deref in filemap_fault+0x544/0x24a0 mm/filemap.c:3382
Read of size 4 at addr 0000000000000028 by task syz-executor.2/19418

CPU: 1 PID: 19418 Comm: syz-executor.2 Not tainted 6.3.0-syzkaller-10620-g33afd4b76393 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
 print_report mm/kasan/report.c:465 [inline]
 kasan_report+0xec/0x130 mm/kasan/report.c:572
 check_region_inline mm/kasan/generic.c:181 [inline]
 kasan_check_range+0x141/0x190 mm/kasan/generic.c:187
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
 page_ref_count include/linux/page_ref.h:67 [inline]
 put_page_testzero include/linux/mm.h:1007 [inline]
 folio_put_testzero include/linux/mm.h:1013 [inline]
 folio_put include/linux/mm.h:1440 [inline]
 filemap_fault+0x544/0x24a0 mm/filemap.c:3382
 __do_fault+0x107/0x600 mm/memory.c:4176
 do_read_fault mm/memory.c:4530 [inline]
 do_fault mm/memory.c:4659 [inline]
 do_pte_missing mm/memory.c:3647 [inline]
 handle_pte_fault mm/memory.c:4947 [inline]
 __handle_mm_fault+0x27f6/0x4170 mm/memory.c:5089
 handle_mm_fault+0x2af/0x9f0 mm/memory.c:5243
 do_user_addr_fault+0x51a/0x1210 arch/x86/mm/fault.c:1440
 handle_page_fault arch/x86/mm/fault.c:1534 [inline]
 exc_page_fault+0x98/0x170 arch/x86/mm/fault.c:1590
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:570
RIP: 0023:0xf72255d0
Code: Unable to access opcode bytes at 0xf72255a6.
RSP: 002b:00000000ffb4674c EFLAGS: 00010202
RAX: 00000000f734e000 RBX: 00000000f734e000 RCX: 00000000f737c038
RDX: 000000002e220000 RSI: 0000000000000004 RDI: 00000000000e257f
RBP: 00000000f737c0c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
