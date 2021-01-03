Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D3B2E8C13
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 13:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbhACMKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 07:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbhACMKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 07:10:44 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A94C061573;
        Sun,  3 Jan 2021 04:10:04 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id c22so16929495pgg.13;
        Sun, 03 Jan 2021 04:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3CCSlG6P1DW0tXx5FC8GS0NqA6gv/0EpjTxFDsREuS8=;
        b=PlU4ay0Jyp8MMx4LID0P8RU2/GrTbDE3Wt+BxwROp1luaanr6fQZ8QGy3AGcIVxI7J
         xqUcSQUf3puvMvWRxwqrqYhbRV12KwqoLGS99S/emDCeB7H6+7OlQBP67EyB/3Jg5V/6
         UdCdRbrioTvzFDp38E3wRMq7xhGwwoL5fOEA2gQq65ft3UKkVJakXNrxQS+jcgyCiUvs
         hU/M8ZJe3kKXPKLfYpD8LGVrOQWo+sLq9uxISIBkcOERuigpu6eYZl62xVuakRPTr4VA
         5Zpk/1LAjgaWZtcXDfs9YN/dx6H2uV09YYhQwojkx+N1m7v+3bfX9Tqc8hckT1RNdTH3
         Lu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3CCSlG6P1DW0tXx5FC8GS0NqA6gv/0EpjTxFDsREuS8=;
        b=baGRPlA8h/iignghgEAI+6hRoNHCW+mHeCzHHtM7ict6u7aNJ5DzonXLGeHYcuQvP4
         hxGD7uPSJRMns0Sa93OMaCUnyHhTh6U9Yl0uhEX9CaGHu6W+9ziZvd7unAYAH+cvVQal
         O4KnYk8cGJFCXRl3AmRbAZhgFrLwXEsV7YHTWFRhq1tbGHukQQjkbabIpt4hDMoH3mpq
         oV3xfP3BBL+zrWRc73aF2P6ASgNiAZ/upegGamnQP/y+g79w/kJpBpz+29XmYPAVZkOE
         pBXw6zfCnP12Lik0gU+NyEhAHUn2kBg/PjKqUXJ9frBOUX2g1/vmCvhAKzmiFd87eaKt
         Hp6g==
X-Gm-Message-State: AOAM532g2irOsumwD+jqyAJoeQZhL35DTxijfp8PuAbZuUc7oltUtPQt
        dYqBI2lrRhP+WNKHaVfgcQ==
X-Google-Smtp-Source: ABdhPJxBYmDfBI6k/Ae2QQD9CxbG0W52nrlFSXFUEGsXMRsPhWQZVHwIKMwuLN1LqMWgoe05j52cGA==
X-Received: by 2002:a63:d650:: with SMTP id d16mr66864865pgj.277.1609675803253;
        Sun, 03 Jan 2021 04:10:03 -0800 (PST)
Received: from DESKTOP (softbank126068109016.bbtec.net. [126.68.109.16])
        by smtp.gmail.com with ESMTPSA id a1sm52464082pfo.56.2021.01.03.04.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 04:10:02 -0800 (PST)
Date:   Sun, 3 Jan 2021 21:09:55 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     syzbot <syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in qrtr_tun_open
Message-ID: <CAKK_rcjc6L7hXwRoAAsx8Xr0TVCCy5VjfmYe3kPjTgFDDObmVA@mail.gmail.com>
References: <00000000000029861705b4e4dc59@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <00000000000029861705b4e4dc59@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

#syz test: https://github.com/google/kasan.git 509a1542

