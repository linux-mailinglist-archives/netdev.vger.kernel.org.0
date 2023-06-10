Return-Path: <netdev+bounces-9759-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 658AD72A776
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:35:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4199D280E12
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DE5139C;
	Sat, 10 Jun 2023 01:35:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73393137B
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:35:01 +0000 (UTC)
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB4535BB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:34:59 -0700 (PDT)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7776b76cc59so288387139f.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 18:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686360898; x=1688952898;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f5mNW1xz4ir4K+TXk9/cw5gWevzhG4ajUOaVhJJcyOA=;
        b=UFxbLm9ec0yitn8TBxHY8mt21+yTDEoQFjxVPtVdHkBwkEnF2GfzE+FfwtpFi8HhWM
         EcWiUz7ODXrpp7QgbnBgwQTrRdiwGO04+XSAJc8bowdTmPqwQ8Zlmarm6vkBs5QEHIE6
         VrxmIofbU9g0Fs22d3mZe1EoqwgOh4ijNaxCffEkubWrAeIJ1CtKbvtKfILAT9F/lBOf
         3Y07qkimKda+ZJXgGvqI9rLGfprhJCKHhBYEYf5PSVPb7KPD0LCu6LPoZkJO3vYnj8QU
         amshyvVG8Calz8MJsVArt82Z7RQ85Sb9Fg2QaM8pEn1DTgru046NU5hdM0OwdhpsfXBp
         vQ8A==
X-Gm-Message-State: AC+VfDwHDsjF9eLyVdk8DQ3eMP9jwkOPce1aRmQAbQjTZkQwunUMIm7B
	inolcc70lI1HFb9Gi/4nr0AuPlysvI9KzC5UkFf9H0Tyaq1b
X-Google-Smtp-Source: ACHHUZ5N1vcUonkSxJW+D8dcCzxgbSsr5CPIhX6GAEHBCilclWELJoe1diJ0k/xADhZS7sRySaC+1litczGZyL7c0o4OegxSEjMQ
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:b187:0:b0:41f:2aa6:8b17 with SMTP id
 t7-20020a02b187000000b0041f2aa68b17mr1307116jah.2.1686360898474; Fri, 09 Jun
 2023 18:34:58 -0700 (PDT)
Date: Fri, 09 Jun 2023 18:34:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000051197705fdbc7e54@google.com>
Subject: [syzbot] [net?] unregister_netdevice: waiting for DEV to become free (8)
From: syzbot <syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com>
To: arnd@arndb.de, bridge@lists.linux-foundation.org, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, nikolay@nvidia.com, pabeni@redhat.com, 
	roopa@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    67faabbde36b selftests/bpf: Add missing prototypes for sev..
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1381363b280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5335204dcdecfda
dashboard link: https://syzkaller.appspot.com/bug?extid=881d65229ca4f9ae8c84
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132faf93280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10532add280000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/751a0490d875/disk-67faabbd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2c5106cd9f1f/vmlinux-67faabbd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/62c1154294e4/bzImage-67faabbd.xz

The issue was bisected to:

commit ad2f99aedf8fa77f3ae647153284fa63c43d3055
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Tue Jul 27 13:45:16 2021 +0000

    net: bridge: move bridge ioctls out of .ndo_do_ioctl

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=146de6f1280000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=166de6f1280000
console output: https://syzkaller.appspot.com/x/log.txt?x=126de6f1280000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Fixes: ad2f99aedf8f ("net: bridge: move bridge ioctls out of .ndo_do_ioctl")

unregister_netdevice: waiting for bridge0 to become free. Usage count = 2
leaked reference.
 __netdev_tracker_alloc include/linux/netdevice.h:4070 [inline]
 netdev_hold include/linux/netdevice.h:4099 [inline]
 dev_ifsioc+0xbc0/0xeb0 net/core/dev_ioctl.c:408
 dev_ioctl+0x250/0x1090 net/core/dev_ioctl.c:605
 sock_do_ioctl+0x15a/0x230 net/socket.c:1215
 sock_ioctl+0x1f8/0x680 net/socket.c:1318
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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

