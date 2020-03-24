Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07682191392
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgCXOtl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Mar 2020 10:49:41 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:45129 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgCXOtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:49:40 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 1522840003;
        Tue, 24 Mar 2020 14:49:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200324141829.GB14512@lunn.ch>
References: <20200324141358.4341-1-olteanv@gmail.com> <20200324141829.GB14512@lunn.ch>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next] net: phy: mscc: consolidate a common RGMII delay implementation
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Message-ID: <158506137648.157373.6196697912192436523@kwain>
Date:   Tue, 24 Mar 2020 15:49:37 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

Quoting Andrew Lunn (2020-03-24 15:18:29)
> On Tue, Mar 24, 2020 at 04:13:58PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > It looks like the VSC8584 PHY driver is rolling its own RGMII delay
> > configuration code, despite the fact that the logic is mostly the same.
> > 
> > In fact only the register layout and position for the RGMII controls has
> > changed. So we need to adapt and parameterize the PHY-dependent bit
> > fields when calling the new generic function.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>

Thanks!
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
