Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550CD487ABC
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 17:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348363AbiAGQv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 11:51:27 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:41530 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348357AbiAGQv0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 11:51:26 -0500
Received: by mail-il1-f200.google.com with SMTP id h23-20020a056e021d9700b002b49f2b9bccso4113570ila.8
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 08:51:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1b9kcxEzadYvbxSNtVaIR8baq9a/dGnbLKfd8RBwxPY=;
        b=mG/eHrJ7ykLIPOc2gEKpri35vv+lA5AXO+PXBjkiUyx0xGIzW8bkqFCS0CSE0bLo1L
         XWKBpNgYSGw4SknfIeW6w+Umje0SQwSYxiTzaEpy1SkQDuMlHeN35SeSAa+4sgpQWM9D
         bBL1DAhyy/O/1cRjg2rAGM4iY4gl2hOnz+HZtcSYPHEZm5akZ1VoNjBFouXC5vK+MhGr
         Td7tMUs9AwswpnnfU+NX5YX7d+OAVGV35s2RYyK+VUZ7veW8Q7b0f2IUTJQgSxPKbNIL
         nAPJoA9jEyM9sDnImtmYVhGzg0LiMyxOnuYzVkdqHZfk1r6GcvQSJIzYUW2PYPZEnrWm
         BXQw==
X-Gm-Message-State: AOAM532MjUfy4X7k6Py4crwxEJv1DBx6NupoUBCcqMVrHRJup2T0zjwQ
        3sbcvo33xsqiLsR59fv1lotnfLzyzDhsSYoc23Y9Rsx6VKXS
X-Google-Smtp-Source: ABdhPJxaDV+LM1+jm1tKLrJYnaiuddmQd2y5lLCFhxLfx/muoOgdaqZUF86rMJV41ZYo+H4ZKK+wQ/EqB5mU/8A5SqqR/J7EZ7vQ
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1244:: with SMTP id o4mr28029318jas.80.1641574286038;
 Fri, 07 Jan 2022 08:51:26 -0800 (PST)
