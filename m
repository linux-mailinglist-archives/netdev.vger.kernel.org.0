Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C832B8960
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgKSBNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:13:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37060 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbgKSBNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:13:54 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfYWG-007pxJ-Dz; Thu, 19 Nov 2020 02:13:52 +0100
Date:   Thu, 19 Nov 2020 02:13:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 09/11] net: dsa: microchip: remove usage of mib_port_count
Message-ID: <20201119011352.GM1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-10-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-10-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:55PM +0100, Michael Grzeschik wrote:
> The variable mib_port_cnt has the same meaning as port_cnt.
> This driver removes the extra variable and is using port_cnt
> everywhere instead.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Nice to see another poorly defined variable disappear.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
