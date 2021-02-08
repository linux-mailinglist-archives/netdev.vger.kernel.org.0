Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81648314229
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236975AbhBHVqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbhBHVoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 16:44:32 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D48C061788
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 13:43:50 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id f2so4725728ioq.2
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 13:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=znzdsgoVi1+0y3RXw53JIJIEVs7j8jUvaVY8J6otDH0=;
        b=QfYHXUENEs9K3UAoRvi2Lo98SS3pmV13yLm8mGevjuWr5IVeN4950X1hhPsgrqlzsv
         Ew6CIgKmqTlMPSoXLYvLandph9/KJzm99azFEb7B7cfIfyl7h3U+KTOYNIzPOul1Vt1E
         xw/CkN5ON6FPizf+/eW4BhDPJemAlu5Fr37f9Xca5+vtEhnn5yikJU8dQnPsjEcEgvUO
         7d4rjSQshKdSsqtLlbH9RUe/9AUeIVdHgbpX4yuzF2TaAD4ScGLfZ2CwVuInlTuxxfO6
         Rn+eEF/stKcrWZOaISfjHnKeEXhQn2VPeo0GPq1i31akv33AOXUyDnn3hPf1nhrn/An7
         dI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=znzdsgoVi1+0y3RXw53JIJIEVs7j8jUvaVY8J6otDH0=;
        b=RVxI5Ms3rToYBvjgMWHsLt+v4ziSBLd60I9d1dcnMkFwo00SuDxRUMJ1+vIwJTIfMg
         2wSYMg+nJGs0JOWC6j0UGt/bCTs/RctbcOwkadWN1Sxj7WWrpl0RR4Piyf0PROmyy3Ni
         kG5kVt1npeH0nlWcCD2O17+g0+wPGdmpRcG26XsBoXpXEGsfwwfypGxOywv39AL4isGr
         rJpuYPRFe1d1FERqeiACEuMktjRVwSQA2oJi30eBFiQFxEWq7jMpMLBnrMuKjPe18/7X
         sdb+7rIupATzYKbv04Jw17f2LaF5wK6ki+nOkCcKrdjJJBWk6F3HMuHkS1c18wUk+HTv
         FfCQ==
X-Gm-Message-State: AOAM532CDtVr48YsyNdHueo6MZL3niFe4UtspeC/RDxpd6/weQ2enkB3
        Km/+QwsVZDnPeXkIWzLYKTV0p0ElepvLQJitpr4B8lpo5m0noA==
X-Google-Smtp-Source: ABdhPJy9LY1Fzp317OoUTrxQtoUSYf6l3C6vXLLZwVzvxXklDl5j2II0fIGP0bmODr1RTQnXxA2RK1zD8hLzj+eoUZQ=
X-Received: by 2002:a05:6638:b12:: with SMTP id a18mr20013546jab.114.1612820629986;
 Mon, 08 Feb 2021 13:43:49 -0800 (PST)
MIME-Version: 1.0
References: <20210208171917.1088230-1-atenart@kernel.org> <20210208171917.1088230-8-atenart@kernel.org>
In-Reply-To: <20210208171917.1088230-8-atenart@kernel.org>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 13:43:39 -0800
Message-ID: <CAKgT0Ue1mYiuP1-qAovV4WwUrJ_k2Ug0tB+syzzHRtHeMiz7ww@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/12] net: remove the xps possible_mask
To:     Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 9:19 AM Antoine Tenart <atenart@kernel.org> wrote:
>
> Remove the xps possible_mask. It was an optimization but we can just
> loop from 0 to nr_ids now that it is embedded in the xps dev_maps. That
> simplifies the code a bit.
>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>  net/core/dev.c       | 43 ++++++++++++++-----------------------------
>  net/core/net-sysfs.c |  4 ++--
>  2 files changed, 16 insertions(+), 31 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index abbb2ae6b3ed..d0c07ccea2e5 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2505,33 +2505,27 @@ static void reset_xps_maps(struct net_device *dev,
>         kfree_rcu(dev_maps, rcu);
>  }
>
> -static void clean_xps_maps(struct net_device *dev, const unsigned long *mask,
> +static void clean_xps_maps(struct net_device *dev,
>                            struct xps_dev_maps *dev_maps, u16 offset, u16 count,
>                            bool is_rxqs_map)
>  {
> -       unsigned int nr_ids = dev_maps->nr_ids;
>         bool active = false;
>         int i, j;
>
> -       for (j = -1; j = netif_attrmask_next(j, mask, nr_ids), j < nr_ids;)
> -               active |= remove_xps_queue_cpu(dev, dev_maps, j, offset,
> -                                              count);
> +       for (j = 0; j < dev_maps->nr_ids; j++)
> +               active |= remove_xps_queue_cpu(dev, dev_maps, j, offset, count);
>         if (!active)
>                 reset_xps_maps(dev, dev_maps, is_rxqs_map);
>
> -       if (!is_rxqs_map) {
> -               for (i = offset + (count - 1); count--; i--) {
> +       if (!is_rxqs_map)
> +               for (i = offset + (count - 1); count--; i--)
>                         netdev_queue_numa_node_write(
> -                               netdev_get_tx_queue(dev, i),
> -                               NUMA_NO_NODE);
> -               }
> -       }
> +                               netdev_get_tx_queue(dev, i), NUMA_NO_NODE);
>  }
>

This violates the coding-style guide for the kernel. The if statement
should still have braces as the for loop and
netdev_queue_numa_node_write are more than a single statement. I'd be
curious to see if checkpatch also complains about this because it
probably should.

For reference see the end of section 3.0 in
Documentation/process/coding-style.rst.

Other than that the rest of the patch seemed to be fine.
