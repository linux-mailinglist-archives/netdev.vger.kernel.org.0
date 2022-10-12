Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 742AA5FC9AA
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 19:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiJLRAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 13:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbiJLRAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 13:00:03 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D8713E99
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:59:53 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id r12-20020a5e8e4c000000b006bc3030624fso5811297ioo.23
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DG+q6lBCzxknCYMN263PUD2mf8mHv3zagp6YGd7y5JI=;
        b=Ls/7zAabuKXmyG1zde1OzSg5fFW65fit5/2p6deiWqDwdFIGvQBne7uETdpGIo4EwY
         Ir7CqJ/jmG7C0fctebL1zi55nH4ETmEDEpR8eHAlNSdqHoU1JsjAd9MKF88j8c/XKotu
         vZw66M6P02sbRHCZpGFsdCEF9VaoLyMfruCxp/RSdpaJddOJyWO2Vd6qfeVG11t3uFyx
         6bISDUdEM/pmmdL2iwncwce0hx4PemO/AjrbnylZ5b+Zj1Sq1OQzJoWfwUdfnJ1AKxpQ
         v14P5QcSlieyEZiFNtdT2O4AIByE9Yd4zf3UZudCcvDy0vZrNrerc1f6i0Tv9i+mxkkw
         weUg==
X-Gm-Message-State: ACrzQf1zQsS5hjlbvTma4Lc+iNWWFihK7LwZJ13DlZfCQHIr2lqdF4rs
        HMjq76E4ZexdhAbvfNQzzhrhnTVDwvnhmOROYZUu2qpNWKgQ
X-Google-Smtp-Source: AMsMyM5eKgZLczgTW3/cwzaZAkE5tgqIyLn6IeDiP+dHBEIvCSNrcdRNwBJzAqd11mvUyIb3OVZX2XWN4mq8TlkGIKvPckWILyV1
MIME-Version: 1.0
X-Received: by 2002:a92:c265:0:b0:2f9:ec63:2e3e with SMTP id
 h5-20020a92c265000000b002f9ec632e3emr15316744ild.275.1665593992556; Wed, 12
 Oct 2022 09:59:52 -0700 (PDT)
Date:   Wed, 12 Oct 2022 09:59:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004438f605ead95255@google.com>
Subject: [syzbot] KMSAN: uninit-value in erspan_build_header
From:   syzbot <syzbot+d551178aab6a783dc249@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        glider@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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

