Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFD3467B1C
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhLCQT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236022AbhLCQT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:19:27 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09916C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:16:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8IvH/sbCqCgygd3HE71vFJQJQaePOcIXnbapbtMfSA8=; b=T8YGXPNlZHaoXxt8XzfZXanbcj
        IEfiJOSuuVoNjKrJ6kKgow7idurMePyP6yRbgHbQP17o+BKXiOGyRcfOLcywtqlC3+GMKbtamvZX1
        iiIeo0iEcr+wJrRyZJQeg+7oXhHJwl20xI/oRHSiLIzXvdaYKTaKt5sfcMbkpO6WkmcPmo6hazRlH
        0ttd9VWs8uXKKlfWyX7CtoK83qrI/a+hEVrKMUMknNVacqmQUFQYeSa0piqdwZ7Y9OKnGFoDOsbnf
        0FeZhIdcPD8xSsp3Wsj27FKDOzI8hwnlKxsyFNlH0b/PT0dv/NUK3kkRJyonsBWakGBWaRuhvOnPS
        nn2YpgFA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56032)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtBE1-000225-9q; Fri, 03 Dec 2021 16:15:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtBDz-0001Zn-0p; Fri, 03 Dec 2021 16:15:51 +0000
Date:   Fri, 3 Dec 2021 16:15:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH RFC net-next 00/12] Allow DSA drivers to set all phylink
 capabilities
Message-ID: <YapCthCbtjXpab6v@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 05:46:01PM +0000, Russell King (Oracle) wrote:
> During the last cycle, I introduced a phylink_get_interfaces() method
> for DSA drivers to be able to fill out the supported_interfaces member
> of phylink_config. However, further phylink development allowing the
> validation hook to be greatly simplified became possible when a bitmask
> of MAC capabilities is used along with the supported_interfaces bitmap.
...

Hi all,

Patches 1 through 3, 6 and 8 have been merged, the rest have not.
Getting patches 4, 5, 7, 10 and 12 tested and reviewed would be great
please. These are ar9331, bcm_sf2, ksz8795, qca8k and xrs700x. Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
