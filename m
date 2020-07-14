Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CE621F229
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 15:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgGNNMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 09:12:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34704 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727975AbgGNNMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 09:12:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvKjg-00535Z-TE; Tue, 14 Jul 2020 15:12:40 +0200
Date:   Tue, 14 Jul 2020 15:12:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 5/5] net: phy: micrel: ksz886x/ksz8081: add
 cabletest support
Message-ID: <20200714131240.GE1140268@lunn.ch>
References: <20200710120851.28984-1-o.rempel@pengutronix.de>
 <20200710120851.28984-6-o.rempel@pengutronix.de>
 <20200711182912.GP1014141@lunn.ch>
 <20200713041129.gyoldkmsti4vl4m2@pengutronix.de>
 <20200713151719.GE1078057@lunn.ch>
 <20200714072501.GA5072@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714072501.GA5072@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> OK. So, i'll cover both errata with separate flags? Set flags in the DSA
> driver and apply workarounds in the PHY. ACK?

Yes. Assume the issues are limited to just the first PHY in this
switch. If there are discrete PHYs with the same issue, we can come up
with a different way to identify them.

     Andrew
