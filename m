Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB04C455812
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245174AbhKRJfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243651AbhKRJfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:35:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16E2C061570;
        Thu, 18 Nov 2021 01:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EbsDLEHzaZ5g1JH3XIo7ZSMjctEUbWlXB5bIcscBOwk=; b=pRgLttNtF80BnOkCEymKa3sRXS
        4dCG7FhwsVx27a93wcoal86CXcfnObuYUwKnLLcNzGYx/mU9SAed69t0/5eWXpBKSsHxWZ7RbQVen
        zCShZZL5CQ/kPAFh8wmUpyXsHcTf/XQ4Z429E7YEbteVRxw135QLGePuRtcn30JZBstCVTEAyFNMg
        fGAQWhB+gdNwukbQZOnrS0ds7AVbtXoFZ2mCAVe+12Zf3io9uY+bXp0PG0Wq1OUiMvu0gamFadAcH
        FYL9yMVRRfau7YtMkpWy4d9X1GQdxfYAtyozfz6FUm2xRJim4IQ3/6xg0yqTgrEyxdykSPDKQBdws
        PpdSbMXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55700)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mndmE-0002kx-1X; Thu, 18 Nov 2021 09:32:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mndmD-0003oC-B6; Thu, 18 Nov 2021 09:32:17 +0000
Date:   Thu, 18 Nov 2021 09:32:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 5/8] net: phylink: pass supported PHY interface
 modes to phylib
Message-ID: <YZYdoQA/ZoPBHTLv@shell.armlinux.org.uk>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-6-kabel@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 11:50:47PM +0100, Marek Behún wrote:
> Pass the supported PHY interface types to phylib so that PHY drivers
> can select an appropriate host configuration mode for their interface
> according to the host capabilities.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
