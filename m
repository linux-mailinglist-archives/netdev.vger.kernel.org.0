Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B278B377C1D
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 08:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhEJGQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 02:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhEJGQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 02:16:36 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C76C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 23:15:32 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i13so13014623pfu.2
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 23:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KVH1rH+yQDHG+6fdOf2loeC/MFs2dsBS09Ew5gso7+U=;
        b=u7tieQ4RXyTZrTI6+c/rNDZdRUxA1liJFXaJvzWU32PJ4D/Z9pNkmxeUvzJACW5A+Q
         4bY+S+hL1/Cx4Z6h404/V/q+DKF0FBlNcEzFtyC4pAhA7OGn4/EC3po4yJHyGtjiWLJQ
         R3X8M9vqQJmALedWx/EDxA6+MRWJ4j37EaF2DydIMm51ZiF9cwvWl4xW0H4aYO8fn3rk
         qc+4LEro8CBZm1+fNhl6ek5oGMq14YfTIvAPKkNQ9qyTwIP1oYoB3OmrP7e6JZXnwlhj
         ebRmIRBcxSXYtjqN3RLW99MecUYQp2MfkepEqYr+Lm/Inob6kG6qUcTsvliMr7Sc2wY8
         cRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KVH1rH+yQDHG+6fdOf2loeC/MFs2dsBS09Ew5gso7+U=;
        b=Mccdut7+wdlQWYDCpM1U4TJ8V69mfTeW7VWFMsEpoLN1YeAsfrZBWgCLsEKJV4mm0S
         iXviLiiFEiFO1526RmkBKNltieqL8x31VF93OGS/gS4f7kuMt4IYb/VcWopN8hAc6FCi
         PYYu4Htlc3G8rsbG0fGF/8/IhTEWUIAhJWb9aCnLiErOwf6DvVv1LN9zmqPtGjmI9nHw
         9NMpTNUiT67SxsR2vxDPCK7zHOtSBrN6aAwrz+YZw/XKtkPwOYS2nOLRJO6VwfR337yK
         Dr4G+wmY+8hWD4UUw8OyocJkobYwteLqG5SpJLCkwvj2L8QqUrqj9tdj1TNOJigi1gPv
         kt2g==
X-Gm-Message-State: AOAM531Kq5imfZm99gRKS+yEKcnm4mLt/87WOHB/gx8Dxte7UdR4odQQ
        ZJ7F0KWJDVplJ72O0wljzaHFs502M15Pr1sTXaw=
X-Google-Smtp-Source: ABdhPJzgMcKPoTJEPq87VFcVRJeH4ieBa0x8eUnUUb83dnKRYHGYomePSaF3XEOl22Ru6CCJiwYi0SQlNOGCOkL7HQM=
X-Received: by 2002:aa7:9313:0:b029:2c5:7e1c:2c77 with SMTP id
 19-20020aa793130000b02902c57e1c2c77mr288554pfj.73.1620627331816; Sun, 09 May
 2021 23:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <52fdf0e0d9d453379df2163f16bdf12f425ef456.camel@coverfire.com>
In-Reply-To: <52fdf0e0d9d453379df2163f16bdf12f425ef456.camel@coverfire.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 10 May 2021 08:15:21 +0200
Message-ID: <CAJ8uoz1qKnJw+StSfuCkXuoS5-qOQA89HKjLzedh7LySBDUp1g@mail.gmail.com>
Subject: Re: xsk_buff_pool.c trace
To:     Dan Siemon <dan@coverfire.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 3:59 AM Dan Siemon <dan@coverfire.com> wrote:
>
> i40e NIC with 5.11.17-300.fc34.x86_64
>
> Unfortunately, this does not consistently occur.
>
> [ 2739.991807] ------------[ cut here ]------------
> [ 2739.996428] Failed to disable zero-copy!

Could you please dump the error value that i40e_xsk_pool_disable
returns? Just so I have something more to go on. There are three
functions that can fail, xsk_get_pool_from_qid(),
i40e_queue_pair_disable(), and i40e_queue_pair_enable(). If you can
dig even deeper into what sub function of those functions that fail,
even better. It would be ideal, if you could enable a function trace
when you get into i40e_xsk_pool_disable so we would know exactly what
function fails.

