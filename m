Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E7C28DF0D
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 12:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbgJNKkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 06:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgJNKkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 06:40:11 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D95C0613D3
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 03:40:11 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id j13so4520560ilc.4
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 03:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NTf7hZKg2+zZSZX10eV/2zk69idp/NCIpS0qAnWVmoI=;
        b=cEQi5NR9R514dIKFYE+Ju+7uZ4FM3+5Vw4GgBb6+gHUsrN3WXgRgFWHWTKHPbOd0Dg
         8IqXK70Olf/XIx2Ui1QLIA+BWTNwxxBk3arpoRznfQ5aZoQe3rqNkq7OomWZfayTtUid
         uSqLPbG7bGZzOYruqH69QtCyPG9GdOXZTAvi3Td5d6KM/5IfIjQM2XMj7yc0flGCAFKR
         FANyHn9Fek2utMF3x1QJWL9P0fDwx91OzBU6IlDvCr/9SFaXvSkMtfQAGww0GMp4H4xw
         Cu9vC22KWwR6DHbqLQpjoZqJ4QrPOcLbXcRi6jUI6euJ67Zxeuni64OQ3SfqNw364ZPC
         U5rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NTf7hZKg2+zZSZX10eV/2zk69idp/NCIpS0qAnWVmoI=;
        b=Zcx5hQ0bf0Mvn62s+sTYISU0LzpNo1tNEz/gAorAx4NZ5Mcy2UpWIde7l8QP/mOiLp
         cvabrWG4ytWjvCOy84zD3IFkwOQlNd/NRLQQa1eCa7xfnHk6yylM0gjI5+I3TBZniaym
         dMMUniOz6sWF8pya4OKnX6m+EETITcArclQ5cQa4Ybth9b2JUCoAQXgJn3lTw38S+S7X
         NWx30m8WC5q3fAeaz6inB89q052j3WXSkh5Ax6/F2AP1s5LIqQPludM7FSFBK9j2KZFa
         KGGqq5Ae9+mXXEHu6+uquX3bkRja9gV7GigXNZsahbloMPKC1tC7wQLZfKZ77MMeYXgW
         KDcA==
X-Gm-Message-State: AOAM533RTId3TdxzLuS7rHbAO2TdVynF+Qj84EXRgkvsddmk1w15lUdV
        rCJ7y0MublyDqssAOenfeIV7sHnLWa6LnBNZ9DAaIg==
X-Google-Smtp-Source: ABdhPJy1pHu+DzX0/Cli5KAP0urYCX1wzF8O2RSzBwKIX+NlLGXB1It+AZxxbJJoE5+f63z5ncAQKlQ/0XZUd/GEj5M=
X-Received: by 2002:a92:9944:: with SMTP id p65mr3089801ili.127.1602672010340;
 Wed, 14 Oct 2020 03:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=ksLeBPmB+KFrB2rvCtQ@mail.gmail.com>
In-Reply-To: <CA+G9fYvFUpODs+NkSYcnwKnXm62tmP=ksLeBPmB+KFrB2rvCtQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 14 Oct 2020 16:09:58 +0530
Message-ID: <CA+G9fYthj157wH5EspZ+oxSkgLG+-mt_1Xi42T5EckKioCbrbw@mail.gmail.com>
Subject: Re: WARNING: at net/netfilter/nf_tables_api.c:622 lockdep_nfnl_nft_mutex_not_held+0x28/0x38
 [nf_tables]
To:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        open list <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, Florian Westphal <fw@strlen.de>,
        fabf@skynet.be, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 at 12:20, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> While running kselftest netfilter on arm64 hikey device on Linux next
> 20201013 the following
> kernel warning noticed.

Same issue noticed on i386.

