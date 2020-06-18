Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5211E1FEC53
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 09:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgFRHUA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 03:20:00 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:47743 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727986AbgFRHT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 03:19:59 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 004AD4000A;
        Thu, 18 Jun 2020 07:19:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200617093217.2a664161@kicinski-fedora-PC1C0HJN>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com> <20200617133127.628454-7-antoine.tenart@bootlin.com> <20200617093217.2a664161@kicinski-fedora-PC1C0HJN>
To:     Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 6/8] net: phy: mscc: timestamping and PHC support
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Message-ID: <159246479497.467274.13476034822528412319@kwain>
Date:   Thu, 18 Jun 2020 09:19:55 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Quoting Jakub Kicinski (2020-06-17 18:32:17)
> On Wed, 17 Jun 2020 15:31:25 +0200 Antoine Tenart wrote:
> > This patch adds support for PHC and timestamping operations for the MSCC
> > PHY. PTP 1-step and 2-step modes are supported, over Ethernet and UDP.
> > 
> > To get and set the PHC time, a GPIO has to be used and changes are only
> > retrieved or committed when on a rising edge. The same GPIO is shared by
> > all PHYs, so the granularity of the lock protecting it has to be
> > different from the ones protecting the 1588 registers (the VSC8584 PHY
> > has 2 1588 blocks, and a single load/save pin).
> > 
> > Co-developed-by: Quentin Schulz <quentin.schulz@bootlin.com>
> > Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
> > Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
> 
> drivers/net/phy/mscc/mscc_ptp.c:406:24: warning: restricted __be16 degrades to integer
> drivers/net/phy/mscc/mscc_ptp.c:407:24: warning: restricted __be16 degrades to integer
> drivers/net/phy/mscc/mscc_ptp.c:1213:23: warning: symbol 'vsc85xx_clk_caps' was not declared. Should it be static?
> 
> Please make sure you don't add warnings when built with W=1 C=1 flags.

I'll look into that.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
