Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5B22B88F6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKSAQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:16:32 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbgKSAQc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:16:32 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfXcl-007pTW-1q; Thu, 19 Nov 2020 01:16:31 +0100
Date:   Thu, 19 Nov 2020 01:16:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 04/11] net: dsa: microchip: ksz8795: use reg_mib_cnt
 where possible
Message-ID: <20201119001631.GH1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-5-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220357.22292-5-m.grzeschik@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:50PM +0100, Michael Grzeschik wrote:
> The extra define SWITCH_COUNTER_NUM is a copy of the KSZ8795_COUNTER_NUM
> define. This patch initializes reg_mib_cnt with KSZ8795_COUNTER_NUM,
> makes use of reg_mib_cnt everywhere instead and removes the extra
> define.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
