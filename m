Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2951329820A
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416516AbgJYOSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:18:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43426 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1416511AbgJYOSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 10:18:46 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWgqn-003R7C-GX; Sun, 25 Oct 2020 15:18:25 +0100
Date:   Sun, 25 Oct 2020 15:18:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH] net: phy: realtek: omit setting PHY-side delay when
 "rgmii" specified
Message-ID: <20201025141825.GB792004@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201025085556.2861021-1-icenowy@aosc.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 04:55:56PM +0800, Icenowy Zheng wrote:
> Currently there are many boards that just set "rgmii" as phy-mode in the
> device tree, and leave the hardware [TR]XDLY pins to set PHY delay mode.
> 
> In order to keep old device tree working, omit setting delay for just
> "RGMII" without any internal delay suffix, otherwise many devices are
> broken.

Hi Icenowy

We have been here before with the Atheros PHY. It did not correctly
implement one of the delay modes, until somebody really did need that
mode. So the driver was fixed. And we then found a number of device
trees were also buggy. It was painful for a while, but all the device
trees got fixed.

We should do the same here. Please submit patches for the device tree
files.

   Andrew
