Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAC12F17F7
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730572AbhAKOUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbhAKOUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:20:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16EEC061786;
        Mon, 11 Jan 2021 06:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7VNCdPxVAptn3zY7xxux6AD0SS/xbvnIWER1FG+yRhA=; b=whFblDmwn1UOzb3TTni/blVYv
        eaEeiOFfOIrdZ0mYONDfBOu0Ul1CE0OKgR/2p/6PJY9HrV0ScZqR/YEsw17b8ODdUGa/VEI/qhdVG
        mNkYjkuGkjEmF+vHFv2v6s7q91sYNA8X4RymSJ4KX23UkziAURo2dPoYsmL3LsL0oq4QfKe9kRETj
        Cku+puCB55dqBXXyNZDFMJj/L+0ugT+8ZqSBGZzQine13vtQ9D13mSC0epMJ/X9uQXKGrdrYnKW/F
        62VmKHYcVI8l6PLPLpa5Vl8YhkOvHmxWQyEiUy8jGchTFh9PYwqXneW3/j+Pul0/RIMqUD98etzrK
        h0Rx1T3yQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46624)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyy2e-00078W-FP; Mon, 11 Jan 2021 14:19:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyy2e-0005JJ-8b; Mon, 11 Jan 2021 14:19:32 +0000
Date:   Mon, 11 Jan 2021 14:19:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 1/2] net: phy: Add 100 base-x mode
Message-ID: <20210111141932.GV1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
 <20210111130657.10703-2-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130657.10703-2-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:06:56PM +0100, Bjarni Jonasson wrote:
> Sparx-5 supports this mode and it is missing in the PHY core.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Looks good, thanks.

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
>  include/linux/phy.h | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 56563e5e0dc7..dce867222d58 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -111,6 +111,7 @@ extern const int phy_10gbit_features_array[1];
>   * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
>   * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
>   * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
> + * @PHY_INTERFACE_MODE_100BASEX: 100 BaseX
>   * @PHY_INTERFACE_MODE_MAX: Book keeping
>   *
>   * Describes the interface between the MAC and PHY.
> @@ -144,6 +145,7 @@ typedef enum {
>  	PHY_INTERFACE_MODE_USXGMII,
>  	/* 10GBASE-KR - with Clause 73 AN */
>  	PHY_INTERFACE_MODE_10GKR,
> +	PHY_INTERFACE_MODE_100BASEX,
>  	PHY_INTERFACE_MODE_MAX,
>  } phy_interface_t;
>  
> @@ -217,6 +219,8 @@ static inline const char *phy_modes(phy_interface_t interface)
>  		return "usxgmii";
>  	case PHY_INTERFACE_MODE_10GKR:
>  		return "10gbase-kr";
> +	case PHY_INTERFACE_MODE_100BASEX:
> +		return "100base-x";
>  	default:
>  		return "unknown";
>  	}
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
