Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51573315CA8
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 02:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbhBJBzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 20:55:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhBJByN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 20:54:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9eh8-005DmY-2t; Wed, 10 Feb 2021 02:53:30 +0100
Date:   Wed, 10 Feb 2021 02:53:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: phy: introduce phydev->port
Message-ID: <YCM8mu6OSIsSz9TI@lunn.ch>
References: <20210209163852.17037-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209163852.17037-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 05:38:52PM +0100, Michael Walle wrote:
> At the moment, PORT_MII is reported in the ethtool ops. This is odd
> because it is an interface between the MAC and the PHY and no external
> port. Some network card drivers will overwrite the port to twisted pair
> or fiber, though. Even worse, the MDI/MDIX setting is only used by
> ethtool if the port is twisted pair.
> 
> Set the port to PORT_TP by default because most PHY drivers are copper
> ones. If there is fibre support and it is enabled, the PHY driver will
> set it to PORT_FIBRE.
> 
> This will change reporting PORT_MII to either PORT_TP or PORT_FIBRE;
> except for the genphy fallback driver.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
