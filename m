Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BA620248C
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 16:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgFTOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 10:49:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50062 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728548AbgFTOtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 10:49:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jmeny-001PEe-9D; Sat, 20 Jun 2020 16:49:14 +0200
Date:   Sat, 20 Jun 2020 16:49:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        richardcochran@gmail.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, foss@0leil.net
Subject: Re: [PATCH net-next v3 1/8] net: phy: add support for a common probe
 between shared PHYs
Message-ID: <20200620144914.GI304147@lunn.ch>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
 <20200619122300.2510533-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619122300.2510533-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 02:22:53PM +0200, Antoine Tenart wrote:
> Shared PHYs (PHYs in the same hardware package) may have shared
> registers and their drivers would usually need to share information.
> There is currently a way to have a shared (part of the) init, by using
> phy_package_init_once(). This patch extends the logic to share parts of
> the probe to allow sharing the initialization of locks or resources
> retrieval.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
