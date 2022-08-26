Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0BD5A224E
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 09:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245674AbiHZHwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 03:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245573AbiHZHwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 03:52:01 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CE2BA9E5
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 00:52:00 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRU8E-0001SH-B3; Fri, 26 Aug 2022 09:51:58 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oRU8E-0004tJ-0G; Fri, 26 Aug 2022 09:51:58 +0200
Date:   Fri, 26 Aug 2022 09:51:57 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v3 15/17] net: dsa: microchip: ksz9477: remove
 unused "on" variable
Message-ID: <20220826075157.GD2116@pengutronix.de>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
 <20220823080231.2466017-16-o.rempel@pengutronix.de>
 <20220825205407.jayiksjrnccpknoj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220825205407.jayiksjrnccpknoj@skbuf>
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

On Thu, Aug 25, 2022 at 11:54:07PM +0300, Vladimir Oltean wrote:
> On Tue, Aug 23, 2022 at 10:02:29AM +0200, Oleksij Rempel wrote:
> > This variable is not used on ksz9477 side. Remove it.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  drivers/net/dsa/microchip/ksz9477.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> > index bfefb60ec91bf..609bd63f4cdb1 100644
> > --- a/drivers/net/dsa/microchip/ksz9477.c
> > +++ b/drivers/net/dsa/microchip/ksz9477.c
> > @@ -1070,7 +1070,6 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
> >  
> >  			/* enable cpu port */
> >  			ksz9477_port_setup(dev, i, true);
> > -			p->on = 1;
> >  		}
> >  	}
> >  
> > @@ -1080,7 +1079,6 @@ void ksz9477_config_cpu_port(struct dsa_switch *ds)
> >  		p = &dev->ports[i];
> >  
> >  		ksz_port_stp_state_set(ds, i, BR_STATE_DISABLED);
> > -		p->on = 1;
> >  		if (dev->chip_id == 0x00947700 && i == 6) {
> >  			p->sgmii = 1;
> >  		}
> > -- 
> > 2.30.2
> > 
> 
> And it seems like it's not used on ksz8 either. The reason I'm saying
> that is that ksz8_flush_dyn_mac_table() is the only apparent user of
> p->on, and that only for the case where flushing the FDB of all ports is
> requested (port > dev->info->port_cnt). But ksz8_flush_dyn_mac_table()
> (through dev->dev_ops->flush_dyn_mac_table) is only called from DSA's
> ds->ops->port_fast_age() method, and that will never be requested
> "for all ports" (and to my knowledge never was in the past, either).
> Badly ported SDK code would be my guess. So there are more
> simplifications which could be done.

Ok, i'll take a look on it as soon as i get one of ksz8 board in my
fingers.

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
