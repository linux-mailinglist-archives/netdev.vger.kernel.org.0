Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B06DC79A52
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbfG2Uuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:50:54 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:46768 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388042AbfG2Uuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:50:54 -0400
Received: by mail-vs1-f68.google.com with SMTP id r3so41935596vsr.13
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=frvGvv1eSF7lfoY9TWCgTHyQ2TliZ9WWvOF4AcqNSmc=;
        b=TJ8VNiSE5mlpFz7/BDqUXOaBhdQ0sd0GBGvzWC4Y1V2zow7r+qeluSdaOqbiV/6Pvv
         yNc4MZlDHy7vMMZzzRPYz4ZOALvtFL5NcTeSgo4tPsHSBZ+YEaZDQRG22gHn/OmtuHWq
         Pk3YHip155H2OHFVoBH6dr1E+4buRjtY6+bqRKIaTZvtXZ5sj5qM1ER1aKu3R6WGHys7
         hl4aQyUZXrI19WxE3C9r87rqyqy4Ygnf/+Jco9RxCwYCCz0fdd7tfqwlFqcToQgViDKD
         7G4keOpVVpJUCrhqsrRhXOHh77DLga3t4QQP0mlmdr9CTjVaZMhJp1DlNh5OihxrGvFF
         5/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=frvGvv1eSF7lfoY9TWCgTHyQ2TliZ9WWvOF4AcqNSmc=;
        b=IJ91eVwo91LFfzB1sqrJFczI1rlAzx4N76sAq0dnOwN6nykYe6hpq2CrnAkxyRYrrL
         /LPELm3N9Leg7vaXRhBoSzpssQXUmrWjTf6h3BT6kBykP07ChKPfPd/ul2CydDOo5kjE
         +8WLZsxPpFPt9yiNgkIQBrUA0jDfTWQUiVp+xGqvNU89Cr2vjmEP1dMwT3UYKSMwYCt0
         fPR1oeweuvMAsdaijtWN2NVo1bx2vWiKRcF3fAUcNODO69se9WlQYhA3CaXnCQTKbjSq
         rpF2rIEd/B1/XtFlri8Ar0Zm/2OnQF1cj+Bl9JEFI0JIQbmkPpu/TuqqpaRCEF3V7l8M
         ph1g==
X-Gm-Message-State: APjAAAUpE3XjEqE0ZCX2gnFanzjUuGWbJvosBHI8a/X05NJWnQfRFr9B
        0va3xxhny26y8k4i29XgymkrLw==
X-Google-Smtp-Source: APXvYqwVRRtruiRCN5f5au+Fd1I4uvHrUwY3ioHU7eRaqIUz9zXSBAo/HudX7QNoYDF+cXBp1KpNIg==
X-Received: by 2002:a67:7d83:: with SMTP id y125mr54537581vsc.126.1564433453640;
        Mon, 29 Jul 2019 13:50:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v5sm72500933vsi.24.2019.07.29.13.50.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 13:50:53 -0700 (PDT)
Date:   Mon, 29 Jul 2019 13:50:43 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <willy@infraded.org>, <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3 net-next] linux: Add skb_frag_t page_offset
 accessors
Message-ID: <20190729135043.0d9a9dcb@cakuba.netronome.com>
In-Reply-To: <20190729171941.250569-2-jonathan.lemon@gmail.com>
References: <20190729171941.250569-1-jonathan.lemon@gmail.com>
        <20190729171941.250569-2-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jul 2019 10:19:39 -0700, Jonathan Lemon wrote:
> Add skb_frag_off(), skb_frag_off_add(), skb_frag_off_set(),
> and skb_frag_off_set_from() accessors for page_offset.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/linux/skbuff.h | 61 ++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 56 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 718742b1c505..7d94a78067ee 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -331,7 +331,7 @@ static inline void skb_frag_size_set(skb_frag_t *frag, unsigned int size)
>  }
>  
>  /**
> - * skb_frag_size_add - Incrementes the size of a skb fragment by %delta
> + * skb_frag_size_add - Increments the size of a skb fragment by %delta
>   * @frag: skb fragment
>   * @delta: value to add
>   */
> @@ -2857,6 +2857,46 @@ static inline void skb_propagate_pfmemalloc(struct page *page,
>  		skb->pfmemalloc = true;
>  }
>  
> +/**
> + * skb_frag_off - Returns the offset of a skb fragment
> + * @frag: the paged fragment
> + */
> +static inline unsigned int skb_frag_off(const skb_frag_t *frag)
> +{
> +	return frag->page_offset;
> +}
> +
> +/**
> + * skb_frag_off_add - Increments the offset of a skb fragment by %delta

I realize you're following the existing code, but should we perhaps use
the latest kdoc syntax? '()' after function name, and args should have
'@' prefix, '%' would be for constants.

> + * @frag: skb fragment
> + * @delta: value to add
> + */
> +static inline void skb_frag_off_add(skb_frag_t *frag, int delta)
> +{
> +	frag->page_offset += delta;
> +}
> +
> +/**
> + * skb_frag_off_set - Sets the offset of a skb fragment
> + * @frag: skb fragment
> + * @offset: offset of fragment
> + */
> +static inline void skb_frag_off_set(skb_frag_t *frag, unsigned int offset)
> +{
> +	frag->page_offset = offset;
> +}
> +
> +/**
> + * skb_frag_off_set_from - Sets the offset of a skb fragment from another fragment
> + * @fragto: skb fragment where offset is set
> + * @fragfrom: skb fragment offset is copied from
> + */
> +static inline void skb_frag_off_set_from(skb_frag_t *fragto,
> +					 const skb_frag_t *fragfrom)

skb_frag_off_copy() ?

> +{
> +	fragto->page_offset = fragfrom->page_offset;
> +}
> +
>  /**
>   * skb_frag_page - retrieve the page referred to by a paged fragment
>   * @frag: the paged fragment
> @@ -2923,7 +2963,7 @@ static inline void skb_frag_unref(struct sk_buff *skb, int f)
>   */
>  static inline void *skb_frag_address(const skb_frag_t *frag)
>  {
> -	return page_address(skb_frag_page(frag)) + frag->page_offset;
> +	return page_address(skb_frag_page(frag)) + skb_frag_off(frag);
>  }
>  
>  /**
> @@ -2939,7 +2979,18 @@ static inline void *skb_frag_address_safe(const skb_frag_t *frag)
>  	if (unlikely(!ptr))
>  		return NULL;
>  
> -	return ptr + frag->page_offset;
> +	return ptr + skb_frag_off(frag);
> +}
> +
> +/**
> + * skb_frag_page_set_from - sets the page in a fragment from another fragment

skb_frag_page_copy() ?

> + * @fragto: skb fragment where page is set
> + * @fragfrom: skb fragment page is copied from
> + */
> +static inline void skb_frag_page_set_from(skb_frag_t *fragto,
> +					  const skb_frag_t *fragfrom)
> +{
> +	fragto->bv_page = fragfrom->bv_page;
>  }
>  
>  /**
