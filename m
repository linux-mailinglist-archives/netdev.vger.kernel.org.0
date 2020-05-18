Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8562D1D7792
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgERLoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgERLoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:44:05 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA66C05BD09
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 04:44:04 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so8966856wmb.4
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 04:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TpZHQuSS5J1/MdmsSlI5TnorhDFPcvIxSK1eebouk4s=;
        b=x5zl5aQiJmNpCU85LnMvnSNodHB2FHjZ7a5XwSyiOMcKEL5XeGr77m4wCSoQhDyQVS
         cxIkUGrWo+M3wzMcQ635FkOp23qOr3NwZZNpWAJxB8Nns3i6s+5WyoELDFjfHxLRyLfD
         DDkfjpcgCHeK6cMsQfXkI3tYanko00Hl/2ZN5VHRBxaqlgap6ZHwLTMe8UkaPMfdFPAC
         dyvIofIAb+J7pQCYS0Ep0rYO6T19bOcHTnF+g2xMPOxWz3xtjtRGBoVGyuIMjTOTXrbh
         btdIIaare25UxWbcbVMOdN4h1DjM5p5JBPjAu6P2NsPxkw3+raO71oVNs8giFs7duInl
         eq4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TpZHQuSS5J1/MdmsSlI5TnorhDFPcvIxSK1eebouk4s=;
        b=aoi5AcElmYNachagjyyKWXmWyzGL0sbO//Xmzol7xuZ1+IjzFDLwpJbsXcIQuRNk9S
         +PNSxZSaD5A5SASds0Boq+MysaAcAmiTxlQEjL4e1SZhOcYe0C/K46Ed7clRoaie/1Wl
         A0SRQJ9BXXZjjF0dpNBGXWMsF/gY6wU0TeDHAELonlNDO6V8gJtcdZSquyWNpnVBljwB
         UESSaMVWn2u+c/DLPewK3UcCGshIAsSeqQfvC45U+qELA//QGZqe1OMo0ud1RyQfbK9F
         lt9ET7DIWklKfOP0Yi0l0MQ7IAxxmHBy0K0L780s6tomVPbKFs1YndpPLv4jeuH5kt/q
         TFwA==
X-Gm-Message-State: AOAM530uqxIaL7PivurHQU2pSRBsNvhCq5CT8Xbz/tTsqFnstuR5BMOT
        emTB1FXyLItWt3Oa5/Eq+E6dfg==
X-Google-Smtp-Source: ABdhPJz3hgujn6RgPOUhENs0N4yfrpiiFlsdExEEozjHbHGBeAyxnCn/IfhmkigCMiXA6oGhjYpYAg==
X-Received: by 2002:a1c:b354:: with SMTP id c81mr18872114wmf.136.1589802243407;
        Mon, 18 May 2020 04:44:03 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id w13sm15637594wrm.28.2020.05.18.04.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 04:44:02 -0700 (PDT)
Date:   Mon, 18 May 2020 13:44:02 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, mkubecek@suse.cz, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH net-next 2/3] nfp: don't check lack of RX/TX channels
Message-ID: <20200518114401.GB5261@netronome.com>
References: <20200515194902.3103469-1-kuba@kernel.org>
 <20200515194902.3103469-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515194902.3103469-3-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 12:49:01PM -0700, Jakub Kicinski wrote:
> Core will now perform this check.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> index a5aa3219d112..6eb9fb9a1814 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> @@ -1438,8 +1438,7 @@ static int nfp_net_set_channels(struct net_device *netdev,
>  	unsigned int total_rx, total_tx;
>  
>  	/* Reject unsupported */
> -	if (!channel->combined_count ||
> -	    channel->other_count != NFP_NET_NON_Q_VECTORS ||
> +	if (channel->other_count != NFP_NET_NON_Q_VECTORS ||
>  	    (channel->rx_count && channel->tx_count))
>  		return -EINVAL;
>  
> -- 
> 2.25.4
> 
