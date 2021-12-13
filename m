Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71A4472CB6
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhLMNAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbhLMNAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 08:00:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912C1C061574;
        Mon, 13 Dec 2021 05:00:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso13255078pjl.3;
        Mon, 13 Dec 2021 05:00:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QX8Aew80hIXRTchz8+FcQ8MQ/fpacOHED6ScaQzbTlY=;
        b=LwC+k8Ww6UvhnLh6TjOJkJwCLLR9bPRPiZSmcyqIaGaKEZaXvsikX1yS5dywl4FkEZ
         TIGz7YNKhmr60ZJ/NEx11alohtq6L2dsl5wmPl8/OY92SvO/XkvjPT8FSrZkjYSXH4wc
         ifOuS2kwSJXTtTVUtG6/ZWIyxHq64fGiGDNLOTnSZIfRxpvjL/rjcO1CAlip2wfXZfmL
         b4FxasCoFCzAq+gI3rVdC5mTMElm+m4d7br6yiyv/mdlVIx2o+9Kgq1Y/K3T6n4oOfTc
         /N9KKzJaeZgVFGctBPHVHf9/FqdhQacE77PXfdDjObv5sZWR6uMZ78qKl5ZK0kxrOcVE
         6Axg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QX8Aew80hIXRTchz8+FcQ8MQ/fpacOHED6ScaQzbTlY=;
        b=DTi/rtUn1nEKol5N8mhxnDU4pKSYBWm+cqDEkVqo8rTcHrRGjS3yz/B33HfIy8is/t
         nNW3YOqlBymJJNq6T+aZgt5R9gtaPG6jFvPpJkuIc29vvSLUR4emX6dEpfS6KsKfUSun
         mgN2/2yMrmOFDFNvB9CsEP81Gtne1qQ/bbioulS39HLGiVSxBKg4Bztr5HQm4ALwoZiw
         470sAQYB8edXYPFHtflubIxYid0pMQx+amAGhkPxCrJMlJqABfbUmMdDmbGAzxmx+8vj
         oZcb5z65Oy9OUiOtzGAG1g04Ca9aWeL+hGA7nq9+HY8CBjstjpGC8F5a3RhFnjGRity8
         lHUg==
X-Gm-Message-State: AOAM531wnxGMAJqFDH1x1O3Mq5nekZuuQuXLlpfvNt5GcfNQw6pCfssU
        iurZHD0yX2/+I5UPUetwKojonQ+z9Edz1HEXOsmJxr+xZNeY8wsn
X-Google-Smtp-Source: ABdhPJxh4/9NHemB2eiU2uTvyp3eJIa1vtxBJTB/Yhn6Mg1X1LbvgYbzmGO/yE4RBRMDwr5b8g1sdVty+0lahDgR1qo=
X-Received: by 2002:a17:903:11c4:b0:143:d220:9161 with SMTP id
 q4-20020a17090311c400b00143d2209161mr95330662plh.2.1639400442111; Mon, 13 Dec
 2021 05:00:42 -0800 (PST)
MIME-Version: 1.0
References: <20211210171511.11574-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20211210171511.11574-1-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Dec 2021 14:00:31 +0100
Message-ID: <CAJ8uoz34a-ASbbd5YvwmHfA5zeicLVfZCeyv3+RC-vWrYozSGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: wipe out dead zero_copy_allocator declarations
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 3:02 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> zero_copy_allocator has been removed back when Bjorn Topel introduced
> xsk_buff_pool. Remove references to it that were dangling in the tree.

Thanks Maciej.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_xsk.h           | 1 -
>  drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h | 2 --
>  include/net/xdp_priv.h                               | 1 -
>  3 files changed, 4 deletions(-)
>
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.h b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> index ea88f4597a07..bb962987f300 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.h
> @@ -22,7 +22,6 @@
>
>  struct i40e_vsi;
>  struct xsk_buff_pool;
> -struct zero_copy_allocator;
>
>  int i40e_queue_pair_disable(struct i40e_vsi *vsi, int queue_pair);
>  int i40e_queue_pair_enable(struct i40e_vsi *vsi, int queue_pair);
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> index a82533f21d36..bba3feaf3318 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h
> @@ -35,8 +35,6 @@ int ixgbe_xsk_pool_setup(struct ixgbe_adapter *adapter,
>                          struct xsk_buff_pool *pool,
>                          u16 qid);
>
> -void ixgbe_zca_free(struct zero_copy_allocator *alloc, unsigned long handle);
> -
>  bool ixgbe_alloc_rx_buffers_zc(struct ixgbe_ring *rx_ring, u16 cleaned_count);
>  int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>                           struct ixgbe_ring *rx_ring,
> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
> index a9d5b7603b89..a2d58b1a12e1 100644
> --- a/include/net/xdp_priv.h
> +++ b/include/net/xdp_priv.h
> @@ -10,7 +10,6 @@ struct xdp_mem_allocator {
>         union {
>                 void *allocator;
>                 struct page_pool *page_pool;
> -               struct zero_copy_allocator *zc_alloc;
>         };
>         struct rhash_head node;
>         struct rcu_head rcu;
> --
> 2.33.1
>
