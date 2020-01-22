Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEB7145C73
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 20:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgAVTaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 14:30:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51078 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbgAVTaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 14:30:07 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so313341wmb.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mvFRnSrf67ClR83ylxljFfQ386JoN2njVtxNW9SXi5M=;
        b=t4jCpDlBUGoa59/8FWRAOkj1GIwFOjlmY9DmhzWrx+Xtl2+DZvm7IVkJVySqO3SrzJ
         O3EdqmB8M+6T6J9eEft8gFhLaRutTPu0pryqMFuB4psDgj+Q+0UH+2qFsVfBxPPL4g7M
         7aJOVpHaPBeUIPrzEqsK3CI20arAkjuMX8QkuQulQLpYu2mQ5zM6xjNbGtMxe0jhZ2Tm
         anioLdD0kuWrSZiMSjOqbN0UlE5wWHfFSmaboQbD9mI5HIUfEWZfpsaGe9DOiW6F3ODz
         zMubHifYxfibg272GOhASN73hPudD0sxh2SkolJd7YFegoiNdB9EbX3omGkW4sAbqBAJ
         1LUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mvFRnSrf67ClR83ylxljFfQ386JoN2njVtxNW9SXi5M=;
        b=k9SpcCPkcZ5wSLkdUKLsq7QdiBXK1nX0W6r9W+U/2A60bgXcyYI8uogi1947E4YXoV
         HeyM3A+CHFlfORFiDqYO58mDyTvlY6h+rRSmPbSTLsW1TgRIFDFFIZ833Pim15Z+g317
         /tOwp+YkU8y4somM3sFI2bzrjhXLrKlvoOHakf8Z8qGz/iQ+1nZFqYGqoWwmZ5w8u3BN
         Ea2KO/nsmYE1/xxFy6P3a1/OKLqu4W4A+OwBs82VGbBpz6jvKlvscx5hYpDesJTHXrJj
         jRVH1tT6Rr1V99J1pItrcV7bOVITFrBLQuKypXpBGP38jqFf+wHtppyH9PoL+cih5iu7
         VIsA==
X-Gm-Message-State: APjAAAWAEBCvN+iX1dYckLKXB+pYAP8eymMXeTA7kFmKeKdaSs1xBL7/
        nNttCxV/H1i/R9ILQ3FX1Cf1SUvKjfmJP9I0jh4=
X-Google-Smtp-Source: APXvYqzfETl7ITn1SL34jVBPgub3rhT3C10cCb2qEoK/QZ+PyStxBG/s0tQM9d/yt7bVsDFUWqhDvV0EiI7/c5cxpI0=
X-Received: by 2002:a05:600c:244:: with SMTP id 4mr4677968wmj.40.1579721405289;
 Wed, 22 Jan 2020 11:30:05 -0800 (PST)
MIME-Version: 1.0
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
 <1579612911-24497-5-git-send-email-sunil.kovvuri@gmail.com> <20200121080058.42b0c473@cakuba>
In-Reply-To: <20200121080058.42b0c473@cakuba>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 23 Jan 2020 00:59:54 +0530
Message-ID: <CA+sq2CenEgQ31St1kGgvWfxgyjv2fhT=Xmpt+QZZrtN3faPAqw@mail.gmail.com>
Subject: Re: [PATCH v4 04/17] octeontx2-pf: Initialize and config queues
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 9:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 21 Jan 2020 18:51:38 +0530, sunil.kovvuri@gmail.com wrote:
> > +dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> > +                        gfp_t gfp)
> > +{
> > +     dma_addr_t iova;
> > +
> > +     /* Check if request can be accommodated in previous allocated page */
> > +     if (pool->page &&
> > +         ((pool->page_offset + pool->rbsize) <= PAGE_SIZE)) {
> > +             pool->pageref++;
> > +             goto ret;
> > +     }
> > +
> > +     otx2_get_page(pool);
> > +
> > +     /* Allocate a new page */
> > +     pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> > +                              pool->rbpage_order);
> > +     if (unlikely(!pool->page))
> > +             return -ENOMEM;
> > +
> > +     pool->page_offset = 0;
> > +ret:
> > +     iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> > +                                   pool->rbsize, DMA_FROM_DEVICE);
> > +     if (!iova) {
> > +             if (!pool->page_offset)
> > +                     __free_pages(pool->page, pool->rbpage_order);
> > +             pool->page = NULL;
> > +             return -ENOMEM;
> > +     }
> > +     pool->page_offset += pool->rbsize;
> > +     return iova;
> > +}
>
> You don't seem to be doing any page recycling if I'm reading this right.
> Can't you use the standard in-kernel page frag allocator
> (netdev_alloc_frag/napi_alloc_frag)?

netdev_alloc_frag() is costly.
eg: it does updates to page's refcount per frag allocation.

Thanks,
Sunil.
