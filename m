Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047F81D1BC2
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389810AbgEMRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389737AbgEMRAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:00:21 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01733C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 10:00:21 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id u15so396783ljd.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X5AiDV5cEp2T06vun5xI9tCWPuLrX196gjC5oY71A7Q=;
        b=YMPWZsOPAsH3YQsE+2rst4AL2W/ckfSkPr7mdwFnRBeeA6+GZoDjoerih3mtguWARq
         ilgjJoyOM7stQFF+quI50STlyCJW8LqqiMU6OO5Z5qpylYHoKpVsiTPcNQyhbp/WsMhv
         7cYv06CidH4FaKxpn7pu2doOKGtML+UvniAZhFbzaQezmFsXj0HJA2Xba4NfZT9/BNyW
         fa5ZQwLbvCXYpWCZHcM5OEaBCxUGhRmskqBVj9DZ9IaH48X1/vU20lw24naqrIhzoqfm
         T3iZy8u8ek6GzYVRxd7ydiMEo2kSppz8Hm6mEY4wSSHgAm3T1ZRGRGCtM+6Sk/LTyrJe
         0HfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X5AiDV5cEp2T06vun5xI9tCWPuLrX196gjC5oY71A7Q=;
        b=E1c1tUpYI+yZ/ARhKwWRrdkO5lRa31Uc0ZSNzNQ72JvFBkQ+rKtQqAt3QEG1HEWaTX
         MonQzj8/kqfvW6Ed5ndwy/wlpVdH5AIFR0ojlrGCnM95r688MGgJvFyx0W7AzDTiL2WR
         rAeTsB8av1nL54Pqks2PHEmn0pAobQEOaBhgtFylUdzo3mjYUqkU9jgnciRnOAhNtkfn
         or7oa1xliqRl4GKjLdlqBSazrkeiETpXWB5wNk/SHBL+xZBiJM8AQE47sEuy9wEaP+JC
         0ZFCB9dbvvu0H2SH66ltdwt3PkuEQjVFzHO+Ey1ZYtRcoZaOiwf91CPG5pM9XZjxhggg
         CZng==
X-Gm-Message-State: AOAM530W7du4FabhmeDujvH6gMPu0FBGYsYFe7mJM4ctovo8jwzPN8cv
        ZrMWTNXzVtQJmoetDqkeXCFrmcYFleJBfZ9gSytkhw==
X-Google-Smtp-Source: ABdhPJyw/Bxu4qAyC1muqfGkDKw+dwCSBnONaxt8tFWoNH7ElGaPJv7n6tCgnFnBChpSALYnxvSbZultJhI+1yjvv5Y=
X-Received: by 2002:a2e:8912:: with SMTP id d18mr36091lji.123.1589389219152;
 Wed, 13 May 2020 10:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt7-R-_fVDeiwj=sVvBQ-456Pm1oFFtM5Hm_94nN-tA+w@mail.gmail.com>
 <CAM_iQpXQdgwFwUONX+za5vJbcXP9krwz_--pG+z_Etf_v8K2mw@mail.gmail.com> <CA+G9fYtCV55uuArU4OLCTaaBPk7BDeZyOBUHoScN4NsbQeuPhA@mail.gmail.com>
In-Reply-To: <CA+G9fYtCV55uuArU4OLCTaaBPk7BDeZyOBUHoScN4NsbQeuPhA@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 22:30:07 +0530
Message-ID: <CA+G9fYu==UjidBS4-xEqzf3if-4-3GvaJCL1O5XD65a81KtWiw@mail.gmail.com>
Subject: Re: x86_64: 5.6.0: locking/lockdep.c:1155 lockdep_register_key
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Brian Gerst <brgerst@gmail.com>, lkft-triage@lists.linaro.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Apr 2020 at 23:15, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Sat, 11 Apr 2020 at 02:20, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Tue, Apr 7, 2020 at 2:58 AM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > On Linux mainline kernel 5.6.0 running kselftest on i386 kernel running on
> > > x86_64 devices we have noticed this kernel warning.
> >
> > This is odd, the warning complains a lockdep key is static, but
> > all of the 3 lockdep keys in netdev_register_lockdep_key() are
> > dynamic. I don't see how this warning could happen.

The reported kernel warning is still reproducible on stable rc 5.6
branch kernel on i386 kernel
running on x86_64 hardware.

