Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398B163892D
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 12:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiKYLzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 06:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiKYLzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 06:55:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 068A12CDC3
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 03:55:02 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oyXIK-0000je-S4; Fri, 25 Nov 2022 12:55:00 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oyXIJ-0002ZF-C6; Fri, 25 Nov 2022 12:54:59 +0100
Date:   Fri, 25 Nov 2022 12:54:59 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Arun.Ramadoss@microchip.com
Cc:     Woojung.Huh@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        edumazet@google.com, pabeni@redhat.com, kernel@pengutronix.de,
        kuba@kernel.org, olteanv@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Message-ID: <20221125115459.GD22688@pengutronix.de>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
 <20221124101458.3353902-7-o.rempel@pengutronix.de>
 <e270aedb761cad689ee969285ac07578848e2ae5.camel@microchip.com>
 <20221125055240.GA22688@pengutronix.de>
 <439da76d5f0fb800f11cec66c06a444a7a4e591a.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <439da76d5f0fb800f11cec66c06a444a7a4e591a.camel@microchip.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 25, 2022 at 07:14:32AM +0000, Arun.Ramadoss@microchip.com wrote:
> Hi Oleksij,
> 
> On Fri, 2022-11-25 at 06:52 +0100, Oleksij Rempel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > Hi Arun,
> > 
> > On Thu, Nov 24, 2022 at 03:05:27PM +0000, Arun.Ramadoss@microchip.com
> >  wrote:
> > > Hi Oleksij,
> > > On Thu, 2022-11-24 at 11:14 +0100, Oleksij Rempel wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > > > know the content is safe
> > > > 
> > > > To make the code more comparable to KSZ9477 code, move DSA
> > > > configurations to the same location.
> > > > 
> > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > ---
> > > >  drivers/net/dsa/microchip/ksz8795.c | 20 ++++++++++----------
> > > >  1 file changed, 10 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/dsa/microchip/ksz8795.c
> > > > b/drivers/net/dsa/microchip/ksz8795.c
> > > > index 060e41b9b6ef..003b0ac2854c 100644
> > > > --- a/drivers/net/dsa/microchip/ksz8795.c
> > > > +++ b/drivers/net/dsa/microchip/ksz8795.c
> > > > @@ -1359,6 +1359,16 @@ int ksz8_setup(struct dsa_switch *ds)
> > > > 
> > > >         ds->mtu_enforcement_ingress = true;
> > > > 
> > > > +       /* We rely on software untagging on the CPU port, so that
> > > > we
> > > > +        * can support both tagged and untagged VLANs
> > > > +        */
> > > > +       ds->untag_bridge_pvid = true;
> > > > +
> > > > +       /* VLAN filtering is partly controlled by the global VLAN
> > > > +        * Enable flag
> > > > +        */
> > > > +       ds->vlan_filtering_is_global = true;
> > > > +
> > > >         ksz_cfg(dev, S_REPLACE_VID_CTRL, SW_FLOW_CTRL, true);
> > > > 
> > > >         /* Enable automatic fast aging when link changed
> > > > detected. */
> > > > @@ -1418,16 +1428,6 @@ int ksz8_switch_init(struct ksz_device
> > > > *dev)
> > > >         dev->phy_port_cnt = dev->info->port_cnt - 1;
> > > >         dev->port_mask = (BIT(dev->phy_port_cnt) - 1) | dev-
> > > > >info-
> > > > > cpu_ports;
> > > 
> > > Since you moved dsa related items to ksz8_setup, remaining items in
> > > ksz8_switch_init are
> > > - dev->cpu_port - Used in ksz_setup but called after the individual
> > > switch setup function. We can move it ksz8_setup.
> > > - dev->phy_port_cnt - Used in ksz8_vlan_filtering and
> > > ksz8_config_cpuport. We can move.
> > > - dev->port_mask - used in ksz_switch_register. So we cannot move.
> > > 
> > > To make the ksz8_switch_init and ksz9477_switch_init function
> > > similar,
> > > we can move dev->cpu_port and dev->phy_port_cnt from
> > > ksz8_switch_init
> > > to ksz8_setup
> > 
> > It make no sense to move this variables. Every place where they are
> > used, can be replaced with dsa functions like:
> > dsa_switch_for_each_user_port() or dsa_cpu_ports()/dsa_is_cpu_port()
> > Making this changes within this patch set make no sense to.
> 
> Agreed. 
> I thought of cleaning up
> ksz8_switch_init/ksz9477_switch_init/lan937x_switch_init, since these
> functions are not performing any useful activity other than
> initializing these variables. Similarly all the exit function are
> performing same reset function. I thought these init and exit function
> in the ksz_dev_ops structure is reduntant.

Can you please give your Acked-by? :)

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
