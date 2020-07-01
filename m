Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038E6210D88
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgGAOT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:19:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731331AbgGAOT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 10:19:27 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jqda5-0039kI-V4; Wed, 01 Jul 2020 16:19:21 +0200
Date:   Wed, 1 Jul 2020 16:19:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] net: dsa: microchip: enable ksz9893 via i2c in the
 ksz9477 driver
Message-ID: <20200701141921.GH718441@lunn.ch>
References: <20200701112216.GA8098@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701112216.GA8098@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 01:22:20PM +0200, Helmut Grohne wrote:
> The KSZ9893 3-Port Gigabit Ethernet Switch can be controlled via SPI,
> I²C or MDIO (very limited and not supported by this driver). While there
> is already a compatible entry for the SPI bus, it was missing for I²C.
> 
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