[  543.896836] audit: type=1415 audit(1589376671.756:87534):
op=SPD-add auid=4294967295 ses=4294967295 subj=kernel res=1
src=0000:0000:0000:0000:0000:0000:0000:0000 src_prefixlen=0
dst=0000:0000:0000:0000:0000:0000:0000:0000 dst_prefixlen=0
[  543.924403] audit: type=1415 audit(1589376671.783:87535):
op=SPD-add auid=4294967295 ses=4294967295 subj=kernel res=1
src=0000:0000:0000:0000:0000:0000:0000:0000 src_prefixlen=0
dst=0000:0000:0000:0000:0000:0000:0000:0000 dst_prefixlen=0
[  544.111779] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
[  544.315145] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
[  544.340418] ------------[ cut here ]------------
[  544.345049] WARNING: CPU: 3 PID: 17049 at
/usr/src/kernel/kernel/locking/lockdep.c:1119
lockdep_register_key+0xb0/0xf0
[  544.355738] Modules linked in: sit vrf test_printf(+) cls_bpf
sch_fq 8021q veth algif_hash af_alg x86_pkg_temp_thermal fuse [last
unloaded: test_blackhole_dev]
[  544.369994] CPU: 3 PID: 17049 Comm: ip Tainted: G      D W
5.6.13-rc1 #1
[  544.377376] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  544.384763] EIP: lockdep_register_key+0xb0/0xf0
[  544.389294] Code: 05 04 b8 8c d7 00 eb da 66 90 8b 04 95 00 68 7e
d7 89 4b 04 89 03 85 c0 89 1c 95 00 68 7e d7 74 a5 89 58 04 eb a0 8d
74 26 00 <0f> 0b 8d 65 f8 5b 5e 5d c3 8d b4 26 00 00 00 00 e8 1b 9e 3c
00 85
[  544.408031] EAX: 00000001 EBX: d79e367c ECX: 00000000 EDX: d79e31a4
[  544.414288] ESI: 00000001 EDI: ffffffff EBP: f5a0fa24 ESP: f5a0fa1c
[  544.420545] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  544.427324] CR0: 80050033 CR2: 0807e7c0 CR3: 20eac000 CR4: 003406d0
[  544.433589] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  544.439855] DR6: fffe0ff0 DR7: 00000400
[  544.443693] Call Trace:
[  544.446143]  alloc_netdev_mqs+0xcb/0x3c0
[  544.450067]  rtnl_create_link+0x133/0x290
[  544.454079]  ? vti_newlink+0x60/0x60
[  544.457659]  __rtnl_newlink+0x637/0x8e0
[  544.461504]  ? mem_cgroup_throttle_swaprate+0x10/0x270
[  544.466651]  ? mem_cgroup_commit_charge+0x47/0x2c0
[  544.471436]  ? trace_hardirqs_on+0x43/0xf0
[  544.475535]  ? handle_mm_fault+0x931/0xcf0
[  544.479656]  rtnl_newlink+0x3c/0x60
[  544.483152]  ? __rtnl_newlink+0x8e0/0x8e0
[  544.487158]  rtnetlink_rcv_msg+0x24b/0x480
[  544.491258]  ? __rtnl_newlink+0x8e0/0x8e0
[  544.495270]  ? netlink_deliver_tap+0x86/0x3b0
[  544.499630]  ? validate_linkmsg+0x300/0x300
[  544.503813]  netlink_rcv_skb+0x6e/0xf0
[  544.507562]  rtnetlink_rcv+0x12/0x20
[  544.511135]  netlink_unicast+0x195/0x250
[  544.515057]  netlink_sendmsg+0x27d/0x430
[  544.518984]  ? netlink_unicast+0x250/0x250
[  544.523078]  sock_sendmsg+0x5c/0x60
[  544.526564]  ____sys_sendmsg+0x191/0x1e0
[  544.530488]  ? copy_msghdr_from_user+0xb9/0x150
[  544.535016]  ___sys_sendmsg+0x5e/0xa0
[  544.538681]  ? lock_page_memcg+0x5/0xe0
[  544.542520]  ? __unlock_page_memcg+0x2d/0xa0
[  544.546793]  ? __unlock_page_memcg+0x43/0xa0
[  544.551065]  ? page_add_file_rmap+0x58/0xa0
[  544.555249]  ? alloc_set_pte+0x10d/0x420
[  544.559171]  ? ktime_get_coarse_real_ts64+0x48/0xc0
[  544.564056]  __sys_sendmsg+0x3e/0x80
[  544.567640]  sys_socketcall+0x20a/0x340
[  544.571482]  ? __might_fault+0x41/0x80
[  544.575236]  do_fast_syscall_32+0x8e/0x340
[  544.579337]  entry_SYSENTER_32+0xaa/0x102
[  544.583347] EIP: 0xb7f03c11
[  544.586146] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb be
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  544.604891] EAX: ffffffda EBX: 00000010 ECX: bfab9c34 EDX: 00000000
[  544.611154] ESI: 00000000 EDI: 080e52c0 EBP: 00000010 ESP: bfab9c20
[  544.617412] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000286
[  544.624196] irq event stamp: 0
[  544.627258] hardirqs last  enabled at (0): [<00000000>] 0x0
[  544.632823] hardirqs last disabled at (0): [<d5eeb738>]
copy_process+0x3e8/0x1810
[  544.640300] softirqs last  enabled at (0): [<d5eeb738>]
copy_process+0x3e8/0x1810
[  544.647770] softirqs last disabled at (0): [<00000000>] 0x0
[  544.653335] ---[ end trace e7d4a168a647a827 ]---
[  544.833114] IPv6: ADDRCONF(NETDEV_CHANGE): veth_b: link becomes ready
[  544.839733] IPv6: ADDRCONF(NETDEV_CHANGE): veth_a: link becomes ready
[  545.005827] ------------[ cut here ]------------
[  545.010459] WARNING: CPU: 3 PID: 17131 at
/usr/src/kernel/kernel/locking/lockdep.c:5179
lockdep_unregister_key+0xf0/0x130
[  545.021399] Modules linked in: sit vrf test_printf(+) cls_bpf
sch_fq 8021q veth algif_hash af_alg x86_pkg_temp_thermal fuse [last
unloaded: test_blackhole_dev]
[  545.035642] CPU: 3 PID: 17131 Comm: ip Tainted: G      D W
5.6.13-rc1 #1
[  545.043031] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[  545.050417] EIP: lockdep_unregister_key+0xf0/0x130
[  545.055208] Code: 05 04 b8 8c d7 00 eb d8 66 90 89 da 8b 02 8b 4a
04 85 c0 89 01 74 03 89 48 04 c7 42 04 22 01 00 00 eb 8b 8d b4 26 00
00 00 00 <0f> 0b 8d 65 f4 5b 5e 5f 5d c3 8d b6 00 00 00 00 e8 eb 9c 3c
00 85
[  545.073947] EAX: 00000001 EBX: d79e667c ECX: 00000000 EDX: 00001439
[  545.080211] ESI: d79e6000 EDI: d79e6034 EBP: ebb8dc7c ESP: ebb8dc70
[  545.086475] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[  545.093253] CR0: 80050033 CR2: b7dcb0a0 CR3: 258c0000 CR4: 003406d0
[  545.099510] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  545.105767] DR6: fffe0ff0 DR7: 00000400
[  545.109598] Call Trace:
[  545.112046]  free_netdev+0xf2/0x160
[  545.115538]  netdev_run_todo+0x237/0x2a0
[  545.119464]  ? valid_fdb_dump_legacy+0xc0/0xc0
[  545.123907]  rtnetlink_rcv_msg+0x252/0x480
[  545.127999]  ? valid_fdb_dump_legacy+0xc0/0xc0
[  545.132447]  ? netlink_deliver_tap+0x86/0x3b0
[  545.136805]  ? validate_linkmsg+0x300/0x300
[  545.140989]  netlink_rcv_skb+0x6e/0xf0
[  545.144735]  rtnetlink_rcv+0x12/0x20
[  545.148314]  netlink_unicast+0x195/0x250
[  545.152238]  netlink_sendmsg+0x27d/0x430
[  545.156169]  ? netlink_unicast+0x250/0x250
[  545.160271]  sock_sendmsg+0x5c/0x60
[  545.163758]  ____sys_sendmsg+0x191/0x1e0
[  545.167682]  ? copy_msghdr_from_user+0xb9/0x150
[  545.172216]  ___sys_sendmsg+0x5e/0xa0
[  545.175887]  ? destroy_inode+0x52/0x70
[  545.179640]  ? free_inode_nonrcu+0x20/0x20
[  545.183737]  ? ktime_get_coarse_real_ts64+0x48/0xc0
[  545.188613]  __sys_sendmsg+0x3e/0x80
[  545.192197]  sys_socketcall+0x20a/0x340
[  545.196042]  ? __might_fault+0x41/0x80
[  545.199792]  do_fast_syscall_32+0x8e/0x340
[  545.203893]  entry_SYSENTER_32+0xaa/0x102
[  545.207903] EIP: 0xb7ef5c11
[  545.210692] Code: 5e 5d c3 8d b6 00 00 00 00 b8 40 42 0f 00 eb be
8b 04 24 c3 8b 1c 24 c3 8b 34 24 c3 8b 3c 24 c3 90 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[  545.229430] EAX: ffffffda EBX: 00000010 ECX: bfdce2a4 EDX: 00000000
[  545.235687] ESI: 00000000 EDI: 080e52c0 EBP: 00000010 ESP: bfdce290
[  545.241944] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000282
[  545.248726] irq event stamp: 0
[  545.251781] hardirqs last  enabled at (0): [<00000000>] 0x0
[  545.257347] hardirqs last disabled at (0): [<d5eeb738>]
copy_process+0x3e8/0x1810
[  545.264823] softirqs last  enabled at (0): [<d5eeb738>]
copy_process+0x3e8/0x1810
[  545.272293] softirqs last disabled at (0): [<00000000>] 0x0
[  545.277857] ---[ end trace e7d4a168a647a828 ]---
[  546.768756] IPv6: ADDRCONF(NETDEV_CHANGE): veth_A-R1: link becomes ready
[  546.799782] IPv6: ADDRCONF(NETDEV_CHANGE): veth_A-R2: link becomes ready
[  546.828383] IPv6: ADDRCONF(NETDEV_CHANGE): veth_B-R1: link becomes ready
[  546.857536] IPv6: ADDRCONF(NETDEV_CHANGE): veth_B-R2: link becomes ready
[  547.794885] IPv6: ADDRCONF(NETDEV_CHANGE): veth_R1-A: link becomes ready


ref:
https://lkft.validation.linaro.org/scheduler/job/1430346#L14444


-- 
Linaro LKFT
https://lkft.linaro.org
