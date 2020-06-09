Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B431F3B35
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbgFIMzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbgFIMzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:55:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE37C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 05:55:39 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jidmy-0003t4-Af; Tue, 09 Jun 2020 14:55:36 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jidmx-0006qd-Il; Tue, 09 Jun 2020 14:55:35 +0200
Date:   Tue, 9 Jun 2020 14:55:35 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mvneta: add support for 2.5G DRSGMII mode
Message-ID: <20200609125535.GK11869@pengutronix.de>
References: <20200608074716.9975-1-s.hauer@pengutronix.de>
 <20200608145737.GG1006885@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608145737.GG1006885@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:27:56 up 110 days, 19:58, 124 users,  load average: 0.09, 0.12,
 0.13
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 04:57:37PM +0200, Andrew Lunn wrote:
> On Mon, Jun 08, 2020 at 09:47:16AM +0200, Sascha Hauer wrote:
> > The Marvell MVNETA Ethernet controller supports a 2.5 Gbps SGMII mode
> > called DRSGMII.
> > 
> > This patch adds a corresponding phy-mode string 'drsgmii' and parses it
> > from DT. The MVNETA then configures the SERDES protocol value
> > accordingly.
> > 
> > It was successfully tested on a MV78460 connected to a FPGA.
> 
> Hi Sascha
> 
> Is this really overclocked SGMII, or 2500BaseX? How does it differ
> from 2500BaseX, which mvneta already supports?

I think it is overclocked SGMII or 2500BaseX depending on the Port MAC
Control Register0 PortType setting bit.
As said to Russell we have a fixed link so nobody really cares if it's
SGMII or 2500BaseX. This boils down the patch to fixing the Serdes
configuration setting for 2500BaseX.

Sascha


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
