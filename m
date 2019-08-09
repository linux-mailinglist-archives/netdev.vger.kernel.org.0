Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7A2878E6
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 13:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406599AbfHILkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 07:40:55 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:56339 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405999AbfHILky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 07:40:54 -0400
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 7E55410000D;
        Fri,  9 Aug 2019 11:40:51 +0000 (UTC)
Date:   Fri, 9 Aug 2019 13:40:50 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        sd@queasysnail.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        alexandre.belloni@bootlin.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: Re: [PATCH net-next v2 0/9] net: macsec: initial support for
 hardware offloading
Message-ID: <20190809114050.GA5285@kwain>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
 <20190809112344.5anl7wq5df5ctj26@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809112344.5anl7wq5df5ctj26@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Allan,

On Fri, Aug 09, 2019 at 01:23:47PM +0200, Allan W. Nielsen wrote:
> 
> I have done a first read through of your patch and it looks good to me.
> 
> The only thing which confused me is all the references to Ocelot.
> 
> As far as I can see, this is a driver for the vsc8584 PHY in the Viper family.
> The Ocelot confusion is properly because you are developing it on an Ocelot
> board. But this is actually a modded board, the official PCB 120 and PCB123 has
> a different pin compatible PHY without MACsec.
> 
> FYI: In the Viper family we have VSC8575, VSC8582, VSC8584, VSC8562 and VSC8564.
> 
> VSC8575, does not have MACsec, but all other does, and they are binary
> compatible (it is the same die instantiated 2 or 4 times, with or without
> MACsec/SyncE).
> 
> I beleive it is only the commit comments which needs to be addressed.

That's right, I mixed up Ocelot and the actual PHY names. I'll look for
Ocelot references in the patches and I'll fix it in v3.

Thanks for spotting this,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
