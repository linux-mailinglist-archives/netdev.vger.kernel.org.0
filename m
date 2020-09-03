Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13D925B841
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgICBYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:24:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbgICBYW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 21:24:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kDdz4-00CxqR-6g; Thu, 03 Sep 2020 03:24:14 +0200
Date:   Thu, 3 Sep 2020 03:24:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] net: mvpp2: check first level interrupt
 status registers
Message-ID: <20200903012414.GH3071395@lunn.ch>
References: <20200902161007.GN1551@shell.armlinux.org.uk>
 <E1kDVMQ-0000jX-D8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kDVMQ-0000jX-D8@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 05:11:46PM +0100, Russell King wrote:
> Check the first level interrupt status registers to determine how to
> further process the port interrupt. We will need this to know whether
> to invoke the link status processing and/or the PTP processing for
> both XLG and GMAC.

As i said, i don't know this driver. Does the hardware actually have
two MAC hardware blocks? One for 10Mbs->1G, and a second for > 1G?

The comments and code seem to fit, so:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
