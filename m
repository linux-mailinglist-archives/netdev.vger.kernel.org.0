Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E343C2797B4
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 10:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgIZIBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 04:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgIZIBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 04:01:04 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2523C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 01:01:03 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k13so5284247pfg.1
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 01:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vJChTDAqgxbCEtfKCoDdnX1gZMkc9QxQzwed3o7WSPQ=;
        b=q2lp8J5mknEsRXWBdLHM1409u5X88gMALb45KpWaYaewZmPycHPn1UUdx3lUf0kGp/
         h02TbTqUfi9hF2rZ5VDQu7dA7MCfdn1bfQDUzQnEGxiVrfiGRPL8n3AGINNyTtspAUmO
         lN42c+RY0BwHBGU2d/mwk9RO4Xm+0zl0w2vInNzHXoRAyMf+J+j/mYt+Y7iZ9WpGH7NR
         xQRyV9H84NhHjdbsiY9TxC5+qzBsXXqnvxwnFfVeutZ3upY52NjiNOM4iXiEt0HMNw4G
         r0ztt1LISpi91T7VweWPmzQ1arXSAPA7QRYN7PFkmIdsTc/9/rynkUgt6N9E+KY0t/mo
         tt0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vJChTDAqgxbCEtfKCoDdnX1gZMkc9QxQzwed3o7WSPQ=;
        b=EiWNth35kGHQ8u8TZq2LINekScthb+cgTdDTLGEK5E8DTAeEn9qXZKmyWLQ4ji/34c
         jZBoKdnVKwEuHETs8anSmPFy/jP5U4+cVuyygs28cTNTjgqu9YpUx6Worqw8MnIGZ48M
         9UvxY+kB58pSkrsP+ZRhLQcqscZ+eD9LFPUB0cAWmPXtgXiyIXsLeJIm5mvvn332nAYg
         549ZWIjvpMCJmrnU6yTYpBgepGRwecZdTVvjvUvlyTwH9q8XEIEt2OxnRuUh6gBbABfM
         hb+ko70bqQ10RPwtOLMK6SwRDAy/+DDWvxPx6ONTefp3VruaEVuouERTItxauhak6vsS
         MwpQ==
X-Gm-Message-State: AOAM532tOYM8Nf1UOObWeyeUNvcVFC91siFwce6I4asd7L5qHnCxxMga
        jIhZxY7MF2b1AKrM453xOzZ2
X-Google-Smtp-Source: ABdhPJzzbyT78nsWZ5YMNRWjk6ytk46vvonNRFsKqCZsRT99Mr4CY+fMzttX6+OAN6uCXqurIhNKHw==
X-Received: by 2002:a63:541a:: with SMTP id i26mr1981896pgb.265.1601107263171;
        Sat, 26 Sep 2020 01:01:03 -0700 (PDT)
Received: from linux ([103.59.133.81])
        by smtp.gmail.com with ESMTPSA id s70sm4209723pgc.11.2020.09.26.01.01.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 01:01:02 -0700 (PDT)
Date:   Sat, 26 Sep 2020 13:30:57 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 1/2] bus: mhi: Remove auto-start option
Message-ID: <20200926080057.GF9302@linux>
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

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

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
