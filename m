Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6ED34928A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhCYNAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:00:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhCYM72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:59:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPPa7-00CxCS-I3; Thu, 25 Mar 2021 13:59:23 +0100
Date:   Thu, 25 Mar 2021 13:59:23 +0100
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
Subject: Re: [PATCHv1 2/6] arm: dts: meson: Add missing ethernet phy mdio
 compatible string
Message-ID: <YFyJK4SL4i19s3px@lunn.ch>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
 <20210325124225.2760-3-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325124225.2760-3-linux.amoon@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:42:21PM +0000, Anand Moon wrote:
> Add missing ethernet phy mdio comatible string to help
> initiate the phy on Amlogic SoC SBC.

"ethernet-phy-ieee802.3-c22" is the default. So this is not wrong, but
it should not be required.

   Andrew
