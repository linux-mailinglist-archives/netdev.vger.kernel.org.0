Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FC026E384
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIQSLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgIQSLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 14:11:03 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE3BC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 11:11:02 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id l17so3423807edq.12
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 11:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GBoef+bxER/kaS3e+khNFNc+0d/KduynkOys6Smgo0M=;
        b=knPlLSkJ06HU/G5Eq2HvwoXKoP510/I0pSFLi4GTbM7WKxkHmJ4T2/f5+XfUAJxOw4
         G0aRBhYzmPlCFWzo5BJMFE9nlCxUPw5bR+nP7NOgYHg7onEjGi97Ijemq078Iecj3QaM
         Omf+r/YQ7xzaL3MqF1Ccjlkr8kzIPwLz+RZg7+0pIa73gIBPP8HCaGHrNc3B1tkJWkhN
         R/oJjlt/An2qKOcMZIl/JQMB3JsRSgt5tLNJIzCdW31ESGIFpVBM9rsiCvvdTVWN8heV
         ySS7X6LvITFh61Tgc6cbYqHZqK5IIapBrpF2ERnx8nvOOijnlNE1WKARYY/sSLK8v50/
         IWHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GBoef+bxER/kaS3e+khNFNc+0d/KduynkOys6Smgo0M=;
        b=rcQl/sTCsINFSVXYtVx+aJCGmRd4WSQLY9NsEY+mNYaW2PRPme4gigTMjWf20x/iT6
         cohqM6xyFJnn/Xmh8XmXyENQIZKJD0LFVCyyXT2YFjPQ0FVa5KE1q7r+9K5LzwpJvlb/
         7QNWOjY+VegAIuX09Fchw3QCQ5nwRn0ODVyNtkBwVdqonh8/u72yceLLhuPVFX7rDZfg
         mLrwfnRqraTCbz4AryRRUiXo/wVaH+hNfSncHZ2fVhyk2rLxLeVupbWzDMkChUfFSz6s
         2akHfWODAuSARkUJ6rmpp9PyZwXg6w01mQbESdVhEn19iKALCqtNLLsE6W/A9jkdKMsC
         adow==
X-Gm-Message-State: AOAM5338/JM87c4HBHvxG/r5EIDIWZAMFXRxNfRvgGuf54HBqBt04Cp9
        ACgNQfy9Mgnte0WcAIoq5hYb7IYoefTGnA==
X-Google-Smtp-Source: ABdhPJwntYa53Vyk9jSGWNR/DFcukMNsUvRGtEm20kS3OJxgMwh0JBpYH2nmQQXSqiBbZPdVuH2VIg==
X-Received: by 2002:a50:84e8:: with SMTP id 95mr33566640edq.99.1600366261422;
        Thu, 17 Sep 2020 11:11:01 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id lg22sm432150ejb.48.2020.09.17.11.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 11:11:00 -0700 (PDT)
Date:   Thu, 17 Sep 2020 20:11:00 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net] nfp: use correct define to return NONE fec
Message-ID: <20200917181059.GA13324@netronome.com>
References: <20200917175257.592636-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917175257.592636-1-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 10:52:57AM -0700, Jakub Kicinski wrote:
> struct ethtool_fecparam carries bitmasks not bit numbers.
> We want to return 1 (NONE), not 0.
> 
> Fixes: 0d0870938337 ("nfp: implement ethtool FEC mode settings")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index 6eb9fb9a1814..9c9ae33d84ce 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -829,8 +829,8 @@ nfp_port_get_fecparam(struct net_device *netdev,
>  	struct nfp_eth_table_port *eth_port;
>  	struct nfp_port *port;
>  
> -	param->active_fec = ETHTOOL_FEC_NONE_BIT;
> -	param->fec = ETHTOOL_FEC_NONE_BIT;
> +	param->active_fec = ETHTOOL_FEC_NONE;
> +	param->fec = ETHTOOL_FEC_NONE;
>  
>  	port = nfp_port_from_netdev(netdev);
>  	eth_port = nfp_port_get_eth_port(port);

Reviewed-by: Simon Horman <simon.horman@netronome.com>

