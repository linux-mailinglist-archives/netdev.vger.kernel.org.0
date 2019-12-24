Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C631212A127
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 13:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLXMKU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 24 Dec 2019 07:10:20 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52651 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfLXMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 07:10:20 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ijj0u-0005ZY-V0; Tue, 24 Dec 2019 13:10:12 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1ijj0s-0001Q6-6P; Tue, 24 Dec 2019 13:10:10 +0100
Date:   Tue, 24 Dec 2019 13:10:10 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, linux@rempel-privat.de, marek.behun@nic.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: qca: ar9331: drop pointless static
 qualifier in ar9331_sw_mbus_init
Message-ID: <20191224121010.o5ezcorzix5kfjns@pengutronix.de>
References: <20191224112515.GE3395@lunn.ch>
 <20191224115812.166927-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191224115812.166927-1-maowenan@huawei.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:09:13 up 39 days,  3:27, 37 users,  load average: 0.00, 0.02,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Dec 24, 2019 at 07:58:12PM +0800, Mao Wenan wrote:
> There is no need to set variable 'mbus' static
> since new value always be assigned before use it.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  v2: change subject and description.
>  drivers/net/dsa/qca/ar9331.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 0d1a7cd85fe8..da3bece75e21 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -266,7 +266,7 @@ static int ar9331_sw_mbus_read(struct mii_bus *mbus, int port, int regnum)
>  static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
>  {
>  	struct device *dev = priv->dev;
> -	static struct mii_bus *mbus;
> +	struct mii_bus *mbus;
>  	struct device_node *np, *mnp;
>  	int ret;
>  
> -- 
> 2.20.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
