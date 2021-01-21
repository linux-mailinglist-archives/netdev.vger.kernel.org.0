Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFF22FEB61
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbhAUNRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbhAUKaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:30:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8A4C0617A9;
        Thu, 21 Jan 2021 02:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ggrNn6bZ56Xs3I/wJOYKm6l6UVf9CFaFXZUAbJsjYKM=; b=Z49kf7iabIfilu1w+JmdPo4LJ
        674DosO+McSf2IJK+jNUcCz+gt6UcV1Y3CMdUj87sUI9kpP9o6c5Ub7aU3HNiZNsDzFDLdaQD7rhO
        c++43CcfCfyEbwWf3XLlotI1l6LV545Rve6KS7HFidPrgBlnKAW1Svv3d9RuWvHgjdV4xUcEMVisy
        OsCQpS73dykyuwBWSPqYjCvQQf4dUldXqt+bKV7W6BmgA5R01B94esaGzAiRWq51/wNxWZrYecSWk
        4+q9LFPZghOSIsxZK/G6ASMWAvQ2ANkNZvB3LE5AS0pDI7jaU5dIpnQoLNx1iDPvIfKlCVmrvrIUG
        DUOk9jH/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50774)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l2XC0-0001CX-14; Thu, 21 Jan 2021 10:27:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l2XBy-0006yr-36; Thu, 21 Jan 2021 10:27:54 +0000
Date:   Thu, 21 Jan 2021 10:27:54 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210121102753.GO1551@shell.armlinux.org.uk>
References: <cover.1611198584.git.richardcochran@gmail.com>
 <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 08:06:01PM -0800, Richard Cochran wrote:
> The mvpp2 is an Ethernet driver, and it implements MAC style time
> stamping of PTP frames.  It has no need of the expensive option to
> enable PHY time stamping.  Remove the incorrect dependency.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> Fixes: 91dd71950bd7 ("net: mvpp2: ptp: add TAI support")

NAK.

> ---
>  drivers/net/ethernet/marvell/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index 41815b609569..7fe15a3286f4 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -94,7 +94,6 @@ config MVPP2
>  
>  config MVPP2_PTP
>  	bool "Marvell Armada 8K Enable PTP support"
> -	depends on NETWORK_PHY_TIMESTAMPING
>  	depends on (PTP_1588_CLOCK = y && MVPP2 = y) || \
>  		   (PTP_1588_CLOCK && MVPP2 = m)
>  
> -- 
> 2.20.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
