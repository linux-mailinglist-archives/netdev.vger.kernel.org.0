Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327B810A9CB
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 06:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfK0FGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 00:06:03 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37384 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbfK0FFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 00:05:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id bb19so5813596pjb.4
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 21:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sViBFOECCP081rRjgLL4aJh++GhBtQgv0rGQRJMbdcw=;
        b=lnaRLqub2Df5JW9fegAH26ADKSj7HeTbWONK60QrSf4TDkTeWBYJPC+P/x1/RbZvvU
         c7OXfRHFMueRi/sxSrgt0RpAnFzCUE7GQcexcL5FlzC+V8OPvG7uH1Exom4rppTWPBO5
         b8SLhmznynqvjWx13NXQEqWm4mGMv5QYhFR2g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sViBFOECCP081rRjgLL4aJh++GhBtQgv0rGQRJMbdcw=;
        b=RVIUv/4hwiw43pn+G/IxeBtohUCj7ioomG2RWESJ6wstApPRQgDGBEDdjdQ4BIf9IS
         xOPsdbD+1rt+JGDF0sbGVM+XgH2qwhIQ7k77agTgvhqzLhhhxYwSld98lEjwbGo3v1Z1
         O5cBCFth9jwWAFOHEauuSp06fyH1cVH3u5ae/ovTqKIGEXtI43+ySHNDThLpvK0YBycy
         3kflvfEaU2QzeX8defdH1ZdxnK6zoK2svvmGqpYapnnpwVRpFoWvmamgRv3dD2WAj2j6
         Ww0pHm55Oo7ADzV3ORhAN/OE/IJ93xqdFKH19JPleFlEyZ1pZ0LMQ2+pe3VEEKMCqAd+
         AHxA==
X-Gm-Message-State: APjAAAUQvNViqfuFJdPaW5FVeyTDC+e5L3UBOBM24F1fOU26Su0YlRxk
        Kf2O1VNNhPXDyL+A2Fyf4vDl+w==
X-Google-Smtp-Source: APXvYqyFEZIZWE+794O50kaWD9xTgidGuvtgEmJvV1slR+EM6BsMWlqZ8q4XMptXCPRG7GRYUFl7Tg==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr2144598plr.257.1574831145792;
        Tue, 26 Nov 2019 21:05:45 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y14sm14877156pff.69.2019.11.26.21.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 21:05:44 -0800 (PST)
Date:   Tue, 26 Nov 2019 21:05:44 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     Larry.Finger@lwfinger.net, jakub.kicinski@netronome.com,
        kvalo@codeaurora.org, Wright.Feng@cypress.com,
        arend.vanspriel@broadcom.com, davem@davemloft.net,
        emmanuel.grumbach@intel.com, franky.lin@broadcom.com,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, luciano.coelho@intel.com,
        netdev@vger.kernel.org, p.figiel@camlintechnologies.com,
        pieter-paul.giesberts@broadcom.com, pkshih@realtek.com,
        rafal@milecki.pl, sara.sharon@intel.com,
        shahar.s.matityahu@intel.com, yhchuang@realtek.com,
        yuehaibing@huawei.com
Subject: Re: [Patch v2 2/4] ipw2x00: Fix -Wcast-function-type
Message-ID: <201911262105.5AE5669F9E@keescook>
References: <20191125150215.29263-1-tranmanphong@gmail.com>
 <20191126175529.10909-1-tranmanphong@gmail.com>
 <20191126175529.10909-3-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191126175529.10909-3-tranmanphong@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 12:55:27AM +0700, Phong Tran wrote:
> correct usage prototype of callback in tasklet_init().
> Report by https://github.com/KSPP/linux/issues/20
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2100.c | 7 ++++---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 +++--
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> index 8dfbaff2d1fe..a162146a43a7 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
> @@ -3206,8 +3206,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
>  	}
>  }
>  
> -static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
> +static void ipw2100_irq_tasklet(unsigned long data)
>  {
> +	struct ipw2100_priv *priv = (struct ipw2100_priv *)data;
>  	struct net_device *dev = priv->net_dev;
>  	unsigned long flags;
>  	u32 inta, tmp;
> @@ -6007,7 +6008,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
>  	spin_unlock_irqrestore(&priv->low_lock, flags);
>  }
>  
> -static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
> +static void ipw2100_irq_tasklet(unsigned long data);
>  
>  static const struct net_device_ops ipw2100_netdev_ops = {
>  	.ndo_open		= ipw2100_open,
> @@ -6137,7 +6138,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
>  	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
>  	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
>  
> -	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
> +	tasklet_init(&priv->irq_tasklet,
>  		     ipw2100_irq_tasklet, (unsigned long)priv);
>  
>  	/* NOTE:  We do not start the deferred work for status checks yet */
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> index ed0f06532d5e..ac5f797fb1ad 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -1945,8 +1945,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
>  	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
>  }
>  
> -static void ipw_irq_tasklet(struct ipw_priv *priv)
> +static void ipw_irq_tasklet(unsigned long data)
>  {
> +	struct ipw_priv *priv = (struct ipw_priv *)data;
>  	u32 inta, inta_mask, handled = 0;
>  	unsigned long flags;
>  	int rc = 0;
> @@ -10680,7 +10681,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
>  	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
>  #endif				/* CONFIG_IPW2200_QOS */
>  
> -	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
> +	tasklet_init(&priv->irq_tasklet,
>  		     ipw_irq_tasklet, (unsigned long)priv);
>  
>  	return ret;
> -- 
> 2.20.1
> 

-- 
Kees Cook