> [ 2740.000378] WARNING: CPU: 0 PID: 302 at net/xdp/xsk_buff_pool.c:118
> xp_disable_drv_zc+0x69/0xa0
> [ 2740.009075] Modules linked in: rfkill vfat fat rpcrdma sunrpc
> rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
> libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm intel_rapl_msr
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support intel_rapl_common
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass i40iw rapl
> intel_cstate ib_uverbs intel_uncore ipmi_ssif ib_core pcspkr i2c_i801
> lpc_ich i2c_smbus joydev mei_me mei acpi_ipmi ioatdma ipmi_si
> ipmi_devintf ipmi_msghandler fuse zram ip_tables xfs ast
> drm_vram_helper drm_kms_helper crct10dif_pclmul crc32_pclmul qat_c62x
> cec drm_ttm_helper crc32c_intel intel_qat ttm ghash_clmulni_intel i40e
> drm igb authenc dca i2c_algo_bit wmi uas usb_storage i2c_dev
> [ 2740.075995] CPU: 0 PID: 302 Comm: kworker/0:2 Not tainted 5.11.17-
> 300.fc34.x86_64 #1
> [ 2740.083734] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./To be filled by O.E.M., BIOS 5.14 04/18/2019
> [ 2740.094334] Workqueue: events xp_release_deferred
> [ 2740.099039] RIP: 0010:xp_disable_drv_zc+0x69/0xa0
> [ 2740.103744] Code: 10 48 8b 87 f0 01 00 00 48 8b 80 50 02 00 00 e8 cd
> 26 2b 00 85 c0 75 06 48 83 c4 20 5b c3 48 c7 c7 70 10 49 95 e8 36 db 01
> 00 <0f> 0b 48 83 c4 20 5b c3 80 3d 29 eb 1b 01 00 75 9c ba 6c 00 00 00
> [ 2740.122494] RSP: 0018:ffffa93580c9be48 EFLAGS: 00010296
> [ 2740.127717] RAX: 000000000000001c RBX: ffffa9358f309000 RCX:
> 0000000000000000
> [ 2740.134851] RDX: ffff8be5e0626ba0 RSI: ffff8be5e0618ac0 RDI:
> ffff8be5e0618ac0
> [ 2740.141985] RBP: ffffa9358f309000 R08: 0000000000000000 R09:
> ffffa93580c9bc78
> [ 2740.149117] R10: ffffa93580c9bc70 R11: ffff8be63ff3c228 R12:
> ffff8be5e0629980
> [ 2740.156251] R13: ffff8be5e062f700 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2740.163382] FS:  0000000000000000(0000) GS:ffff8be5e0600000(0000)
> knlGS:0000000000000000
> [ 2740.171468] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2740.177217] CR2: 00007f42c932d224 CR3: 0000000409a10003 CR4:
> 00000000007706f0
> [ 2740.184349] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2740.191481] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2740.198617] PKRU: 55555554
> [ 2740.201328] Call Trace:
> [ 2740.203786]  ? mutex_lock+0xe/0x30
> [ 2740.207198]  xp_release_deferred+0x22/0xa0
> [ 2740.211296]  process_one_work+0x1ec/0x380
> [ 2740.215309]  worker_thread+0x53/0x3e0
> [ 2740.218975]  ? process_one_work+0x380/0x380
> [ 2740.223161]  kthread+0x11b/0x140
> [ 2740.226392]  ? kthread_associate_blkcg+0xa0/0xa0
> [ 2740.231015]  ret_from_fork+0x1f/0x30
> [ 2740.234604] ---[ end trace cbb7bcf4ac8a3b92 ]---
> [ 2740.336808] ------------[ cut here ]------------
> [ 2740.341429] Failed to disable zero-copy!
> [ 2740.345384] WARNING: CPU: 3 PID: 316 at net/xdp/xsk_buff_pool.c:118
> xp_disable_drv_zc+0x69/0xa0
> [ 2740.354086] Modules linked in: rfkill vfat fat rpcrdma sunrpc
> rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
> libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm intel_rapl_msr
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support intel_rapl_common
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass i40iw rapl
> intel_cstate ib_uverbs intel_uncore ipmi_ssif ib_core pcspkr i2c_i801
> lpc_ich i2c_smbus joydev mei_me mei acpi_ipmi ioatdma ipmi_si
> ipmi_devintf ipmi_msghandler fuse zram ip_tables xfs ast
> drm_vram_helper drm_kms_helper crct10dif_pclmul crc32_pclmul qat_c62x
> cec drm_ttm_helper crc32c_intel intel_qat ttm ghash_clmulni_intel i40e
> drm igb authenc dca i2c_algo_bit wmi uas usb_storage i2c_dev
> [ 2740.420997] CPU: 3 PID: 316 Comm: kworker/3:1 Tainted: G        W
> 5.11.17-300.fc34.x86_64 #1
> [ 2740.430133] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./To be filled by O.E.M., BIOS 5.14 04/18/2019
> [ 2740.440730] Workqueue: events xp_release_deferred
> [ 2740.445447] RIP: 0010:xp_disable_drv_zc+0x69/0xa0
> [ 2740.450150] Code: 10 48 8b 87 f0 01 00 00 48 8b 80 50 02 00 00 e8 cd
> 26 2b 00 85 c0 75 06 48 83 c4 20 5b c3 48 c7 c7 70 10 49 95 e8 36 db 01
> 00 <0f> 0b 48 83 c4 20 5b c3 80 3d 29 eb 1b 01 00 75 9c ba 6c 00 00 00
> [ 2740.468900] RSP: 0018:ffffa93580d0be48 EFLAGS: 00010296
> [ 2740.474124] RAX: 000000000000001c RBX: ffffa93586ff2000 RCX:
> 0000000000000000
> [ 2740.481258] RDX: ffff8be5e06e6ba0 RSI: ffff8be5e06d8ac0 RDI:
> ffff8be5e06d8ac0
> [ 2740.488392] RBP: ffffa93586ff2000 R08: 0000000000000000 R09:
> ffffa93580d0bc78
> [ 2740.495523] R10: ffffa93580d0bc70 R11: ffff8be63ff3c228 R12:
> ffff8be5e06e9980
> [ 2740.502657] R13: ffff8be5e06ef700 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2740.509792] FS:  0000000000000000(0000) GS:ffff8be5e06c0000(0000)
> knlGS:0000000000000000
> [ 2740.517877] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2740.523622] CR2: 000056209994d798 CR3: 000000028ee14004 CR4:
> 00000000007706e0
> [ 2740.530757] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2740.537889] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2740.545022] PKRU: 55555554
> [ 2740.547736] Call Trace:
> [ 2740.550190]  xp_release_deferred+0x22/0xa0
> [ 2740.554298]  process_one_work+0x1ec/0x380
> [ 2740.558321]  worker_thread+0x53/0x3e0
> [ 2740.561993]  ? process_one_work+0x380/0x380
> [ 2740.566177]  kthread+0x11b/0x140
> [ 2740.569414]  ? kthread_associate_blkcg+0xa0/0xa0
> [ 2740.574031]  ret_from_fork+0x1f/0x30
> [ 2740.577623] ---[ end trace cbb7bcf4ac8a3b93 ]---
> [ 2740.679825] ------------[ cut here ]------------
> [ 2740.684440] Failed to disable zero-copy!
> [ 2740.688392] WARNING: CPU: 2 PID: 387 at net/xdp/xsk_buff_pool.c:118
> xp_disable_drv_zc+0x69/0xa0
> [ 2740.697087] Modules linked in: rfkill vfat fat rpcrdma sunrpc
> rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
> libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm intel_rapl_msr
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support intel_rapl_common
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass i40iw rapl
> intel_cstate ib_uverbs intel_uncore ipmi_ssif ib_core pcspkr i2c_i801
> lpc_ich i2c_smbus joydev mei_me mei acpi_ipmi ioatdma ipmi_si
> ipmi_devintf ipmi_msghandler fuse zram ip_tables xfs ast
> drm_vram_helper drm_kms_helper crct10dif_pclmul crc32_pclmul qat_c62x
> cec drm_ttm_helper crc32c_intel intel_qat ttm ghash_clmulni_intel i40e
> drm igb authenc dca i2c_algo_bit wmi uas usb_storage i2c_dev
> [ 2740.763999] CPU: 2 PID: 387 Comm: kworker/2:1 Tainted: G        W
> 5.11.17-300.fc34.x86_64 #1
> [ 2740.773123] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./To be filled by O.E.M., BIOS 5.14 04/18/2019
> [ 2740.783722] Workqueue: events xp_release_deferred
> [ 2740.788431] RIP: 0010:xp_disable_drv_zc+0x69/0xa0
> [ 2740.793135] Code: 10 48 8b 87 f0 01 00 00 48 8b 80 50 02 00 00 e8 cd
> 26 2b 00 85 c0 75 06 48 83 c4 20 5b c3 48 c7 c7 70 10 49 95 e8 36 db 01
> 00 <0f> 0b 48 83 c4 20 5b c3 80 3d 29 eb 1b 01 00 75 9c ba 6c 00 00 00
> [ 2740.811883] RSP: 0018:ffffa935843ebe48 EFLAGS: 00010296
> [ 2740.817110] RAX: 000000000000001c RBX: ffffa9358eb05000 RCX:
> 0000000000000000
> [ 2740.824242] RDX: ffff8be5e06a6ba0 RSI: ffff8be5e0698ac0 RDI:
> ffff8be5e0698ac0
> [ 2740.831375] RBP: ffffa9358eb05000 R08: 0000000000000000 R09:
> ffffa935843ebc78
> [ 2740.838509] R10: ffffa935843ebc70 R11: ffff8be63ff3c228 R12:
> ffff8be5e06a9980
> [ 2740.845643] R13: ffff8be5e06af700 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2740.852776] FS:  0000000000000000(0000) GS:ffff8be5e0680000(0000)
> knlGS:0000000000000000
> [ 2740.860861] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2740.866609] CR2: 00007f580c1a0ae0 CR3: 000000028ec8c002 CR4:
> 00000000007706e0
> [ 2740.873741] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2740.880875] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2740.888006] PKRU: 55555554
> [ 2740.890719] Call Trace:
> [ 2740.893173]  xp_release_deferred+0x22/0xa0
> [ 2740.897274]  process_one_work+0x1ec/0x380
> [ 2740.901294]  worker_thread+0x53/0x3e0
> [ 2740.904959]  ? process_one_work+0x380/0x380
> [ 2740.909144]  kthread+0x11b/0x140
> [ 2740.912378]  ? kthread_associate_blkcg+0xa0/0xa0
> [ 2740.916999]  ret_from_fork+0x1f/0x30
> [ 2740.920578] ---[ end trace cbb7bcf4ac8a3b94 ]---
> [ 2740.925513] i40e 0000:17:00.1: VSI seid 391 Rx ring 72 disable
> timeout
> [ 2740.945857] ------------[ cut here ]------------
> [ 2740.950479] Failed to disable zero-copy!
> [ 2740.954431] WARNING: CPU: 2 PID: 783 at net/xdp/xsk_buff_pool.c:118
> xp_disable_drv_zc+0x69/0xa0
> [ 2740.963126] Modules linked in: rfkill vfat fat rpcrdma sunrpc
> rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
> libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm intel_rapl_msr
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support intel_rapl_common
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass i40iw rapl
> intel_cstate ib_uverbs intel_uncore ipmi_ssif ib_core pcspkr i2c_i801
> lpc_ich i2c_smbus joydev mei_me mei acpi_ipmi ioatdma ipmi_si
> ipmi_devintf ipmi_msghandler fuse zram ip_tables xfs ast
> drm_vram_helper drm_kms_helper crct10dif_pclmul crc32_pclmul qat_c62x
> cec drm_ttm_helper crc32c_intel intel_qat ttm ghash_clmulni_intel i40e
> drm igb authenc dca i2c_algo_bit wmi uas usb_storage i2c_dev
> [ 2741.030038] CPU: 2 PID: 783 Comm: kworker/2:2 Tainted: G        W
> 5.11.17-300.fc34.x86_64 #1
> [ 2741.039170] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./To be filled by O.E.M., BIOS 5.14 04/18/2019
> [ 2741.049769] Workqueue: events xp_release_deferred
> [ 2741.054475] RIP: 0010:xp_disable_drv_zc+0x69/0xa0
> [ 2741.059181] Code: 10 48 8b 87 f0 01 00 00 48 8b 80 50 02 00 00 e8 cd
> 26 2b 00 85 c0 75 06 48 83 c4 20 5b c3 48 c7 c7 70 10 49 95 e8 36 db 01
> 00 <0f> 0b 48 83 c4 20 5b c3 80 3d 29 eb 1b 01 00 75 9c ba 6c 00 00 00
> [ 2741.077929] RSP: 0018:ffffa93580f37e48 EFLAGS: 00010296
> [ 2741.083156] RAX: 000000000000001c RBX: ffffa9358f70b000 RCX:
> 0000000000000000
> [ 2741.090287] RDX: ffff8be5e06a6ba0 RSI: ffff8be5e0698ac0 RDI:
> ffff8be5e0698ac0
> [ 2741.097424] RBP: ffffa9358f70b000 R08: 0000000000000000 R09:
> ffffa93580f37c78
> [ 2741.104555] R10: ffffa93580f37c70 R11: ffff8be63ff3c228 R12:
> ffff8be5e06a9980
> [ 2741.111687] R13: ffff8be5e06af700 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2741.118822] FS:  0000000000000000(0000) GS:ffff8be5e0680000(0000)
> knlGS:0000000000000000
> [ 2741.126909] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2741.132655] CR2: 00007f580c1a0ae0 CR3: 000000028ec8c002 CR4:
> 00000000007706e0
> [ 2741.139787] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2741.146921] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2741.154053] PKRU: 55555554
> [ 2741.156764] Call Trace:
> [ 2741.159219]  xp_release_deferred+0x22/0xa0
> [ 2741.163320]  process_one_work+0x1ec/0x380
> [ 2741.167330]  worker_thread+0x53/0x3e0
> [ 2741.170996]  ? process_one_work+0x380/0x380
> [ 2741.175184]  kthread+0x11b/0x140
> [ 2741.178415]  ? kthread_associate_blkcg+0xa0/0xa0
> [ 2741.183036]  ret_from_fork+0x1f/0x30
> [ 2741.186617] ---[ end trace cbb7bcf4ac8a3b95 ]---
> [ 2741.294857] ------------[ cut here ]------------
> [ 2741.299477] Failed to disable zero-copy!
> [ 2741.303428] WARNING: CPU: 2 PID: 5711 at net/xdp/xsk_buff_pool.c:118
> xp_disable_drv_zc+0x69/0xa0
> [ 2741.312210] Modules linked in: rfkill vfat fat rpcrdma sunrpc
> rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
> libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm intel_rapl_msr
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support intel_rapl_common
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass i40iw rapl
> intel_cstate ib_uverbs intel_uncore ipmi_ssif ib_core pcspkr i2c_i801
> lpc_ich i2c_smbus joydev mei_me mei acpi_ipmi ioatdma ipmi_si
> ipmi_devintf ipmi_msghandler fuse zram ip_tables xfs ast
> drm_vram_helper drm_kms_helper crct10dif_pclmul crc32_pclmul qat_c62x
> cec drm_ttm_helper crc32c_intel intel_qat ttm ghash_clmulni_intel i40e
> drm igb authenc dca i2c_algo_bit wmi uas usb_storage i2c_dev
> [ 2741.379125] CPU: 2 PID: 5711 Comm: kworker/2:0 Tainted: G        W
> 5.11.17-300.fc34.x86_64 #1
> [ 2741.388341] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./To be filled by O.E.M., BIOS 5.14 04/18/2019
> [ 2741.398943] Workqueue: events xp_release_deferred
> [ 2741.403649] RIP: 0010:xp_disable_drv_zc+0x69/0xa0
> [ 2741.408354] Code: 10 48 8b 87 f0 01 00 00 48 8b 80 50 02 00 00 e8 cd
> 26 2b 00 85 c0 75 06 48 83 c4 20 5b c3 48 c7 c7 70 10 49 95 e8 36 db 01
> 00 <0f> 0b 48 83 c4 20 5b c3 80 3d 29 eb 1b 01 00 75 9c ba 6c 00 00 00
> [ 2741.427100] RSP: 0018:ffffa9372f13fe48 EFLAGS: 00010296
> [ 2741.432328] RAX: 000000000000001c RBX: ffffa9358ef07000 RCX:
> 0000000000000000
> [ 2741.439460] RDX: ffff8be5e06a6ba0 RSI: ffff8be5e0698ac0 RDI:
> ffff8be5e0698ac0
> [ 2741.446594] RBP: ffffa9358ef07000 R08: 0000000000000000 R09:
> ffffa9372f13fc78
> [ 2741.453727] R10: ffffa9372f13fc70 R11: ffff8be63ff3c228 R12:
> ffff8be5e06a9980
> [ 2741.460858] R13: ffff8be5e06af700 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2741.467994] FS:  0000000000000000(0000) GS:ffff8be5e0680000(0000)
> knlGS:0000000000000000
> [ 2741.476080] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2741.481824] CR2: 00007f580c1a0ae0 CR3: 000000028ec8c002 CR4:
> 00000000007706e0
> [ 2741.488959] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2741.496092] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2741.503224] PKRU: 55555554
> [ 2741.505936] Call Trace:
> [ 2741.508391]  xp_release_deferred+0x22/0xa0
> [ 2741.512491]  process_one_work+0x1ec/0x380
> [ 2741.516505]  worker_thread+0x53/0x3e0
> [ 2741.520170]  ? process_one_work+0x380/0x380
> [ 2741.524354]  kthread+0x11b/0x140
> [ 2741.527587]  ? kthread_associate_blkcg+0xa0/0xa0
> [ 2741.532206]  ret_from_fork+0x1f/0x30
> [ 2741.535789] ---[ end trace cbb7bcf4ac8a3b96 ]---
> [ 2741.637874] ------------[ cut here ]------------
> [ 2741.642495] Failed to disable zero-copy!
> [ 2741.646450] WARNING: CPU: 3 PID: 3925 at net/xdp/xsk_buff_pool.c:118
> xp_disable_drv_zc+0x69/0xa0
> [ 2741.655239] Modules linked in: rfkill vfat fat rpcrdma sunrpc
> rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod ib_iser
> libiscsi scsi_transport_iscsi rdma_cm iw_cm ib_cm intel_rapl_msr
> iTCO_wdt intel_pmc_bxt iTCO_vendor_support intel_rapl_common
> isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm irqbypass i40iw rapl
> intel_cstate ib_uverbs intel_uncore ipmi_ssif ib_core pcspkr i2c_i801
> lpc_ich i2c_smbus joydev mei_me mei acpi_ipmi ioatdma ipmi_si
> ipmi_devintf ipmi_msghandler fuse zram ip_tables xfs ast
> drm_vram_helper drm_kms_helper crct10dif_pclmul crc32_pclmul qat_c62x
> cec drm_ttm_helper crc32c_intel intel_qat ttm ghash_clmulni_intel i40e
> drm igb authenc dca i2c_algo_bit wmi uas usb_storage i2c_dev
> [ 2741.722150] CPU: 3 PID: 3925 Comm: kworker/3:0 Tainted: G        W
> 5.11.17-300.fc34.x86_64 #1
> [ 2741.731371] Hardware name: To be filled by O.E.M. To be filled by
> O.E.M./To be filled by O.E.M., BIOS 5.14 04/18/2019
> [ 2741.741968] Workqueue: events xp_release_deferred
> [ 2741.746676] RIP: 0010:xp_disable_drv_zc+0x69/0xa0
> [ 2741.751380] Code: 10 48 8b 87 f0 01 00 00 48 8b 80 50 02 00 00 e8 cd
> 26 2b 00 85 c0 75 06 48 83 c4 20 5b c3 48 c7 c7 70 10 49 95 e8 36 db 01
> 00 <0f> 0b 48 83 c4 20 5b c3 80 3d 29 eb 1b 01 00 75 9c ba 6c 00 00 00
> [ 2741.770130] RSP: 0018:ffffa93580f9fe48 EFLAGS: 00010296
> [ 2741.775354] RAX: 000000000000001c RBX: ffffa9358af02000 RCX:
> 0000000000000000
> [ 2741.782487] RDX: ffff8be5e06e6ba0 RSI: ffff8be5e06d8ac0 RDI:
> ffff8be5e06d8ac0
> [ 2741.789624] RBP: ffffa9358af02000 R08: 0000000000000000 R09:
> ffffa93580f9fc78
> [ 2741.796763] R10: ffffa93580f9fc70 R11: ffff8be63ff3c228 R12:
> ffff8be5e06e9980
> [ 2741.803895] R13: ffff8be5e06ef700 R14: 0000000000000000 R15:
> 0000000000000000
> [ 2741.811030] FS:  0000000000000000(0000) GS:ffff8be5e06c0000(0000)
> knlGS:0000000000000000
> [ 2741.819116] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2741.824861] CR2: 00007fc9a42684e0 CR3: 00000002ccdf4001 CR4:
> 00000000007706e0
> [ 2741.831994] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2741.839127] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [ 2741.846259] PKRU: 55555554
> [ 2741.848973] Call Trace:
> [ 2741.851428]  xp_release_deferred+0x22/0xa0
> [ 2741.855539]  process_one_work+0x1ec/0x380
> [ 2741.859557]  worker_thread+0x53/0x3e0
> [ 2741.863221]  ? process_one_work+0x380/0x380
> [ 2741.867410]  kthread+0x11b/0x140
> [ 2741.870651]  ? kthread_associate_blkcg+0xa0/0xa0
> [ 2741.875271]  ret_from_fork+0x1f/0x30
> [ 2741.878861] ---[ end trace cbb7bcf4ac8a3b97 ]---
>
>
