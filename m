Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE8F533FB78
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCQWsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhCQWru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:47:50 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94868C06174A;
        Wed, 17 Mar 2021 15:47:50 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n11so168785pgm.12;
        Wed, 17 Mar 2021 15:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AZQlG8sfqVYekS3pQFGKTyi8VGzITZR4qzf1zhijQFo=;
        b=ALZ1VE0LjbIRB2fJBolEdDSQVlBgdLAhjfQ1p0zidMdgRuoDdEOLIv71AdJPHgcRpo
         APFCzTCeWkr9e7pKMu+fcR3rRnukr2jgmZGNjF8fyXI2prnKkxIi3UvTu699wE5tVHIG
         NUkLBIvGP/iWfFVgnHwmUSONAB9K7yYkMU1AydYfN2cNlP+StfbLfB0m7PORlVILJdLW
         DWhJ/g8hVz8TPO7P++gO0qi9KvzX/K53qL+Fm1X+oA88bhpzc/urp73XR9/Je70D5ihC
         gxsmP1cve67ldDKV62WP4u6AKBvuUV/dEm20/LpFXhF0rk5CR4cgxFvLLOJEveUVE2dO
         NjUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AZQlG8sfqVYekS3pQFGKTyi8VGzITZR4qzf1zhijQFo=;
        b=laiUYcYelIXSFLSt9YlhJMabvTvyv86gJnieyUGohWr2IX4AOeedfH4VyLJH3MaWJ3
         3MSboY7T+mFQrpixAE7ro6WSq6Rdp+UxTVrMvBK5EX26miZYUzSWLWsGZ4nWTmHlMLIX
         xn82Jk0Yim5JK/TN++dPKYafoEeKaKAnmgh44NsU/WTbUISPKGR6hbAaL3Vjw8VjImGN
         hFuhkDCO83EteSp0FBlK4fUGtJrULxM/LE4Q17pXU1jBj+Ko1Axcup+C9bZytz+EKxCO
         6p+CvSLtMZ1f411dmawqjoDEVJyncS+IVacyEbQ9taA2TVfuHnosHddV+cxZiLTXXyAJ
         ZWow==
X-Gm-Message-State: AOAM530UmjWk5S+q+d1idaugoURh6wvFsXDPiD9xxATMaCARtiq76pIB
        L2Lhm/HerZ8PovCXJY80TGpCFiK4FYs=
X-Google-Smtp-Source: ABdhPJz69XyQa2AZP5IQXw/ofOSkrD2zxcYnwqOI1/2kpgk23ahjCbVqMpJQZtF3ZvO7hiST/ij+tw==
X-Received: by 2002:a65:4942:: with SMTP id q2mr4332175pgs.34.1616021269760;
        Wed, 17 Mar 2021 15:47:49 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a19sm115940pfn.181.2021.03.17.15.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:47:49 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: ipa: introduce dma_addr_high32()
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317222946.118125-1-elder@linaro.org>
 <20210317222946.118125-3-elder@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <36b9977b-32b1-eb4a-0056-4f742e3fe4d6@gmail.com>
Date:   Wed, 17 Mar 2021 15:47:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317222946.118125-3-elder@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/2021 3:29 PM, Alex Elder wrote:
> Create a new helper function to encapsulate extracting the
> high-order 32 bits of a DMA address.  It returns 0 for builds
> in which a DMA address is not 64 bits.
> 
> This avoids doing a 32-position shift on a DMA address if it
> happens not to be 64 bits wide.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  drivers/net/ipa/gsi.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> index 2119367b93ea9..53698c64cf882 100644
> --- a/drivers/net/ipa/gsi.c
> +++ b/drivers/net/ipa/gsi.c
> @@ -688,6 +688,16 @@ static void gsi_evt_ring_doorbell(struct gsi *gsi, u32 evt_ring_id, u32 index)
>  	iowrite32(val, gsi->virt + GSI_EV_CH_E_DOORBELL_0_OFFSET(evt_ring_id));
>  }
>  
> +/* Encapsulate extracting high-order 32 bits of DMA address */
> +static u32 dma_addr_high32(dma_addr_t addr)
> +{
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> +	return (u32)(addr >> 32);

You can probably use upper_32bits() here...

> +#else /* !CONFIG_ARCH_DMA_ADDR_T_64BIT */
> +	return 0;
> +#endif /* !CONFIG_ARCH_DMA_ADDR_T_64BIT */
> +}
> +
>  /* Program an event ring for use */
>  static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
>  {
> @@ -711,7 +721,7 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
>  	val = evt_ring->ring.addr & GENMASK(31, 0);

...and you can use lower_32bits() here.

>  	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_2_OFFSET(evt_ring_id));
>  
> -	val = evt_ring->ring.addr >> 32;
> +	val = dma_addr_high32(evt_ring->ring.addr);

Does the compiler do a good job at eliminating the assignment when
CONFIG_ARCH_DMA_ADDR_T_64BIT is not defined?

>  	iowrite32(val, gsi->virt + GSI_EV_CH_E_CNTXT_3_OFFSET(evt_ring_id));
>  
>  	/* Enable interrupt moderation by setting the moderation delay */
> @@ -819,7 +829,7 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
>  	val = channel->tre_ring.addr & GENMASK(31, 0);
>  	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_2_OFFSET(channel_id));
>  
> -	val = channel->tre_ring.addr >> 32;
> +	val = dma_addr_high32(channel->tre_ring.addr);
>  	iowrite32(val, gsi->virt + GSI_CH_C_CNTXT_3_OFFSET(channel_id));
>  
>  	/* Command channel gets low weighted round-robin priority */
> 

-- 
Florian
