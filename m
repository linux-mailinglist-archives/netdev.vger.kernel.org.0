Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699FD4352CA
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhJTSlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhJTSlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:41:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F224CC06174E
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 11:39:36 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id i20so28750779edj.10
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 11:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=IOnuBNH10izCy7bvEjOZ+zy8jkLs6gqN7bvf8hCT9qk=;
        b=Lw5N3LhxQcN/IteqznskbBJ67qhEtso9Ea1Nc62KAHv2dCwUf8TMgs9dSd0a+veyei
         i9ocmgm1MzaSzJLg3b0k+jM2AwdZoyiGR+q8oyz4clrWeT2iUeYTA652TVGScPq/zVnI
         F3gOA0f1xm98apkVCzFfg6Fp61+/v/HFNIijvpeLXllR/wlkS0ITf1EoYE70kqAZqjIk
         fXFMjf2cjCh9Pe5C+Tnsuk0wTCW1ZKjrC9WW5Nq2lI3OYNIhF1gBaOi/j2OH6/ApBOO/
         +pmYlqX8vZRGDFUSsjdc8sQghpzpvCrETt1IVBt9m3yBDpyLGO2HFUofak1NccdtyeW6
         0B/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=IOnuBNH10izCy7bvEjOZ+zy8jkLs6gqN7bvf8hCT9qk=;
        b=ykyeSAp0SvuJJBZDVzoPtdQ3VTmePyyaOY6YdH3zTyLZrZIHJhiUiBqcqMPaSntmk6
         qho7/bcg680Wub/Jdwhxgx2YqZFNDJ9k9jIkPNV4ejF8tMDh32DbFBnEu/jkgvVwYKVW
         O3FilbPCMN9gmsmFjYa6XLon2EXggdUijL85SgAH1hkQgZzY2i+3E0mvdqznQaWo3zxn
         RmKDVHU0DSGT86+abDFTq5k3+YEzuoLzd/ERw5ROIrs6GjRgABvyf104s233486Uzfio
         j1EZl7O8oJcNlVXC0vdwPk0F40BUEPoCo590t5X3z+T3z410YcR25iqfNriltBUHXW13
         mCVw==
X-Gm-Message-State: AOAM530qnE24mp/1FpTp2rhbjIZEz6gqUuVob95ld9yH4Tg8KflpehWy
        kwhu5mNSG4hkpnXavhwtaw2lmo/txE0BXZcRc6PCVl39wS0=
X-Google-Smtp-Source: ABdhPJz0BNKf5f7ihREF52JOz13SD8v+jz7TKix4ZVZJxdSzI9keWX2gJVGK9k2Er+/7aPop3kPBKgHe76FCOGw34NA=
X-Received: by 2002:a17:907:3e08:: with SMTP id hp8mr1169133ejc.493.1634755173829;
 Wed, 20 Oct 2021 11:39:33 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 21 Oct 2021 00:09:22 +0530
Message-ID: <CA+G9fYu8oby3LZ732W5xR0VS0WZ8D1XFWOuP-Tu7wogULcuNCA@mail.gmail.com>
Subject: [Next] WARNING: CPU: 1 PID: 219 at include/linux/seqlock.h:271 gnet_stats_add_basic+0x2e0/0x548
To:     Netdev <netdev@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel crash noticed on linux next 20211020 tag.
while booting on qemu_arm devices.

Crash log,
         Starting Entropy Daemon based on the HAVEGE algorithm...
