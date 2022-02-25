Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A412C4C4AD5
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243014AbiBYQcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243012AbiBYQcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:32:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA581D86E7
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1t5cwZvxhesj2xl5ihjJctiwbkRyj1zv5ihyBV2Dq2s=; b=O61lRetCwWe/539bjv7pC/SElo
        tfiCPU5bdODVh6IgBy3Z7mmCZW1AgJFz+38QTE6FAz5UqidakeAaEq9/S6vsI5AgjHLgHpCBQfDSc
        fyKeb+97WQjbWRaVU5SSGWKFJ/PaVFfHJH5n+AM3RgrtmlWTK1ozmOzunuKo5LnoO5pUNBTw/P4MK
        oizaGlB8sO/bA9uN5efek5B3OpyT0akFM1fGHrwbI8z7MpvzYikTBapu2WI6VzJckB6cIJygEAobJ
        8NrX2NkRP0vbP6xm6Dp1AqV1XWHnU27Y0gx8DyF49eF+6voSsk+gBh0gpctrGETJU04ZLkW5mKufL
        1R8doc9g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57504)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nNdVZ-0005j6-OR; Fri, 25 Feb 2022 16:31:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nNdVY-0003EB-B9; Fri, 25 Feb 2022 16:31:52 +0000
Date:   Fri, 25 Feb 2022 16:31:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek =?utf-8?B?QmVoxILImW4=?= <kabel@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Message-ID: <YhkEeENNuIXRkCD7@shell.armlinux.org.uk>
References: <YhkBfuRJkOG9gVZR@shell.armlinux.org.uk>
 <E1nNdJV-00AsoS-Qi@rmk-PC.armlinux.org.uk>
 <20220225162530.cnt4da7zpo6gxl4z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220225162530.cnt4da7zpo6gxl4z@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 04:25:30PM +0000, Vladimir Oltean wrote:
> On Fri, Feb 25, 2022 at 04:19:25PM +0000, Russell King (Oracle) wrote:
> > Populate the supported interfaces bitmap for the Ocelot DSA switches.
> > 
> > Since all sub-drivers only support a single interface mode, defined by
> > ocelot_port->phy_mode, we can handle this in the main driver code
> > without reference to the sub-driver.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Brilliant, thanks.

This is the final driver in net-next that was making use of
phylink_set_pcs(), so once this series is merged, that function will
only be used by phylink internally. The next patch I have in the queue
is to remove that function.

Marek Behún will be very happy to see phylink_set_pcs() gone.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
