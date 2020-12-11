Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FEB2D6FCC
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 06:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbgLKFjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 00:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389684AbgLKFiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 00:38:52 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED2EC0613D3
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 21:38:07 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id s2so4034477plr.9
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 21:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qA8KF79vkXZC4AdXOTeJaMxuesaV/kTVaSa9pBU9Owk=;
        b=gL31Eo1QX8sqOP/b3a2qO1h4Xe2pN3Fg2GWOE1lEmfBOXYHfN3TZ87un+Nu7HMoS+j
         bvDjJqvgKqiFFYa6DXn1qtn9oFesQyLhBuEQfpIDHvcx4N5ehjd89m4E738CdWRo1KRx
         RXuBWxVYCLiNaXzoLivlPTbqFn1WX8l1ol/HqpMZteRQ6rrBDVLt8U9DL3KYulgPjoah
         cAJtgCc5BcbgVy7KIFpxiG0RyiKKyMYFx8x0f+/zaMctfIPFT7rS/hV30P4ej7vrFNQV
         TIL4X8JEyMC+8nTEK36t4ikUnQ2dzu81G9lmRNn2GJa4UZveHg9cM2Jd13OQDic0AK48
         w7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qA8KF79vkXZC4AdXOTeJaMxuesaV/kTVaSa9pBU9Owk=;
        b=PreCLuyKzd/Gfw/YgTpsDY3V5U3+M8NYd+3tJAxZg2lkuLgTUUCkHSptsnBFVaSYWY
         BK+R7kgAlJCaFGXGis/5MQCzdIAgrKddzPY7jG69kVPDNPaq4LAAzQEAt/tkbk9JNBr3
         c21PGe6afANO/9wcp5axx9s5Jevd9vqmZMTUEb2rzqFkN9q5GUUnHyCXmqvyVoki+Djo
         JNax9YwpMv3M2qwFPSy4ONr8HqrVui0+xjKcwAPWI0DUKAnFPwtOECQ3UKSQzFTpcdWO
         tfU9AkRsXpqz35CIXaIG3w8l8/lm0wYKVt03DHvfZYNQv1vGT9ioyj5jX3YU8scVkmG3
         MXCQ==
X-Gm-Message-State: AOAM530MrrgvQohEDNPP+FAndpDqLCslYiCTsZOmhKdTSVkNLYJK7O3T
        msLTi4d92eFsIVklwREhiIfy
X-Google-Smtp-Source: ABdhPJxKy68V+xykRB5MnwzQsoW8Fr+DN7ux+DyNcMHGQ3c0L5A6eWt/SHJWvBgj+KA/8eMML5e2bw==
X-Received: by 2002:a17:90a:ae02:: with SMTP id t2mr11398308pjq.169.1607665086962;
        Thu, 10 Dec 2020 21:38:06 -0800 (PST)
Received: from work ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id gp17sm8430308pjb.0.2020.12.10.21.38.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 10 Dec 2020 21:38:06 -0800 (PST)
Date:   Fri, 11 Dec 2020 11:08:00 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        jhugo@codeaurora.org
Subject: Re: [PATCH v2 2/3] net: mhi: Get RX queue size from MHI core
Message-ID: <20201211053800.GC4222@work>
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
 <1607598951-2340-2-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607598951-2340-2-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 12:15:50PM +0100, Loic Poulain wrote:
> The RX queue size can be determined at runtime by retrieving the
> number of available transfer descriptors.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  v2: Fixed commit message typo
> 
>  drivers/net/mhi_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
> index 8e72d94..0333e07 100644
> --- a/drivers/net/mhi_net.c
> +++ b/drivers/net/mhi_net.c
> @@ -256,9 +256,6 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>  	mhi_netdev->mdev = mhi_dev;
>  	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
>  
> -	/* All MHI net channels have 128 ring elements (at least for now) */
> -	mhi_netdev->rx_queue_sz = 128;
> -
>  	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
>  	u64_stats_init(&mhi_netdev->stats.rx_syncp);
>  	u64_stats_init(&mhi_netdev->stats.tx_syncp);
> @@ -268,6 +265,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
>  	if (err)
>  		goto out_err;
>  
> +	/* Number of transfer descriptors determines size of the queue */
> +	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> +

This value is not static right? You might need to fetch the count in
mhi_net_rx_refill_work().

Thanks,
Mani

>  	err = register_netdev(ndev);
>  	if (err)
>  		goto out_err;
> -- 
> 2.7.4
> 
