Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4E51BA3F1
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgD0MwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727846AbgD0MwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 08:52:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F48C0610D5;
        Mon, 27 Apr 2020 05:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=npgNBfjXCgdOT6VhrlGrF6mCkBD86EOkn8/hf4N7+Xg=; b=a/7b4z2qzgc5vUXpvfjDqlWFR
        eHuKJUX5x6kbAaOEUDrXclNWnO1VUMxWUQ0MOpByul2vIZQNYS7W7tyjND0FgJOzJsl2/O0ulNNdd
        T7ZFUbY9ceu/h7MptFsfE2YzJsYOrIYlqHMMeUMlGK47UOr4inl6q4T2b7pZnsVlBnNHbNouIdv8i
        TTBkayO3wdgVVnu44j7yAfCTyA9eKf4z4BXlxkCaX1j2vRwV9LVgaDWUQl1BpmdvetjBe6pglYnpO
        y3pTxvBUFLkfeVQBrfmRye0MfGBTM2tInVpUZSl3fQUfJROARf9+9lSsmBRotIfklRiFatSm5yDLG
        ZkznR4qJw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56264)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jT3Ev-0002uk-JK; Mon, 27 Apr 2020 13:52:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jT3Er-0006fX-0I; Mon, 27 Apr 2020 13:51:57 +0100
Date:   Mon, 27 Apr 2020 13:51:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next v2 6/9] net: phy: add backplane kr driver
 support
Message-ID: <20200427125156.GD25745@shell.armlinux.org.uk>
References: <AM0PR04MB54432C98E0CD7FF5B155F446FBAF0@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB54432C98E0CD7FF5B155F446FBAF0@AM0PR04MB5443.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 12:40:37PM +0000, Florinel Iordache wrote:
> > > +/* Backplane mutex between all KR PHY threads */ static struct mutex
> > > +backplane_lock;
> > 
> > 
> > > +/* Read AN Link Status */
> > > +static int is_an_link_up(struct phy_device *phydev) {
> > > +     struct backplane_device *bpdev = phydev->priv;
> > > +     int ret, val = 0;
> > > +
> > > +     mutex_lock(&bpdev->bpphy_lock);
> > 
> > Last time i asked the question about how this mutex and the phy mutex interact.
> > I don't remember seeing an answer.
> > 
> >           Andrew
> 
> Hi Andrew,
> Yes, your question was:
> <<How does this mutex interact with phydev->lock? It appears both are trying to do the same thing, serialise access to the PHY hardware.>>
> The answer is: yes, you are right, they both are protecting the critical section related to accessing the PHY hardware for a particular PHY.
> As you can see the backplane device (bpdev) has associated one phy_device (phydev) so  bpdev->bpphy_lock and phydev->lock are equivalent.
> Normally your assumption is correct: backplane driver should use the same phydev->lock but there is the following problem:
> Backplane driver needs to protect all accesses to a PHY hardware including the ones coming from backplane scheduled workqueues for all lanes within a PHY.
> But phydev->lock is already acquired for a phy_device (from phy.c) before each phy_driver callback is called (e.g.: config_aneg, suspend, ...)
> So if I would use phydev->lock instead of bpdev->bpphy_lock then this would result in a deadlock when it is called from phy_driver callbacks.
> However a possible solution would be to remove all these locks using bpphy_lock and use instead only one phydev->lock in backplane kr state machine: (bp_kr_state_machine).
> But this solution will result in poorer performance, the training total duration will increase because only one single lane can enter the training procedure at a time therefore it would be possible for multi-lane phy training to ultimately fail because training is not finished in under 500ms. So I wanted to avoid this loss of training performance.
> Yet another possible solution would be to keep the locks where they are, at the lowest level exactly at phy_read/write_mmd calls, in order to allow lanes training running in parallel, but use instead the phydev->lock as would be normal to be and according to your suggestion.
> But in this case I must avoid the deadlock I mentioned above by differentiating between the calls coming from phy_driver callbacks where the phydev->lock is already acquired for this phy_device by the phy framework so the mutex should be skipped in this case and the calls coming from anywhere else (for example from backplane kr state machine) when the phydev->lock was not already acquired for this phy_device and the mutex must be used.
> If you agree with this latest solution then I can implement it in next version by using a flag in backplane_device called: 'phy_mutex_already_acquired' or 'skip_phy_mutex' which must be set in all backplane phy_driver callbacks and will be used to skip the locks on phydev->lock used at phy_read/write_mmd calls in these cases.

I think you have a rather big misunderstanding of the locking in phylib
from what you said above.

The register accessors do not use phydev->lock.

Follow the code.

	phy_read_mmd() uses phy_lock_mdio_bus().

	phy_lock_mdio_bus() locks the phydev->mdio.bus->mdio_lock mutex.

This is the _bus_ level lock, and is entirely different from
phydev->lock.

It is entirely safe to call phy_read_mmd() from any region of code
which is holding phydev->lock - indeed, we have many PHY drivers that
already do this.

So, I think you need to rewrite your entire locking strategy, because
it seems that you've misunderstood the locking here.

However, it's actually way worse, because of the abuse in your driver
of a single phy_device struct, which you use to access multiple PHYs,
randomly changing phydev->mdio.addr according to which PHY needs to be
accessed - you need to _carefully_ consider how your locking is done
for that.  I regard this as a big abuse, and I'm very tempted to NAK
your patches on this abuse alone.

I think you need to take onboard my comments about the (ab)use of
phy_device here.

An alternative solution to this is to push the phy_* accessors up a
level to the mdiobus level (we already have some, and I've already
been converting others) so you don't have to mess with
phydev->mdio.addr at all.

However, I would still consider your use of struct phy_device to be
an abuse.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