On Wed, Nov 25, 2020 at 11:13 AM syzbot <syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4d02da97 Merge tag 'net-5.10-rc5' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16f4331e500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c5353ac514ca5a43
> dashboard link: https://syzkaller.appspot.com/bug?extid=5d6e4af21385f5cfc56a
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1115d001500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1467f82e500000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.350s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.440s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.520s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.600s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.680s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.760s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.850s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> BUG: memory leak
> unreferenced object 0xffff888117d40180 (size 64):
>   comm "syz-executor845", pid 10294, jiffies 4295034653 (age 32.930s)
>   hex dump (first 32 bytes):
>     c0 24 04 84 ff ff ff ff 00 00 00 00 00 00 00 00  .$..............
>     90 01 d4 17 81 88 ff ff 90 01 d4 17 81 88 ff ff  ................
>   backtrace:
>     [<00000000fcfbf0c5>] kmalloc include/linux/slab.h:552 [inline]
>     [<00000000fcfbf0c5>] kzalloc include/linux/slab.h:664 [inline]
>     [<00000000fcfbf0c5>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
>     [<000000003dd258a0>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
>     [<00000000c462f734>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
>     [<000000006a388b0e>] do_dentry_open+0x1e6/0x620 fs/open.c:817
>     [<00000000757d8e01>] do_open fs/namei.c:3252 [inline]
>     [<00000000757d8e01>] path_openat+0x74a/0x1b00 fs/namei.c:3369
>     [<00000000b8d1608f>] do_filp_open+0xa0/0x190 fs/namei.c:3396
>     [<0000000089fdef83>] do_sys_openat2+0xed/0x230 fs/open.c:1168
>     [<000000004cd3d1c0>] do_sys_open fs/open.c:1184 [inline]
>     [<000000004cd3d1c0>] __do_sys_openat fs/open.c:1200 [inline]
>     [<000000004cd3d1c0>] __se_sys_openat fs/open.c:1195 [inline]
>     [<000000004cd3d1c0>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1195
>     [<00000000d6a554a2>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>     [<0000000099a4af52>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
> write to /proc/sys/kernel/hung_task_check_interval_secs failed: No such file or directory
> write to /proc/sys/kernel/softlockup_all_cpu_backtrace failed: No such file or directory
> write to /proc/sys/fs/mount-max failed: Bad address
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

--7AUc2qLy4jB3hD7Z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-PATCH-net-net-qrtr-Fix-memory-leak-in-qrtr_tun_open.patch"

From dfc30988f5c32badd701d2db340ff5b945799917 Mon Sep 17 00:00:00 2001
From: Takeshi Misawa <jeliantsurux@gmail.com>
Date: Sun, 3 Jan 2021 15:46:19 +0900
Subject: [PATCH] [PATCH net] net: qrtr: Fix memory leak in qrtr_tun_open

If qrtr_endpoint_register() failed, tun is leaked.
Fix this, by freeing tun in error path.

syzbot report:
BUG: memory leak
unreferenced object 0xffff88811848d680 (size 64):
  comm "syz-executor684", pid 10171, jiffies 4294951561 (age 26.070s)
  hex dump (first 32 bytes):
    80 dd 0a 84 ff ff ff ff 00 00 00 00 00 00 00 00  ................
    90 d6 48 18 81 88 ff ff 90 d6 48 18 81 88 ff ff  ..H.......H.....
  backtrace:
    [<0000000018992a50>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000018992a50>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000018992a50>] qrtr_tun_open+0x22/0x90 net/qrtr/tun.c:35
    [<0000000003a453ef>] misc_open+0x19c/0x1e0 drivers/char/misc.c:141
    [<00000000dec38ac8>] chrdev_open+0x10d/0x340 fs/char_dev.c:414
    [<0000000079094996>] do_dentry_open+0x1e6/0x620 fs/open.c:817
    [<000000004096d290>] do_open fs/namei.c:3252 [inline]
    [<000000004096d290>] path_openat+0x74a/0x1b00 fs/namei.c:3369
    [<00000000b8e64241>] do_filp_open+0xa0/0x190 fs/namei.c:3396
    [<00000000a3299422>] do_sys_openat2+0xed/0x230 fs/open.c:1172
    [<000000002c1bdcef>] do_sys_open fs/open.c:1188 [inline]
    [<000000002c1bdcef>] __do_sys_openat fs/open.c:1204 [inline]
    [<000000002c1bdcef>] __se_sys_openat fs/open.c:1199 [inline]
    [<000000002c1bdcef>] __x64_sys_openat+0x7f/0xe0 fs/open.c:1199
    [<00000000f3a5728f>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<000000004b38b7ec>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 28fb4e59a47d ("net: qrtr: Expose tunneling endpoint to user space")
Reported-by: syzbot+5d6e4af21385f5cfc56a@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
 net/qrtr/tun.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/tun.c b/net/qrtr/tun.c
index 15ce9b642b25..20d60a78590a 100644
--- a/net/qrtr/tun.c
+++ b/net/qrtr/tun.c
@@ -31,6 +31,7 @@ static int qrtr_tun_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 static int qrtr_tun_open(struct inode *inode, struct file *filp)
 {
 	struct qrtr_tun *tun;
+	int ret;
 
 	tun = kzalloc(sizeof(*tun), GFP_KERNEL);
 	if (!tun)
@@ -43,7 +44,17 @@ static int qrtr_tun_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = tun;
 
-	return qrtr_endpoint_register(&tun->ep, QRTR_EP_NID_AUTO);
+	ret = qrtr_endpoint_register(&tun->ep, QRTR_EP_NID_AUTO);
+	if (ret) {
+		goto out;
+	}
+
+	return ret;
+
+out:
+	filp->private_data = NULL;
+	kfree(tun);
+	return ret;
 }
 
 static ssize_t qrtr_tun_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.25.1


--7AUc2qLy4jB3hD7Z--
