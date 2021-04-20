Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC13653AC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhDTIA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhDTIAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:00:54 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBA6C061763
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:00:23 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id x12so36094360ejc.1
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7tp1mqoHVTwihyTDBSNSlok7X7xYlH8+iLFRzNdLf7g=;
        b=mj+I67ylJFRxKnhymovlnFt3xphE/FT0tNcw8tCskAkzOVGBQL0c5my9upnKleo9nw
         Qon52Q9uWhU6TqmBlvkNY/pupihTMRFh3QMPQ0i2TDLyM9h5XAwnT6mQQdYDtpRHpsqs
         sNLji4Y+wiTwQ/Lu2TnjMmFBwuux0UDS62myANADdzRXjh8kB3rfclSQZnA7Nb3RjUUU
         ivQBXem/Sk5xs4UWr1mPoCqLJzGgqDGQyldcUhUwPjcAWuzPwR8QNiaa71qvm8AsdFl3
         JWhxAgQuULuDZy+t9HZLupNtZ0JB14XlM+ljnF/zeHkpwHt1KbJnjYz4XHJNtLzfPlvQ
         IFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7tp1mqoHVTwihyTDBSNSlok7X7xYlH8+iLFRzNdLf7g=;
        b=hLlCB7hTph+I5nbGW9PH/vQcHychXkazIho1ufNttIHn67FAG2iu85HBpU+Rsx4HZU
         oQQi542hU4y+cgcACdROufeJGcXZ4pWKrkpVB6JkewhUAdpEileYwumgSqMpTE+Ua1dz
         TezXi9u0Mx7JGaBUv0uVxE+OhKmHmZ7ew/KjitaWnhChCffhmcIHjN9yFUvBQZekkutA
         XArfNxkiRqKG3XhaJt8iycORuXHd1+zirX2SaIQuNv3Hsj9GsjMxReS8it/sx515BwFu
         raP2Amdl3trm4kE5uTAk9h/0RVCk3msY9LyDrBuF6zP3W3KO0tfgmNWs77wkPAhcjZoZ
         g53w==
X-Gm-Message-State: AOAM5318DrmsDOlWzLa+JgxG8YNtjxvH4bvP62gv03vtXJQJvBM1LxkA
        j68M4n7O8Dxi0kIc46ikfT+fLk0BNQ93DIraE8QfnA==
X-Google-Smtp-Source: ABdhPJyll9vL1qL+L7WrwQQpjO129pScys8bpDTAvnvQM24mAMYw90ZqKX6VA1Lz4TsErQxGoIHeMyPX1ug71/fT17k=
X-Received: by 2002:a17:906:4f91:: with SMTP id o17mr26046248eju.503.1618905621934;
 Tue, 20 Apr 2021 01:00:21 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 20 Apr 2021 13:30:10 +0530
Message-ID: <CA+G9fYtujdEqdGE_3dDpAecLMAmUfwZEm5EmPEGTNdLQgXtYYw@mail.gmail.com>
Subject: [stable-rc 5.4] thp04: page allocation failure: order:0,
 mode:0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), nodemask=(null)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LTP List <ltp@lists.linux.it>, linux-mm <linux-mm@kvack.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following kernel crash reported on arm64 hikey device running stable-rc
 5.4.114-rc1 kernel and testing LTP thp04 test case.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

I have tried to reproduce this crash but was not successful after
multiple attempts.
Could not bisect this problem because it is not reproducible.

step to reproduce:
-------------------------
 - Boot 5.4.114-rc1 kernel on arm64 hikey device.
 - run ltp cve test case
 - cd /opt/ltp
 - ./runltp -f cve
 -  ./runltp -s thp04

