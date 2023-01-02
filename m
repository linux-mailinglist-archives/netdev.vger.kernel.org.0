Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA5B65AF39
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 11:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjABKCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 05:02:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbjABKCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 05:02:49 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFCDFC2B
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 02:02:47 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so17828635iln.21
        for <netdev@vger.kernel.org>; Mon, 02 Jan 2023 02:02:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PyJN7OJ2YqNiOOnZ+Fq+PsLaoelIj5+JM/BH5hSu9d8=;
        b=AQOMx9NWB4xcOWyFtl06epFcHNaeNes0flmPc0BmdLIZBLDwiV4iSHRJIgC0w4Kq4T
         7gcSqEqw/BWW6G4LDNlEO35pa2+YI2phrQ0ZjMy0m409GGNKDdDeJx8BHp25TR1BEihJ
         p5QOxjCSDVJWIXIi/X9+Ss0ZJqc94j9cZ1yhNo0EkNlTBf1FA2POpJR1jlsMSxfh14Wc
         YyL0VOUixUFKP/ZnI05uS7QzE0zaqcf9gXBE4wRq8KUwxAewRgMJIq85pgrRLsELBEkJ
         RFafH1XorBQav94oPohNm9wW4Q9Qo6I08CnGUhZpF8tcyiRThy5lxwXBkSvcKYWQMGV8
         MZqw==
X-Gm-Message-State: AFqh2krigmPfWbDIXV5glMA/fK2H8EpWC3HOtu2F0r5/xNjeQReeYwzP
        YEXtKTFRUBMosUmjgtOHBexSSXMrlmG6CasUfoNR51i1hf2z
X-Google-Smtp-Source: AMrXdXuK8BL5XFckTUtiI6cAiKbo7vijg0rMDXz5UPvsraCP28ZDLqVvaqbabsZpbk/BMI1eVrK5QrdvlMBAmLABBIOBZ9ZvIx/F
MIME-Version: 1.0
X-Received: by 2002:a6b:c817:0:b0:6e0:2427:f72e with SMTP id
 y23-20020a6bc817000000b006e02427f72emr2089330iof.55.1672653767119; Mon, 02
 Jan 2023 02:02:47 -0800 (PST)
Date:   Mon, 02 Jan 2023 02:02:47 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f187905f1450d91@google.com>
Subject: [syzbot] BUG: unable to handle kernel paging request in cfg80211_inform_bss_frame_data
From:   syzbot <syzbot+6b5032e139299571a3d1@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    a5541c0811a0 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15374118480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd4e584773e9397
dashboard link: https://syzkaller.appspot.com/bug?extid=6b5032e139299571a3d1
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4b7702208fb9/disk-a5541c08.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9ec0153ec051/vmlinux-a5541c08.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6f8725ad290a/Image-a5541c08.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6b5032e139299571a3d1@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address 002e6f696b6c629f
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
[002e6f696b6c629f] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 4479 Comm: kworker/u4:21 Not tainted 6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: phy15 ieee80211_iface_work
pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __kmem_cache_alloc_node+0x17c/0x350 mm/slub.c:3437
lr : slab_pre_alloc_hook mm/slab.h:712 [inline]
lr : slab_alloc_node mm/slub.c:3318 [inline]
lr : __kmem_cache_alloc_node+0x80/0x350 mm/slub.c:3437
sp : ffff800015e63890
x29: ffff800015e638a0 x28: ffff000124078000 x27: ffff0001238ab474
x26: ffff00010b9e3658 x25: 00000000ffffffff x24: ffff80000bc33670
x23: 0000000000000048 x22: 622e6f696b6c625f x21: 0000000000000000
x20: 0000000000000b20 x19: ffff0000c0001200 x18: 00000000000003a6
x17: 0000000000000075 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000005 x12: ffff80000d8f0a90
x11: 0000000000000001 x10: 0000000000000000 x9 : 0000000000000040
x8 : 0000000000387011 x7 : ffff80000bcf8a58 x6 : 0000000000000000
x5 : 0000000000000000 x4 : ffff80000bc33670 x3 : 0000000000387019
x2 : 0000000000000000 x1 : 0000000000000080 x0 : fffffc000317aa00
Call trace:
 next_tid mm/slub.c:2349 [inline]
 slab_alloc_node mm/slub.c:3382 [inline]
 __kmem_cache_alloc_node+0x17c/0x350 mm/slub.c:3437
 __do_kmalloc_node mm/slab_common.c:954 [inline]
 __kmalloc+0xb4/0x140 mm/slab_common.c:968
 kmalloc include/linux/slab.h:558 [inline]
 kzalloc include/linux/slab.h:689 [inline]
 cfg80211_inform_single_bss_frame_data net/wireless/scan.c:2471 [inline]
 cfg80211_inform_bss_frame_data+0x29c/0xc40 net/wireless/scan.c:2532
 ieee80211_bss_info_update+0x3f4/0x60c net/mac80211/scan.c:190
 ieee80211_rx_bss_info net/mac80211/ibss.c:1120 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1609 [inline]
 ieee80211_ibss_rx_queued_mgmt+0xb9c/0x1078 net/mac80211/ibss.c:1638
 ieee80211_iface_process_skb net/mac80211/iface.c:1630 [inline]
 ieee80211_iface_work+0x444/0x68c net/mac80211/iface.c:1684
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
Code: 54000ee1 34000eeb b9402a69 91002103 (f8696ada) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	54000ee1 	b.ne	0x1dc  // b.any
   4:	34000eeb 	cbz	w11, 0x1e0
   8:	b9402a69 	ldr	w9, [x19, #40]
   c:	91002103 	add	x3, x8, #0x8
* 10:	f8696ada 	ldr	x26, [x22, x9] <-- trapping instruction


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
