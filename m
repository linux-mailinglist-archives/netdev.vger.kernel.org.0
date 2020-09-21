Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086182726D3
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgIUOVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgIUOVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:21:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1319C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:20:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id md22so56040pjb.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0K3rzT1axib93I2ajH7zn/5MgQgyEhgLmNblhYBRtGo=;
        b=I8aUDHK7etJCGmFn1edtqZ/JWv33NUSxB4qH5WghtbcrJWw+rJfYdVk/drizuS5vAX
         9AmniTbXB6GEy5MtzNWIBxO1fMWY27GKM4Ja9PRvW4T8CxMyiK4QGedMpSdJuh9bABBp
         Ykgk3fPRpx62wlcwkus4hG7WT4Jt3WuM0pf9hmcHU5eBMhbhG0SIiH/JdFxxQY2QOPus
         T7ZEwFSuAGjsFyc1h6hpnpYFdtzxHyg7m6P4R7h727A4Bf2fJWoLITUa6MjRonl0Q60k
         FVRDg/p3LPiiR3SWvuwTqkCcUbnuc22JZFKSEI8at0NnTP6MMX3z4GT/kpJttrP8mL+I
         xHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0K3rzT1axib93I2ajH7zn/5MgQgyEhgLmNblhYBRtGo=;
        b=jH5xwXanoKk4+9IAwznGku2yzcuqVi1B2QKPox36Yafass/Fom03ScneaNFtWeAJWW
         iZZq4dc/5sF//c55bTC1Ipk8s7+e52Ct8rfIwEWsKRd4IpA1jiRdvYRGl7DkPsYVMxm2
         l3+WaNOYlfH6Em3guj2flO2pQsCPXOQg5vuuo8RN2AoA1VvXW4iQ/9rFP3jRswWLYALx
         6wUT2ms5Kh/Uf3wuq/HQNabtwctEKYiWIKYCRLTylI6eMm4JLmXa/aa9TsI8awPS9eXZ
         /QFUHprvh68I/Gx/OU6YMW4YsoIVlFgeWXTnHZ5haHBTUemnm8FdAMkenfzXDluDwbdV
         tcaw==
X-Gm-Message-State: AOAM532SgLZghW2Xxlk892QmnmDJwyzdJAQnjpaIy81no1KiCFDehEq6
        x3n35mNO025e7NKYGm+4PpQ7
X-Google-Smtp-Source: ABdhPJwLjry9hrWsfl41fuFRuKVWG/dD/n01EZ5s2p0x7x5l1Cc3z+WU3C/phr3/D+tR8JkzlkaYXA==
X-Received: by 2002:a17:90a:4b42:: with SMTP id o2mr52099pjl.205.1600698058038;
        Mon, 21 Sep 2020 07:20:58 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:6d03:bd12:1004:2ccf:6900:b97])
        by smtp.gmail.com with ESMTPSA id u15sm12378501pfm.61.2020.09.21.07.20.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 21 Sep 2020 07:20:57 -0700 (PDT)
Date:   Mon, 21 Sep 2020 19:50:50 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 1/2] bus: mhi: Remove auto-start option
Message-ID: <20200921142050.GF3262@Mani-XPS-13-9360>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:43:03AM +0200, Loic Poulain wrote:
> There is really no point having an auto-start for channels.
> This is confusing for the device drivers, some have to enable the
> channels, others don't have... and waste resources (e.g. pre allocated
> buffers) that may never be used.
> 
> This is really up to the MHI device(channel) driver to manage the state
> of its channels.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

I need to hold this series for next merge window as this has the dependency
with ath11k driver and I'm not sure about the networking tree's merge window.

I'll merge this one and post patches to remove auto_start from ath11k mhi
driver for v5.11.

Thanks,
Mani

> ---
>  v2: split MHI and qrtr changes in dedicated commits
> 
>  drivers/bus/mhi/core/init.c     | 9 ---------
>  drivers/bus/mhi/core/internal.h | 1 -
>  include/linux/mhi.h             | 2 --
>  3 files changed, 12 deletions(-)
> 
> diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
> index dccc824..8798deb 100644
> --- a/drivers/bus/mhi/core/init.c
> +++ b/drivers/bus/mhi/core/init.c
> @@ -721,7 +721,6 @@ static int parse_ch_cfg(struct mhi_controller *mhi_cntrl,
>  		mhi_chan->offload_ch = ch_cfg->offload_channel;
>  		mhi_chan->db_cfg.reset_req = ch_cfg->doorbell_mode_switch;
>  		mhi_chan->pre_alloc = ch_cfg->auto_queue;
> -		mhi_chan->auto_start = ch_cfg->auto_start;
>  
>  		/*
>  		 * If MHI host allocates buffers, then the channel direction
> @@ -1119,11 +1118,6 @@ static int mhi_driver_probe(struct device *dev)
>  			goto exit_probe;
>  
>  		ul_chan->xfer_cb = mhi_drv->ul_xfer_cb;
> -		if (ul_chan->auto_start) {
> -			ret = mhi_prepare_channel(mhi_cntrl, ul_chan);
> -			if (ret)
> -				goto exit_probe;
> -		}
>  	}
>  
>  	ret = -EINVAL;
> @@ -1157,9 +1151,6 @@ static int mhi_driver_probe(struct device *dev)
>  	if (ret)
>  		goto exit_probe;
>  
> -	if (dl_chan && dl_chan->auto_start)
> -		mhi_prepare_channel(mhi_cntrl, dl_chan);
> -
>  	mhi_device_put(mhi_dev);
>  
>  	return ret;
> diff --git a/drivers/bus/mhi/core/internal.h b/drivers/bus/mhi/core/internal.h
> index 5a81a42..73b52a0 100644
> --- a/drivers/bus/mhi/core/internal.h
> +++ b/drivers/bus/mhi/core/internal.h
> @@ -563,7 +563,6 @@ struct mhi_chan {
>  	bool configured;
>  	bool offload_ch;
>  	bool pre_alloc;
> -	bool auto_start;
>  	bool wake_capable;
>  };
>  
> diff --git a/include/linux/mhi.h b/include/linux/mhi.h
> index 811e686..0d277c7 100644
> --- a/include/linux/mhi.h
> +++ b/include/linux/mhi.h
> @@ -214,7 +214,6 @@ enum mhi_db_brst_mode {
>   * @offload_channel: The client manages the channel completely
>   * @doorbell_mode_switch: Channel switches to doorbell mode on M0 transition
>   * @auto_queue: Framework will automatically queue buffers for DL traffic
> - * @auto_start: Automatically start (open) this channel
>   * @wake-capable: Channel capable of waking up the system
>   */
>  struct mhi_channel_config {
> @@ -232,7 +231,6 @@ struct mhi_channel_config {
>  	bool offload_channel;
>  	bool doorbell_mode_switch;
>  	bool auto_queue;
> -	bool auto_start;
>  	bool wake_capable;
>  };
>  
> -- 
> 2.7.4
> 
