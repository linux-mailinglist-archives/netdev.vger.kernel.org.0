Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEAF1FFE3D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbgFRWho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:37:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbgFRWhn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:37:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jm3AC-001BQe-Gz; Fri, 19 Jun 2020 00:37:40 +0200
Date:   Fri, 19 Jun 2020 00:37:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        michael@walle.cc, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618223740.GD279339@lunn.ch>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618221352.GB279339@lunn.ch>
 <20200618222727.GM1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618222727.GM1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The other thing is, drivers/net/phy is becoming a little cluttered -
> we have approaching 100 files there.
> 
> Should we be thinking about drivers/net/phy/mdio/ (for mdio*),
> drivers/net/phy/lib/ for the core phylib code or leaving it where
> it is, and, hmm, drivers/net/phy/media/ maybe for the PHY and PCS
> drivers?  Or something like that?

Hi Russell

Do you have any experience how good git is at following file moves
like this. We don't want to make it too hard for backporters of fixes.

If it is not going to be too painful, then yes, mdio, phy and pcs
subdirectories would be nice.

       Andrew
