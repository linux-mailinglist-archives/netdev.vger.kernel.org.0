Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C16EE03C9
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 14:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389062AbfJVMZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 08:25:02 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:52015 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387575AbfJVMZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 08:25:02 -0400
X-Originating-IP: 92.137.17.54
Received: from localhost (alyon-657-1-975-54.w92-137.abo.wanadoo.fr [92.137.17.54])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id DB4701BF215;
        Tue, 22 Oct 2019 12:24:59 +0000 (UTC)
Date:   Tue, 22 Oct 2019 14:24:59 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        davem@davemloft.net, nicolas.ferre@microchip.com,
        netdev@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: macb: convert to phylink
Message-ID: <20191022122459.GE3125@piout.net>
References: <20191018143924.7375-1-antoine.tenart@bootlin.com>
 <20191018190810.GH24810@lunn.ch>
 <20191018200823.GK25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191018200823.GK25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2019 21:08:23+0100, Russell King - ARM Linux admin wrote:
> On Fri, Oct 18, 2019 at 09:08:10PM +0200, Andrew Lunn wrote:
> > On Fri, Oct 18, 2019 at 04:39:24PM +0200, Antoine Tenart wrote:
> > > This patch converts the MACB Ethernet driver to the Phylink framework.
> > > The MAC configuration is moved to the Phylink ops and Phylink helpers
> > > are now used in the ethtools functions.
> 
> What seems to be missing is "why".  It isn't obvious from the patch why
> this conversion is being done...
> 

One of the first goal was to get access to
phylink_ethtool_get_pauseparam/phylink_ethtool_set_pauseparam and the
flow control logic instead of having to open code it.

There are also boards with a zynqmp and SFP cages.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
