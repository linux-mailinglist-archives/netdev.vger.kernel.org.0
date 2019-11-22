Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B942105DAD
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfKVA1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:27:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36190 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfKVA1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:27:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pM6IQSVZhY9AtRKEsMuRfPvBEBeofGuxRtUaKkzOOtI=; b=qJbnPbQLLC26vD0X74dRyFd2H
        kopf1qaHYXW7OhDd+ecN800Cx5xURQSAZxE/ukAr9T/Pd+p/9px0K14Fiu9pjv7GeDCQ9DzGsTw6G
        Cd4q9A2br0kHRXKJExL/Cli0iKy4frjnc6xQjc1iHI1Ve94ADdWbXEqOV1NTaamPVv3rNjiADnMvx
        2uvKer+5cOBZJaTQsX2DL09AbEJjmQeA1qSH3GXu7+NjjhA6mSiamBSPO488UvdE9cwL/CgRBgivO
        zXZGBIzvbGDPYCH4kJGXP4aKiWa0R4KHJIg9fXGjOBcDNhPfDzIZfO1ZGF/GOKgw4gSMthNSf0Y5L
        toNl3rD5Q==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38746)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iXwnX-0001cc-Nr; Fri, 22 Nov 2019 00:27:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iXwnX-0003CI-66; Fri, 22 Nov 2019 00:27:43 +0000
Date:   Fri, 22 Nov 2019 00:27:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next 3/3] dpaa2-eth: return all supported link modes
 in PHY_INTERFACE_MODE_NA
Message-ID: <20191122002743.GF25745@shell.armlinux.org.uk>
References: <1574363727-5437-1-git-send-email-ioana.ciornei@nxp.com>
 <1574363727-5437-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1574363727-5437-4-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 09:15:27PM +0200, Ioana Ciornei wrote:
> The include/linux/phylink.h states:
>  * When @state->interface is %PHY_INTERFACE_MODE_NA, phylink expects
>  * MAC driver to return all supported link modes.
> 
> Make the necessary adjustment to meet the requirements.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

This is independent of patch 1.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> index efc587515661..d93d71724e5a 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -95,6 +95,7 @@ static void dpaa2_mac_validate(struct phylink_config *config,
>  	phylink_set(mask, Asym_Pause);
>  
>  	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_NA:
>  	case PHY_INTERFACE_MODE_RGMII:
>  	case PHY_INTERFACE_MODE_RGMII_ID:
>  	case PHY_INTERFACE_MODE_RGMII_RXID:
> -- 
> 1.9.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
