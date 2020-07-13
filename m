Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAEE21DF73
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgGMSQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729687AbgGMSQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:16:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31C6C061755;
        Mon, 13 Jul 2020 11:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GgQfa/zfUs4bMYvIRWAhtn5sur2upOt/Z4JLH9TrGEM=; b=ZIlMaZV/jZOHCAtlQd+3Z++Q7
        JhPpsrPZqorJpQ3t4Qwesz55IgHFXO6XUQFO5d0zQShjk0pIXEzCGfy25MgzMCApJ/7bLYjBe/1lT
        kCSw9XeFE5hIUuAF+91y6uMNVwUkiFgthqtCwReTIqcBvAYm8DiwVP5AnvVxxLckis0XEh4Ua/O0l
        qtuUgpu+5xTnHK66nbvWUyFn4wlMipWq7lqqbsDzqewhgOG8FGcu3Bmysf1WTl9SsX9Xsy1yfPBSZ
        CzVt0y9OL3swkbvqHzLn+rE7/2/rY/fNDAh+z9FQVwpanQZWlfYYgdySO5dwY5PdocFPmCv2wUak6
        UFKgSDmXw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39072)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jv2zq-0004DP-9A; Mon, 13 Jul 2020 19:16:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jv2zm-0006Up-O7; Mon, 13 Jul 2020 19:16:06 +0100
Date:   Mon, 13 Jul 2020 19:16:06 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner
 ability constants
Message-ID: <20200713181606.GV1551@shell.armlinux.org.uk>
References: <20200709213526.21972-1-michael@walle.cc>
 <20200709213526.21972-2-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709213526.21972-2-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 11:35:23PM +0200, Michael Walle wrote:
> The constants are taken from the USXGMII Singleport Copper Interface
> specification. The naming are based on the SGMII ones, but with an MDIO_
> prefix.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  include/uapi/linux/mdio.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> index 4bcb41c71b8c..784723072578 100644
> --- a/include/uapi/linux/mdio.h
> +++ b/include/uapi/linux/mdio.h
> @@ -324,4 +324,30 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
>  	return MDIO_PHY_ID_C45 | (prtad << 5) | devad;
>  }
>  
> +/* UsxgmiiChannelInfo[15:0] for USXGMII in-band auto-negotiation.*/
> +#define MDIO_LPA_USXGMII_EEE_CLK_STP	0x0080	/* EEE clock stop supported */

Bit 7 is the EEE clock stop capability, set when supported.  Tick.

> +#define MDIO_LPA_USXGMII_EEE		0x0100	/* EEE supported */

Bit 8 is the EEE capability, set when supported.  Tick.

> +#define MDIO_LPA_USXGMII_SPD_MASK	0x0e00	/* USXGMII speed mask */

Bits 9 through 11 are the speed.  Tick.

> +#define MDIO_LPA_USXGMII_FULL_DUPLEX	0x1000	/* USXGMII full duplex */

Bit 12 is the duplex mode, set for full, clear for half.  Tick.

> +#define MDIO_LPA_USXGMII_DPX_SPD_MASK	0x1e00	/* USXGMII duplex and speed bits */
> +#define MDIO_LPA_USXGMII_10		0x0000	/* 10Mbps */
> +#define MDIO_LPA_USXGMII_10HALF		0x0000	/* 10Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_10FULL		0x1000	/* 10Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_100		0x0200	/* 100Mbps */
> +#define MDIO_LPA_USXGMII_100HALF	0x0200	/* 100Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_100FULL	0x1200	/* 100Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_1000		0x0400	/* 1000Mbps */
> +#define MDIO_LPA_USXGMII_1000HALF	0x0400	/* 1000Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_1000FULL	0x1400	/* 1000Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_10G		0x0600	/* 10Gbps */
> +#define MDIO_LPA_USXGMII_10GHALF	0x0600	/* 10Gbps half-duplex */
> +#define MDIO_LPA_USXGMII_10GFULL	0x1600	/* 10Gbps full-duplex */
> +#define MDIO_LPA_USXGMII_2500		0x0800	/* 2500Mbps */
> +#define MDIO_LPA_USXGMII_2500HALF	0x0800	/* 2500Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_2500FULL	0x1800	/* 2500Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_5000		0x0a00	/* 5000Mbps */
> +#define MDIO_LPA_USXGMII_5000HALF	0x0a00	/* 5000Mbps half-duplex */
> +#define MDIO_LPA_USXGMII_5000FULL	0x1a00	/* 5000Mbps full-duplex */
> +#define MDIO_LPA_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */

Bit 15 is the link bit, set for link up.  Tick.

The speed bits correspond (they're a little harder to check, it would
have been easier for them to be 2 << 9 etc), tick.

The speed+duplex bits correspond (same issue with the raw speed bits,
defining them as MDIO_LPA_USXGMII_1000 | MDIO_LPA_USXGMII_FULL_DUPLEX
would've made them more obvious, but at the expense of being more
long winded), tick.

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
