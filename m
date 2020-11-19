Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB52B8978
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgKSBWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:22:35 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgKSBWf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:22:35 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfYeg-007q3L-5s; Thu, 19 Nov 2020 02:22:34 +0100
Date:   Thu, 19 Nov 2020 02:22:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 11/11] net: dsa: microchip: ksz8795: use num_vlans where
 possible
Message-ID: <20201119012234.GO1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-12-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-12-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:57PM +0100, Michael Grzeschik wrote:
> The value of the define VLAN_TABLE_ENTRIES can be derived from
> num_vlans. This patch is using the variable num_vlans instead and
> removes the extra define.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
