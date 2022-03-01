Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363924C8EA2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 16:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiCAPLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 10:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235577AbiCAPLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 10:11:03 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05383A66DB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 07:10:20 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id f9-20020a5ec709000000b00640c72b204eso10858207iop.22
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 07:10:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=syaIJdoX76LA+/8N3q09XHODOEJFhsoROjEaL6EZp2A=;
        b=M0KtQN2DWukRh6x48mywUNDYggRk9TEb83Zb9wUJtI+aBiexQu9JCp1nwWzcJq3JnU
         ibfwgm4F9ecQZzCHto/q0yA0Mhn1MRaorELw5osYK4DNvBX1SBkWFMzEnKUZ4rcJ9Aua
         4FGKOL/bwvDR6zI24Qwih04pEM2nlzZAM+V+Y0uf/jXu6WwcuN7ExtWLjKylDm156fJK
         bPLflUKUztStRp6CKZsVqL9n+ca5n2mfdPGz8P8NM6X1sYpPTiM2wuGYw1D4K1kZGYZY
         mCaC37DJoPCE9MWxlWILkc74Our+p1WQLOXj5gxDHRFrPxF5fN2RkX3xuk0keVbANLYz
         0rGA==
X-Gm-Message-State: AOAM53246QVhPLeOYQtNWpl3NfI4wXpTpyTVtvtMliQa6kf0ZeaZENSx
        e1w6b70BJyxEujFHyf8X37oiscXKEvTrNGvbeRATj6Zkh9a1
X-Google-Smtp-Source: ABdhPJx6Xjot1fvFWyBNe4hna03lIWR1Nxyj+cwfLDc95sLgQCFOJ5lQzq7hnu54Yg+0aJ27x8VbF2ZUixOMakjVE8Ofi9DtIta+
MIME-Version: 1.0
X-Received: by 2002:a92:ca47:0:b0:2c2:ab28:1163 with SMTP id
 q7-20020a92ca47000000b002c2ab281163mr19617213ilo.260.1646147419347; Tue, 01
 Mar 2022 07:10:19 -0800 (PST)
Date:   Tue, 01 Mar 2022 07:10:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002da23a05d9299019@google.com>
Subject: [syzbot] WARNING in submit_bio_noacct
From:   syzbot <syzbot+7fdd158f9797accbebfc@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    196d330d7fb1 Add linux-next specific files for 20220222
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14ac04a2700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45b71d0aea81d553
dashboard link: https://syzkaller.appspot.com/bug?extid=7fdd158f9797accbebfc
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7fdd158f9797accbebfc@syzkaller.appspotmail.com

Trying to write to read-only block-device sda1 (partno 1)
WARNING: CPU: 0 PID: 4281 at block/blk-core.c:581 bio_check_ro block/blk-core.c:581 [inline]
WARNING: CPU: 0 PID: 4281 at block/blk-core.c:581 submit_bio_noacct+0x16f3/0x1be0 block/blk-core.c:810
Modules linked in:
CPU: 0 PID: 4281 Comm: syz-executor.3 Not tainted 5.17.0-rc5-next-20220222-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bio_check_ro block/blk-core.c:581 [inline]
RIP: 0010:submit_bio_noacct+0x16f3/0x1be0 block/blk-core.c:810
Code: 00 00 45 0f b6 a4 24 50 05 00 00 48 8d 74 24 60 48 89 ef e8 ff 2d fe ff 48 c7 c7 e0 7b 04 8a 48 89 c6 44 89 e2 e8 71 9f 3f 05 <0f> 0b e9 91 f3 ff ff e8 d1 e3 ad fd e8 5c c8 83 05 31 ff 89 c3 89
RSP: 0018:ffffc90010956e18 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88801ae02da0 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff816038e8 RDI: fffff5200212adb5
RBP: ffff888075db4780 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815fe2ae R11: 0000000000000000 R12: 0000000000000001
R13: ffff888075db4790 R14: ffff888016f0d080 R15: 1ffff9200212adcb
FS:  00007ff14f7f9700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8be596c058 CR3: 000000006bacb000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 submit_bio block/blk-core.c:941 [inline]
 submit_bio+0x1a0/0x350 block/blk-core.c:905
 ext4_io_submit+0x181/0x210 fs/ext4/page-io.c:379
 ext4_writepages+0x1450/0x3b90 fs/ext4/inode.c:2798
 do_writepages+0x1ab/0x690 mm/page-writeback.c:2447
 filemap_fdatawrite_wbc mm/filemap.c:384 [inline]
 filemap_fdatawrite_wbc+0x143/0x1b0 mm/filemap.c:374
 __filemap_fdatawrite_range mm/filemap.c:417 [inline]
 file_write_and_wait_range+0x163/0x1e0 mm/filemap.c:775
 ext4_sync_file+0x21f/0xfd0 fs/ext4/fsync.c:151
 vfs_fsync_range+0x13a/0x220 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2796 [inline]
 ext4_buffered_write_iter+0x2b7/0x390 fs/ext4/file.c:277
 ext4_file_write_iter+0x43c/0x1510 fs/ext4/file.c:679
 call_write_iter include/linux/fs.h:2095 [inline]
 do_iter_readv_writev+0x47a/0x750 fs/read_write.c:726
 do_iter_write+0x188/0x710 fs/read_write.c:852
 vfs_iter_write+0x70/0xa0 fs/read_write.c:893
 iter_file_splice_write+0x723/0xc70 fs/splice.c:689
 do_splice_from fs/splice.c:767 [inline]
 direct_splice_actor+0x110/0x180 fs/splice.c:936
 splice_direct_to_actor+0x34b/0x8c0 fs/splice.c:891
 do_splice_direct+0x1b3/0x280 fs/splice.c:979
 do_sendfile+0xaf2/0x1250 fs/read_write.c:1246
 __do_sys_sendfile64 fs/read_write.c:1311 [inline]
 __se_sys_sendfile64 fs/read_write.c:1297 [inline]
 __x64_sys_sendfile64+0x1cc/0x210 fs/read_write.c:1297
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7ff14e689059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff14f7f9168 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007ff14e79bf60 RCX: 00007ff14e689059
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000004
RBP: 00007ff14e6e308d R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000f6c1 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc6da5bc4f R14: 00007ff14f7f9300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
