Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0982A2982C0
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 18:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1417641AbgJYR3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 13:29:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729202AbgJYR3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 13:29:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWjp2-003Rxx-OE; Sun, 25 Oct 2020 18:28:48 +0100
Date:   Sun, 25 Oct 2020 18:28:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH] net: phy: realtek: omit setting
 PHY-side delay when "rgmii" specified
Message-ID: <20201025172848.GI792004@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io>
 <20201025141825.GB792004@lunn.ch>
 <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io>
 <20201025143608.GD792004@lunn.ch>
 <F5D81295-B4CD-4B80-846A-39503B70E765@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F5D81295-B4CD-4B80-846A-39503B70E765@aosc.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> 1. As the PHY chip has hardware configuration for configuring delays,
> >> we should at least have a mode that respects what's set on the
> >hardware.
> >
> >Yes, that is PHY_INTERFACE_MODE_NA. In DT, set the phy-mode to "". Or
> >for most MAC drivers, don't list a phy-mode at all.
> 
> However, we still need to tell the MAC it's RGMII mode that is in use, not
> MII/RMII/*MII. So the phy-mode still needs to be something that
> contains rgmii.

So for this MAC driver, you are going to have to fix the device tree.
And for the short turn, maybe implement the workaround discussed in
the other thread.

    Andrew
