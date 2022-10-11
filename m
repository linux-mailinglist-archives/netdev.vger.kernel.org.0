Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B605FAE9F
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiJKIop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiJKIon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:44:43 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88091DFA
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:44:37 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id f15-20020a056e020b4f00b002fa34db70f0so10365847ilu.2
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:44:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0nqWeV9EF6KsIDD2LA5M41aHMNeyj3iWpzMj//ZlfoY=;
        b=ybX94EbnPv+Ee/68CCbIP3KibDTTurIDXKRAMljooN3B0Peq0sACIWQwUat4V5/9r1
         ctLea9FX74avca/7qKTqeG1dhZI/VZm7Sj7k0rmmhHMV7ZGXgdIcf+MtyC7ZRMQtnQbE
         gf7QcLDXE+Fget1B9bFOD0SwvN1I/0YS/7g6eNa7WOUeAOP38IU8sK8qehjgoeJbswoo
         zdGt2JUcUWXaedSBNtYPuWLhhXWtfemWgawsIEuVtUP9ACuyz2J9tBcrDRheSrjlxHPq
         31qPdAX/p2v75mZ4FkgWn7dFIfcDb4/Yd5ONv7kFD7LH+XZ26VKwTx1Lj5Cfk1kYM1W0
         6yeQ==
X-Gm-Message-State: ACrzQf0KCh7iu8GAvjtHzFij/xqaodwXDNZ9E+sw/FjIMQLVn9c7EQLA
        9EY60EUaqwaft/Ho7LjRxL/MTeIZ3Pf3Vw5zu7cIxvkOLkyX
X-Google-Smtp-Source: AMsMyM4HiqKwOTRZeICA7LrYZN2D0oJukuso7kvW7j01J0mQnR8acZWEEBx14+DUsX/ikEoazZIHq4f27+ZW+D+VkmLMuOgzD8L0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:ec8:b0:2f9:aa6c:3c6f with SMTP id
 i8-20020a056e020ec800b002f9aa6c3c6fmr11584890ilk.138.1665477876854; Tue, 11
 Oct 2022 01:44:36 -0700 (PDT)
Date:   Tue, 11 Oct 2022 01:44:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003b373905eabe492f@google.com>
Subject: [syzbot] upstream test error: WARNING in wg_cpumask_next_online
From:   syzbot <syzbot+4d46c43d81c3bd155060@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
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

