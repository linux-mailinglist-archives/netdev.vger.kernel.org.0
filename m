Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2D43459CA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCWIfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCWIek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 04:34:40 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FACC061574;
        Tue, 23 Mar 2021 01:34:39 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id h1so17386258ilr.1;
        Tue, 23 Mar 2021 01:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=pUQTHkjOOGQZfkg5AcixOpdDdSVFLjS2Z3BvpqFaJEY=;
        b=EO5qdr/fENm6OfgHLoHnMixDFilVzV1P80sWnY1W+L9HxRQccK4ZCTdNldjsn6lSgZ
         mGkgn1VNVgEJklco/Ds6bS2G23dKx4OCPpV8oltk1CgQZXD15OrEYWJ5TbXCdGMDuxxa
         7fT0Z6NZlakDfNZ9yVzeMgWFFg43vW2InwizY/ggv2FU3QNIQrNMy52ENU2B8t2xCtt5
         bF1kcroNSVK9NKKFFzo4BNiR19tEzcknVt92UotqhDS9lFdo8dHwz50IPflyc5froHl8
         LhpPvzqKiv4G6pIjRsvKwuTz+UisRL4RNtuNwAshmsanqGwTZONF5VmvLXBI7yxkeA7k
         K6+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=pUQTHkjOOGQZfkg5AcixOpdDdSVFLjS2Z3BvpqFaJEY=;
        b=TlGAjwu5YpRkkelgE1pTrs7MDoRcvclGsV9A838oRUHu17gBrIaPzg9IJaaAdxdcK4
         4o/ueS3mNLtKBOF4AAWZX0ziX6j+XSb9U+csS6Km3HREcbJ04St3Ps5dDCAAgbxCImBH
         sG6oqWfeInKlVJKCnVX9rxAenHIGD4JYOdW6SwYNYVsVd2RLw51TDo8eeYXUOzvQUfih
         vVYt08waWlNdukaK6y7LK2t0rYjgyuOcPSYNuCYoB0VxTCrmOFPgV9IBwqAnyyfg9vYU
         5oKlqkHVjx4P6kdlsvtgtds7WxqxrXbOCpiq/3kFiZa2i4O+g3+Z1p6OfukmbRHLvnvJ
         uVEA==
X-Gm-Message-State: AOAM533BFDiti8rMTf1dzCfbt8lX3AtUAWJatJ37qnS+d72y/T4xAPZK
        F39H83KpYh5TyBleieuuKjkSDygqL6HvENERhB8=
X-Google-Smtp-Source: ABdhPJxzQQyXU+ztVqBTXdsJ8KwY5xraVSaJj8P9mETGj0IWviLOccf96K3mtCAJ70hQmsDKf7caI1tvI30m0rt21eg=
X-Received: by 2002:a05:6e02:12cc:: with SMTP id i12mr3973979ilm.10.1616488479391;
 Tue, 23 Mar 2021 01:34:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210322143714.494603ed@canb.auug.org.au>
In-Reply-To: <20210322143714.494603ed@canb.auug.org.au>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 23 Mar 2021 09:34:03 +0100
Message-ID: <CA+icZUVoE=KzACzAM3QGGqcYUWSr0Pqv8Tboj42Bm+gnO6QmEg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the tip tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Borislav Petkov <bp@suse.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 4:39 AM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> arch/x86/net/bpf_jit_comp.c: In function 'arch_prepare_bpf_trampoline':
> arch/x86/net/bpf_jit_comp.c:2015:16: error: 'ideal_nops' undeclared (first use in this function)
>  2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
>       |                ^~~~~~~~~~
> arch/x86/net/bpf_jit_comp.c:2015:16: note: each undeclared identifier is reported only once for each function it appears in
> arch/x86/net/bpf_jit_comp.c:2015:27: error: 'NOP_ATOMIC5' undeclared (first use in this function); did you mean 'GFP_ATOMIC'?
>  2015 |   memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
>       |                           ^~~~~~~~~~~
>       |                           GFP_ATOMIC
>
> Caused by commit
>
>   a89dfde3dc3c ("x86: Remove dynamic NOP selection")
>
> interacting with commit
>
>   b90829704780 ("bpf: Use NOP_ATOMIC5 instead of emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG")
>
> from the net tree.
>
> I have applied the following merge fix patch.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 22 Mar 2021 14:30:37 +1100
> Subject: [PATCH] x86: fix up for "bpf: Use NOP_ATOMIC5 instead of
>  emit_nops(&prog, 5) for BPF_TRAMP_F_CALL_ORIG"
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I had the same issue yesterday, when I had...

<tip.git#x86/cpu> + <net.git#master>

...on top of Linux v5.12-rc4.
( See [1] and [2] ).

I applied the same fix.

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=x86/cpu&id=a89dfde3dc3c2dbf56910af75e2d8b11ec5308f6
[2] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b9082970478009b778aa9b22d5561eef35b53b63

> ---
>  arch/x86/net/bpf_jit_comp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index db50ab14df67..e2b5da5d441d 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -2012,7 +2012,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
>                 /* remember return value in a stack for bpf prog to access */
>                 emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
>                 im->ip_after_call = prog;
> -               memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
> +               memcpy(prog, x86_nops[5], X86_PATCH_SIZE);
>                 prog += X86_PATCH_SIZE;
>         }
>
> --
> 2.30.0
>
> --
> Cheers,
> Stephen Rothwell