Date:   Fri, 07 Jan 2022 08:51:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003118ba05d500cce1@google.com>
Subject: [syzbot] KMSAN: uninit-value in nf_nat_setup_info (2)
From:   syzbot <syzbot+cbcd154fce7c6d953d1c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        glider@google.com, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81c325bbf94e kmsan: hooks: do not check memory in kmsan_in..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=125922b3b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46a956fc7a887c60
dashboard link: https://syzkaller.appspot.com/bug?extid=cbcd154fce7c6d953d1c
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cbcd154fce7c6d953d1c@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __nf_ct_tuple_src_equal include/net/netfilter/nf_conntrack_tuple.h:128 [inline]
BUG: KMSAN: uninit-value in nf_ct_tuple_equal include/net/netfilter/nf_conntrack_tuple.h:143 [inline]
BUG: KMSAN: uninit-value in nf_nat_setup_info+0x3adb/0x4750 net/netfilter/nf_nat_core.c:607
 __nf_ct_tuple_src_equal include/net/netfilter/nf_conntrack_tuple.h:128 [inline]
 nf_ct_tuple_equal include/net/netfilter/nf_conntrack_tuple.h:143 [inline]
 nf_nat_setup_info+0x3adb/0x4750 net/netfilter/nf_nat_core.c:607
 __nf_nat_alloc_null_binding net/netfilter/nf_nat_core.c:664 [inline]
 nf_nat_alloc_null_binding net/netfilter/nf_nat_core.c:670 [inline]
 nf_nat_inet_fn+0x12bc/0x1720 net/netfilter/nf_nat_core.c:759
 nf_nat_ipv6_fn+0x4dd/0x580 net/netfilter/nf_nat_proto.c:937
 nf_nat_ipv6_local_fn+0xa7/0x830 net/netfilter/nf_nat_proto.c:1001
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x184/0x480 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0x27b6/0x2880 net/ipv6/ip6_output.c:324
 sctp_v6_xmit+0xd84/0x19b0 net/sctp/ipv6.c:250
 sctp_packet_transmit+0x438f/0x45a0 net/sctp/output.c:652
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 nf_ct_invert_tuple+0x5e8/0x620 net/netfilter/nf_conntrack_core.c:464
 nf_nat_setup_info+0x30d/0x4750 net/netfilter/nf_nat_core.c:602
 __nf_nat_alloc_null_binding net/netfilter/nf_nat_core.c:664 [inline]
 nf_nat_alloc_null_binding net/netfilter/nf_nat_core.c:670 [inline]
 nf_nat_inet_fn+0x12bc/0x1720 net/netfilter/nf_nat_core.c:759
 nf_nat_ipv6_fn+0x4dd/0x580 net/netfilter/nf_nat_proto.c:937
 nf_nat_ipv6_local_fn+0xa7/0x830 net/netfilter/nf_nat_proto.c:1001
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x184/0x480 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0x27b6/0x2880 net/ipv6/ip6_output.c:324
 sctp_v6_xmit+0xd84/0x19b0 net/sctp/ipv6.c:250
 sctp_packet_transmit+0x438f/0x45a0 net/sctp/output.c:652
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 __nf_conntrack_alloc+0x2de/0x7f0 net/netfilter/nf_conntrack_core.c:1559
 init_conntrack+0x29b/0x2530 net/netfilter/nf_conntrack_core.c:1635
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1746 [inline]
 nf_conntrack_in+0x1b4b/0x2fe0 net/netfilter/nf_conntrack_core.c:1901
 ipv6_conntrack_local+0x68/0x80 net/netfilter/nf_conntrack_proto.c:414
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x184/0x480 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0x27b6/0x2880 net/ipv6/ip6_output.c:324
 sctp_v6_xmit+0xd84/0x19b0 net/sctp/ipv6.c:250
 sctp_packet_transmit+0x438f/0x45a0 net/sctp/output.c:652
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 nf_ct_invert_tuple+0x614/0x620 net/netfilter/nf_conntrack_core.c:465
 init_conntrack+0x11f/0x2530 net/netfilter/nf_conntrack_core.c:1629
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1746 [inline]
 nf_conntrack_in+0x1b4b/0x2fe0 net/netfilter/nf_conntrack_core.c:1901
 ipv6_conntrack_local+0x68/0x80 net/netfilter/nf_conntrack_proto.c:414
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x184/0x480 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0x27b6/0x2880 net/ipv6/ip6_output.c:324
 sctp_v6_xmit+0xd84/0x19b0 net/sctp/ipv6.c:250
 sctp_packet_transmit+0x438f/0x45a0 net/sctp/output.c:652
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 nf_ct_get_tuple_ports net/netfilter/nf_conntrack_core.c:255 [inline]
 nf_ct_get_tuple+0x1500/0x1730 net/netfilter/nf_conntrack_core.c:327
 resolve_normal_ct net/netfilter/nf_conntrack_core.c:1722 [inline]
 nf_conntrack_in+0x74d/0x2fe0 net/netfilter/nf_conntrack_core.c:1901
 ipv6_conntrack_local+0x68/0x80 net/netfilter/nf_conntrack_proto.c:414
 nf_hook_entry_hookfn include/linux/netfilter.h:142 [inline]
 nf_hook_slow+0x184/0x480 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:262 [inline]
 NF_HOOK include/linux/netfilter.h:305 [inline]
 ip6_xmit+0x27b6/0x2880 net/ipv6/ip6_output.c:324
 sctp_v6_xmit+0xd84/0x19b0 net/sctp/ipv6.c:250
 sctp_packet_transmit+0x438f/0x45a0 net/sctp/output.c:652
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was stored to memory at:
 pskb_expand_head+0x3c9/0x1ca0 net/core/skbuff.c:1710
 skb_expand_head+0x561/0x970 net/core/skbuff.c:1828
 ip6_xmit+0xb97/0x2880 net/ipv6/ip6_output.c:266
 sctp_v6_xmit+0xd84/0x19b0 net/sctp/ipv6.c:250
 sctp_packet_transmit+0x438f/0x45a0 net/sctp/output.c:652
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 sctp_packet_transmit+0x528/0x45a0 net/sctp/output.c:597
 sctp_packet_singleton+0x3d8/0x580 net/sctp/outqueue.c:777
 sctp_outq_flush_ctrl net/sctp/outqueue.c:908 [inline]
 sctp_outq_flush+0x667/0x5eb0 net/sctp/outqueue.c:1202
 sctp_outq_uncork+0x105/0x120 net/sctp/outqueue.c:758
 sctp_side_effects net/sctp/sm_sideeffect.c:1195 [inline]
 sctp_do_sm+0x946f/0x9b50 net/sctp/sm_sideeffect.c:1166
 sctp_primitive_ASSOCIATE+0x172/0x1a0 net/sctp/primitive.c:73
 sctp_sendmsg_to_asoc+0x143f/0x1f90 net/sctp/socket.c:1837
 sctp_sendmsg+0x3eaa/0x5460 net/sctp/socket.c:2027
 inet_sendmsg+0x15b/0x1d0 net/ipv4/af_inet.c:819
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x704/0x840 net/socket.c:2492
 __compat_sys_sendmsg net/compat.c:347 [inline]
 __do_compat_sys_sendmsg net/compat.c:354 [inline]
 __se_compat_sys_sendmsg net/compat.c:351 [inline]
 __ia32_compat_sys_sendmsg+0xed/0x130 net/compat.c:351
 do_syscall_32_irqs_on arch/x86/entry/common.c:114 [inline]
 __do_fast_syscall_32+0x96/0xf0 arch/x86/entry/common.c:180
 do_fast_syscall_32+0x34/0x70 arch/x86/entry/common.c:205
 do_SYSENTER_32+0x1b/0x20 arch/x86/entry/common.c:248
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c

CPU: 0 PID: 21099 Comm: syz-executor.2 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
