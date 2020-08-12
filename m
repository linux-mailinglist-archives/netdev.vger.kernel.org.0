Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209E6242D4E
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgHLQaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 12:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgHLQaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 12:30:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFBEC061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 09:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=I0Zh3wU+8xirwa0hIdC8uYT0hNTwCef7dAA9UwRoIMM=; b=nyDoEc2G9qogyvXl7G7d4kVW2
        NZykVxOYlNHaHmgNqeaNgE7Tv92GJbfDonprr5HgJgWgnPEwhBfMFQWpYJfTGLNX1mi8I9a1iGbqo
        YkuI/pq6davMDl+iDH5hxFfamMOuUKquYki4biCIUBQzbTelpYxQr8BT+N32tYQRKKvFOmwhl+PnL
        Z5BHwyudng73azFVpJ7LoJEoEQzk+yycCtpiqlAU9112bmio26PeF4RMNeovTA1siP/i56EeZ9v+H
        wbtIwTJIWNWS9ZpKfxfWNDNjW/i2n4QRLpgUo8jKvTzqOOvlFkPg9WK8fOenPI7y8AEeX91QugpfR
        KPFhkqu7w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51626)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k5tdp-0002tj-4Q; Wed, 12 Aug 2020 17:30:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k5tdo-0003xT-Nd; Wed, 12 Aug 2020 17:30:16 +0100
Date:   Wed, 12 Aug 2020 17:30:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812163016.GU1551@shell.armlinux.org.uk>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-4-marek.behun@nic.cz>
 <20200811152144.GN1551@shell.armlinux.org.uk>
 <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
 <20200812150054.GP1551@shell.armlinux.org.uk>
 <20200812173716.140bed4d@dellmb.labs.office.nic.cz>
 <20200812154837.GQ1551@shell.armlinux.org.uk>
 <20200812181333.69191baf@dellmb.labs.office.nic.cz>
 <20200812162232.GT1551@shell.armlinux.org.uk>
 <20200812182817.1bb7bb4a@dellmb.labs.office.nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200812182817.1bb7bb4a@dellmb.labs.office.nic.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 06:28:17PM +0200, Marek Behún wrote:
> On Wed, 12 Aug 2020 17:22:32 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Wed, Aug 12, 2020 at 06:13:33PM +0200, Marek Behún wrote:
> > > The MACTYPE is not being lost. But changing it requires Port
> > > Software Reset, which resets the link, so it cannot be done for
> > > example in read_status.  
> > 
> > Wouldn't the right place to configure it be in the config_init()
> > method - which is called once we have a MAC attaching to the PHY?
> > As I mentioned, if we had a way to pass the MAC interface supported
> > mask into phylib, config_init() could then use that to determine what
> > to do.
> > 
> 
> It is done from config_init. mv3310_power_up is called from
> mv3310_config_init.

I think it'll be best to resume this once we have saner weather.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
