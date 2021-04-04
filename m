Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7DC1353966
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 20:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhDDSZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 14:25:47 -0400
Received: from hs01.dk-develop.de ([173.249.23.66]:36332 "EHLO
        hs01.dk-develop.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhDDSZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 14:25:46 -0400
Date:   Sun, 4 Apr 2021 20:25:39 +0200
From:   Danilo Krummrich <danilokrummrich@dk-develop.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        davem@davemloft.net, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <YGoEo3s/AxrjowLH@arch-linux>
References: <20210331141755.126178-1-danilokrummrich@dk-develop.de>
 <20210331141755.126178-3-danilokrummrich@dk-develop.de>
 <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <YGcOBkr2V1onxWDt@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGcOBkr2V1onxWDt@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 02:28:54PM +0200, Andrew Lunn wrote:
> > > Do you actually have a requirement for this?
> > >
> > Yes, the Marvell 88Q2112 1000Base-T1 PHY. But actually, I just recognize that it
> > should be possible to just register it with the compatible string
> > "ethernet-phy-ieee802.3-c22" instead of "ethernet-phy-ieee802.3-c45", this
> > should result in probing it as c22 PHY and doing indirect accesses through
> > phy_*_mmd().
> 
> Hi Danilo
> 
> Do you plan to submit a driver for this?
> 
Hi Andrew,

Yes, I'll get it ready once I got some spare time.
> Does this device have an ID in register 2 and 3 in C22 space?
> 
Currently, I don't have access to the datasheet and I don't remember.
In a couple of days I should have access to the HW again and I will try.
>      Andrew
Cheers,
Danilo