# selftests: netfilter: nft_trans_stress.sh
[ 1092.615814] ------------[ cut here ]------------
[ 1092.620454] WARNING: CPU: 0 PID: 4504 at
/usr/src/kernel/net/netfilter/nf_tables_api.c:622
lockdep_nfnl_nft_mutex_not_held+0x20/0x30 [nf_tables]
[ 1092.633405] Modules linked in: nf_tables act_mirred cls_u32
mpls_iptunnel mpls_router sch_etf xt_conntrack nf_conntrack
nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 ip_tables netdevsim
vrf 8021q bridge stp llc sch_fq veth algif_hash x86_pkg_temp_thermal
fuse [last unloaded: test_blackhole_dev]
[ 1092.659896] CPU: 0 PID: 4504 Comm: nft Tainted: G        W
5.9.0-next-20201013 #1
[ 1092.668078] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1092.675558] EIP: lockdep_nfnl_nft_mutex_not_held+0x20/0x30 [nf_tables]
[ 1092.682091] Code: 26 00 31 c0 5d c3 8d 74 26 00 3e 8d 74 26 00 55
b8 0a 00 00 00 89 e5 e8 3e 1a 90 e2 84 c0 75 0a 5d c3 90 8d b4 26 00
00 00 00 <0f> 0b 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 3e 8d 74 26
00 55
[ 1092.700837] EAX: 00000001 EBX: c3d76300 ECX: 00000001 EDX: ffffffff
[ 1092.707105] ESI: e4ec7a7c EDI: e4ec7c84 EBP: e4ec7a00 ESP: e4ec7a00
[ 1092.713377] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[ 1092.720173] CR0: 80050033 CR2: b7b85002 CR3: 03616000 CR4: 003506d0
[ 1092.726441] Call Trace:
[ 1092.728901]  nft_chain_parse_hook+0x3f/0x2b0 [nf_tables]
[ 1092.734221]  ? prep_new_page+0x12a/0x130
[ 1092.738146]  ? get_page_from_freelist+0xdc5/0xf50
[ 1092.742850]  ? lock_acquire+0x191/0x330
[ 1092.746692]  nf_tables_addchain.constprop.68+0xb3/0x630 [nf_tables]
[ 1092.752957]  ? nft_chain_lookup.part.38+0x19d/0x350 [nf_tables]
[ 1092.758883]  nf_tables_newchain+0x408/0x660 [nf_tables]
[ 1092.764122]  ? nf_tables_addchain.constprop.68+0x630/0x630 [nf_tables]
[ 1092.770654]  nfnetlink_rcv_batch+0x4fc/0x740
[ 1092.774930]  ? security_capable+0x33/0x50
[ 1092.778950]  ? __nla_parse+0x1e/0x30
[ 1092.782536]  nfnetlink_rcv+0x10d/0x130
[ 1092.786288]  netlink_unicast+0x195/0x250
[ 1092.790215]  netlink_sendmsg+0x27d/0x430
[ 1092.794141]  ? netlink_unicast+0x250/0x250
[ 1092.798238]  sock_sendmsg+0x5c/0x60
[ 1092.801733]  ____sys_sendmsg+0x199/0x1e0
[ 1092.805659]  ? __vma_adjust+0x28e/0x8e0
[ 1092.809497]  ___sys_sendmsg+0x5e/0xa0
[ 1092.813164]  ? lock_acquire+0x191/0x330
[ 1092.817004]  ? __local_bh_enable_ip+0x78/0xd0
[ 1092.821370]  ? __local_bh_enable_ip+0x78/0xd0
[ 1092.825730]  ? _raw_spin_unlock_bh+0x2a/0x30
[ 1092.830002]  ? trace_hardirqs_on+0x48/0xd0
[ 1092.834102]  ? __local_bh_enable_ip+0x78/0xd0
[ 1092.838458]  ? release_sock+0x71/0xa0
[ 1092.842126]  ? _raw_spin_unlock_bh+0x2a/0x30
[ 1092.846400]  ? release_sock+0x71/0xa0
[ 1092.850071]  ? lock_acquire+0x191/0x330
[ 1092.853914]  ? sock_setsockopt+0x54f/0xf80
[ 1092.858013]  ? ktime_get_coarse_real_ts64+0xde/0xf0
[ 1092.862889]  ? ktime_get_coarse_real_ts64+0xde/0xf0
[ 1092.867769]  __sys_sendmsg+0x3e/0x80
[ 1092.871352]  __ia32_sys_socketcall+0x20a/0x340
[ 1092.875806]  __do_fast_syscall_32+0x54/0x90
[ 1092.880000]  do_fast_syscall_32+0x29/0x60
[ 1092.884012]  do_SYSENTER_32+0x15/0x20
[ 1092.887677]  entry_SYSENTER_32+0x9f/0xf2
[ 1092.891603] EIP: 0xb7f3b549
[ 1092.894401] Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08
03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[ 1092.913147] EAX: ffffffda EBX: 00000010 ECX: bff259a4 EDX: 00000000
[ 1092.919412] ESI: 00000000 EDI: 00000006 EBP: bff26ad8 ESP: bff25990
[ 1092.925677] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000282
[ 1092.932466] CPU: 0 PID: 4504 Comm: nft Tainted: G        W
5.9.0-next-20201013 #1
[ 1092.940643] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.0b 07/27/2017
[ 1092.948112] Call Trace:
[ 1092.950558]  dump_stack+0x6d/0x8b
[ 1092.953877]  ? lockdep_nfnl_nft_mutex_not_held+0x20/0x30 [nf_tables]
[ 1092.960228]  __warn+0x7a/0xe0
[ 1092.963195]  ? lockdep_nfnl_nft_mutex_not_held+0x20/0x30 [nf_tables]
[ 1092.969546]  report_bug+0xa9/0x150
[ 1092.972953]  ? exc_overflow+0x40/0x40
[ 1092.976617]  handle_bug+0x2d/0x60
[ 1092.979927]  exc_invalid_op+0x1b/0x70
[ 1092.983584]  handle_exception+0x140/0x140
[ 1092.987589] EIP: lockdep_nfnl_nft_mutex_not_held+0x20/0x30 [nf_tables]
[ 1092.994106] Code: 26 00 31 c0 5d c3 8d 74 26 00 3e 8d 74 26 00 55
b8 0a 00 00 00 89 e5 e8 3e 1a 90 e2 84 c0 75 0a 5d c3 90 8d b4 26 00
00 00 00 <0f> 0b 5d c3 8d b6 00 00 00 00 8d bf 00 00 00 00 3e 8d 74 26
00 55
[ 1093.012850] EAX: 00000001 EBX: c3d76300 ECX: 00000001 EDX: ffffffff
[ 1093.019108] ESI: e4ec7a7c EDI: e4ec7c84 EBP: e4ec7a00 ESP: e4ec7a00
[ 1093.025364] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010202
[ 1093.032144]  ? exc_overflow+0x40/0x40
[ 1093.035811]  ? lockdep_nfnl_nft_mutex_not_held+0x20/0x30 [nf_tables]
[ 1093.042161]  nft_chain_parse_hook+0x3f/0x2b0 [nf_tables]
[ 1093.047465]  ? prep_new_page+0x12a/0x130
[ 1093.051390]  ? get_page_from_freelist+0xdc5/0xf50
[ 1093.056087]  ? lock_acquire+0x191/0x330
[ 1093.059922]  nf_tables_addchain.constprop.68+0xb3/0x630 [nf_tables]
[ 1093.066187]  ? nft_chain_lookup.part.38+0x19d/0x350 [nf_tables]
[ 1093.072112]  nf_tables_newchain+0x408/0x660 [nf_tables]
[ 1093.077349]  ? nf_tables_addchain.constprop.68+0x630/0x630 [nf_tables]
[ 1093.083872]  nfnetlink_rcv_batch+0x4fc/0x740
[ 1093.088140]  ? security_capable+0x33/0x50
[ 1093.092152]  ? __nla_parse+0x1e/0x30
[ 1093.095729]  nfnetlink_rcv+0x10d/0x130
[ 1093.099483]  netlink_unicast+0x195/0x250
[ 1093.103406]  netlink_sendmsg+0x27d/0x430
[ 1093.107324]  ? netlink_unicast+0x250/0x250
[ 1093.111414]  sock_sendmsg+0x5c/0x60
[ 1093.114897]  ____sys_sendmsg+0x199/0x1e0
[ 1093.118818]  ? __vma_adjust+0x28e/0x8e0
[ 1093.122654]  ___sys_sendmsg+0x5e/0xa0
[ 1093.126312]  ? lock_acquire+0x191/0x330
[ 1093.130142]  ? __local_bh_enable_ip+0x78/0xd0
[ 1093.134493]  ? __local_bh_enable_ip+0x78/0xd0
[ 1093.138843]  ? _raw_spin_unlock_bh+0x2a/0x30
[ 1093.143106]  ? trace_hardirqs_on+0x48/0xd0
[ 1093.147199]  ? __local_bh_enable_ip+0x78/0xd0
[ 1093.151550]  ? release_sock+0x71/0xa0
[ 1093.155216]  ? _raw_spin_unlock_bh+0x2a/0x30
[ 1093.159486]  ? release_sock+0x71/0xa0
[ 1093.163143]  ? lock_acquire+0x191/0x330
[ 1093.166977]  ? sock_setsockopt+0x54f/0xf80
[ 1093.171074]  ? ktime_get_coarse_real_ts64+0xde/0xf0
[ 1093.175945]  ? ktime_get_coarse_real_ts64+0xde/0xf0
[ 1093.180816]  __sys_sendmsg+0x3e/0x80
[ 1093.184396]  __ia32_sys_socketcall+0x20a/0x340
[ 1093.188842]  __do_fast_syscall_32+0x54/0x90
[ 1093.193026]  do_fast_syscall_32+0x29/0x60
[ 1093.197029]  do_SYSENTER_32+0x15/0x20
[ 1093.200686]  entry_SYSENTER_32+0x9f/0xf2
[ 1093.204604] EIP: 0xb7f3b549
[ 1093.207396] Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08
03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f
34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
8d 76
[ 1093.226140] EAX: ffffffda EBX: 00000010 ECX: bff259a4 EDX: 00000000
[ 1093.232397] ESI: 00000000 EDI: 00000006 EBP: bff26ad8 ESP: bff25990
[ 1093.238653] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000282
[ 1093.245453] irq event stamp: 0
[ 1093.248510] hardirqs last  enabled at (0): [<00000000>] 0x0
[ 1093.254086] hardirqs last disabled at (0): [<d9af07cb>]
copy_process+0x41b/0x1870
[ 1093.261563] softirqs last  enabled at (0): [<d9af07cb>]
copy_process+0x41b/0x1870
[ 1093.269042] softirqs last disabled at (0): [<00000000>] 0x0
[ 1093.274615] ---[ end trace 57d0b79ceae71310 ]---


> Full test log link,
> https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201013/testrun/3302070/suite/linux-log-parser/test/check-kernel-warning-1839079/log
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
