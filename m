Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7391692F
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfEGR2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:28:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38101 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfEGR2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:28:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id d13so3048959qth.5
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 10:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=EXaJJYnOhCMm1Ies7w0+ULwlGJK0FIFIMnFExUlBqmk=;
        b=o/r9IVM5MhwMiJDJ9GVBWFCxkF0ebVK49NOcXyK3oMxdQdwXCejyZcGgqxxZbluDRm
         TkLtTH/eX9lZ8Hmmjn3AjqvEtJOSVkbfEWlTF8X+cx3Ci0C6l/baZ/3IDmdJYLkq9Gxl
         qNfjNfWyviSVQuJ5NI/NVbGyZcbmMWcmfOPDmg1bZcSh/1hDkQy+VnbtYiIy9KVel14o
         Bh1AvI5Q4EXXWRlncz5nllTS/shUOyYW9YzFHkr3z+BRlktQFpIiru9Klc6AWvRe0uSa
         0LWCXqSSHhiYrQQYtkK2F7v0nNk19iYZYDgbfam9iurl9vHv5dReP0Nx7sQLTqdLcpQS
         XQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=EXaJJYnOhCMm1Ies7w0+ULwlGJK0FIFIMnFExUlBqmk=;
        b=UChY9AzkYIQMX0mdOHYOu4kx4gYlZeRF/jAGzEQxtvaaVP8BTU8OYS/upkCqkVRYe1
         jrpGRS7g5PDX3im0GkLgK+11T2YT44404HXw7R38SoH2bvFRvIPNSzBY0/FLdosFQUuT
         tYt8jDjw1R+yGE4mRTTMqGC/0rRTdcCoMD+g/uzhMB40w4hnOR1McX+DzxqC8BaX9MNy
         sSjCWzpy4rF2v1TDLe73JIgBALOGX/UqAqexeAWvJT3p058cAyk637RYfhmRR1H3prS4
         PnJ8S30AK3vl2htz+rPTXH9EH9/w0Xd7RDB1IE8QtHVxheNOJ4rCeXa0z4mN1rg4cVgC
         2AOQ==
X-Gm-Message-State: APjAAAWDfZSQsZwLG9RLNzFmK8xannvEfCTJbXi0d7EzVpzKAH5UbsQI
        88fpahA6bKaCCDKYPmpoxyn0Xw==
X-Google-Smtp-Source: APXvYqyIrBg1/Odexc0u9Gyx6vUUNEENb9y4VJBTuXlyJ+UvZiEnf2cIcBUNxrZ//Bz917WhUaM9ew==
X-Received: by 2002:ac8:2565:: with SMTP id 34mr28459068qtn.37.1557250092551;
        Tue, 07 May 2019 10:28:12 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p6sm7274766qkc.13.2019.05.07.10.28.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 07 May 2019 10:28:12 -0700 (PDT)
Date:   Tue, 7 May 2019 10:28:03 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, stefanc@marvell.com,
        mw@semihalf.com, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net] net: mvpp2: cls: Add missing NETIF_F_NTUPLE flag
Message-ID: <20190507102803.09fcb56c@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20190507123635.17782-1-maxime.chevallier@bootlin.com>
References: <20190507123635.17782-1-maxime.chevallier@bootlin.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 May 2019 14:36:35 +0200, Maxime Chevallier wrote:
> Now that the mvpp2 driver supports classification offloading, we must
> add the NETIF_F_NTUPLE to the features list.
> 
> Fixes: 90b509b39ac9 ("net: mvpp2: cls: Add Classification offload support")
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> Hello David,
> 
> This patch applies on top of a commit 90b509b39ac9, which is in net-next
> but hasn't made it to -net yet.
> 
> Thanks,
> 
> Maxime
> 
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 25fbed2b8d94..1f164c893936 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -5040,8 +5040,10 @@ static int mvpp2_port_probe(struct platform_device *pdev,
>  	dev->hw_features |= features | NETIF_F_RXCSUM | NETIF_F_GRO |
>  			    NETIF_F_HW_VLAN_CTAG_FILTER;
>  
> -	if (mvpp22_rss_is_supported())
> +	if (mvpp22_rss_is_supported()) {
>  		dev->hw_features |= NETIF_F_RXHASH;
> +		dev->features |= NETIF_F_NTUPLE;

Hm, why not in hw_features?

> +	}
>  
>  	if (port->pool_long->id == MVPP2_BM_JUMBO && port->id != 0) {
>  		dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);

