Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D942E6D93
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 04:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgL2DYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 22:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbgL2DYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 22:24:51 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC841C061793;
        Mon, 28 Dec 2020 19:24:11 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id w5so8481076pgj.3;
        Mon, 28 Dec 2020 19:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5oQEZVhwxEBad+iWsLPSUmR4sIPhMcMcVNJYflAmDyM=;
        b=IgptlGLhBs8lTdwu8WCEjoV0kLrl6C6hSUUC5tnV/Nfur9RGu1hYnQAYlVRMUBic/t
         MvZqZLEoPDw5J+XpNLrpA9ag/3kGUfjDjQbN6v8A55NqO5va2SPRlyYiovWqRu1wdQwi
         Giiw17H62Oqn5Sv5XMFYrmVc0i/YP7jOaCBxVuHrVM32PAwisqIenLCZHVZBcJH8AtgE
         wIaXf7pn67VjwYBsiR6UeCTP0aTff/m8b3shJSFQicpG3hwNUBetBMJSLFN7YZiwEy9t
         h60+e/LTT8acIVyogqAprw0XXrJxx0AcgHsSHtf+QiciO+g/OatlAOMnzdvaGz+zMKjz
         UIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5oQEZVhwxEBad+iWsLPSUmR4sIPhMcMcVNJYflAmDyM=;
        b=K0FKLMeN5VOYd5MHhVGsSpwSxJvvScYkABmXgXZ3hKOSYbJc73Ew9nizT73htRq/p7
         G79NcGH3qoQ2x1SaOhAJQYRh+Y06JwHfFMwincLEGiH8svAvgj2Wb11E4Nn73y7GHooJ
         EYRhzgjcCUmgdkv+YxC5erZLDAHjaRzL3qv+XCs9VPkAcDRW8JQaddx8QOHx3fSauvcp
         q1PaRrLA27SGT/H/hjCzWK2F94mAOwR34xQ/jwC7aBQcB/lYp7caKZijDLSsrovv4D1q
         cO1CtfaRwJfRnmez2Mjr31XjLtsEyvfwUwYi4WB+KGVhm8kBabM0oLJFGqLGCOkHCs1Z
         v0Pg==
X-Gm-Message-State: AOAM533OYzc6drzKigEVDE70qi0Z3uF/N4mXvM7JLOnw/3TYVQvkP51N
        u+Wf2S1gUNmgca8L3RGI92WS6N6PVx8=
X-Google-Smtp-Source: ABdhPJxpdfVGqGeXe3Br42URTLqyIlkNxNG2JcZ20bsxEMcJDrOi6exHkMr7RYfkT3LgzcR3s2Rp4w==
X-Received: by 2002:a63:5309:: with SMTP id h9mr26530679pgb.19.1609212250789;
        Mon, 28 Dec 2020 19:24:10 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d36sm39472017pgm.77.2020.12.28.19.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 19:24:09 -0800 (PST)
Subject: Re: [PATCH net-next v2 5/6] bcm63xx_enet: convert to build_skb
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
 <20201224142421.32350-6-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <49b174e9-df1c-a2fc-f5d5-adeabd940692@gmail.com>
Date:   Mon, 28 Dec 2020 19:24:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224142421.32350-6-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 6:24 AM, Sieng Piaw Liew wrote:
> We can increase the efficiency of rx path by using buffers to receive
> packets then build SKBs around them just before passing into the network
> stack. In contrast, preallocating SKBs too early reduces CPU cache
> efficiency.
> 
> Check if we're in NAPI context when refilling RX. Normally we're almost
> always running in NAPI context. Dispatch to napi_alloc_frag directly
> instead of relying on netdev_alloc_frag which does the same but
> with the overhead of local_bh_disable/enable.
> 
> Tested on BCM6328 320 MHz and iperf3 -M 512 to measure packet/sec
> performance. Included netif_receive_skb_list and NET_IP_ALIGN
> optimizations.
> 
> Before:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-10.00  sec  49.9 MBytes  41.9 Mbits/sec  197         sender
> [  4]   0.00-10.00  sec  49.3 MBytes  41.3 Mbits/sec            receiver
> 
> After:
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-30.00  sec   171 MBytes  47.8 Mbits/sec  272         sender
> [  4]   0.00-30.00  sec   170 MBytes  47.6 Mbits/sec            receiver

This looks good, however there are a few nits and suggestions below:

[snip]

> @@ -862,6 +868,24 @@ static void bcm_enet_adjust_link(struct net_device *dev)
>  		priv->pause_tx ? "tx" : "off");
>  }
>  
> +static void bcm_enet_free_rx_buf_ring(struct device *kdev, struct bcm_enet_priv *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < priv->rx_ring_size; i++) {
> +		struct bcm_enet_desc *desc;
> +
> +		if (!priv->rx_buf[i])
> +			continue;
> +
> +		desc = &priv->rx_desc_cpu[i];
> +		dma_unmap_single(kdev, desc->address, priv->rx_buf_size,
> +				 DMA_FROM_DEVICE);
> +		skb_free_frag(priv->rx_buf[i]);
> +	}
> +	kfree(priv->rx_buf);
> +}

This is a good helper to introduced, however I would introduce it as a
preliminary patch that way it becomes clear when you are doing the
sk_buff to buf substitution in the next patch.

[snip]

> @@ -1640,9 +1641,12 @@ static int bcm_enet_change_mtu(struct net_device *dev, int new_mtu)
>  	 * align rx buffer size to dma burst len, account FCS since
>  	 * it's appended
>  	 */
> -	priv->rx_skb_size = ALIGN(actual_mtu + ETH_FCS_LEN,
> +	priv->rx_buf_size = ALIGN(actual_mtu + ETH_FCS_LEN,
>  				  priv->dma_maxburst * 4);
>  
> +	priv->rx_frag_size = SKB_DATA_ALIGN(priv->rx_buf_offset + priv->rx_buf_size)
> +						+ SKB_DATA_ALIGN(sizeof(struct skb_shared_info));

The alignment of the second line is a bit off and you should aim for the
+ operator to be on the preceding line, and have SKB_DATA_ALIGN() start
on the opening parenthesis of the preceding line.
-- 
Florian
