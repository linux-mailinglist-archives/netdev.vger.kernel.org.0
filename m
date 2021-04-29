Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBF36EA29
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 14:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbhD2MPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 08:15:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230148AbhD2MPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 08:15:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lc5Z9-001dqO-5L; Thu, 29 Apr 2021 14:14:47 +0200
Date:   Thu, 29 Apr 2021 14:14:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v1 3/3] net: dsa: ksz: ksz8863_smi_probe: set
 proper return value for ksz_switch_alloc()
Message-ID: <YIqjN5VNOVGnoot5@lunn.ch>
References: <20210429110833.2181-1-o.rempel@pengutronix.de>
 <20210429110833.2181-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429110833.2181-3-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 29, 2021 at 01:08:33PM +0200, Oleksij Rempel wrote:
> ksz_switch_alloc() will return NULL only if allocation is failed. So,
> the proper return value is -ENOMEM.
> 
> Fixes: 60a364760002 ("net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
