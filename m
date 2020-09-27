Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674FC279DA0
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 05:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgI0DCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 23:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgI0DCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 23:02:06 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9BFC0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 20:02:06 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y14so5433568pgf.12
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 20:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jONgDEzXR0zhOqot56v3TWnX1lFtFjRQRgNvOjGCsAY=;
        b=jy6Ob47LaSQTtpqp8YQPB9a7I+3wxUaVcmKyGEAjXKrhnFYRAXr+7Npf+HIAEf967d
         SCEZyMdXXE75Mg6ZAYJj5+JrF4JpjQYttHhxfF7HW7hDxywFg52rIHHtyV0zBOpDA6mm
         0+EaBgfuQWa6X+XlwgNYY42ke+ACRclBaJolFUg08OUKr3l3mA5S3gwaDTsH228fBKjr
         Tm0R5MMmqSPak1T22wHSrUq/+2CCWt+BIH3f93s7f10uof3bePlhuiHJVWS7tR1VOJLs
         en/qro8X+wwnmnz/f6M/cmrHK0XWDns4jSsrewEdXc4Ab7c9zUI2AyRei8pylxFOyuCR
         lIiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jONgDEzXR0zhOqot56v3TWnX1lFtFjRQRgNvOjGCsAY=;
        b=HE3tTyO6+9CfYUUhsNeTXyBapEKzamoottGPIxIzVI1ytYRxll58YHa1xFFjuP5mx5
         K7+t8z2V9ZnR8GKJEm1xDAVesI6exz6fHMuwK0XpZXgYjUppBzM37zGO3NKQGdKgn9uW
         TsUvOtMP2VqPGlmuoWuAXiSG+ILWkha/Xo3ZVIVz5JcorIljAHDeTnxVCo0Bhro8fweo
         YomisC13OWhB1EIuSlo8fBl/OzJvOR7zcxUIvjIKe2/PmHvw0086CFUYkDxnx8oU9Orp
         2v2Lg3g6NP2Rdhz+B8poj/QBpLg0e0VZ/6xvdKbY7HIHqnAfbo6/BfGhW7TeDGGwsSCI
         IkCQ==
X-Gm-Message-State: AOAM5308qH4JwZ0du2Vtwds0Hq/KiqGSBvWr0W6mNyQ+8tVXAg/RhjxC
        IM2fvi1Mogushxi96cJKshUe
X-Google-Smtp-Source: ABdhPJyI95ixblRNSoEHJ9Nn78KOAI5jlyUcc11XSkttHrH0rJGUMB9qAyN+nsMJ1MVAIoTGPJnRlw==
X-Received: by 2002:aa7:9518:0:b029:142:2501:35e3 with SMTP id b24-20020aa795180000b0290142250135e3mr5547649pfp.67.1601175725683;
        Sat, 26 Sep 2020 20:02:05 -0700 (PDT)
Received: from Mani-XPS-13-9360 ([2409:4072:198:cd53:8f:5b5c:829a:cfde])
        by smtp.gmail.com with ESMTPSA id j19sm6948759pfe.108.2020.09.26.20.02.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 26 Sep 2020 20:02:05 -0700 (PDT)
Date:   Sun, 27 Sep 2020 08:31:58 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     hemantk@codeaurora.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 1/2] bus: mhi: Remove auto-start option
Message-ID: <20200927030158.GB3213@Mani-XPS-13-9360>
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

Applied to mhi-next!

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
