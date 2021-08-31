Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117A43FD002
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhHaXnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbhHaXnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 19:43:00 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD37C061575;
        Tue, 31 Aug 2021 16:42:05 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id s16so1406982ilo.9;
        Tue, 31 Aug 2021 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=0y4nU63gO0oNV22cVI5sGx1Q3r9kFI6KD4AUMmK6/ek=;
        b=tQqxtvVA7CQUvM3GRrBIUnJ26dH9d0bs+rUhem2IOWeTtNHd6xEsxCTXYHc60WCzg6
         X6r37YdxKrtgadC6yvNeXS433ziZILnqy8cW776IXLf44WzHAc2TFT2koyYIJ/acynjs
         dNMvH5MBVLw8ymoSMTwbvug3hoRuOtkchF5CbGwBY6Qvka2ikWT1dxaDV735KubXJXDW
         gHJBQ1u6VCyowLCXsS60PaBfB+ZdArD53/UJHF9pbL7Lte6wpCnxvOOkH5TFoOe6zJkJ
         r5q352urUxxjPNiHjIKG3UOW1w490dWVfmio/FlEDi5thWw/1e5u4VfN4WyUhw/yoRSl
         YLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=0y4nU63gO0oNV22cVI5sGx1Q3r9kFI6KD4AUMmK6/ek=;
        b=KxmPk4sp1+2t77HGK+6lh0PFaqu86V4YeZOdxnagOKTsIHRpi6ur1njtjlRHXpZp+k
         2nNFXGi9QH+VQ58BHIO3/XrzSURP68pXld0BFF1LQYBbWvM9lV+/m0VZc7qMv8GwUWT5
         oLIg1wj4OxfwnxPCwXsCO1M0898MVDQ3U+wXzPOHwrXQdgBjKaoTvVkKiDEaWuz8QlUj
         Wbdxn7mBTCGM2hvP0AtAX+4GMcoqHoz/J33VrsSK37ocR+3MoxznCqwyzTKuQrDbWQ0E
         b0iLHd0Xp4mk1Pan7D3jGM+6P9refd9ZR3PfkeaaNxFXCtGuomrCkLPoRdknUeEAHdVq
         6GTA==
X-Gm-Message-State: AOAM5303At+f+26wdnSu92EYfhQ/8n2ogWbwbfhcLdUm2RLaApWkRwOi
        CXe3+ND+SxV3MbxLzO4PKDdEVb9Xk+Q=
X-Google-Smtp-Source: ABdhPJwtL8AK/D0KP/DZ9zObRIc6voNwklzo1W+3S2VCLSOo+nnk8B1ob1Bae4wlpO7pa2nOD10M0w==
X-Received: by 2002:a92:c091:: with SMTP id h17mr19559118ile.286.1630453324508;
        Tue, 31 Aug 2021 16:42:04 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id x10sm11010899ila.4.2021.08.31.16.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 16:42:03 -0700 (PDT)
Date:   Tue, 31 Aug 2021 16:41:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Message-ID: <612ebe4548da_6b87208fa@john-XPS-13-9370.notmuch>
In-Reply-To: <4f0438cf2a94e539e56b6a291978e08fd2e9c60b.1629473233.git.lorenzo@kernel.org>
References: <cover.1629473233.git.lorenzo@kernel.org>
 <4f0438cf2a94e539e56b6a291978e08fd2e9c60b.1629473233.git.lorenzo@kernel.org>
Subject: RE: [PATCH v12 bpf-next 06/18] net: marvell: rely on
 xdp_update_skb_shared_info utility routine
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi wrote:
> Rely on xdp_update_skb_shared_info routine in order to avoid
> resetting frags array in skb_shared_info structure building
> the skb in mvneta_swbm_build_skb(). Frags array is expected to
> be initialized by the receiving driver building the xdp_buff
> and here we just need to update memory metadata.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>

>  drivers/net/ethernet/marvell/mvneta.c | 35 +++++++++++++++------------
>  1 file changed, 20 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index cbf614d6b993..b996eb49d813 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2304,11 +2304,19 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  		skb_frag_size_set(frag, data_len);
>  		__skb_frag_set_page(frag, page);
>  
> -		if (!xdp_buff_is_mb(xdp))
> +		if (!xdp_buff_is_mb(xdp)) {
> +			sinfo->xdp_frags_size = *size;
>  			xdp_buff_set_mb(xdp);
> +		}
> +		if (page_is_pfmemalloc(page))
> +			xdp_buff_set_frag_pfmemalloc(xdp);
>  	} else {
>  		page_pool_put_full_page(rxq->page_pool, page, true);
>  	}
> +
> +	/* last fragment */
> +	if (len == *size)
> +		sinfo->xdp_frags_tsize = sinfo->nr_frags * PAGE_SIZE;
>  	*size -= len;
>  }
>  
> @@ -2316,13 +2324,18 @@ static struct sk_buff *
>  mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
> -	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	unsigned int size, truesize;
>  	struct sk_buff *skb;
>  	u8 num_frags;
> -	int i;
>  
> -	if (unlikely(xdp_buff_is_mb(xdp)))
> +	if (unlikely(xdp_buff_is_mb(xdp))) {

Just curious does the mvneta hardware support header split? If we
get to that point then we can drop the unlikely.

> +		struct skb_shared_info *sinfo;
> +
> +		sinfo = xdp_get_shared_info_from_buff(xdp);
> +		truesize = sinfo->xdp_frags_tsize;
> +		size = sinfo->xdp_frags_size;
>  		num_frags = sinfo->nr_frags;
> +	}
>  
>  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>  	if (!skb)
> @@ -2334,18 +2347,10 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct page_pool *pool,
>  	skb_put(skb, xdp->data_end - xdp->data);
>  	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
>  
> -	if (likely(!xdp_buff_is_mb(xdp)))
> -		goto out;
> -
> -	for (i = 0; i < num_frags; i++) {
> -		skb_frag_t *frag = &sinfo->frags[i];
> -
> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> -				skb_frag_page(frag), skb_frag_off(frag),
> -				skb_frag_size(frag), PAGE_SIZE);
> -	}
> +	if (unlikely(xdp_buff_is_mb(xdp)))
> +		xdp_update_skb_shared_info(skb, num_frags, size, truesize,
> +					   xdp_buff_is_frag_pfmemalloc(xdp));
>  
> -out:
>  	return skb;
>  }
>  
> -- 
> 2.31.1
> 


