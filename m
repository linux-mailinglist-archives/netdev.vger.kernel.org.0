Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE20605805
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJTHNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbiJTHND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:13:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD715ECCF
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:13:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z97so28529827ede.8
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cQF7shMOaRQonYJ106IZz0MxpfPL6PYZUfZ7s13dUNM=;
        b=Q8UNf33MkmgmFSwS+b25nZWJFd5urYJLAu7fYb2z7XEwGMRj4MP1K+3ouAhJzYk2gP
         6GECstiUK47x4Ix8ojBK5LnX6TabhJSJu0R/X4IT1K+tt3Cqna/rynLhB8Q4b1F4QRZO
         T4Fv/XS0o+s8Rvll4vVJKboxqbONnYYBOcNm10PRmlrqPKIT9hMZp+74L5ozLujwswBt
         Hi0jTuSVFRyAqbbI16YqhtwPsujN8uFKGYOaNhYhLltZoUMmzyHXu2vVbWUypdW9ODPC
         L7XN4NWuDLEHM/pG9MErMLPGFTZa434ES8AcXtyGX+oc3YaVqPlAuOEG+fHixYL6Wcaj
         sqYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cQF7shMOaRQonYJ106IZz0MxpfPL6PYZUfZ7s13dUNM=;
        b=eRL2FLxdZJZyfHzST6u/ECXR7tKc6WnZyNxqfS3ibYZq0DWL9julxK6DRngmWu3mma
         3fzkrFLduvK2c2drdBcGHTUpBfu7tRMmTfpWSw74CTk/1+mm5EK+SjZu9ZQy7QxWlbwn
         LM3Oa+053VH8g2afWsAdP00UdmGsPj3pnz0GLkDitAzuJxL+U1v/QbMHrGQuZSYmk/oD
         k7ePgkYcBDDK1LwgSj++fS4kONwOsq1CMbgdkkqrFNC/Hv7OCUVlpd63LA7HUiwq1Dce
         9VE59wU831EOvrV6p+nmnnI3Bva7faa6xbYzmXazCMmelupxTs03cRxDASq/nSGr+EeQ
         4O6Q==
X-Gm-Message-State: ACrzQf05M8YCqDgAzPx2RnhbdrJO6pA4dyic7lsIoVFYY8CZh/oRYYfk
        eHR0HAzFaZnwH07wcwdoRW1hEXiY97FIhW/laotyLg==
X-Google-Smtp-Source: AMsMyM7c9FOSk1QyeJUBJzvCUD7Wed9fZE6Pkw5IV8sm17wKgYsNfU2Xwsmc9RimidJvhHlwdrKWg6dygD96vvXOoAU=
X-Received: by 2002:a05:6402:190f:b0:45d:2c25:3a1d with SMTP id
 e15-20020a056402190f00b0045d2c253a1dmr11216272edz.175.1666249978265; Thu, 20
 Oct 2022 00:12:58 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 20 Oct 2022 12:42:46 +0530
Message-ID: <CA+G9fYvepPVpDn5AP6bwDukpx7h++avMPEUARuHyvJqWwQ84uQ@mail.gmail.com>
Subject: selftests: net: pmtu.sh: Unable to handle kernel paging request at
 virtual address 2c86c000
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following kernel crash reported while running selftests: net: pmtu.sh
on x15 device with kselftests merge configs enabled.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

