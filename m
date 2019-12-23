Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7612947B
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 11:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfLWK5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 05:57:51 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39166 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfLWK5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 05:57:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AJi1bSzf2CTFSkBMqdWcYKhm22m5Iv4lMaNhZ4z9I8M=; b=jebe56vFX/WrSsKn38pH7tlt6
        ds4FplDdyNA/X8EwWIOpf/ZreeMrSTzqFweWtxF80HKteoP1N5guiaUi9yRKkbnFRw/BahOD8pQNR
        H0rJPbaI+FSc7hF4YQec0MdvI3+AheYw+34DFPcZK0Q2i2Y7DBLhBtDxNNP7jZ1OCPIKSiZXA1cWy
        FcvvDAYI7Rp9PsrTLIMw8uuKkxGvH7Zl/1Y2daJp8ugskzTzArcX9anx9afBb98FuShtjCzoPqMMA
        JV5OMbP1Lgn9FbVdCl5rABeQtRZfCROhjDbzbjuubAEtDWOqEtFbfsPpp2zKvCfnvxAcyRsf0pdeI
        7CxL4c+kA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:45216)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ijLPE-0001K7-SC; Mon, 23 Dec 2019 10:57:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ijLPD-0000kk-QF; Mon, 23 Dec 2019 10:57:43 +0000
Date:   Mon, 23 Dec 2019 10:57:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, shawnguo@kernel.org,
        leoyang.li@nxp.com, devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: Re: [PATCH net-next v2 1/7] net: phy: add interface modes for XFI,
 SFI
Message-ID: <20191223105743.GN25745@shell.armlinux.org.uk>
References: <1577096053-20507-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1577096053-20507-2-git-send-email-madalin.bucur@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1577096053-20507-2-git-send-email-madalin.bucur@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 12:14:07PM +0200, Madalin Bucur wrote:
> From: Madalin Bucur <madalin.bucur@nxp.com>
> 
> Add explicit entries for XFI, SFI to make sure the device
> tree entries for phy-connection-type "xfi" or "sfi" are
> properly parsed and differentiated against the existing
> backplane 10GBASE-KR mode.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>

NAK until we've finished discussing this matter in the previous posting.

> ---
>  include/linux/phy.h | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index dd4a91f1feaa..5651c7be0c45 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -99,7 +99,8 @@ typedef enum {
>  	PHY_INTERFACE_MODE_2500BASEX,
>  	PHY_INTERFACE_MODE_RXAUI,
>  	PHY_INTERFACE_MODE_XAUI,
> -	/* 10GBASE-KR, XFI, SFI - single lane 10G Serdes */
> +	PHY_INTERFACE_MODE_XFI,
> +	PHY_INTERFACE_MODE_SFI,
>  	PHY_INTERFACE_MODE_10GKR,
>  	PHY_INTERFACE_MODE_USXGMII,
>  	PHY_INTERFACE_MODE_MAX,
> @@ -175,6 +176,10 @@ static inline const char *phy_modes(phy_interface_t interface)
>  		return "rxaui";
>  	case PHY_INTERFACE_MODE_XAUI:
>  		return "xaui";
> +	case PHY_INTERFACE_MODE_XFI:
> +		return "xfi";
> +	case PHY_INTERFACE_MODE_SFI:
> +		return "sfi";
>  	case PHY_INTERFACE_MODE_10GKR:
>  		return "10gbase-kr";
>  	case PHY_INTERFACE_MODE_USXGMII:
> -- 
> 2.1.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
