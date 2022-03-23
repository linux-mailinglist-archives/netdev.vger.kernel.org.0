Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58784E58FB
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 20:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245326AbiCWTPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 15:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiCWTPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 15:15:51 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D6E37AAC
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 12:14:20 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id u15-20020a92da8f000000b002c863d2f21dso969786iln.15
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 12:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2ZDnCCGjtWFNfeOASE7YLgyJVCHQS+Agca5j8mHDAO4=;
        b=HGjNYrEfgaIs7c+HarPOkyn8IUhJmAZP3V46omLqVnZfHBjFX3zDXY+Hm2O6no9Mvf
         jtlr8xP3EjIfHSAFGAIzA/WTniDt1djkm0Mk2XpM4GisINs9rcyfsoURED5RFQ2gdMOl
         hICpXEHZyuQDsnTVXoFRrAuvwgLnPJkHZFwhWrJYuCC9EkAvbzw828PEWUX9TKisByg/
         jgXs4S+ywkjUF9ti2Hbf/WT5l8sbvTr5hYBnPUpLHjeAHq6DlJOgK464bcFq+TKE1EQL
         p2VaSWKq26Xrups+br3Sv120eUCYTCDExMggt7OTMMav/DmgF245RN4gBSip76DDe+QR
         C2IA==
X-Gm-Message-State: AOAM530fzeCRPcxo/IbH1kCJ7HJoIgvUSeyOGQAeOqe673TveqpiUg1e
        t+28yKiQOQyfxvT7Im601qGwlNLYjLgp16Jnw2RC32VFQE5Q
X-Google-Smtp-Source: ABdhPJxdzO9rFo426k2EUnyp3kMUM3M9wnf8kZVxiQD/Ex+DSGzHL1nNp8qYm5R4XPGgNtKBVsSSajM86jDW3vBBI0p4L8t1Nuce
MIME-Version: 1.0
X-Received: by 2002:a92:c7c5:0:b0:2c8:465a:71c6 with SMTP id
 g5-20020a92c7c5000000b002c8465a71c6mr877579ilk.292.1648062859885; Wed, 23 Mar
 2022 12:14:19 -0700 (PDT)
Date:   Wed, 23 Mar 2022 12:14:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054c45805dae78903@google.com>
Subject: [syzbot] bpf-next boot error: KASAN: null-ptr-deref Write in register_btf_kfunc_id_set
From:   syzbot <syzbot+12babd2d45fac8bfff7d@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a8fee96202e2 libbpf: Avoid NULL deref when initializing ma..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1686180b700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=820db791969fe863
dashboard link: https://syzkaller.appspot.com/bug?extid=12babd2d45fac8bfff7d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12babd2d45fac8bfff7d@syzkaller.appspotmail.com

usbcore: registered new interface driver snd-usb-audio
usbcore: registered new interface driver snd-ua101
usbcore: registered new interface driver snd-usb-usx2y
usbcore: registered new interface driver snd-usb-us122l
usbcore: registered new interface driver snd-usb-caiaq
usbcore: registered new interface driver snd-usb-6fire
usbcore: registered new interface driver snd-usb-hiface
usbcore: registered new interface driver snd-bcd2000
usbcore: registered new interface driver snd_usb_pod
usbcore: registered new interface driver snd_usb_podhd
usbcore: registered new interface driver snd_usb_toneport
usbcore: registered new interface driver snd_usb_variax
drop_monitor: Initializing network drop monitor service
NET: Registered PF_LLC protocol family
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.3
u32 classifier
    Performance counters on
    input device check on
    Actions configured
nf_conntrack_irc: failed to register helpers
nf_conntrack_sane: failed to register helpers
nf_conntrack_sip: failed to register helpers
xt_time: kernel timezone is -0000
IPVS: Registered protocols (TCP, UDP, SCTP, AH, ESP)
IPVS: Connection hash table configured (size=4096, memory=64Kbytes)
IPVS: ipvs loaded.
IPVS: [rr] scheduler registered.
IPVS: [wrr] scheduler registered.
IPVS: [lc] scheduler registered.
IPVS: [wlc] scheduler registered.
IPVS: [fo] scheduler registered.
IPVS: [ovf] scheduler registered.
IPVS: [lblc] scheduler registered.
IPVS: [lblcr] scheduler registered.
IPVS: [dh] scheduler registered.
IPVS: [sh] scheduler registered.
IPVS: [mh] scheduler registered.
IPVS: [sed] scheduler registered.
IPVS: [nq] scheduler registered.
IPVS: [twos] scheduler registered.
IPVS: [sip] pe registered.
ipip: IPv4 and MPLS over IPv4 tunneling driver
gre: GRE over IPv4 demultiplexor driver
ip_gre: GRE over IPv4 tunneling driver
IPv4 over IPsec tunneling driver
ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
BUG: KASAN: null-ptr-deref in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: null-ptr-deref in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: null-ptr-deref in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: null-ptr-deref in btf_get kernel/bpf/btf.c:1636 [inline]
BUG: KASAN: null-ptr-deref in btf_get_module_btf kernel/bpf/btf.c:6588 [inline]
BUG: KASAN: null-ptr-deref in register_btf_kfunc_id_set+0x99/0x8b0 kernel/bpf/btf.c:6812
Write of size 4 at addr 0000000000000054 by task swapper/0/1

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc6-syzkaller-02045-ga8fee96202e2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:446 [inline]
 kasan_report.cold+0x66/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 btf_get kernel/bpf/btf.c:1636 [inline]
 btf_get_module_btf kernel/bpf/btf.c:6588 [inline]
 register_btf_kfunc_id_set+0x99/0x8b0 kernel/bpf/btf.c:6812
 bbr_register+0x18/0x48 net/ipv4/tcp_bbr.c:1183
 do_one_initcall+0x103/0x650 init/main.c:1302
 do_initcall_level init/main.c:1375 [inline]
 do_initcalls init/main.c:1391 [inline]
 do_basic_setup init/main.c:1410 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1615
 kernel_init+0x1a/0x1d0 init/main.c:1504
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G    B             5.17.0-rc6-syzkaller-02045-ga8fee96202e2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 panic+0x2b0/0x6dd kernel/panic.c:233
 end_report.cold+0x63/0x6f mm/kasan/report.c:128
 __kasan_report mm/kasan/report.c:449 [inline]
 kasan_report.cold+0x71/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 btf_get kernel/bpf/btf.c:1636 [inline]
 btf_get_module_btf kernel/bpf/btf.c:6588 [inline]
 register_btf_kfunc_id_set+0x99/0x8b0 kernel/bpf/btf.c:6812
 bbr_register+0x18/0x48 net/ipv4/tcp_bbr.c:1183
 do_one_initcall+0x103/0x650 init/main.c:1302
 do_initcall_level init/main.c:1375 [inline]
 do_initcalls init/main.c:1391 [inline]
 do_basic_setup init/main.c:1410 [inline]
 kernel_init_freeable+0x6b1/0x73a init/main.c:1615
 kernel_init+0x1a/0x1d0 init/main.c:1504
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
