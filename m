Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9976411363
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 08:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfEBGcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 02:32:03 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44399 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfEBGcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 02:32:02 -0400
Received: by mail-io1-f66.google.com with SMTP id r71so1072084iod.11;
        Wed, 01 May 2019 23:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WGMCFAzGm3CobSQocX4r+FnTqfDTBc1bpPU4QQeOhDY=;
        b=CXMeVfq0ALu7tWgwUP+PeWaHpT2p9eKmz76o3zD9hnt2O7wj9FEZhcm1iubi+6qJ25
         HCS8zEdI8HANKXKt2mpN2Cdais0yzlnLPQwuKj8nfm3HaDOeC+56GC1bSKkw+BfhnFJK
         FJYMW+2Xr9J/QobmDEOxMkIp+i5uPgikmL++JBu0XHAKmFX2fPHIJ9QfpsQ+a854gnEG
         kYAKMoqhtss6NzBF7uq23XkK8oJIPVZedn2UAYQZg5ZDk5odHm7IFl90rG5+7B7t/vPV
         9Rva7vsPetYxp9WbjYyh20VWER4uA8+lX0Xv5R29M6aMUo26MdIuGqllERStuHRQRQHU
         27dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WGMCFAzGm3CobSQocX4r+FnTqfDTBc1bpPU4QQeOhDY=;
        b=pO7ciQ62nuPlM8yr4QeIAeFMxldwFj437Xau4+R0i1RyyCTxcU5zF984Ykr2YorGdM
         k9mZv8JIb+tyrOfvvxxx50Fl83dHEo3Y6NbRFPYCM4nPCL2jTKAAep0A9shCBCICgkna
         6gn7C9z8zvx54b1+BJmAd3gJ5moWfp3NuvRCZqIbBaofZLf+8UUl9cHHJ9ZKEbPNMUfO
         vd6S71knpXJ9EeJuGfCGbvZmynio3ljQXd4HZM+wB69S4+B9Xw8cK4ZQ0FOo2iJCQOZb
         MvBC/EF4BeMq2S9N1NnEbhVS1vFMt7t4ONrRT4ZHUUUkR/JqT28M9WRegmh9r98vICWn
         3IhQ==
X-Gm-Message-State: APjAAAWFYq5oNWJcVOxATShRM5zlEHKk2LbRmTbBmnf1odE90RnFUx1C
        qMzi5Y3h0P53MzOmZ4aASmERFC6/0jYtEDwe+Us=
X-Google-Smtp-Source: APXvYqxvraDLWRHUAd6drNfVgpeSbYfAIVhDqH2YhhHfFHihnxUJyYTI75XZixavJtyWEnYfKEfxjxVAjzKL3wgRxnE=
X-Received: by 2002:a05:6602:21d3:: with SMTP id c19mr1262943ioc.233.1556778721541;
 Wed, 01 May 2019 23:32:01 -0700 (PDT)
MIME-Version: 1.0
References: <1556751209-4778-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1556751209-4778-1-git-send-email-vgupta@synopsys.com>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 1 May 2019 23:31:25 -0700
Message-ID: <CAH3MdRVkUFfwKkgT-pi-RLBpcEf6n0bAwWZOu-=7+qctPTCpkw@mail.gmail.com>
Subject: Re: [PATCH] tools/bpf: fix perf build error with uClibc (seen on ARC)
To:     Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, Wang Nan <wangnan0@huawei.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-snps-arc@lists.infradead.org,
        linux-perf-users@vger.kernel.org, arnaldo.melo@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 1, 2019 at 3:55 PM Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>
> When build perf for ARC recently, there was a build failure due to lack
> of __NR_bpf.
>
> | Auto-detecting system features:
> |
> | ...                     get_cpuid: [ OFF ]
> | ...                           bpf: [ on  ]
> |
> | #  error __NR_bpf not defined. libbpf does not support your arch.
>     ^~~~~
> | bpf.c: In function 'sys_bpf':
> | bpf.c:66:17: error: '__NR_bpf' undeclared (first use in this function)
> |  return syscall(__NR_bpf, cmd, attr, size);
> |                 ^~~~~~~~
> |                 sys_bpf
>
> The fix is to define a fallbak __NR_bpf.
>
> The obvious fix with be __arc__ specific value, but i think a better fix
> is to use the asm-generic uapi value applicable to ARC as well as any new
> arch (hopefully we don't add an old existing arch here). Otherwise I can
> just add __arc__

I prefer explicitly guard with __arc__. We still have arm/sh with different
__NR_bpf values. This patch will give wrong bpf syscall values for these
two architectures.

Alternatively, you could add support for arm/sh together
with your current patch. Hopefully I did not miss other architectures.

>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  tools/lib/bpf/bpf.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 9cd015574e83..2c5eb7928400 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -47,7 +47,10 @@
>  # elif defined(__s390__)
>  #  define __NR_bpf 351
>  # else
> -#  error __NR_bpf not defined. libbpf does not support your arch.
> +/*
> + * Any non listed arch (new) will have to asm-generic uapi complient
> + */
> +#  define __NR_bpf 280
>  # endif
>  #endif
>
> --
> 2.7.4
>
