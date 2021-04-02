Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A4C352AAA
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 14:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhDBM3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 08:29:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60124 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235373AbhDBM3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 08:29:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lSIv0-00EUqF-Gy; Fri, 02 Apr 2021 14:28:54 +0200
Date:   Fri, 2 Apr 2021 14:28:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danilo Krummrich <danilokrummrich@dk-develop.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGcOBkr2V1onxWDt@lunn.ch>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGZvGfNSBBq/92D+@arch-linux>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Do you actually have a requirement for this?
> >
> Yes, the Marvell 88Q2112 1000Base-T1 PHY. But actually, I just recognize that it
> should be possible to just register it with the compatible string
> "ethernet-phy-ieee802.3-c22" instead of "ethernet-phy-ieee802.3-c45", this
> should result in probing it as c22 PHY and doing indirect accesses through
> phy_*_mmd().

Hi Danilo

Do you plan to submit a driver for this?

Does this device have an ID in register 2 and 3 in C22 space?

     Andrew
