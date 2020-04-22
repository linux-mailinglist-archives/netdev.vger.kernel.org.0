Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957351B465E
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 15:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgDVNjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 09:39:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56274 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgDVNjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 09:39:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=k+1cIh8XjYZNIJTil34Mdg1G0PNol/tREUjipVfCnrY=; b=5yXS+Gp2kRNtwZC+GWd7ec6S9C
        ArpFHQok6rG9P31AYY4mjSNnrgrFOXtLx0HyZJucIv9v05OnD/zsWJH+sKznoZv0+voggepI1GITW
        Fk8/jIo7um77GRCw7JiQHifdZndY58ZP2QeH5tPk/LoFl+Z/QAzNYcLRIvoXzXMSyU8I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jRFaz-004D3b-A3; Wed, 22 Apr 2020 15:39:21 +0200
Date:   Wed, 22 Apr 2020 15:39:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Message-ID: <20200422133921.GA974925@lunn.ch>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422072137.8517-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 09:21:37AM +0200, Oleksij Rempel wrote:
> Add support for following phy-modes: rgmii, rgmii-id, rgmii-txid, rgmii-rxid.
> 
> This PHY has an internal RX delay of 1.2ns and no delay for TX.
> 
> The pad skew registers allow to set the total TX delay to max 1.38ns and
> the total RX delay to max of 2.58ns (configurable 1.38ns + build in
> 1.2ns) and a minimal delay of 0ns.
> 
> According to the RGMII v1.3 specification the delay provided by PCB traces
> should be between 1.5ns and 2.0ns. The RGMII v2.0 allows to provide this
> delay by MAC or PHY. So, we configure this PHY to the best values we can
> get by this HW: TX delay to 1.38ns (max supported value) and RX delay to
> 1.80ns (best calculated delay)
> 
> The phy-modes can still be fine tuned/overwritten by *-skew-ps
> device tree properties described in:
> Documentation/devicetree/bindings/net/micrel-ksz90x1.txt
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
