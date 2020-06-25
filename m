Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7663320A350
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391017AbgFYQr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:47:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60716 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390448AbgFYQr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 12:47:29 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1joV27-002EOb-Qr; Thu, 25 Jun 2020 18:47:27 +0200
Date:   Thu, 25 Jun 2020 18:47:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next 5/8] net: phy: mscc: do not access the MDIO bus
 lock directly
Message-ID: <20200625164727.GN442307@lunn.ch>
References: <20200625154211.606591-1-antoine.tenart@bootlin.com>
 <20200625154211.606591-6-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625154211.606591-6-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 05:42:08PM +0200, Antoine Tenart wrote:
> This patch improves the MSCC driver by using the provided
> phy_lock_mdio_bus and phy_unlock_mdio_bus helpers instead of locking and
> unlocking the MDIO bus lock directly. The patch is only cosmetic but
> should improve maintenance and consistency.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
