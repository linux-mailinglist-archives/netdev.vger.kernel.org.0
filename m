Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE2F116A710
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 14:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgBXNPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 08:15:30 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40480 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXNPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 08:15:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q2l2YrkweMeugbzvKpHX/irQPHC9QO3YDrezlIvs2Ug=; b=w9NORjWOCD7zYUD53+HwRsC5Q
        SWrWCHvrQfPN78I0naXTf5YL/A5tMBDV43+U1enJA/NfIj6B9l37kPVk+tLDWxNW8sb5O8217weta
        QcVr2MR1+cqa2I4HfqOjwg4oUQ3MI2/aNzaG8VMXcRXgp/ArqzUiYbyykJ3Neilzn8+UuEB7xPeGA
        X+UndBgVUU2eB6j5d6E7wcRcs3okQpLxCIhUqN0qAUrS7lExYkUKc4sQ2gEqrmaJHi6fYz54l1otJ
        A54Rr9oEJhhCFFrchEoMsdf09DVtoDlFhPlATgqvINhcToa+ZUseMjOaobf01eCTBWn3TxGOYKp4I
        xm9BBGGOw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44640)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j6DZy-0002su-5y; Mon, 24 Feb 2020 13:15:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j6DZw-0006TD-Ea; Mon, 24 Feb 2020 13:15:20 +0000
Date:   Mon, 24 Feb 2020 13:15:20 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200224131520.GM18808@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
 <20200219143036.GB3390@piout.net>
 <20200220101828.GV25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220101828.GV25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 10:18:28AM +0000, Russell King - ARM Linux admin wrote:
> On Wed, Feb 19, 2020 at 03:30:36PM +0100, Alexandre Belloni wrote:
> > Hi,
> > 
> > On 17/02/2020 17:24:21+0000, Russell King wrote:
> > > Convert the macb ethernet driver to use the finalised link
> > > parameters in mac_link_up() rather than the parameters in mac_config().
> > > 
> > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > ---
> > >  drivers/net/ethernet/cadence/macb.h      |  1 -
> > >  drivers/net/ethernet/cadence/macb_main.c | 46 ++++++++++++++----------
> > >  2 files changed, 27 insertions(+), 20 deletions(-)
> > > 
> > 
> > I did test the series after rebasing on top of the at91rm9200 fix.

Okay, I've updated my series, which will appear in my "phy" branch
later today.  However, what would you like me to do with the authorship
on the updated patch (I haven't yet checked what the differences were),
and can I add a tested-by to patch 1 for you?  I'll wait until you've
replied before pushing it out.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
