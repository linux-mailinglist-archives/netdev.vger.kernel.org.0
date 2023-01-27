Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1CB67E999
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbjA0Pgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbjA0Pgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:36:45 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B01222D2;
        Fri, 27 Jan 2023 07:36:44 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id g23so5294442plq.12;
        Fri, 27 Jan 2023 07:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tD8oSVYhnxG/S8yW3kIWIJCg9bTAW+68+2JbtNleSCo=;
        b=RMDP1kGzSOTJJ3aNoxIVuxO9AxlFf855MBul/yaIxbGi0fcchvjqg+TkbOKK8lCVYg
         +ffs7bTNtnb6C5jrICrCL2e38SG4P43naHmpWb8oLRW34HNeT2+6orRNTHT412N43dov
         vYX6ic3MDQ9hpH5RQPCVySrQLph44iwS4l7QytycWeyZC51wqAnIdXNNuceBW1gn3KKk
         0izYFqUDfto1vu0j5hM7h7XBPmRP1TujbnUtpLuWYe32uOC3ZzXDOrzPa1iW1Y7pd9+f
         fmW2u9EMYawkPVAeZt+nqy2uEh4pdwnyEcwoxEMm8E6hxzZmU9q0mZX1rEuA34duI2Pz
         Ho9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tD8oSVYhnxG/S8yW3kIWIJCg9bTAW+68+2JbtNleSCo=;
        b=IlBgVc9VPTQ+/EqYJ1IBfs3VhXLr/9dr8i7tP3bpMbdYGtyN1hfnkEaQlfuPBYvXE5
         SVTFRSYaRcwuJ+3UN0S4jlMu/V4jpnOVgvoM1+fk06YtZf110aop1iqCYMHMEyyI5MU+
         Ke53I468/PQQlyOT+DKSrm4gioltmWFiACFLUHU+xym4eb/wykg9UNwcIiszu8khp973
         QdBR6pKWtnzqb+yOC5JgM5USV458vKokhB17zgbWcodfsfKDW1bc7WJz/BW2z8qMwojt
         sOkfwce463BtNXTF2ApxjnJGjp/ADSDskzBa1dq9U8wUuVlrL9cJoekaKekmQisGifcI
         NczQ==
X-Gm-Message-State: AO0yUKUVD13ollpcqHY0QPdhq5L5jliFXp+DdPEMGrCLN6FdHHUwH0xJ
        h9wksIah1dNAAlbeycWnT4JEFuV9LTkvcDwH8yp7NqYy
X-Google-Smtp-Source: AK7set+y7XUzy08N/G4vmB5/kI1OzTqGqppCVHGtgiFEF8RsGlKNvFXzRWOE9vzbZon0RcoXgvrjk+0gJACobrSkvNU=
X-Received: by 2002:a17:90a:e50f:b0:22c:113f:116f with SMTP id
 t15-20020a17090ae50f00b0022c113f116fmr1268497pjy.175.1674833803705; Fri, 27
 Jan 2023 07:36:43 -0800 (PST)
MIME-Version: 1.0
References: <20230127101627.891614-1-ilias.apalodimas@linaro.org>
In-Reply-To: <20230127101627.891614-1-ilias.apalodimas@linaro.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 27 Jan 2023 07:36:32 -0800
Message-ID: <CAKgT0UdGMbaNDX4xEknXa9MAXAW6PoU1y4ogVFycn6jBFuDYiQ@mail.gmail.com>
Subject: Re: [PATCH] page_pool: add a comment explaining the fragment counter usage
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 2:16 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> When reading the page_pool code the first impression is that keeping
> two separate counters, one being the page refcnt and the other being
> fragment pp_frag_count, is counter-intuitive.
>
> However without that fragment counter we don't know when to reliably
> destroy or sync the outstanding DMA mappings.  So let's add a comment
> explaining this part.
>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  include/net/page_pool.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 813c93499f20..115dbce6d431 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -277,6 +277,14 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>                                   unsigned int dma_sync_size,
>                                   bool allow_direct);
>
> +/* pp_frag_count is our number of outstanding DMA maps.  We can't rely on the
> + * page refcnt for that as we don't know who might be holding page references
> + * and we can't reliably destroy or sync DMA mappings of the fragments.
> + *

This isn't quite right. Basically each frag is writable by the holder
of the frag. As such pp_frag_count represents the number of writers
who could still update the page either in the form of updating
skb->data or via DMA from the device.

> + * When pp_frag_count reaches 0 we can either recycle the page, if the page
> + * refcnt is 1, or return it back to the memory allocator and destroy any
> + * mappings we have.
> + */
>  static inline void page_pool_fragment_page(struct page *page, long nr)
>  {
>         atomic_long_set(&page->pp_frag_count, nr);

The rest of this looks good to me.