[   15.611450] ------------[ cut here ]------------
[   15.614631] WARNING: CPU: 1 PID: 219 at include/linux/seqlock.h:271
gnet_stats_add_basic+0x2e0/0x548
[   15.619863] Modules linked in: fuse
[   15.621820] CPU: 1 PID: 219 Comm: NetworkManager Not tainted
5.15.0-rc6-next-20211020 #1
[   15.629011] Hardware name: Generic DT based system
[   15.632132] Backtrace:
[   15.633763] [<c159a598>] (dump_backtrace) from [<c159a7b0>]
(show_stack+0x20/0x24)
[   15.640696]  r7:00000009 r6:00000000 r5:c1c896e0 r4:60000013
[   15.644135] [<c159a790>] (show_stack) from [<c15a41bc>]
(dump_stack_lvl+0x60/0x78)
[   15.649336] [<c15a415c>] (dump_stack_lvl) from [<c15a41ec>]
(dump_stack+0x18/0x1c)
[   15.656049]  r7:00000009 r6:0000010f r5:c12ea968 r4:c1c796b4
[   15.659501] [<c15a41d4>] (dump_stack) from [<c0356838>] (__warn+0xe0/0x144)
[   15.665905] [<c0356758>] (__warn) from [<c159b7d0>]
(warn_slowpath_fmt+0x84/0xb8)
[   15.670799]  r8:00000009 r7:c12ea968 r6:0000010f r5:c1c796b4 r4:00000000
[   15.674824] [<c159b750>] (warn_slowpath_fmt) from [<c12ea968>]
(gnet_stats_add_basic+0x2e0/0x548)
[   15.682438]  r9:00000000 r8:c12eb178 r7:00000000 r6:c53b99d0
r5:c3365ea0 r4:00000000
[   15.687144] [<c12ea688>] (gnet_stats_add_basic) from [<c12eb178>]
(___gnet_stats_copy_basic+0x94/0x18c)
[   15.695278]  r10:00000001 r9:c4d4d780 r8:c3365ea0 r7:00000000
r6:00000000 r5:c53b9a68
[   15.700138]  r4:c53b99d0
[   15.701596] [<c12eb0e4>] (___gnet_stats_copy_basic) from
[<c12eb298>] (gnet_stats_copy_basic+0x28/0x30)
[   15.709271]  r10:00000000 r9:c5220cc0 r8:00000000 r7:c5408000
r6:00000000 r5:c5220cc0
[   15.716754]  r4:c3365e00
[   15.718375] [<c12eb270>] (gnet_stats_copy_basic) from [<c137e5b0>]
(tc_fill_qdisc+0x29c/0x45c)
[   15.723901] [<c137e314>] (tc_fill_qdisc) from [<c137e808>]
(tc_dump_qdisc_root+0x98/0x1bc)
[   15.728747]  r10:00000000 r9:c5220cc0 r8:c5053bb8 r7:00000000
r6:00000000 r5:00000000
[   15.736183]  r4:00000001
[   15.738107] [<c137e770>] (tc_dump_qdisc_root) from [<c137f2ac>]
(tc_dump_qdisc+0x174/0x25c)
[   15.745388]  r10:00000001 r9:c234bb40 r8:c5220cc0 r7:00000000
r6:c5053bb8 r5:00000000
[   15.749667]  r4:c33f0000
[   15.751277] [<c137f138>] (tc_dump_qdisc) from [<c1396460>]
(netlink_dump+0x154/0x364)
[   15.758400]  r10:00000000 r9:00007f00 r8:c5053bb8 r7:c4d4d780
r6:00007f00 r5:c5220cc0
[   15.762750]  r4:c5053800
[   15.764050] [<c139630c>] (netlink_dump) from [<c1396fa4>]
(__netlink_dump_start+0x174/0x224)
[   15.771348]  r10:00000000 r9:c5053bb8 r8:00000000 r7:c53b9c7c
r6:c5220d80 r5:c5205000
[   15.776145]  r4:c5053800
[   15.777715] [<c1396e30>] (__netlink_dump_start) from [<c131d180>]
(rtnetlink_rcv_msg+0x2f4/0x540)
[   15.785106]  r9:00000000 r8:c137f138 r7:c5220d80 r6:c4d4d780
r5:00000000 r4:c5205000
[   15.791886] [<c131ce8c>] (rtnetlink_rcv_msg) from [<c1399600>]
(netlink_rcv_skb+0xc4/0x11c)
[   15.796838]  r10:c4d4d780 r9:c5053a44 r8:00000024 r7:c5205000
r6:c4d4d780 r5:c131ce8c
[   15.801860]  r4:c5220d80
[   15.803413] [<c139953c>] (netlink_rcv_skb) from [<c1317b2c>]
(rtnetlink_rcv+0x20/0x24)
[   15.810282]  r8:00000000 r7:c5220d80 r6:c5053800 r5:00000024 r4:c304f800
[   15.816716] [<c1317b0c>] (rtnetlink_rcv) from [<c1398c98>]
(netlink_unicast+0x1a0/0x264)
[   15.822014] [<c1398af8>] (netlink_unicast) from [<c1398f68>]
(netlink_sendmsg+0x20c/0x460)
[   15.827255]  r10:c5053800 r9:00000000 r8:00000000 r7:c5220d80
r6:c4d4d780 r5:c53b9f48
[   15.834244]  r4:00000024
[   15.835804] [<c1398d5c>] (netlink_sendmsg) from [<c12d0318>]
(____sys_sendmsg+0x1e0/0x290)
[   15.843564]  r10:c4d4d780 r9:c53b9dcc r8:00000000 r7:00000000
r6:c46adc00 r5:c1398d5c
[   15.848266]  r4:c53b9f48
[   15.849821] [<c12d0138>] (____sys_sendmsg) from [<c12d233c>]
(___sys_sendmsg+0xb0/0xdc)
[   15.857074]  r10:00000128 r9:00000000 r8:c4d4d780 r7:00000000
r6:c46adc00 r5:c53b9f48
[   15.862000]  r4:00000000
[   15.863630] [<c12d228c>] (___sys_sendmsg) from [<c12d2514>]
(sys_sendmsg+0x5c/0x98)
[   15.869879]  r9:c4d4d780 r8:c03002a4 r7:befe879c r6:c4d4d780
r5:c46adc00 r4:00000000
[   15.874816] [<c12d24b8>] (sys_sendmsg) from [<c03000c0>]
(ret_fast_syscall+0x0/0x1c)
[   15.881956] Exception stack(0xc53b9fa8 to 0xc53b9ff0)
[   15.884954] 9fa0:                   00000000 befe879c 00000007
befe879c 00000000 00000000
[   15.891833] 9fc0: 00000000 befe879c 00000007 00000128 b6a62000
00000001 00000005 0027fe18
[   15.897081] 9fe0: 00000000 befe8740 00000000 b6d71ec0
[   15.900493]  r7:00000128 r6:00000007 r5:befe879c r4:00000000
[   15.906386] irq event stamp: 36305
[   15.907882] hardirqs last  enabled at (36313): [<c03e31c8>]
__up_console_sem+0x60/0x70
[   15.911674] hardirqs last disabled at (36320): [<c03e31b4>]
__up_console_sem+0x4c/0x70
[   15.918671] softirqs last  enabled at (36304): [<c0301fec>]
__do_softirq+0x32c/0x560
[   15.922707] softirqs last disabled at (36261): [<c0360034>]
__irq_exit_rcu+0x154/0x178
[   15.922869] ---[ end trace 3190ec354e2b2e34 ]---

Full log,
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20211020/testrun/6177894/suite/linux-log-parser/test/check-kernel-warning-3786488/log
https://lkft.validation.linaro.org/scheduler/job/3786488#L775

Build config:
https://builds.tuxbuild.com/1zlLmMyDukg9DNVY8NUNkQ1d2ff/config

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


steps to reproduce:
1) https://builds.tuxbuild.com/1zlLmMyDukg9DNVY8NUNkQ1d2ff/tuxmake_reproducer.sh
2) boot qemu_arm with OE rootfs as showing in below command line.
/usr/bin/qemu-system-aarch64 -cpu host,aarch64=off -machine
virt-2.10,accel=kvm -nographic -net
nic,model=virtio,macaddr=BA:DD:AD:CC:09:02 -net tap -m 2048 -monitor
none -kernel kernel/zImage --append "console=ttyAMA0 root=/dev/vda rw"
-hda rootfs/rpb-console-image-lkft-am57xx-evm-20211006160523.rootfs.ext4
-m 4096 -smp 2 -nographic

--
Linaro LKFT
https://lkft.linaro.org
