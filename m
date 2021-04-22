Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5533680C4
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236327AbhDVMqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:46:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35658 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236144AbhDVMqW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 08:46:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZYiD-000UwN-Aq; Thu, 22 Apr 2021 14:45:41 +0200
Date:   Thu, 22 Apr 2021 14:45:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/9] net: phy: Add support for LAN937x T1 phy
 driver
Message-ID: <YIFv9Wcp94395Hbb@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-3-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-3-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +#define PORT_T1_PHY_RESET	BIT(15)
> +#define PORT_T1_PHY_LOOPBACK	BIT(14)
> +#define PORT_T1_SPEED_100MBIT	BIT(13)
> +#define PORT_T1_POWER_DOWN	BIT(11)
> +#define PORT_T1_ISOLATE	BIT(10)
> +#define PORT_T1_FULL_DUPLEX	BIT(8)

These appear to be standard BMCR_ values. Please don't define your
own.

> +
> +#define REG_PORT_T1_PHY_BASIC_STATUS 0x01
> +
> +#define PORT_T1_MII_SUPPRESS_CAPABLE	BIT(6)
> +#define PORT_T1_LINK_STATUS		BIT(2)
> +#define PORT_T1_EXTENDED_CAPABILITY	BIT(0)
> +
> +#define REG_PORT_T1_PHY_ID_HI 0x02
> +#define REG_PORT_T1_PHY_ID_LO 0x03

MII_PHYSID1 and MII_PHYSID2

Please go through all these #defines and replace them with the
standard ones Linux provides. You are obfusticating the code by not
using what people already know.

      Andrew