Test crash log:
--------------------
../../../../include/tst_fuzzy_sync.h:507: TINFO: Minimum sampling period ended
../../../../include/tst_fuzzy_sync.h:331: TINFO: loop = 1024, delay_bias = 0
../../../../include/tst_fuzzy_sync.h:320: TINFO: start_a - start_b: {
avg =   -43ns, avg_dev =   104ns, dev_ratio = 2.44 }
../../../../include/tst_fuzzy_sync.h:320: TINFO: end_a - start_a  : {
avg = 1373611ns, avg_dev = 90431ns, dev_ratio = 0.07 }
../../../../include/tst_fuzzy_sync.h:320: TINFO: end_b - start_b  : {
avg = 968943ns, avg_dev = 11299ns, dev_ratio = 0.01 }
../../../../include/tst_fuzzy_sync.h:320: TINFO: end_a - end_b    : {
avg = 404625ns, avg_dev = 80082ns, dev_ratio = 0.20 }
../../../../include/tst_fuzzy_sync.h:320: TINFO: spins            : {
avg = 38993  , avg_dev =  7743  , dev_ratio = 0.20 }
[ 1303.074490] wlcore: down
[ 1303.081180] thp04: page allocation failure: order:0,
mode:0x400dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO), nodemask=(null)
[ 1303.081189] Unable to handle kernel paging request at virtual
address 0000000000001540
[ 1303.081191] ,cpuset=/,mems_allowed=0
[ 1303.081302] Unable to handle kernel paging request at virtual
address 0000000000001540
[ 1303.081313] Mem abort info:
[ 1303.081322]   ESR = 0x96000004
[ 1303.081331]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1303.081340]   SET = 0, FnV = 0
[ 1303.081348]   EA = 0, S1PTW = 0
[ 1303.081355] Data abort info:
[ 1303.081363]   ISV = 0, ISS = 0x00000004
[ 1303.081371]   CM = 0, WnR = 0
[ 1303.081393] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000074f30000
[ 1303.081402] [0000000000001540] pgd=0000000000000000
[ 1303.081417] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[ 1303.081424] Modules linked in: algif_hash wl18xx wlcore mac80211
cfg80211 hci_uart snd_soc_hdmi_codec btbcm snd_soc_audio_graph_card
adv7511 snd_soc_simple_card_utils crct10dif_ce wlcore_sdio bluetooth
cec kirin_drm drm_kms_helper dw_drm_dsi rfkill drm fuse
[ 1303.081483] CPU: 0 PID: 210 Comm: kworker/0:2 Not tainted 5.4.114-rc1 #1
[ 1303.081487] Hardware name: HiKey Development Board (DT)
[ 1303.081506] Workqueue: events vmstat_shepherd
[ 1303.081514] pstate: a0000005 (NzCv daif -PAN -UAO)
[ 1303.081523] pc : next_online_pgdat+0x24/0x78
[ 1303.081530] lr : next_zone+0x40/0x50
[ 1303.081534] sp : ffff8000129f3d10
[ 1303.081537] x29: ffff8000129f3d10 x28: ffff800011fe7000
[ 1303.081544] x27: ffff000077af1b30 x26: ffff000077af1ae0
[ 1303.081551] x25: 0000000000000000 x24: ffff000077b4cd38
[ 1303.081557] x23: ffff800011fe9000 x22: ffff800011fe9920
[ 1303.081564] x21: 0000000000000003 x20: ffff000077b531d8
[ 1303.081570] x19: 0000000000000000 x18: 0000000000000000
[ 1303.081577] x17: 0000000000000000 x16: 0000000000000000
[ 1303.081583] x15: 0000000000000000 x14: 0000000000000000
[ 1303.081589] x13: 0000000000000000 x12: 0000000000000000
[ 1303.081596] x11: 0000000000000000 x10: 0000000000000040
[ 1303.081603] x9 : 0000002a141f0a9e x8 : 0000000000000002
[ 1303.081609] x7 : ffff000077b30c10 x6 : ffff800011fea000
[ 1303.081616] x5 : ffff800011fea968 x4 : ffff000077b53226
[ 1303.081623] x3 : 0000000000000000 x2 : 000000000000000c
[ 1303.081629] x1 : 0000000000000004 x0 : ffff800011fea000
[ 1303.081637] Call trace:
[ 1303.081645]  next_online_pgdat+0x24/0x78
[ 1303.081654]  next_zone+0x40/0x50
[ 1303.081661]  need_update+0x7c/0xb0
[ 1303.081667]  vmstat_shepherd+0x7c/0x100
[ 1303.081676]  process_one_work+0x1c4/0x480
[ 1303.081682]  worker_thread+0x54/0x430
[ 1303.081690]  kthread+0x11c/0x150
[ 1303.081700]  ret_from_fork+0x10/0x1c
[ 1303.081710] Code: aa1e03e0 d503201f d2800081 9000eb20 (b9554262)
[ 1303.081718] ---[ end trace cd32e7e2c7ee8919 ]---
[ 1303.081820] Unable to handle kernel paging request at virtual
address 0000000000001540
[ 1303.081830] Mem abort info:
[ 1303.081838]   ESR = 0x96000004
[ 1303.081849]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1303.081858]   SET = 0, FnV = 0
[ 1303.081866]   EA = 0, S1PTW = 0
[ 1303.081873] Data abort info:
[ 1303.081881]   ISV = 0, ISS = 0x00000004
[ 1303.081889]   CM = 0, WnR = 0
[ 1303.081899] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000001b98000
[ 1303.081907] [0000000000001540] pgd=0000000000000000
[ 1303.081921] Internal error: Oops: 96000004 [#2] PREEMPT SMP
[ 1303.081926] Modules linked in: algif_hash wl18xx wlcore mac80211
cfg80211 hci_uart snd_soc_hdmi_codec btbcm snd_soc_audio_graph_card
adv7511 snd_soc_simple_card_utils crct10dif_ce wlcore_sdio bluetooth
cec kirin_drm drm_kms_helper dw_drm_dsi rfkill drm fuse
[ 1303.081967] CPU: 2 PID: 51 Comm: kworker/2:1 Tainted: G      D
     5.4.114-rc1 #1
[ 1303.081971] Hardware name: HiKey Development Board (DT)
[ 1303.081982] Workqueue: mm_percpu_wq vmstat_update
[ 1303.081989] pstate: a0000005 (NzCv daif -PAN -UAO)
[ 1303.081997] pc : next_online_pgdat+0x24/0x78
[ 1303.082004] lr : next_zone+0x40/0x50
[ 1303.082007] sp : ffff8000124d3be0
[ 1303.082012] x29: ffff8000124d3be0 x28: 0000000000000000
[ 1303.082019] x27: 0000000000000006 x26: ffff000074e00000
[ 1303.082026] x25: 0000000000000000 x24: ffff8000119f0218
[ 1303.082033] x23: ffff8000119f01d8 x22: 0000000000000000
[ 1303.082043] x21: ffff8000124d3cc0 x20: ffff8000124d3cd8
[ 1303.082050] x19: 0000000000000000 x18: 0000000000000000
[ 1303.082057] x17: 0000000000000000 x16: 0000000000000000
[ 1303.082064] x15: 0000000000000000 x14: 0000000000000000
[ 1303.082070] x13: 0000000000000000 x12: 0000000000000000
[ 1303.082077] x11: 0000000000000000 x10: 0000000000000000
[ 1303.082084] x9 : 0000000000000000 x8 : ffff000077bdbe20
[ 1303.082090] x7 : ffff8000119f0218 x6 : ffff8000119f0226
[ 1303.082097] x5 : 0000000000000000 x4 : 0000000000000000
[ 1303.082104] x3 : ffff8000119f01d8 x2 : ffff800066144000
[ 1303.082111] x1 : 0000000000000004 x0 : ffff800011fea000
[ 1303.082117] Call trace:
[ 1303.082125]  next_online_pgdat+0x24/0x78
[ 1303.082131]  next_zone+0x40/0x50
[ 1303.082139]  refresh_cpu_vm_stats+0xbc/0x3f8
[ 1303.082146]  vmstat_update+0x1c/0x88
[ 1303.082153]  process_one_work+0x1c4/0x480
[ 1303.082158]  worker_thread+0x54/0x430
[ 1303.082165]  kthread+0x11c/0x150
[ 1303.082172]  ret_from_fork+0x10/0x1c
[ 1303.082181] Code: aa1e03e0 d503201f d2800081 9000eb20 (b9554262)
[ 1303.082187] ---[ end trace cd32e7e2c7ee891a ]---
[ 1303.085351] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.085362]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.085372]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.085502] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.085510]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.085517]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.085618] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.085626]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.085633]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.085713] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.085721]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.085728]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.085822] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.085829]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.085836]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.085916] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.085923]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.085931]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.086023] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.086030]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.086037]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.086117] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.086124]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.086131]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.086223] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.086231]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.086238]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.086317] SLUB: Unable to allocate memory on node -1,
gfp=0x400cc0(GFP_KERNEL_ACCOUNT)
[ 1303.086324]   cache: skbuff_head_cache, object size: 216, buffer
size: 256, default order: 1, min order: 0
[ 1303.086331]   node 0: slabs: 53, objs: 1696, free: 0
[ 1303.091806] Mem abort info:
[ 1303.091810]   ESR = 0x96000006
[ 1303.091815]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1303.091819]   SET = 0, FnV = 0
[ 1303.091823]   EA = 0, S1PTW = 0
[ 1303.091826] Data abort info:
[ 1303.091830]   ISV = 0, ISS = 0x00000006
[ 1303.091834]   CM = 0, WnR = 0
[ 1303.091840] user pgtable: 4k pages, 48-bit VAs, pgdp=000000006ab4d000
[ 1303.091844] [0000000000001540] pgd=000000006dded003,
pud=000000006a870003, pmd=0000000000000000
[ 1303.091858] Internal error: Oops: 96000006 [#3] PREEMPT SMP
[ 1303.092766] socket: no more sockets
[ 1303.092883] socket: no more sockets
[ 1303.092913] socket: no more sockets
[ 1303.092942] socket: no more sockets
[ 1303.092971] socket: no more sockets
[ 1303.092999] socket: no more sockets
[ 1303.093027] socket: no more sockets
[ 1303.093056] socket: no more sockets
[ 1303.093078] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.093085] socket: no more sockets
[ 1303.093113] socket: no more sockets
[ 1303.093246] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.093331] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.093488] NetworkManager invoked oom-killer: gfp_mask=0x0(),
order=0, oom_score_adj=0
[ 1303.093505] CPU: 4 PID: 354 Comm: NetworkManager Tainted: G      D
         5.4.114-rc1 #1
