Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76FC342792
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhCSVTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:19:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37982 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhCSVTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:19:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lNMX2-00Bww7-EE; Fri, 19 Mar 2021 22:19:44 +0100
Date:   Fri, 19 Mar 2021 22:19:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Tretter <m.tretter@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de, robh+dt@kernel.org, hkallweit1@gmail.com,
        dmurphy@ti.com
Subject: Re: [PATCH 0/2] net: phy: dp83867: Configure LED modes via device
 tree
Message-ID: <YFUVcLCzONhPmeh8@lunn.ch>
References: <20210319155710.2793637-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319155710.2793637-1-m.tretter@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 04:57:08PM +0100, Michael Tretter wrote:
> Hello,
> 
> The dp83867 has 4 LED pins, which can be multiplexed with different functions
> of the phy.
> 
> This series adds a device tree binding to describe the multiplexing of the
> functions to the LEDs and implements the binding for the dp83867 phy.
> 
> I found existing bindings for configuring the LED modes for other phys:
> 
> In Documentation/devicetree/bindings/net/micrel.txt, the binding is not
> flexible enough for the use case in the dp83867, because there is a value for
> each LED configuration, which would be a lot of values for the dp83867.
> 
> In Documentation/devicetree/bindings/net/mscc-phy-vsc8532.txt, there is a
> separate property for each LED, which would work, but I found rather
> unintuitive compared to how clock bindings etc. work.
> 
> The new binding defines two properties: one for the led names and another
> property for the modes of the LEDs with defined values in the same order.
> Currently, the binding is specific to the dp83867, but I guess that the
> binding could be made more generic and used for other phys, too.

There is some work going on to manage PHY LEDs just like other LEDs in
Linux, using /sys/class/leds.

Please try to help out with that work, rather than adding yet another
DT binding.

   Andrew
