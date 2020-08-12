Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924C4242C45
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgHLPos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:44:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51008 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgHLPos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 11:44:48 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k5svc-0099uI-FY; Wed, 12 Aug 2020 17:44:36 +0200
Date:   Wed, 12 Aug 2020 17:44:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC russell-king 3/4] net: phy: marvell10g: change
 MACTYPE according to phydev->interface
Message-ID: <20200812154436.GH2141651@lunn.ch>
References: <20200810220645.19326-1-marek.behun@nic.cz>
 <20200810220645.19326-4-marek.behun@nic.cz>
 <20200811152144.GN1551@shell.armlinux.org.uk>
 <20200812164431.34cf569f@dellmb.labs.office.nic.cz>
 <20200812150054.GP1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812150054.GP1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I'm aware of that problem.  I have some experimental patches which add
> PHY interface mode bitmaps to the MAC, PHY, and SFP module parsing
> functions.  I have stumbled on some problems though - it's going to be
> another API change (and people are already whinging about the phylink
> API changing "too quickly", were too quickly seems to be defined as
> once in three years), and in some cases, DSA, it's extremely hard to
> work out how to properly set such a bitmap due to DSA's layered
> approach.

Hi Russell

If DSAs layering is causing real problems, we could rip it out, and
let the driver directly interact with phylink. I'm not opposed to
that.

	Andrew
