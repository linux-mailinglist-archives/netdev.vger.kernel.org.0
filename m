Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935D5433F20
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhJSTUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhJSTUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 15:20:23 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2F9C06161C;
        Tue, 19 Oct 2021 12:18:10 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id n7-20020a05600c4f8700b00323023159e1so4877947wmq.2;
        Tue, 19 Oct 2021 12:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=InDKItQ11uQ3VYhvXe8c9poh+/aIqQ+YampvUePROjQ=;
        b=PyB9JkGY2AFcD0rrE/0D3wlN0mdMjEq2007SbKKlAoEOQfFxFOAvk1WmmNw6CdeVEU
         O4U6Rvd6vbz0HEKUcIXw/xfb6y/9/1iSF2uiPFWGcnsH8sFDfSDWgwFcGPtW3P+fnlnx
         c0MwDxenf1Fj02sX1dx+oh+zTwJs0cmFowxK1mJjcJUEekiFaF/9nehyOTykCtLRL0yd
         /AMXpfwVAzRSYhjQs4Hcl8FLr/nxAsq0GaBjMIFNRgQ+P+F8I9KJfZnQoeGKf0JrUUwP
         P+idXBO22RjbCJpY/6MnYwbkOpwGJDP6hfx31MKS5Ij3CL7T0Y+j9fyhD9qFD/NqIW0m
         khrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=InDKItQ11uQ3VYhvXe8c9poh+/aIqQ+YampvUePROjQ=;
        b=pWxSafBzXbsh8xYoQ5+ubLvTOdCEXrOol8ulNqcVhVODI464rnKBvRo7nKxi2KK5h7
         lr5LVElcUrQq2tC//w/Mlt9887n6XcSI8VaSz+qyEr0ivdSNR3xFwMLK0YyXqq2COnNL
         eeon7FQN1NZorof5XUFBXlBmLjQwM6uOHNeIYIBeNhws95Anf58h56bIM93AcNQSRbc7
         rezwiktBX2o/zSMmCqGwQnttekEebLaKQhmL8682XCEXjwqYbme0nsYUWHH2S++z2Lzu
         0MNbutp99LE0dijvz55tNHFnYegPTCkDc40aWlHHmisdbkSPgM842To6AcgGtzBKT6X7
         T8cA==
X-Gm-Message-State: AOAM533EdeMbEzUlns4L4IXx+HqoGDrraU8oNnqbjLd4BMgfzs1zjgwr
        JMXLT96BeuBu95YALzgC3sc=
X-Google-Smtp-Source: ABdhPJzdXAyggjZI6RBikmtOHBGe1gIxhrdxYTGJWDNVkLgORLdbVWGMUjq65DWDnbP8+R6F49T9IA==
X-Received: by 2002:a7b:c441:: with SMTP id l1mr8033693wmi.69.1634671089090;
        Tue, 19 Oct 2021 12:18:09 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id n12sm2138786wri.22.2021.10.19.12.18.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Oct 2021 12:18:08 -0700 (PDT)
Date:   Tue, 19 Oct 2021 20:18:06 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
Message-ID: <20211019191806.csewm7p26x3imk25@gmail.com>
Mail-Followup-To: Erik Ekman <erik@kryo.se>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211018183709.124744-1-erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018183709.124744-1-erik@kryo.se>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> These modes were added to ethtool.h in 5711a98221443 ("net: ethtool: add support
> for 1000BaseX and missing 10G link modes") back in 2016.
> 
> Only setting CR mode for 10G, similar to how 25/40/50/100G modes are set up.
> 
> Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 SFP module.
> Before:
> 
> $ ethtool ext
> Settings for ext:
> 	Supported ports: [ FIBRE ]
> 	Supported link modes:   1000baseT/Full
> 	                        10000baseT/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: No
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  Not reported
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: No
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  Not reported
> 	Link partner advertised pause frame use: No
> 	Link partner advertised auto-negotiation: No
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: off
> 	Port: FIBRE
> 	PHYAD: 255
> 	Transceiver: internal
>         Current message level: 0x000020f7 (8439)
>                                drv probe link ifdown ifup rx_err tx_err hw
> 	Link detected: yes
> 
> After:
> 
> $ ethtool ext
> Settings for ext:
> 	Supported ports: [ FIBRE ]
> 	Supported link modes:   1000baseX/Full
> 	                        10000baseCR/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: No
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  Not reported
> 	Advertised pause frame use: No
> 	Advertised auto-negotiation: No
> 	Advertised FEC modes: Not reported
> 	Link partner advertised link modes:  Not reported
> 	Link partner advertised pause frame use: No
> 	Link partner advertised auto-negotiation: No
> 	Link partner advertised FEC modes: Not reported
> 	Speed: 1000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: off
> 	Port: FIBRE
> 	PHYAD: 255
> 	Transceiver: internal
> 	Supports Wake-on: g
> 	Wake-on: d
>         Current message level: 0x000020f7 (8439)
>                                drv probe link ifdown ifup rx_err tx_err hw
> 	Link detected: yes
> 
> Signed-off-by: Erik Ekman <erik@kryo.se>

Acked-by: Martin Habets <habetsm.xilinx@gmail.com>

> ---
>  drivers/net/ethernet/sfc/mcdi_port_common.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/mcdi_port_common.c b/drivers/net/ethernet/sfc/mcdi_port_common.c
> index 4bd3ef8f3384..e84cdcb6a595 100644
> --- a/drivers/net/ethernet/sfc/mcdi_port_common.c
> +++ b/drivers/net/ethernet/sfc/mcdi_port_common.c
> @@ -133,9 +133,9 @@ void mcdi_to_ethtool_linkset(u32 media, u32 cap, unsigned long *linkset)
>  	case MC_CMD_MEDIA_QSFP_PLUS:
>  		SET_BIT(FIBRE);
>  		if (cap & (1 << MC_CMD_PHY_CAP_1000FDX_LBN))
> -			SET_BIT(1000baseT_Full);
> +			SET_BIT(1000baseX_Full);
>  		if (cap & (1 << MC_CMD_PHY_CAP_10000FDX_LBN))
> -			SET_BIT(10000baseT_Full);
> +			SET_BIT(10000baseCR_Full);
>  		if (cap & (1 << MC_CMD_PHY_CAP_40000FDX_LBN))
>  			SET_BIT(40000baseCR4_Full);
>  		if (cap & (1 << MC_CMD_PHY_CAP_100000FDX_LBN))
> @@ -192,9 +192,11 @@ u32 ethtool_linkset_to_mcdi_cap(const unsigned long *linkset)
>  		result |= (1 << MC_CMD_PHY_CAP_100FDX_LBN);
>  	if (TEST_BIT(1000baseT_Half))
>  		result |= (1 << MC_CMD_PHY_CAP_1000HDX_LBN);
> -	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full))
> +	if (TEST_BIT(1000baseT_Full) || TEST_BIT(1000baseKX_Full) ||
> +	    TEST_BIT(1000baseX_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_1000FDX_LBN);
> -	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full))
> +	if (TEST_BIT(10000baseT_Full) || TEST_BIT(10000baseKX4_Full) ||
> +	    TEST_BIT(10000baseCR_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_10000FDX_LBN);
>  	if (TEST_BIT(40000baseCR4_Full) || TEST_BIT(40000baseKR4_Full))
>  		result |= (1 << MC_CMD_PHY_CAP_40000FDX_LBN);
> -- 
> 2.31.1
