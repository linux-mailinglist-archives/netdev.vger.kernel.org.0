Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02CF455CB4
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhKRNeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbhKRNeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 08:34:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4849FC061570;
        Thu, 18 Nov 2021 05:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=U3N4YPILgQ/uPDE2BJ2/bMrkZykcR8BBN2K9CD7VYQ4=; b=XY4RacNN3IB6ryNs35EvUNthL4
        qgYK9YeTteUIvrt6Ps4BUHoCtudpD4jjidMLXvKWnFbK2AgoUzE54LqRKyb84RpR0wa3PWjt5FIsD
        4DBAFTU1zvtb9Qv1pU6pyEWvHjRhLzIkE/vibzPgGUnJTQcjQQFrNcL/Fz4yADNJkutgHoO8hc9Yk
        w8KR/lN1lU6u8DFIErDJz2cODWWzstZagogy3GnHId9PDgrGn8IW0d0uXq9ZWJcXfz/wGZB/wO0vc
        qWacPp19+cH7Hjke9jv0VS5WNNkVVnyk7rEQkKpQGpWMfmgymuo7b+P4uXGvlg4ylaWykY8FxSlVo
        CLm3Iy/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55718)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnhVR-0002yL-2O; Thu, 18 Nov 2021 13:31:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnhVP-0003xW-W1; Thu, 18 Nov 2021 13:31:12 +0000
Date:   Thu, 18 Nov 2021 13:31:11 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <YZZVn6jve4BvSqyX@shell.armlinux.org.uk>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
 <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
 <YZYj9fwCeWdIZJOt@shell.armlinux.org.uk>
 <20211118125928.tav7k5xlbnhrgp3o@soft-dev3-1.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118125928.tav7k5xlbnhrgp3o@soft-dev3-1.localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 01:59:28PM +0100, Horatiu Vultur wrote:
> The 11/18/2021 09:59, Russell King (Oracle) wrote:
> > Another approach would be to split phylink_mii_c22_pcs_decode_state()
> > so that the appropriate decode function is selected depending on the
> > interface state, which may be a better idea.
> 
> I have tried to look for phylink_mii_c22_pcs_decode_state() and I
> have found it only here [1], and seems that it depends on [2]. But not
> much activity happened to these series since October.
> Do you think they will still get in?

I don't see any reason the first two patches should not be sent. I'm
carrying the second one locally because I use it in some changes I've
made to the mv88e6xxx code - as I mentioned in the patchwork entry you
linked to. See:

 http://git.armlinux.org.uk/cgit/linux-arm.git/log/?h=net-queue

 "net: phylink: Add helpers for c22 registers without MDIO"

Although I notice I committed it to my tree with the wrong author. :(

Sean, please can you submit the mdiodev patch and this patch for
net-next as they have general utility? Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
