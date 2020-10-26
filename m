Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E66298CC3
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 13:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1774859AbgJZMN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 08:13:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1774787AbgJZMNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 08:13:15 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kX1Mv-003bHn-3T; Mon, 26 Oct 2020 13:12:57 +0100
Date:   Mon, 26 Oct 2020 13:12:57 +0100
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
Subject: Re: [linux-sunxi] Re: [PATCH] net: phy: realtek: omit setting
 PHY-side delay when "rgmii" specified
Message-ID: <20201026121257.GB836546@lunn.ch>
References: <20201025085556.2861021-1-icenowy@aosc.io>
 <20201025141825.GB792004@lunn.ch>
 <77AAA8B8-2918-4646-BE47-910DDDE38371@aosc.io>
 <20201025143608.GD792004@lunn.ch>
 <F5D81295-B4CD-4B80-846A-39503B70E765@aosc.io>
 <20201025172848.GI792004@lunn.ch>
 <C3279C11-EE7F-49FA-9BB3-ACA797B7B690@aosc.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3279C11-EE7F-49FA-9BB3-ACA797B7B690@aosc.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> By referring to linux/phy.h, NA means not applicable. This surely
> do not apply when RGMII is really in use.

It means the PHY driver should not touch the mode, something else has
set it up. That could be strapping, the bootloader, ACPI firmware,
whatever.

> I think no document declares RGMII must have all internal delays
> of the PHY explicitly disabled. It just says RGMII.

Please take a look at all the other PHY drivers. They should all
disable delays when passed PHY_INTERFACE_MODE_RGMII.

	Andrew
