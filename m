Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE314A7E5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgA0QQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:16:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38256 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729505AbgA0QQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 11:16:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=FMStAuMdUvPtlZSG748bT/MUB/fTbV/HL3g/nNS74xI=; b=MSzFVbOGBumi
        qfftaOB2fr2GlIsWi4gDbmKOC2dLKiEJtWsVLCj1F7CmETzHVpP2SA3fYopHS+CrL+s8j/6pMb3//
        8IyOrCFlUlzAuw+NGbRdFmt9HJP1d8ZjIT9//yNLr5mJA0p5cphDuDqLYedHbwk5hhuwps4oufrU5
        0CrPkZq9icS9hmUaTyMf9CEx+CoWEHAHoBlNj1dQZmrP8u0DEcNvTbA2LxDzAuzWfcZlux3XU1Rwe
        /wh1sA3iFaHm2KSPWO3SIgjYytx9l/0mSQ9HpT3iO6T88YdpBOoQ0zW//y6IlELeNJJiBIsjosZil
        pHL5Sgs0+jug413joHIU2A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60624)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iw73l-0002Ms-LQ; Mon, 27 Jan 2020 16:16:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iw73i-0001YE-GI; Mon, 27 Jan 2020 16:16:18 +0000
Date:   Mon, 27 Jan 2020 16:16:18 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, ykaukab@suse.de
Subject: Re: FWD: [PATCH v2 0/2] net: phy: aquantia: indicate rate adaptation
Message-ID: <20200127161618.GY25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127151351.GG13647@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew, thanks for the heads up.

Madalin, please resend this series, copying me with these patches, so
Andrew doesn't have to keep alerting me to your patches. Thanks.

On Mon, Jan 27, 2020 at 04:13:51PM +0100, Andrew Lunn wrote:
> ----- Forwarded message from Madalin Bucur <madalin.bucur@oss.nxp.com> -----
> 
> Date: Mon, 27 Jan 2020 17:07:49 +0200
> From: Madalin Bucur <madalin.bucur@oss.nxp.com>
> To: davem@davemloft.net
> Cc: andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org, ykaukab@suse.de, Madalin
> 	Bucur <madalin.bucur@oss.nxp.com>
> Subject: [PATCH v2 0/2] net: phy: aquantia: indicate rate adaptation
> X-Spam-Status: No, score=-6.9 required=4.0 tests=BAYES_00,
> 	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,RCVD_IN_DNSWL_HI,
> 	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
> 	version=3.4.4-rc1
> 
> Changes since v1:
>   rewrote commit messages to evidentiate that this is a PHY
>   generic feature, not a particular feature of the Aquantia
>   PHYs and added more details on how the 1G link issue this
>   is circumventing came about.
> 
> This patch-set introduces a bit into the phy_device
> structure to indicate the PHYs ability to do rate
> adaptation between the system and line interfaces and
> sets this bit for the Aquantia PHYs that have this feature.
> 
> By taking into account the presence of the said bit, address
> an issue with the LS1046ARDB board 10G interface no longer
> working with an 1G link partner after autonegotiation support
> was added for the Aquantia PHY on board in
> 
> commit 09c4c57f7bc4 ("net: phy: aquantia: add support for auto-negotiation configuration")
> 
> Before this commit the values advertised by the PHY were not
> influenced by the dpaa_eth driver removal of system-side unsupported
> modes as the aqr_config_aneg() was basically a no-op. After this
> commit, the modes removed by the dpaa_eth driver were no longer
> advertised thus autonegotiation with 1G link partners failed.
> 
> Madalin Bucur (2):
>   net: phy: aquantia: add rate_adaptation indication
>   dpaa_eth: support all modes with rate adapting PHYs
> 
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++---
>  drivers/net/phy/aquantia_main.c                |  3 +++
>  include/linux/phy.h                            |  3 +++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> -- 
> 2.1.0
> 
> 
> ----- End forwarded message -----
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
