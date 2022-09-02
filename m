Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0225C5AADB8
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 13:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbiIBLcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 07:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236110AbiIBLbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 07:31:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF777D8B06
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 04:29:13 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oU4rI-0001eb-5X; Fri, 02 Sep 2022 13:29:12 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oU4rG-00021e-31; Fri, 02 Sep 2022 13:29:10 +0200
Date:   Fri, 2 Sep 2022 13:29:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>
Subject: Re: [PATCH v3: net-next 3/4] net: dsa: microchip: ksz9477: remove
 0x033C and 0x033D addresses from regmap_access_tables
Message-ID: <20220902112910.GB15827@pengutronix.de>
References: <20220902101610.109646-1-romain.naour@smile.fr>
 <20220902101610.109646-3-romain.naour@smile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220902101610.109646-3-romain.naour@smile.fr>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 02, 2022 at 12:16:09PM +0200, Romain Naour wrote:
> From: Romain Naour <romain.naour@skf.com>
> 
> According to the KSZ9477S datasheet, there is no global register
> at 0x033C and 0x033D addresses.
> 
> Signed-off-by: Romain Naour <romain.naour@skf.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>

> ---
>  drivers/net/dsa/microchip/ksz_common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 02fb721c1090..a700631130e0 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -546,7 +546,8 @@ static const struct regmap_range ksz9477_valid_regs[] = {
>  	regmap_reg_range(0x0302, 0x031b),
>  	regmap_reg_range(0x0320, 0x032b),
>  	regmap_reg_range(0x0330, 0x0336),
> -	regmap_reg_range(0x0338, 0x033e),
> +	regmap_reg_range(0x0338, 0x033b),
> +	regmap_reg_range(0x033e, 0x033e),
>  	regmap_reg_range(0x0340, 0x035f),
>  	regmap_reg_range(0x0370, 0x0370),
>  	regmap_reg_range(0x0378, 0x0378),
> -- 
> 2.34.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
