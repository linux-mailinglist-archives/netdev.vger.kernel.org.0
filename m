Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3170562F406
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiKRLux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiKRLuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:50:52 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3575B922F5
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:50:48 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id k3-20020a92c243000000b0030201475a6bso3150062ilo.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:50:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O8R1Gfq5Fl8LwQMCqabLpPUSSLaHyEz1st1n5T0M71Q=;
        b=jpPFnOJKjJDaGGAL8xWXELyIrh3W0pl+tFQKmLoU4QfKRNU220A6BQITwGaS/lHGwp
         YvQ2y+Msr9rcBJ1rlcPjWWIqK1SNPC6DWEzEWtyxXpHQu1G5bbSqGJeI8abh/+bitGC4
         9OiDmWoQZVbIEnW/tZtI+HTjCaq7AzOHX7CXaPUve5Lc9MwF9yom4zpCkzJ3ByVCMc9w
         SFo+nOWi8y3X6e6Hyjv5f+eoPOXD0rjwlUyZ2fMB1KTGmoUk8o+ac+FuMXel6N6f1JxP
         PQzz74p9UtfOWOwxz263NGgzUY7c+YSN14DCuHYvt6FHmu8C4BxTSwVqhk4Svc1JCvFo
         MjXw==
X-Gm-Message-State: ANoB5pkKXRMrQ+uF24gDx+jOwFsFRylDCB0w+SHAhV+/UmqTGP9Y/EjG
        9n9cVuckDbs83t+tJJQamqi0LQa4M0lE7ZcMn5riiGDr87+b
X-Google-Smtp-Source: AA0mqf4RGzkXLsKamY623483tK8m6PTRRuSBapAkPe84hE8zj/n0j9csBqc4FSc4HfXalJiUd+3VzbJLtuSEfec9HGG6ldbsW5gh
MIME-Version: 1.0
X-Received: by 2002:a02:6d5c:0:b0:375:2859:655c with SMTP id
 e28-20020a026d5c000000b003752859655cmr2955441jaf.1.1668772247467; Fri, 18 Nov
 2022 03:50:47 -0800 (PST)
Date:   Fri, 18 Nov 2022 03:50:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000057d3e05edbd51b9@google.com>
Subject: [syzbot] WARNING in default_device_exit_batch (4)
From:   syzbot <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, roman.gushchin@linux.dev, shakeelb@google.com,
        shaozhengchao@huawei.com, syzkaller-bugs@googlegroups.com,
        vasily.averin@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81ac25651a62 Merge tag 'nfsd-6.1-5' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b08501880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6f4e5e9899396248
dashboard link: https://syzkaller.appspot.com/bug?extid=9dfc3f3348729cc82277
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9604c2253fa1/disk-81ac2565.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1af57bc5afd/vmlinux-81ac2565.xz
kernel image: https://storage.googleapis.com/syzbot-assets/20049443b718/bzImage-81ac2565.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com

bond3 (unregistering): Released all slaves
------------[ cut here ]------------
WARNING: CPU: 0 PID: 4036 at net/core/dev.c:10870 unregister_netdevice_many+0x1412/0x1930 net/core/dev.c:10870
Modules linked in:
CPU: 0 PID: 4036 Comm: kworker/u4:8 Not tainted 6.1.0-rc5-syzkaller-00103-g81ac25651a62 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: netns cleanup_net
RIP: 0010:unregister_netdevice_many+0x1412/0x1930 net/core/dev.c:10870
Code: c2 1a 00 00 48 c7 c6 80 60 5b 8b 48 c7 c7 80 61 5b 8b c6 05 8e 50 86 06 01 e8 d7 2f f3 01 0f 0b e9 7a f9 ff ff e8 de 53 c8 f9 <0f> 0b e9 51 f9 ff ff e8 42 17 15 fa e9 b9 ed ff ff 4c 89 ef e8 95
RSP: 0018:ffffc90005cd7a58 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000738d3001 RCX: 0000000000000000
RDX: ffff8880267cd7c0 RSI: ffffffff87b7c5a2 RDI: 0000000000000001
RBP: ffff888060fb1600 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffff888060fb1600 R14: ffff88807ad9c000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ca93a63950 CR3: 000000007f17c000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 default_device_exit_batch+0x44d/0x590 net/core/dev.c:11341
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
 cleanup_net+0x4ee/0xb00 net/core/net_namespace.c:601
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x669/0x1090 kernel/workqueue.c:2436
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
