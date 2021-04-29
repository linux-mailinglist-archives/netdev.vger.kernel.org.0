Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF9636EA26
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 14:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbhD2MPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 08:15:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46026 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhD2MPQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 08:15:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lc5Yn-001dph-F8; Thu, 29 Apr 2021 14:14:25 +0200
Date:   Thu, 29 Apr 2021 14:14:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ksz: ksz8795_spi_probe: fix
 possible NULL pointer dereference
Message-ID: <YIqjIdofihe0ViWy@lunn.ch>
References: <20210429110833.2181-1-o.rempel@pengutronix.de>
 <20210429110833.2181-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429110833.2181-2-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 01:08:32PM +0200, Oleksij Rempel wrote:
> Fix possible NULL pointer dereference in case devm_kzalloc() failed to
> allocate memory
> 
> Fixes: cc13e52c3a89 ("net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support")
> Reported-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

