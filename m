Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CCE4545FD
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237027AbhKQLzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbhKQLzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 06:55:02 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFA2C061746
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 03:52:04 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 131so6674481ybc.7
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 03:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IXJmB9DsrkP0Hl2X6TbOwJcxLtK5wGiHx+4l+DLgyu0=;
        b=UvbMV3fyqh6gAOb0SdTanMwPJxP/u4+ZL3yFDfKzV1czXOZixPZVswla4YNGlaenLr
         2DEy1i1zqG2tkdnwMSE9O8bQcuFyULUcaaemhydffoKdJlzSTM4s0we6p1r0IiL+G0hh
         fjp1nklrcymDLzodFWHrg8DwSt6lN4TyT7b3WdJwp/wO8cac6NvWRTELTwUJfAGhetlm
         RQaODfMP4oI5RRf6Tnq2M8cPUJGJnhU+EfFn8rqdhlP+A9Zmf3+isI1QbteEbjukex08
         06569AbcdlEuTVYeEBsqzQyjTQsynuwlbmbTwvtYdvcd/dCCQ/Un8d9C4QHY4r41JL9y
         LaKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IXJmB9DsrkP0Hl2X6TbOwJcxLtK5wGiHx+4l+DLgyu0=;
        b=EvCi7DWK+iC5miaqvwp2vwoKN9yCn1Kv8E92/D8mfSJApOrZk4uERITweqBWGvbx4Q
         e+pLi82EgJ/RezfR+9AfhQpodRa1XL+ITJXgH/LiO0csxuquUKPDUPwsx8HIDtdjtqEj
         9L5DwMHLbQuRk3SOcNTuckau8ap4e+U6kr00zmKqfo2CsolQ8fAd/HJAF4ihtwVXAdvA
         GeXE6lzmbKa39hK+MIsQRm2lKVGbKwKjMSMWc/ncYov0cAiQlOGzFVNh2H4ugCUf9gxY
         LGBrXbRqyjL8lzO84RInqv8xjkeQ3rydCvidlcDSxkw2F5TbX+yHWoHysP++dQ970YdH
         OOBg==
X-Gm-Message-State: AOAM530mP6ferf47W6t856f+UdbEWmeD5zv3FydkxyRetgStDegJjw1B
        Hlqc2UwEzWBqAMAXyOP7EpTTg/h9tjrULX10+rinOQ==
X-Google-Smtp-Source: ABdhPJz2VtCKhzu8qZQihL+co6Mjb8uHqzCSoeW/gU9T0TjHNu8foK/mFxIYBP2LjWFnrz17Dbu/9zaW30o6I6X2Gy0=
X-Received: by 2002:a25:c68a:: with SMTP id k132mr16877021ybf.531.1637149923308;
 Wed, 17 Nov 2021 03:52:03 -0800 (PST)
MIME-Version: 1.0
References: <20211117075652.58299-1-linyunsheng@huawei.com> <b7476c7a-3fd2-b774-9123-929969d00b28@redhat.com>
In-Reply-To: <b7476c7a-3fd2-b774-9123-929969d00b28@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 17 Nov 2021 13:51:27 +0200
Message-ID: <CAC_iWjK8tmPvPZpribvi=_Qz1gAPGFDB_Z-i17KLQufRy-dSYQ@mail.gmail.com>
Subject: Re: [PATCH net] page_pool: Revert "page_pool: disable dma mapping support..."
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, akpm@linux-foundation.org, peterz@infradead.org,
        vbabka@suse.cz, willy@infradead.org, will@kernel.org,
        feng.tang@intel.com, jgg@ziepe.ca, ebiederm@xmission.com,
        aarcange@redhat.com, guillaume.tucker@collabora.com,
        Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 at 13:48, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
> Added CC: linux-mm@kvack.org
>
> On 17/11/2021 08.56, Yunsheng Lin wrote:
> > This reverts commit d00e60ee54b12de945b8493cf18c1ada9e422514.
> >
> > As reported by Guillaume in [1]:
> > Enabling LPAE always enables CONFIG_ARCH_DMA_ADDR_T_64BIT
> > in 32-bit systems, which breaks the bootup proceess when a
> > ethernet driver is using page pool with PP_FLAG_DMA_MAP flag.
> > As we were hoping we had no active consumers for such system
> > when we removed the dma mapping support, and LPAE seems like
> > a common feature for 32 bits system, so revert it.
> >
> > 1. https://www.spinics.net/lists/netdev/msg779890.html
> >
> > Fixes: d00e60ee54b1 ("page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA")
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> > ---
> >   include/linux/mm_types.h | 13 ++++++++++++-
> >   include/net/page_pool.h  | 12 +++++++++++-
> >   net/core/page_pool.c     | 10 ++++------
> >   3 files changed, 27 insertions(+), 8 deletions(-)
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
> Too bad that we have to keep this code-uglyness in struct page, and
> handling in page_pool.

Indeed :(

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>
>
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index bb8c6f5f19bc..c3a6e6209600 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -105,7 +105,18 @@ struct page {
> >                       struct page_pool *pp;
> >                       unsigned long _pp_mapping_pad;
> >                       unsigned long dma_addr;
> > -                     atomic_long_t pp_frag_count;
> > +                     union {
> > +                             /**
> > +                              * dma_addr_upper: might require a 64-bit
> > +                              * value on 32-bit architectures.
> > +                              */
> > +                             unsigned long dma_addr_upper;
> > +                             /**
> > +                              * For frag page support, not supported in
> > +                              * 32-bit architectures with 64-bit DMA.
> > +                              */
> > +                             atomic_long_t pp_frag_count;
> > +                     };
> >               };
> >               struct {        /* slab, slob and slub */
> >                       union {
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 3855f069627f..a4082406a003 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -216,14 +216,24 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
> >       page_pool_put_full_page(pool, page, true);
> >   }
> >
> > +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT      \
> > +             (sizeof(dma_addr_t) > sizeof(unsigned long))
> > +
> >   static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> >   {
> > -     return page->dma_addr;
> > +     dma_addr_t ret = page->dma_addr;
> > +
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> > +             ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
> > +
> > +     return ret;
> >   }
> >
> >   static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> >   {
> >       page->dma_addr = addr;
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> > +             page->dma_addr_upper = upper_32_bits(addr);
> >   }
> >
> >   static inline void page_pool_set_frag_count(struct page *page, long nr)
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 9b60e4301a44..1a6978427d6c 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -49,12 +49,6 @@ static int page_pool_init(struct page_pool *pool,
> >        * which is the XDP_TX use-case.
> >        */
> >       if (pool->p.flags & PP_FLAG_DMA_MAP) {
> > -             /* DMA-mapping is not supported on 32-bit systems with
> > -              * 64-bit DMA mapping.
> > -              */
> > -             if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > -                     return -EOPNOTSUPP;
> > -
> >               if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
> >                   (pool->p.dma_dir != DMA_BIDIRECTIONAL))
> >                       return -EINVAL;
> > @@ -75,6 +69,10 @@ static int page_pool_init(struct page_pool *pool,
> >                */
> >       }
> >
> > +     if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> > +         pool->p.flags & PP_FLAG_PAGE_FRAG)
> > +             return -EINVAL;
> > +
> >       if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
> >               return -ENOMEM;
> >
> >
>
