Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87643525F8
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 06:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbhDBEJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 00:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhDBEJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 00:09:47 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E08BC0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 21:09:45 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id x16so3672736wrn.4
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 21:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=meCY3g4ZddcaVFsiixJeKxINO9meMOC/HmZiu7pSnis=;
        b=JbBObYJHzVzwWjRYrtVEvwWuBeATrp4It6u7NUrI90LOdM+HfoHmV+3Cvi1sb96OPI
         D21x4RUhRG7GTbRhJYZBSUERMEl5wYrQteEPDtOz8xReUQwRPvrq956//qiakIsVMpjE
         GuLs/mIehb/szAS4EHzdm089SS4+pgmwOJX0XG4qSmZU+qMtvrJkQ8/i8EsJyqZBeYj3
         mSNZOrkFdJE4wskQEjbVErZtcpMueMUg/RsR35auYUwjCIwe1iu0aL+Dy4e34WVban3h
         OduQYY0kFjCT1ETwZQgfn0o5ZeDeDbiAOgNHue6+HuvvRkuKfN5NM3fq+4p392TL+Cu4
         sr9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=meCY3g4ZddcaVFsiixJeKxINO9meMOC/HmZiu7pSnis=;
        b=M2O9M+fca7YuEc8rZRnCuXcmGOXZBHeif+FSn+CnGGQtwf3CbAakWN92NmFnpCwUDu
         rO7HnbrElGp0/CNQMPcD2ODHC9D/eSE4ezAbckmRrmXa59lwhpU/Qg6f6fFrRi3mr35I
         ItWvfgVXD3zdrTNePvtfANlWVvgIaQ97FloUMVtcGsFotLqsvFiPru4tclWnTHcN5Kad
         /aeao9wY+CiSkFkFXTh8PcdpwfZPqC/P+22acw+AKKx3r8EeWDcm+ISVvvmsXgDdZ52M
         /9REfqDtqr21ibB4Rea8w8cFEtTSzDMQ1JvuFg3gcyhOgCx8tg6lK43wuBXh+TpFKYur
         9U1g==
X-Gm-Message-State: AOAM533Jm/2Z6UE5xNthDhjQowAKB40cYAI2PbJ2hKO5M6QauYDld+ki
        dv74T9D0kn8oNUuBnuGNUEjsmVCrmE+CS9at8a6Awg==
X-Google-Smtp-Source: ABdhPJxDjcPeZhhqphDAJyUV6xkBRwIEwREpi6+dv9r+XRHq/ftq4auQOWCKv0PCii8iWP0QH2ZDPwnwZjAUlOUXv9M=
X-Received: by 2002:adf:9544:: with SMTP id 62mr12946985wrs.128.1617336583795;
 Thu, 01 Apr 2021 21:09:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210401002442.2fe56b88@xhacker> <20210401002551.0ddbacf9@xhacker>
In-Reply-To: <20210401002551.0ddbacf9@xhacker>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 2 Apr 2021 09:39:32 +0530
Message-ID: <CAAhSdy0N427hw6sK5NEbrs_bb2N9y6aDOrCLO+mcpysLvaaoPQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] riscv: Mark some global variables __ro_after_init
To:     Jisheng Zhang <jszhang3@mail.ustc.edu.cn>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        kasan-dev@googlegroups.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:01 PM Jisheng Zhang
<jszhang3@mail.ustc.edu.cn> wrote:
>
> From: Jisheng Zhang <jszhang@kernel.org>
>
> All of these are never modified after init, so they can be
> __ro_after_init.
>
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Looks good to me.

Reviewed-by: Anup Patel <anup@brainfault.org>

Regards,
Anup