[ 1303.093510] Hardware name: HiKey Development Board (DT)
[ 1303.093516] Call trace:
[ 1303.093530]  dump_backtrace+0x0/0x178
[ 1303.093533] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.093538]  show_stack+0x28/0x38
[ 1303.093548]  dump_stack+0xe0/0x160
[ 1303.093559]  dump_header+0x4c/0x1f8
[ 1303.093568]  oom_kill_process+0x1cc/0x1d0
[ 1303.093576]  out_of_memory+0x178/0x4f0
[ 1303.093584]  pagefault_out_of_memory+0x8c/0x298
[ 1303.093593]  do_page_fault+0x484/0x4c8
[ 1303.093602]  do_translation_fault+0xb4/0xd0
[ 1303.093609]  do_mem_abort+0x54/0xb0
[ 1303.093616]  el0_da+0x1c/0x20
[ 1303.093620] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.093625] Mem-Info:
[ 1303.093648] Unable to handle kernel paging request at virtual
address 0000000000001540
[ 1303.093656] Mem abort info:
[ 1303.093664]   ESR = 0x96000006
[ 1303.093673]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1303.093681]   SET = 0, FnV = 0
[ 1303.093689]   EA = 0, S1PTW = 0
[ 1303.093697] Data abort info:
[ 1303.093705]   ISV = 0, ISS = 0x00000006
[ 1303.093713]   CM = 0, WnR = 0
[ 1303.093722] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000072aa1000
[ 1303.093730] [0000000000001540] pgd=0000000074f43003,
pud=000000006f64c003, pmd=0000000000000000
[ 1303.093776] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.093859] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.094013] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.094095] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.094248] systemd-journald[246]: Failed to open system journal:
Cannot allocate memory
[ 1303.100042] CPU: 1 PID: 18028 Comm: thp04 Tainted: G      D
  5.4.114-rc1 #1
