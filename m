Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CB028B063
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgJLIiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgJLIiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:38:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76246C0613CE;
        Mon, 12 Oct 2020 01:38:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id e7so3845328pfn.12;
        Mon, 12 Oct 2020 01:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iMH7sgbBpO8JCmtjjKhnakg0TmKyze0aEEJgsqLeYIE=;
        b=nlvs5EPs/dwH/lL3qgYtYD9AT3ZQcOEIwvdWUz0sYulkSTNyd1lbo6YyoYgxru2SNr
         asvP7hcMl2ZKXowLwkBgDW0u9kJRwzNa9Uyyvyj3McfMrTG+QEbdDyABtk9V1qJLkDRk
         cXRzeRHJRUpDaJq2E/fmPUxovhMIyGnIDLILWN3Own2gUMPmbxvBzb85HbMh7LSnzBJ2
         TBscZYCbYiWopdnVfdlza1vwHsK6v/xING/Jk4z8saG6P5Za90tWdfS7LnODJm8CuUBg
         oJS5A7aBHwysJ0t9iPQua/RI40Ir9geg2w0E4+NSOiTvtWr7rl2E6MHZl9dJ7rEoAERz
         Bhqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iMH7sgbBpO8JCmtjjKhnakg0TmKyze0aEEJgsqLeYIE=;
        b=gqHcHeP2bXWMh1AWouP80Q3sQ2p246xvPfQVPhI/7MGzsjkFhWP2wmOAKZ9MZS/SZz
         e+rS5cveqe3VCPfdMKse3Ip8fuS1i1p2uZl56+g/6bL9tQgSF4KG9K47InHcHEbrVSb/
         dX9Ae+ch4FT5bZxzOFArnSigCchwuHPIetJGsbyFu+nO63+YEENiynXfsoU74/XHP/D/
         pXhvND5p8LkrA+YYqJE1DOHiufELsADfAGZdxfjxyn5ZoEzsdqu6Ve2+RKC/1xDYqOpO
         /3sWTHfjT0MnozfjlSNryNXhPTlkgahGyPqCfDYJ1SGuQBmyoUjRu5dTK64M4QsvkkjV
         LjUQ==
X-Gm-Message-State: AOAM531pRZ0AfMULqbldPK4t6NEZ44Gatp30v91wgJ5HSlr5Kcdtap0K
        bZtJcponGffZhvK66zNvv+nXuKzAWPHPV63db2c=
X-Google-Smtp-Source: ABdhPJwSK/PvprgoSckBeUzMPl6dCrsP0AChH6EjEKb+lWaHFUJedvrclSmbFGSZ0mIT8NY0jDrIFzZui0Z7515wxJs=
X-Received: by 2002:a17:90a:ab81:: with SMTP id n1mr19881593pjq.117.1602491885983;
 Mon, 12 Oct 2020 01:38:05 -0700 (PDT)
MIME-Version: 1.0
References: <1602166338-21378-1-git-send-email-magnus.karlsson@gmail.com> <43b0605d-f0c9-b81c-4d16-344a7832e083@iogearbox.net>
In-Reply-To: <43b0605d-f0c9-b81c-4d16-344a7832e083@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 12 Oct 2020 10:37:54 +0200
Message-ID: <CAJ8uoz3nfDe0a9Vp0NmnHVv5qM+kvqR-f6Yd0keKSqctNzi6=g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: introduce padding between ring pointers
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 5:03 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/8/20 4:12 PM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Introduce one cache line worth of padding between the producer and
> > consumer pointers in all the lockless rings. This so that the HW
> > adjacency prefetcher will not prefetch the consumer pointer when the
> > producer pointer is used and vice versa. This improves throughput
> > performance for the l2fwd sample app with 2% on my machine with HW
> > prefetching turned on.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Applied, thanks!
>
> >   net/xdp/xsk_queue.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> > index dc1dd5e..3c235d2 100644
> > --- a/net/xdp/xsk_queue.h
> > +++ b/net/xdp/xsk_queue.h
> > @@ -15,6 +15,10 @@
> >
> >   struct xdp_ring {
> >       u32 producer ____cacheline_aligned_in_smp;
> > +     /* Hinder the adjacent cache prefetcher to prefetch the consumer pointer if the producer
> > +      * pointer is touched and vice versa.
> > +      */
> > +     u32 pad ____cacheline_aligned_in_smp;
> >       u32 consumer ____cacheline_aligned_in_smp;
> >       u32 flags;
> >   };
> >
>
> I was wondering whether we should even generalize this further for reuse
> elsewhere e.g. ...
>
> diff --git a/include/linux/cache.h b/include/linux/cache.h
> index 1aa8009f6d06..5521dab01649 100644
> --- a/include/linux/cache.h
> +++ b/include/linux/cache.h
> @@ -85,4 +85,17 @@
>   #define cache_line_size()      L1_CACHE_BYTES
>   #endif
>
> +/*
> + * Dummy element for use in structs in order to pad a cacheline
> + * aligned element with an extra cacheline to hinder the adjacent
> + * cache prefetcher to prefetch the subsequent struct element.
> + */
> +#ifndef ____cacheline_padding_in_smp
> +# ifdef CONFIG_SMP
> +#  define ____cacheline_padding_in_smp u8 :8 ____cacheline_aligned_in_smp
> +# else
> +#  define ____cacheline_padding_in_smp
> +# endif /* CONFIG_SMP */
> +#endif
> +
>   #endif /* __LINUX_CACHE_H */
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index cdb9cf3cd136..1da36423e779 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -15,11 +15,9 @@
>
>   struct xdp_ring {
>          u32 producer ____cacheline_aligned_in_smp;
> -       /* Hinder the adjacent cache prefetcher to prefetch the consumer
> -        * pointer if the producer pointer is touched and vice versa.
> -        */
> -       u32 pad ____cacheline_aligned_in_smp;
> +       ____cacheline_padding_in_smp;
>          u32 consumer ____cacheline_aligned_in_smp;
> +       ____cacheline_padding_in_smp;
>          u32 flags;
>   };

This should be beneficial in theory, though I could not measure any
statistically significant improvement. Though, the flags variable is
touched much less frequently than the producer and consumer pointers,
so that might explain it. We also need to make the compiler allocate
flags to a cache line 128 bytes (2 cache lines) from the consumer
pointer like this:

u32 consumer ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;
u32 flags ____cacheline_aligned_in_smp;

> ... was there any improvement to also pad after the consumer given the struct
> xdp_ring is also embedded into other structs?

Good idea. Yes, I do believe I see another ~0.4% increase and more
stable high numbers when trying this out. The xdp_ring is followed by
the ring descriptors themselves in both the rt/tx rings and the umem
rings. And these rings are quite large, 2K in the sample app, so
accessed less frequently (1/8th of the time with a batch size of 256
and ring size 2K) which might explain the lower increase. In the end,
I ended up with the following struct:

u32 producer ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;
u32 consumer ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;
u32 flags ____cacheline_aligned_in_smp;
____cacheline_padding_in_smp;

Do you want to submit a patch, or shall I do it? I like your
____cacheline_padding_in_smp better than my explicit "padN" member.

Thanks: Magnus

> Thanks,
> Daniel
