Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 571BC562C75
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiGAHSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiGAHSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:18:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6474E39149
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 00:18:50 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o7AvF-0004E3-67; Fri, 01 Jul 2022 09:18:37 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1o7AvD-0003ME-DV; Fri, 01 Jul 2022 09:18:35 +0200
Date:   Fri, 1 Jul 2022 09:18:35 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: sja1105: silent spi_device_id
 warnings
Message-ID: <20220701071835.GC951@pengutronix.de>
References: <20220630071013.1710594-1-o.rempel@pengutronix.de>
 <20220630161059.jnmladythszbh7py@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630161059.jnmladythszbh7py@skbuf>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 07:10:59PM +0300, Vladimir Oltean wrote:
> On Thu, Jun 30, 2022 at 09:10:13AM +0200, Oleksij Rempel wrote:
> > Add spi_device_id entries to silent following warnings:
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1105e
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1105t
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1105p
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1105q
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1105r
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1105s
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1110a
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1110b
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1110c
> >  SPI driver sja1105 has no spi_device_id for nxp,sja1110d
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
> > index b253e27bcfb4..b03d0d0c3dbf 100644
> > --- a/drivers/net/dsa/sja1105/sja1105_main.c
> > +++ b/drivers/net/dsa/sja1105/sja1105_main.c
> > @@ -3382,12 +3382,28 @@ static const struct of_device_id sja1105_dt_ids[] = {
> >  };
> >  MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
> >  
> > +static const struct spi_device_id sja1105_spi_ids[] = {
> > +	{ "sja1105e" },
> > +	{ "sja1105t" },
> > +	{ "sja1105p" },
> > +	{ "sja1105q" },
> > +	{ "sja1105r" },
> > +	{ "sja1105s" },
> > +	{ "sja1110a" },
> > +	{ "sja1110b" },
> > +	{ "sja1110c" },
> > +	{ "sja1110d" },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(spi, sja1105_spi_ids);
> > +
> >  static struct spi_driver sja1105_driver = {
> >  	.driver = {
> >  		.name  = "sja1105",
> >  		.owner = THIS_MODULE,
> >  		.of_match_table = of_match_ptr(sja1105_dt_ids),
> >  	},
> > +	.id_table = sja1105_spi_ids,
> >  	.probe  = sja1105_probe,
> >  	.remove = sja1105_remove,
> >  	.shutdown = sja1105_shutdown,
> > -- 
> > 2.30.2
> > 
> 
> Do we also need these?
> 
> MODULE_ALIAS("spi:sja1105e");
> MODULE_ALIAS("spi:sja1105t");
> MODULE_ALIAS("spi:sja1105p");
> MODULE_ALIAS("spi:sja1105q");
> MODULE_ALIAS("spi:sja1105r");
> MODULE_ALIAS("spi:sja1105s");
> MODULE_ALIAS("spi:sja1110a");
> MODULE_ALIAS("spi:sja1110b");
> MODULE_ALIAS("spi:sja1110c");
> MODULE_ALIAS("spi:sja1110d");

No, it is not needed. With this patch modinfo will show this additional
aliases:
alias:          spi:sja1110d
alias:          spi:sja1110c
alias:          spi:sja1110b
alias:          spi:sja1110a
alias:          spi:sja1105s
alias:          spi:sja1105r
alias:          spi:sja1105q
alias:          spi:sja1105p
alias:          spi:sja1105t
alias:          spi:sja1105e

This seems to be enough for properly working module auto loading.

> To be honest I don't do much testing with modules at all, so I'm not
> sure if udev-based module loading is broken or not. I remember becoming
> vaguely curious after commit 5fa6863ba692 ("spi: Check we have a
> spi_device_id for each DT compatible"), and I did some basic testing
> without the spi_device_id table and MODULE_ALIASes, and it appeared that
> udev could still autoload the sja1105 kernel module just fine.
> So I'm not really sure what's broken.

Without this patch, module is not automatically loaded on my testing
system.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