[ 1303.103634] Modules linked in: algif_hash wl18xx wlcore mac80211
cfg80211 hci_uart snd_soc_hdmi_codec btbcm snd_soc_audio_graph_card
adv7511 snd_soc_simple_card_utils crct10dif_ce wlcore_sdio bluetooth
cec kirin_drm drm_kms_helper dw_drm_dsi rfkill drm fuse
[ 1303.111730] Hardware name: HiKey Development Board (DT)
[ 1303.114592] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G      D
  5.4.114-rc1 #1
[ 1303.117710] Call trace:
[ 1303.123139] Hardware name: HiKey Development Board (DT)
[ 1303.126270]  dump_backtrace+0x0/0x178
[ 1303.129474] pstate: a0000085 (NzCv daIf -PAN -UAO)
[ 1303.132417]  show_stack+0x28/0x38
[ 1303.136341] pc : next_online_pgdat+0x24/0x78
[ 1303.139369]  dump_stack+0xe0/0x160
[ 1303.145953] lr : next_zone+0x40/0x50
[ 1303.150939]  warn_alloc+0x100/0x170
[ 1303.156632] sp : ffff80001238bd20
[ 1303.179898]  __alloc_pages_slowpath+0xbc4/0xbf0
[ 1303.186741] x29: ffff80001238bd20 x28: 0000000000000000
[ 1303.192082]  __alloc_pages_nodemask+0x2ec/0x360
[ 1303.196535] x27: 0000000000000006 x26: ffff0000389e8000
[ 1303.201434]  alloc_pages_current+0x90/0x100
[ 1303.205791] x25: 0000000000000000 x24: ffff8000119f0218
[ 1303.209450]  do_huge_pmd_anonymous_page+0x3b0/0x818
[ 1303.212830] x23: ffff8000119f01d8 x22: 0000000000000000
[ 1303.218261]  __handle_mm_fault+0x83c/0x10a8
[ 1303.223684] x21: ffff80001238be00 x20: ffff80001238be18
[ 1303.229113]  handle_mm_fault+0x110/0x1f8
[ 1303.234536] x19: 0000000000000000 x18: 0000000000000000
[ 1303.239968]  do_page_fault+0x14c/0x4c8
[ 1303.245390] x17: 0000000000000000 x16: 0000000000000000
[ 1303.250821]  do_translation_fault+0xb4/0xd0
[ 1303.256245] x15: 0000000000000000 x14: 0000000000000000
[ 1303.261673]  do_mem_abort+0x54/0xb0
[ 1303.267097] x13: 0000000000000000 x12: 0000000000000000
[ 1303.272526]  el0_da+0x1c/0x20
[ 1303.277951] x11: 0000000000000000 x10: 0000000000000000
[ 1303.291214] Mem-Info:
[ 1303.304193] x9 : 0000000000000000 x8 : ffff000077bdbe20
[ 1303.304201] x7 : ffff8000119f0218 x6 : ffff8000119f0226
[ 1303.304208] x5 : 0000000000000000 x4 : ffff8000661c0000
[ 1303.304215] x3 : ffff800011feaff0 x2 : ffff8000661c0000
[ 1303.317358] Unable to handle kernel paging request at virtual
address 0000000000001540
[ 1303.327384] x1 : 0000000000000004 x0 : ffff800011fea000
[ 1303.327393] Call trace:
[ 1303.327406]  next_online_pgdat+0x24/0x78
[ 1303.327412]  next_zone+0x40/0x50
[ 1303.327420]  refresh_cpu_vm_stats+0xbc/0x3f8
[ 1303.327427]  quiet_vmstat+0x64/0x488
[ 1303.327441]  tick_nohz_idle_stop_tick+0xc4/0x2f0
[ 1303.338935] Mem abort info:
[ 1303.349349]  do_idle+0x1e0/0x2a0
[ 1303.349358]  cpu_startup_entry+0x30/0x90
[ 1303.349367]  secondary_start_kernel+0x16c/0x198
[ 1303.349380] Code: aa1e03e0 d503201f d2800081 9000eb20 (b9554262)
[ 1303.349392] ---[ end trace cd32e7e2c7ee891b ]---

Full test log link,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.113-74-gc509b45704fd/testrun/4393633/suite/linux-log-parser/test/check-kernel-oops-2551234/log
and
https://lkft.validation.linaro.org/scheduler/job/2551234#L10291

metadata:
  git branch: linux-5.4.y
  git repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
  git commit: c509b45704fd663fc59405e98d29d7f06eaae4b5
  git describe: v5.4.113-74-gc509b45704fd
  make_kernelversion: 5.4.114-rc1
  kernel-config: https://builds.tuxbuild.com/1rOEzHLegEbudzQQdiifqEuFVur/config

--
Linaro LKFT
https://lkft.linaro.org
