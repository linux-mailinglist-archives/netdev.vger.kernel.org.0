Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE33349293
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhCYNCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:02:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230241AbhCYNCN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:02:13 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPPcl-00CxFH-2x; Thu, 25 Mar 2021 14:02:07 +0100
Date:   Thu, 25 Mar 2021 14:02:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCHv1 0/6] Amlogic Soc - Add missing ethernet mdio compatible
 string
Message-ID: <YFyJz/Ql615FQz3I@lunn.ch>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325124225.2760-1-linux.amoon@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:42:19PM +0000, Anand Moon wrote:
> On most of the Amlogic SoC I observed that Ethernet would not get
> initialize when try to deploy the mainline kernel, earlier I tried to
> fix this issue with by setting ethernet reset but it did not resolve
> the issue see below.
> 	resets = <&reset RESET_ETHERNET>;
> 	reset-names = "stmmaceth";
> 
> After checking what was the missing with Rockchip SoC dts
> I tried to add this missing compatible string and then it
> started to working on my setup.

Adding

compatible = "ethernet-phy-ieee802.3-c22"

should not fix anything, since that is the default. We need to better
understand what is going on here.

	   Andrew
