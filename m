Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9582B88EC
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgKSAKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:10:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbgKSAKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:10:52 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfXXG-007pP6-Hy; Thu, 19 Nov 2020 01:10:50 +0100
Date:   Thu, 19 Nov 2020 01:10:50 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 02/11] net: dsa: microchip: ksz8795: remove superfluous
 port_cnt assignment
Message-ID: <20201119001050.GF1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-3-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-3-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:48PM +0100, Michael Grzeschik wrote:
> The port_cnt assignment will be done again in the init function.
> This patch removes the previous assignment in the detect function.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
