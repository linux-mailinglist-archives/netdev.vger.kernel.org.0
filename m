Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30D2D40BE
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730479AbgLILMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgLILMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:12:16 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DD8C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 03:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=D3ex7G1S42ztQuRytB73J4SYEnd1UispZBAScBEmaTU=; b=K6eXH9g78sedrC0j3hwqJ0N1H
        P2bq7mZmUON42BgD1mNwOcYiCIXfgFTwZyzynf4RDoHPOs9V0PTovwkAjiFHRHh7sDk3JvJjndKug
        sPg1w8xQISaK8Pbh6VXx4hP+KQtd1FEWr24Co/qJ/cHrz4kvF0zZGuGvLq5DpnKnK6wVsqaPvd27q
        6AAtgx9rqBZ5gjL2iP+HBKSrguUt+QatX59IxurI/FaXTj6BvOC5KIaXXHydtmmWcjQaDxML6eJby
        PVjLKrLsVEjuq+jdir4eyf/k0Fw+tULCnCU4hAHnHAnwnqm4Ak9kYpl76ugJLanZbMNxnbQR0KwM+
        i2PUNYmeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41726)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kmxNH-0002Hf-1U; Wed, 09 Dec 2020 11:11:11 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kmxNF-0006yU-Bb; Wed, 09 Dec 2020 11:11:09 +0000
Date:   Wed, 9 Dec 2020 11:11:09 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH net-next 0/2] Add support for VSOL V2801F/CarlitoxxPro
 CPGOS03 GPON module
Message-ID: <20201209111109.GR1551@shell.armlinux.org.uk>
References: <20201204143451.GL1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201204143451.GL1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub,

What's happening with these patches?

If I'm getting the patchwork URLs correct, these patches seem not to
appear in patchwork. They both went to netdev as normal and where
accepted by vger from what I can see.

Thanks.

On Fri, Dec 04, 2020 at 02:34:52PM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> This patch set adds support for the V2801F / CarlitoxxPro module. This
> requires two changes:
> 
> 1) the module only supports single byte reads to the ID EEPROM,
>    while we need to still permit sequential reads to the diagnostics
>    EEPROM for atomicity reasons.
> 
> 2) we need to relax the encoding check when we have no reported
>    capabilities to allow 1000base-X based on the module bitrate.
> 
> Thanks to Pali Rohár for responsive testing over the last two days.
> 
>  drivers/net/phy/sfp-bus.c | 11 ++++-----
>  drivers/net/phy/sfp.c     | 63 +++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 63 insertions(+), 11 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
