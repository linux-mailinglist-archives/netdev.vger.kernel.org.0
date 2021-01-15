Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072C12F7EA4
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAOOzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:55:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbhAOOzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 09:55:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l0QVG-000lNp-Gs; Fri, 15 Jan 2021 15:55:06 +0100
Date:   Fri, 15 Jan 2021 15:55:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next] net: ks8851: Connect and start/stop the
 internal PHY
Message-ID: <YAGsynozCNzyGfnI@lunn.ch>
References: <20210111125337.36513-1-marex@denx.de>
 <X/xlDTUQTLgVoaUE@lunn.ch>
 <dd43881e-edff-74fd-dbcb-26c5ca5b6e72@denx.de>
 <YABNA+0aPI42lJLh@lunn.ch>
 <268090ca-06dd-d7e2-c06b-b9282f3cbe67@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <268090ca-06dd-d7e2-c06b-b9282f3cbe67@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I noticed a couple of drivers implement both the mii and mdiobus options.
> > 
> > Which ones?
> 
> boardcom b44.c and bcm63xx_enet.c for example

Thanks. I will take a look at those and maybe ask Florian.

> > Simply getting the link status might be safe, but if
> > set_link_ksettings() or get_link_ksettings() is used, phylib is going
> > to get confused when the PHY is changed without it knowing.. So please
> > do remove all the mii calls as part of the patchset.
> 
> Isn't that gonna break some ABI ?

I guess not, but i have no definitive answer. It should add more
features, not take any away.

> Also, is separate patch OK ?

It obviously works well enough that you have not run into issues. So i
guess anybody doing a git bisect will be O.K. if they land on the
state with both phydev and mii. So yes, a separate patch is O.K.

      Andrew