HEAD commit:    60bb8154d1d7 Merge tag 'xfs-6.1-for-linus' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10ce0ea4880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=184ee7ce557d8550
dashboard link: https://syzkaller.appspot.com/bug?extid=4d46c43d81c3bd155060
compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d46c43d81c3bd155060@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 2267 at include/linux/cpumask.h:110 wg_cpumask_next_online+0x1c0/0x2c0 drivers/net/wireguard/queueing.h:132
Modules linked in:
CPU: 1 PID: 2267 Comm: kworker/u4:7 Tainted: G        W          6.0.0-syzkaller-10822-g60bb8154d1d7 #0
Hardware name: linux,dummy-virt (DT)
Workqueue: wg-kex-wg2 wg_packet_handshake_send_worker
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
pc : cpumask_check include/linux/cpumask.h:117 [inline]
pc : cpumask_next include/linux/cpumask.h:178 [inline]
pc : wg_cpumask_next_online+0x1c0/0x2c0 drivers/net/wireguard/queueing.h:133
lr : wg_packet_receive+0x978/0x1560 drivers/net/wireguard/receive.c:568
sp : ffff800010ab7480
x29: ffff800010ab7480 x28: 0000000000000001 x27: 1fffe000015d2219
x26: 0000000000000000 x25: ffff80000de5c000 x24: 0000000000000000
x23: 0000000000000003 x22: ffff80000de5cb68 x21: 0000000000000001
x20: ffff00000ae910c8 x19: ffff80000de5cd50 x18: 000000002b1800ff
x17: ffff80005cbe4000 x16: ffff800010ab8000 x15: ffff000018c3eca8
x14: 1ffff00002156e68 x13: 0000000000000000 x12: ffff6000015d2291
x11: 1fffe000015d2290 x10: ffff6000015d2290 x9 : dfff800000000000
x8 : ffff00000ae91483 x7 : 00009ffffea2dd70 x6 : 0000000000000001
x5 : ffff00000ae91480 x4 : ffff700001bcb9aa x3 : dfff800000000000
x2 : 0000000000000002 x1 : 0000000000000002 x0 : 0000000000000001
Call trace:
 wg_cpumask_next_online+0x1c0/0x2c0 drivers/net/wireguard/queueing.h:132
 wg_packet_receive+0x978/0x1560 drivers/net/wireguard/receive.c:568
 wg_receive+0x58/0xb0 drivers/net/wireguard/socket.c:326
 udpv6_queue_rcv_one_skb+0x8f4/0x17c0 net/ipv6/udp.c:714
 udpv6_queue_rcv_skb+0x134/0x7e0 net/ipv6/udp.c:775
 udp6_unicast_rcv_skb+0xe8/0x270 net/ipv6/udp.c:918
 __udp6_lib_rcv+0x8a4/0x2330 net/ipv6/udp.c:1003
 udpv6_rcv+0x1c/0x2c net/ipv6/udp.c:1111
 ip6_protocol_deliver_rcu+0x154/0x14f0 net/ipv6/ip6_input.c:439
 ip6_input_finish+0x108/0x220 net/ipv6/ip6_input.c:484
 NF_HOOK include/linux/netfilter.h:302 [inline]
 NF_HOOK include/linux/netfilter.h:296 [inline]
 ip6_input+0xbc/0x2b0 net/ipv6/ip6_input.c:493
 dst_input include/net/dst.h:455 [inline]
 ip6_rcv_finish net/ipv6/ip6_input.c:79 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 NF_HOOK include/linux/netfilter.h:296 [inline]
 ipv6_rcv+0x39c/0x47c net/ipv6/ip6_input.c:309
 __netif_receive_skb_one_core+0xf4/0x170 net/core/dev.c:5485
 __netif_receive_skb+0x24/0x184 net/core/dev.c:5599
 process_backlog+0x24c/0x6b0 net/core/dev.c:5927
 __napi_poll+0x94/0x3a4 net/core/dev.c:6494
 napi_poll net/core/dev.c:6561 [inline]
 net_rx_action+0x78c/0xb60 net/core/dev.c:6672
 _stext+0x28c/0x107c
 ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
 call_on_irq_stack+0x2c/0x54 arch/arm64/kernel/entry.S:889
 do_softirq_own_stack+0x1c/0x30 arch/arm64/kernel/irq.c:84
 do_softirq.part.0+0xd0/0xf4 kernel/softirq.c:472
 do_softirq kernel/softirq.c:464 [inline]
 __local_bh_enable_ip+0x50c/0x5d0 kernel/softirq.c:396
 __raw_read_unlock_bh include/linux/rwlock_api_smp.h:257 [inline]
 _raw_read_unlock_bh+0x54/0x64 kernel/locking/spinlock.c:284
 wg_socket_send_skb_to_peer+0xf0/0x190 drivers/net/wireguard/socket.c:184
 wg_socket_send_buffer_to_peer+0x110/0x160 drivers/net/wireguard/socket.c:200
 wg_packet_send_handshake_initiation+0x1a8/0x274 drivers/net/wireguard/send.c:40
 wg_packet_handshake_send_worker+0x1c/0x34 drivers/net/wireguard/send.c:51
 process_one_work+0x780/0x184c kernel/workqueue.c:2289
 worker_thread+0x3cc/0xc40 kernel/workqueue.c:2436
 kthread+0x23c/0x2a0 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
irq event stamp: 6169
hardirqs last  enabled at (6168): [<ffff80000816f1d4>] __local_bh_enable_ip+0x1e4/0x5d0 kernel/softirq.c:401
hardirqs last disabled at (6169): [<ffff80000c8ec9b4>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:404
softirqs last  enabled at (6160): [<ffff800009f35a60>] wg_socket_send_skb_to_peer+0xf0/0x190 drivers/net/wireguard/socket.c:184
softirqs last disabled at (6161): [<ffff800008019cb0>] ____do_softirq+0x10/0x20 arch/arm64/kernel/irq.c:79
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