> ---
>  arch/riscv/kernel/sbi.c  | 8 ++++----
>  arch/riscv/kernel/smp.c  | 4 ++--
>  arch/riscv/kernel/time.c | 2 +-
>  arch/riscv/kernel/vdso.c | 4 ++--
>  arch/riscv/mm/init.c     | 6 +++---
>  5 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
> index d3bf756321a5..cbd94a72eaa7 100644
> --- a/arch/riscv/kernel/sbi.c
> +++ b/arch/riscv/kernel/sbi.c
> @@ -11,14 +11,14 @@
>  #include <asm/smp.h>
>
>  /* default SBI version is 0.1 */
> -unsigned long sbi_spec_version = SBI_SPEC_VERSION_DEFAULT;
> +unsigned long sbi_spec_version __ro_after_init = SBI_SPEC_VERSION_DEFAULT;
>  EXPORT_SYMBOL(sbi_spec_version);
>
> -static void (*__sbi_set_timer)(uint64_t stime);
> -static int (*__sbi_send_ipi)(const unsigned long *hart_mask);
> +static void (*__sbi_set_timer)(uint64_t stime) __ro_after_init;
> +static int (*__sbi_send_ipi)(const unsigned long *hart_mask) __ro_after_init;
>  static int (*__sbi_rfence)(int fid, const unsigned long *hart_mask,
>                            unsigned long start, unsigned long size,
> -                          unsigned long arg4, unsigned long arg5);
> +                          unsigned long arg4, unsigned long arg5) __ro_after_init;
>
>  struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
>                         unsigned long arg1, unsigned long arg2,
> diff --git a/arch/riscv/kernel/smp.c b/arch/riscv/kernel/smp.c
> index ea028d9e0d24..504284d49135 100644
> --- a/arch/riscv/kernel/smp.c
> +++ b/arch/riscv/kernel/smp.c
> @@ -30,7 +30,7 @@ enum ipi_message_type {
>         IPI_MAX
>  };
>
> -unsigned long __cpuid_to_hartid_map[NR_CPUS] = {
> +unsigned long __cpuid_to_hartid_map[NR_CPUS] __ro_after_init = {
>         [0 ... NR_CPUS-1] = INVALID_HARTID
>  };
>
> @@ -85,7 +85,7 @@ static void ipi_stop(void)
>                 wait_for_interrupt();
>  }
>
> -static struct riscv_ipi_ops *ipi_ops;
> +static struct riscv_ipi_ops *ipi_ops __ro_after_init;
>
>  void riscv_set_ipi_ops(struct riscv_ipi_ops *ops)
>  {
> diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
> index 1b432264f7ef..8217b0f67c6c 100644
> --- a/arch/riscv/kernel/time.c
> +++ b/arch/riscv/kernel/time.c
> @@ -11,7 +11,7 @@
>  #include <asm/processor.h>
>  #include <asm/timex.h>
>
> -unsigned long riscv_timebase;
> +unsigned long riscv_timebase __ro_after_init;
>  EXPORT_SYMBOL_GPL(riscv_timebase);
>
>  void __init time_init(void)
> diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
> index 3f1d35e7c98a..25a3b8849599 100644
> --- a/arch/riscv/kernel/vdso.c
> +++ b/arch/riscv/kernel/vdso.c
> @@ -20,8 +20,8 @@
>
>  extern char vdso_start[], vdso_end[];
>
> -static unsigned int vdso_pages;
> -static struct page **vdso_pagelist;
> +static unsigned int vdso_pages __ro_after_init;
> +static struct page **vdso_pagelist __ro_after_init;
>
>  /*
>   * The vDSO data page.
> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index 76bf2de8aa59..719ec72ef069 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -149,11 +149,11 @@ void __init setup_bootmem(void)
>  }
>
>  #ifdef CONFIG_MMU
> -static struct pt_alloc_ops pt_ops;
> +static struct pt_alloc_ops pt_ops __ro_after_init;
>
> -unsigned long va_pa_offset;
> +unsigned long va_pa_offset __ro_after_init;
>  EXPORT_SYMBOL(va_pa_offset);
> -unsigned long pfn_base;
> +unsigned long pfn_base __ro_after_init;
>  EXPORT_SYMBOL(pfn_base);
>
>  pgd_t swapper_pg_dir[PTRS_PER_PGD] __page_aligned_bss;
> --
> 2.31.0
>
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
