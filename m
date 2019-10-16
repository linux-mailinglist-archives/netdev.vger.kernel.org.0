Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC3EED99C5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 21:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394303AbfJPTOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 15:14:19 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:49027 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731321AbfJPTOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 15:14:19 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 4C4AB40007;
        Wed, 16 Oct 2019 19:14:16 +0000 (UTC)
Date:   Wed, 16 Oct 2019 21:14:16 +0200
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     David Miller <davem@davemloft.net>
Cc:     vz@mleia.com, slemieux.tyco@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] net: lpc_eth: parse phy nodes from device tree
Message-ID: <20191016191416.GA3125@piout.net>
References: <20191010204530.15150-1-alexandre.belloni@bootlin.com>
 <20191010204530.15150-2-alexandre.belloni@bootlin.com>
 <20191016.142359.416946718751400991.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016.142359.416946718751400991.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16/10/2019 14:23:59-0400, David Miller wrote:
> From: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Date: Thu, 10 Oct 2019 22:45:30 +0200
> 
> > When connected to a micrel phy, phy_find_first doesn't work properly
> > because the first phy found is on address 0, the broadcast address but, the
> > first thing the phy driver is doing is disabling this broadcast address.
> > The phy is then available only on address 1 but the mdio driver doesn't
> > know about it.
> > 
> > Instead, register the mdio bus using of_mdiobus_register and try to find
> > the phy description in device tree before falling back to phy_find_first.
> > 
> > This ultimately also allows to describe the interrupt the phy is connected
> > to.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> 
> I asked you to address Andrew's feedback.
> 
> You can't let this sit for days like that.
> 
> Therefore, I'm dropping your patches.

I'm planning to send a v2 to address that but I didn't have time to test
today.

-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