# selftests: net: pmtu.sh
...
# TEST: IPv4 over vxlan6: PMTU exceptions                             [ OK ]
[  169.299682] 8<--- cut here ---
[  169.302764] Unable to handle kernel paging request at virtual
address 2c86c000
[  169.310089] [2c86c000] *pgd=00000000
[  169.313720] Internal error: Oops: 5 [#1] SMP ARM
[  169.318359] Modules linked in: act_csum act_pedit cls_flower
sch_prio ip_tables x_tables veth tun cfg80211 bluetooth
snd_soc_simple_card snd_soc_simple_card_utils etnaviv gpu_sched
onboard_usb_hub snd_soc_davinci_mcasp snd_soc_ti_udma snd_soc_ti_edma
snd_soc_ti_sdma snd_soc_core ac97_bus snd_pcm_dmaengine snd_pcm
snd_timer snd soundcore display_connector fuse [last unloaded:
test_blackhole_dev]
[  169.353576] CPU: 0 PID: 295 Comm: rngd Not tainted 6.0.3-rc1 #1
[  169.359527] Hardware name: Generic DRA74X (Flattened Device Tree)
[  169.365631] PC is at percpu_counter_add_batch+0x28/0xc4
[  169.370910] LR is at 0x0
[  169.373443] pc : [<c0989aa8>]    lr : [<00000000>]    psr: 600d0113
[  169.379730] sp : f0001ed8  ip : 00000020  fp : f0001f50
[  169.385009] r10: c23aef04  r9 : c231efd0  r8 : c25da080
[  169.390258] r7 : c84adb80  r6 : 00000001  r5 : c9a99440  r4 : 2c86c000
[  169.396820] r3 : ffffffff  r2 : ffffffff  r1 : 00000000  r0 : c9a99440
[  169.403381] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[  169.410552] Control: 10c5387d  Table: 891f006a  DAC: 00000051
[  169.416320] Register r0 information: slab net_namespace start
c9a98ec0 data offset 64 pointer offset 1344 allocated at
copy_net_ns+0x78/0x27c
[  169.429107]     kmem_cache_alloc+0x328/0x43c
[  169.433380]     copy_net_ns+0x78/0x27c
[  169.437164]     create_new_namespaces+0x10c/0x2a4
[  169.441894]     unshare_nsproxy_namespaces+0x70/0x8c
[  169.446868]     ksys_unshare+0x16c/0x32c
[  169.450836]     ret_fast_syscall+0x0/0x1c
[  169.454864]  Free path:
[  169.457305]     cleanup_net+0x2e0/0x3c4
[  169.461151]     process_one_work+0x26c/0x708
[  169.465454]     worker_thread+0x60/0x4e8
[  169.469421]     kthread+0xfc/0x11c
[  169.472839]     ret_from_fork+0x14/0x2c
[  169.476684] Register r1 information: NULL pointer
[  169.481414] Register r2 information: non-paged memory
[  169.486480] Register r3 information: non-paged memory
[  169.491577] Register r4 information: non-paged memory
[  169.496643] Register r5 information: slab net_namespace start
c9a98ec0 data offset 64 pointer offset 1344 allocated at
copy_net_ns+0x78/0x27c
[  169.509460]     kmem_cache_alloc+0x328/0x43c
[  169.513763]     copy_net_ns+0x78/0x27c
[  169.517517]     create_new_namespaces+0x10c/0x2a4
[  169.522247]     unshare_nsproxy_namespaces+0x70/0x8c
[  169.527221]     ksys_unshare+0x16c/0x32c
[  169.531188]     ret_fast_syscall+0x0/0x1c
[  169.535217]  Free path:
[  169.537658]     cleanup_net+0x2e0/0x3c4
[  169.541503]     process_one_work+0x26c/0x708
[  169.545806]     worker_thread+0x60/0x4e8
[  169.549743]     kthread+0xfc/0x11c
[  169.553161]     ret_from_fork+0x14/0x2c
[  169.557037] Register r6 information: non-paged memory
[  169.562103] Register r7 information: slab task_struct start
c84adb40 data offset 64 pointer offset 0 allocated at
copy_process+0x1a4/0x1950
[  169.574707]     kmem_cache_alloc+0x328/0x43c
[  169.579010]     copy_process+0x1a4/0x1950
[  169.583038]     kernel_clone+0x5c/0x418
[  169.586883]     sys_clone+0x74/0x90
[  169.590393]     __sys_trace_return+0x0/0x10
[  169.594604]  Free path:
[  169.597076]     rcu_core+0x3c8/0x1140
[  169.600738]     __do_softirq+0x130/0x538
[  169.604675] Register r8 information: non-slab/vmalloc memory
[  169.610382] Register r9 information: non-slab/vmalloc memory
[  169.616058] Register r10 information: non-slab/vmalloc memory
[  169.621856] Register r11 information: 2-page vmalloc region
starting at 0xf0000000 allocated at start_kernel+0x578/0x764
[  169.632781] Register r12 information: non-paged memory
[  169.637939] Process rngd (pid: 295, stack limit = 0xf0188000)
[  169.643707] Stack: (0xf0001ed8 to 0xf0002000)
[  169.648101] 1ec0:
    c9b33540 00000000
[  169.656311] 1ee0: 00000001 00000000 c25da080 c231efd0 c23aef04
c1325f00 00000020 c25da080
[  169.664550] 1f00: c231efd0 c84adb80 c9b33570 c0402628 00000000
00000000 c04025c4 00000000
[  169.672760] 1f20: 00000000 0000000a 00000000 c23b0940 c25d9e80
eeb0ff14 c229a5d8 c229a5d8
[  169.680969] 1f40: c229a484 c229a484 eeb0fec0 00000001 00000000
f0001f50 00000000 e2868d57
[  169.689178] 1f60: 00000002 c23030a4 00000008 00000009 c25d97e0
c231efd0 00000100 c84adb80
[  169.697418] 1f80: 00000080 c0301e10 c3212340 c1770a48 00000015
c2303080 c229a518 0000000a
[  169.705627] 1fa0: c22a3100 c25d79bc c22a3100 ffffccf2 c2305d40
c1de927c c1dfc684 f0001fd0
[  169.713836] 1fc0: 00400040 00000001 c231fbb0 c84adb80 000d0030
ffffffff c84adb80 c229a044
[  169.722076] 1fe0: 00000000 b633f000 f0189fa8 c0359ca4 b6ec2cce
c0359e00 b6ec2cce c099b6bc
[  169.730285]  percpu_counter_add_batch from dst_destroy+0x11c/0x130
[  169.736511]  dst_destroy from rcu_core+0x3c8/0x1140
[  169.741394]  rcu_core from __do_softirq+0x130/0x538
[  169.746307]  __do_softirq from __irq_exit_rcu+0x14c/0x170
[  169.751739]  __irq_exit_rcu from irq_exit+0x10/0x30
[  169.756622]  irq_exit from call_with_stack+0x18/0x20
[  169.761627]  call_with_stack from __irq_usr+0x7c/0xa0
[  169.766693] Exception stack(0xf0189fb0 to 0xf0189ff8)
[  169.771789] 9fa0:                                     6fce9940
1b458cad 0000003d b6b3e970
[  169.779998] 9fc0: b6b3ea20 00028789 0001629c b6b3e8d8 000172a0
00000000 b633f000 b6b3f3a0
[  169.788208] 9fe0: 00000000 b6b3e8d8 b6ec3835 b6ec2cce 000d0030 ffffffff
[  169.794860] Code: e5871004 ee1d4f90 e5901038 e1a0efcc (e7946001)

Broadcast message from systemd-journald@am57xx-evm (Thu 2022[
169.801116] ---[ end trace 0000000000000000 ]---
-04-28 17:45:03 UTC):
kernel[290]: [  169.313720] Internal [  169.811279] Kernel panic - not
syncing: Fatal exception in interrupt
[  169.823211] CPU1: stopping
[  169.825927] CPU: 1 PID: 308 Comm: rngd Tainted: G      D
6.0.3-rc1 #1
[  169.833343] Hardware name: Generic DRA74X (Flattened Device Tree)
[  169.839477]  unwind_backtrace from show_stack+0x18/0x1c
[  169.844757]  show_stack from dump_stack_lvl+0x58/0x70
[  169.849822]  dump_stack_lvl from do_handle_IPI+0x308/0x334
[  169.855346]  do_handle_IPI from ipi_handler+0x20/0x28
[  169.860412]  ipi_handler from handle_percpu_devid_irq+0xcc/0x320
[  169.866485]  handle_percpu_devid_irq from generic_handle_domain_irq+0x30/0x40
[  169.873657]  generic_handle_domain_irq from gic_handle_irq+0x90/0xb0
[  169.880035]  gic_handle_irq from generic_handle_arch_irq+0x34/0x44
[  169.886260]  generic_handle_arch_irq from call_with_stack+0x18/0x20
[  169.892547]  call_with_stack from __irq_svc+0x9c/0xb8
[  169.897644] Exception stack(0xf0181ee0 to 0xf0181f28)
[  169.902709] 1ee0: 005807d2 00000000 77359400 00000010 00008272
c23b3300 f0181f80 c23b33c4
[  169.910919] 1f00: c0427c70 c23b3400 c23b3450 00001c49 0058075e
f0181f30 f6df0000 c0420798
[  169.919158] 1f20: 600f0013 ffffffff
[  169.922637]  __irq_svc from ktime_get_real_ts64+0x110/0x22c
[  169.928253]  ktime_get_real_ts64 from posix_get_realtime_timespec+0x14/0x1c
[  169.935272]  posix_get_realtime_timespec from sys_clock_gettime+0x64/0xc8
[  169.942077]  sys_clock_gettime from __sys_trace_return+0x0/0x10
[  169.948028] Exception stack(0xf0181fa8 to 0xf0181ff0)
[  169.953124] 1fa0:                   00000000 b61fea18 00000000
b61fea18 00000000 00000000
[  169.961334] 1fc0: 00000000 b61fea18 b61feacc 00000193 000172a0
00000000 b59ff000 bee7f000
[  169.969543] 1fe0: bee7f020 b61fe9c0 bee8055c bee806b8
[  169.974639] ---[ end Kernel panic - not syncing: Fatal exception in
interrupt ]---
error: Oops: 5 [#1] SMP ARM

Full test log:
https://lkft.validation.linaro.org/scheduler/job/5708561#L5793

metadata:
  git_ref: linux-6.0.y
  git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git_sha: 84429734035197a6ab8e79c852d5e4e6ed744703
  git_describe: v6.0-916-g844297340351
  kernel_version: 6.0.3-rc1
  kernel-config: https://builds.tuxbuild.com/2GMZBBq4CuTDk9rrHpkrP7lPMTT/config
  build-url: https://gitlab.com/mrchapp/linux/-/pipelines/671394419
  artifact-location: https://builds.tuxbuild.com/2GMZBBq4CuTDk9rrHpkrP7lPMTT
  toolchain: gcc-10
  vmlinux.xz: https://builds.tuxbuild.com/2GMZBBq4CuTDk9rrHpkrP7lPMTT/vmlinux.xz
  System.map: https://builds.tuxbuild.com/2GMZBBq4CuTDk9rrHpkrP7lPMTT/System.map


--
Linaro LKFT
https://lkft.linaro.org
