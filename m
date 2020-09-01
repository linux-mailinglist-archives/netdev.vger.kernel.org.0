Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7CA258E3C
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgIAMcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:32:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35802 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgIAMbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 08:31:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kD5Qk-00ClTG-QI; Tue, 01 Sep 2020 14:30:30 +0200
Date:   Tue, 1 Sep 2020 14:30:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 4/5] net: phy: smsc: add phy refclk in support
Message-ID: <20200901123030.GA3030381@lunn.ch>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-5-m.felsch@pengutronix.de>
 <2993e0ed-ebe9-fd85-4650-7e53c15cfe34@gmail.com>
 <20200901082413.cjnmy3s4lb5pfhv5@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901082413.cjnmy3s4lb5pfhv5@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, I got this.
> 
> > , or assuming a prior state,
> 
> This is the our case. Isn't it the purpose of the bootloader to setup
> the HW?

This is a bit of a philosophical discussion. For PCs developers would
definitely agree, the firmware should be setting up most of the
hardware. And the firmware is involved in driving the hardware, via
ACPI. That works because you mostly cannot replaces the firmware.

In the ARM world we tend to take the opposite view. The bootloader
does the minimum to get the OS running, and the OS then setups up
everything. Often there are a choice of bootloaders, you have no idea
if the vendor bootload has been replaced by a mainline one with extra
features, etc. And we have no idea what the bootloader is actually
doing, so we try to assume nothing.

       Andrew
