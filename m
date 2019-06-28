Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6ED59825
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbfF1KFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:05:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44914 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfF1KFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zo2lrLytL0COZvhU9U0To9L5I5lBFcCco9RAtI9unXs=; b=2BwXhftfW+MtnjSM+MVlnTD5c
        7ozx2lr+mO+LZRsgVbEG9QvDaL83erzhB61QZ/Yf3Qm1MDC8KtCVSwU3TbiMQ4GYaHS8pA6VeAe0r
        CKQLDPB53rsb9ARX8+LcF8rXkLvyCCFNPkFiVGtEEm2L38/dI9L1jL2YJnJb3KdeuyrmGpekLIMD/
        LWRQtOnG/sm2KqeYEHwqG2HwgQzihD7WHGuo3Pw9nnVdn3jAXOPx6dw/iFktzjI2MbEeO0vhMsE52
        53aiYX3TvV8SDYpABGugxIOESrdGcCveCVbHS/laEO1GdWoeGpW6MkOB6wVtzIn3rlxRnOBL7P9zx
        2G0dNurVg==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:59104)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hgnlJ-00007p-RR; Fri, 28 Jun 2019 11:05:46 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hgnlH-0001Pp-1T; Fri, 28 Jun 2019 11:05:43 +0100
Date:   Fri, 28 Jun 2019 11:05:42 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/3] Better PHYLINK compliance for SJA1105 DSA
Message-ID: <20190628100542.hmzqnp4bsnkikcvv@shell.armlinux.org.uk>
References: <20190627214637.22366-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627214637.22366-1-olteanv@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 12:46:34AM +0300, Vladimir Oltean wrote:
> After discussing with Russell King, it appears this driver is making a
> few confusions and not performing some checks for consistent operation.
> 
> Changes in v2:
> - Removed redundant print in the phylink_validate callback (in 2/3).
> 
> Vladimir Oltean (3):
>   net: dsa: sja1105: Don't check state->link in phylink_mac_config
>   net: dsa: sja1105: Check for PHY mode mismatches with what PHYLINK
>     reports
>   net: dsa: sja1105: Mark in-band AN modes not supported for PHYLINK
> 
>  drivers/net/dsa/sja1105/sja1105_main.c | 56 +++++++++++++++++++++++++-
>  1 file changed, 54 insertions(+), 2 deletions(-)

Thanks.  For the whole series:

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