HEAD commit:    968c2729e576 x86: kmsan: fix comment in kmsan_shadow.c
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=100cd00c880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=131312b26465c190
dashboard link: https://syzkaller.appspot.com/bug?extid=d551178aab6a783dc249
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c78ce21b953f/disk-968c2729.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/22868d826804/vmlinux-968c2729.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d551178aab6a783dc249@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in erspan_build_header+0x16d/0x330 include/net/erspan.h:197
 erspan_build_header+0x16d/0x330 include/net/erspan.h:197
 erspan_xmit+0x11a2/0x1f00 net/ipv4/ip_gre.c:701
 __netdev_start_xmit include/linux/netdevice.h:4819 [inline]
 netdev_start_xmit include/linux/netdevice.h:4833 [inline]
 xmit_one+0x14e/0x5f0 net/core/dev.c:3590
 dev_hard_start_xmit+0xe5/0x370 net/core/dev.c:3606
 sch_direct_xmit+0x3f1/0xdb0 net/sched/sch_generic.c:342
 __dev_xmit_skb+0xc22/0x1a30 net/core/dev.c:3817
 __dev_queue_xmit+0x12cb/0x31f0 net/core/dev.c:4222
 dev_queue_xmit include/linux/netdevice.h:3008 [inline]
 __bpf_tx_skb net/core/filter.c:2115 [inline]
 __bpf_redirect_common net/core/filter.c:2154 [inline]
 __bpf_redirect+0x1293/0x13b0 net/core/filter.c:2161
 ____bpf_clone_redirect net/core/filter.c:2430 [inline]
 bpf_clone_redirect+0x324/0x470 net/core/filter.c:2402
 ___bpf_prog_run+0x7ed/0xaee0 kernel/bpf/core.c:1813
 __bpf_prog_run512+0xc2/0x110 kernel/bpf/core.c:2038
 bpf_dispatcher_nop_func include/linux/bpf.h:903 [inline]
 __bpf_prog_run include/linux/filter.h:594 [inline]
 bpf_prog_run include/linux/filter.h:601 [inline]
 bpf_test_run+0x592/0xd20 net/bpf/test_run.c:402
 bpf_prog_test_run_skb+0x1625/0x20b0 net/bpf/test_run.c:1141
 bpf_prog_test_run+0x6a0/0x730 kernel/bpf/syscall.c:3620
 __sys_bpf+0x88d/0xe70 kernel/bpf/syscall.c:4971
 __do_sys_bpf kernel/bpf/syscall.c:5057 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5055 [inline]
 __ia32_sys_bpf+0x9c/0xe0 kernel/bpf/syscall.c:5055
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:246
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:732 [inline]
 slab_alloc_node mm/slub.c:3258 [inline]
 __kmalloc_node_track_caller+0x814/0x1250 mm/slub.c:4970
 kmalloc_reserve net/core/skbuff.c:362 [inline]
 pskb_expand_head+0x24a/0x1a80 net/core/skbuff.c:1729
 __skb_cow include/linux/skbuff.h:3529 [inline]
 skb_cow_head include/linux/skbuff.h:3563 [inline]
 erspan_xmit+0xad2/0x1f00 net/ipv4/ip_gre.c:688
 __netdev_start_xmit include/linux/netdevice.h:4819 [inline]
 netdev_start_xmit include/linux/netdevice.h:4833 [inline]
 xmit_one+0x14e/0x5f0 net/core/dev.c:3590
 dev_hard_start_xmit+0xe5/0x370 net/core/dev.c:3606
 sch_direct_xmit+0x3f1/0xdb0 net/sched/sch_generic.c:342
 __dev_xmit_skb+0xc22/0x1a30 net/core/dev.c:3817
 __dev_queue_xmit+0x12cb/0x31f0 net/core/dev.c:4222
 dev_queue_xmit include/linux/netdevice.h:3008 [inline]
 __bpf_tx_skb net/core/filter.c:2115 [inline]
 __bpf_redirect_common net/core/filter.c:2154 [inline]
 __bpf_redirect+0x1293/0x13b0 net/core/filter.c:2161
 ____bpf_clone_redirect net/core/filter.c:2430 [inline]
 bpf_clone_redirect+0x324/0x470 net/core/filter.c:2402
 ___bpf_prog_run+0x7ed/0xaee0 kernel/bpf/core.c:1813
 __bpf_prog_run512+0xc2/0x110 kernel/bpf/core.c:2038
 bpf_dispatcher_nop_func include/linux/bpf.h:903 [inline]
 __bpf_prog_run include/linux/filter.h:594 [inline]
 bpf_prog_run include/linux/filter.h:601 [inline]
 bpf_test_run+0x592/0xd20 net/bpf/test_run.c:402
 bpf_prog_test_run_skb+0x1625/0x20b0 net/bpf/test_run.c:1141
 bpf_prog_test_run+0x6a0/0x730 kernel/bpf/syscall.c:3620
 __sys_bpf+0x88d/0xe70 kernel/bpf/syscall.c:4971
 __do_sys_bpf kernel/bpf/syscall.c:5057 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5055 [inline]
 __ia32_sys_bpf+0x9c/0xe0 kernel/bpf/syscall.c:5055
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:246
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

CPU: 0 PID: 12499 Comm: syz-executor.1 Not tainted 6.0.0-rc5-syzkaller-48543-g968c2729e576 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
