Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5812F0907
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 19:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAJS2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 13:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbhAJS2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 13:28:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CEB0C061786;
        Sun, 10 Jan 2021 10:27:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IUrmBc1Xb+aW91qUOm8o62OuUwZcIxU7p0QZiLY/6Aw=; b=pBYvYwUAoMth2rcMDfh9+oDio
        l+jOdqt53KGmxWVVWoXLZGunKcNxNnlkwwRTWXSUNDzhOAhyL1f1PRcqSHF+g0h04+ppPCs5NxoED
        iXh7qUSBw/MX3NOzD8wi1A4zX5Brygm+i4oY0Vyxh6tN4I2ZN0QctS/PMESawXpI67SaegW66ieBp
        5Fa17Fss5/VB3AaDi9hN1/Iszee7tdTS8hDARV7VafN7S2oZ/q1Si87qhIcfow+jexvLGvrq1R/KS
        vUfb+V64frf29vFKT7VJO84Y86IDRJ+wZc3VtvaEhxpWUqDQSd0Uf7l2daOEON9u6exRjQjjCMYC5
        4aavpYTVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46256)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kyfR1-00066L-3u; Sun, 10 Jan 2021 18:27:27 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kyfR0-0004Qd-AD; Sun, 10 Jan 2021 18:27:26 +0000
Date:   Sun, 10 Jan 2021 18:27:26 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [EXT] Re: [PATCH RFC net-next  03/19] net: mvpp2: add CM3 SRAM
 memory map
Message-ID: <20210110182726.GL1551@shell.armlinux.org.uk>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
 <1610292623-15564-4-git-send-email-stefanc@marvell.com>
 <20210110175500.GG1551@shell.armlinux.org.uk>
 <CO6PR18MB38737188EA6812EE82F99379B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
 <X/tBiyrJ8cJX+3u6@lunn.ch>
 <CO6PR18MB3873C00A07115021090AB9D4B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB3873C00A07115021090AB9D4B0AC9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 06:09:39PM +0000, Stefan Chulski wrote:
> > > > > +	} else {
> > > > > +		priv->sram_pool = of_gen_pool_get(dn, "cm3-mem", 0);
> > > > > +		if (!priv->sram_pool) {
> > > > > +			dev_warn(&pdev->dev, "DT is too old, TX FC
> > > > disabled\n");
> > > >
> > > > I don't see anything in this patch that disables TX flow control,
> > > > which means this warning message is misleading.
> > >
> > > OK, I would change to TX FC not supported.
> > 
> > And you should tell phlylink, so it knows to disable it in autoneg.
> > 
> > Which make me wonder, do we need a fix for stable? Has flow control never
> > been support in this device up until these patches get merged?
> > It should not be negotiated if it is not supported, which means telling phylink.
> > 
> >    Andrew
> 
> TX FC never were really supported. MAC or PHY can negotiated flow control.
> But MAC would never trigger FC frame.

That really sucks.

> Should I prepare separate patch that disable TX FC till we merge this patches?

From what I see in table 28B in 802.3, there is no way to advertise
that you only support RX flow control. If you advertise ASM_DIR=1
PAUSE=0, it basically means you support sending FC frames, but not
receiving them. Advertising anything with PAUSE=1 means you support
both sending and receiving FC frames, irrespective of the state of
ASM_DIR.

So, our only option would be to completely disable pause frames.
Yes, I think we need a separate patch for that for the net tree,
and it should be backported to stable kernels, IMHO.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
