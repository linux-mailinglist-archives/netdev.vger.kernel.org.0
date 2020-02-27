Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9D81722E3
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbgB0QKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:10:13 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:59979 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729890AbgB0QKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 11:10:13 -0500
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id DCBBA100007;
        Thu, 27 Feb 2020 16:10:10 +0000 (UTC)
Date:   Thu, 27 Feb 2020 17:10:10 +0100
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: mscc: support LOS active low
Message-ID: <20200227161010.GC1686232@kwain>
References: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
 <20200227155440.GC5245@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227155440.GC5245@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On Thu, Feb 27, 2020 at 04:54:40PM +0100, Andrew Lunn wrote:
> On Thu, Feb 27, 2020 at 04:40:31PM +0100, Antoine Tenart wrote:
> > 
> > This series adds a device tree property for the VSC8584 PHY family to
> > describe the LOS pin connected to the PHY as being active low. This new
> > property is then used in the MSCC PHY driver.
> 
> I think i'm missing the big picture.
> 
> Is this for when an SFP is connected directly to the PHY? The SFP
> output LOS, indicating loss of received fibre/copper signal, is active
> low?

Yes, the SFP cage can be connected directly to the PHY, and the SFP LOS
signal is active low (there's a pull-up on the LOS line).

Also, I realized I send this series before my other patches adding
support for fibre mode on this PHY, so it may make more sense to send
this one after.

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
