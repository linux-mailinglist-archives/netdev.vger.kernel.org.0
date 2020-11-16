Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293A62B3C61
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 06:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgKPFVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 00:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgKPFVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 00:21:41 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C35C0613CF
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 21:21:39 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id v12so13031956pfm.13
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 21:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8gbosqwx+MVwvYTEQXZ6R3WLMESaxo3OHv7NTPb1+o4=;
        b=Ka1M4vcgw0vEtD9LDGezlL6vzIaCdvBwdPD44cRGcomrYe16sEAwHTrLcjNwtoZgiR
         qvm2ax5+GBcqoutVQ9WT3aBrUV4pi7rgyeLJUISfM30Yxr05N1k7jfIRkTlsT4lV+nF+
         N32bellfXXcavX4cb1bZPJG4dokoNaXZk6W9bQMSDx3CfQwjA6ld5GJ2UHtltCYysjsf
         7I+rteCU4l7jzaE2RNw2SFj1sAyfDb/IRuGgalMijhBehI2O+WzCbCXQ/9LtNA6UpFXj
         t8AFZ0/j511ViJQoRXp0lQV+gn+T8ncub5tAE0V8W/XC+PhzM4ivHJSRmSrGkmneqbcr
         xhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8gbosqwx+MVwvYTEQXZ6R3WLMESaxo3OHv7NTPb1+o4=;
        b=QvGuiaxHnjU2jfwC8V7xiosVv+9gkcWvGD0Kji9Jzd3I9pkf48wTMXxYH8Et3bvqTU
         LTs6eLS7ilR6JzPSAp3VBtdAy8Rk/KD9pDpg09UMP00V5Fx91/LGxNgwZLTy6ta5UtYd
         Xq0oCIgw30Ayt4LTK8eOHnTnBVl57tssTOdehcyV79B//HWYk1QZXQ3HJB7VaMX9QkiT
         QteKPvRXCj/BEzQi/ADTxi3iRnKb2RixKCUab21L0InIP5DjviLVR6aA9eVwl3mgMuG5
         +Q76oG8ibhZ/tfnDRnrhXYUdjrfSUmyvyncSBlt4bTspLRXmN/ugOfGkjtL7sqk3ysvU
         wGcw==
X-Gm-Message-State: AOAM530DFCIMLLqzb66zKQsI670RyYcL7V9y8AZOMvpnWgwGTqvxZG/R
        OFCs784iYb6XaYg0EsU2i2nf
X-Google-Smtp-Source: ABdhPJxHWMky69bxOENycPWieuRlr4MHfvIwIXAGBpJgs5N7E6HVU69ztxx5wkKLNzwTd576L8RRYg==
X-Received: by 2002:a17:90a:f68e:: with SMTP id cl14mr14037281pjb.193.1605504099320;
        Sun, 15 Nov 2020 21:21:39 -0800 (PST)
Received: from Mani-XPS-13-9360 ([2409:4072:618e:9b0a:75fd:1290:bf5c:a350])
        by smtp.gmail.com with ESMTPSA id b6sm14493770pgq.58.2020.11.15.21.21.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 15 Nov 2020 21:21:38 -0800 (PST)
Date:   Mon, 16 Nov 2020 10:51:24 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, ath11k@lists.infradead.org
Subject: Re: [PATCH v2 1/2] bus: mhi: Remove auto-start option
Message-ID: <20201116052124.GA3926@Mani-XPS-13-9360>
References: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600674184-3537-1-git-send-email-loic.poulain@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ath11k list

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

Applied to mhi-ath11k-immutable branch! This branch will get merged into
mhi-next and ath-next.

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
