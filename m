Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B73343AC9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 08:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhCVHjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 03:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVHjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 03:39:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9B1C061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 00:39:41 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lOFA1-0002rH-Oz; Mon, 22 Mar 2021 08:39:37 +0100
Received: from mtr by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mtr@pengutronix.de>)
        id 1lOFA0-0007nU-To; Mon, 22 Mar 2021 08:39:36 +0100
Date:   Mon, 22 Mar 2021 08:39:36 +0100
From:   Michael Tretter <m.tretter@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, robh+dt@kernel.org, hkallweit1@gmail.com
Subject: Re: [PATCH 0/2] net: phy: dp83867: Configure LED modes via device
 tree
Message-ID: <20210322073936.GA31778@pengutronix.de>
References: <20210319155710.2793637-1-m.tretter@pengutronix.de>
 <YFUVcLCzONhPmeh8@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YFUVcLCzONhPmeh8@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:13:54 up 32 days, 10:37, 79 users,  load average: 0.75, 0.72,
 0.58
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mtr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Mar 2021 22:19:44 +0100, Andrew Lunn wrote:
> On Fri, Mar 19, 2021 at 04:57:08PM +0100, Michael Tretter wrote:
> > The dp83867 has 4 LED pins, which can be multiplexed with different functions
> > of the phy.
> > 
> > This series adds a device tree binding to describe the multiplexing of the
> > functions to the LEDs and implements the binding for the dp83867 phy.
> > 
> > I found existing bindings for configuring the LED modes for other phys:
> > 
> > In Documentation/devicetree/bindings/net/micrel.txt, the binding is not
> > flexible enough for the use case in the dp83867, because there is a value for
> > each LED configuration, which would be a lot of values for the dp83867.
> > 
> > In Documentation/devicetree/bindings/net/mscc-phy-vsc8532.txt, there is a
> > separate property for each LED, which would work, but I found rather
> > unintuitive compared to how clock bindings etc. work.
> > 
> > The new binding defines two properties: one for the led names and another
> > property for the modes of the LEDs with defined values in the same order.
> > Currently, the binding is specific to the dp83867, but I guess that the
> > binding could be made more generic and used for other phys, too.
> 
> There is some work going on to manage PHY LEDs just like other LEDs in
> Linux, using /sys/class/leds.
> 
> Please try to help out with that work, rather than adding yet another
> DT binding.

Oh, thanks. That's even better.

For reference: https://lore.kernel.org/netdev/20190813191147.19936-1-mka@chromium.org/

Michael
