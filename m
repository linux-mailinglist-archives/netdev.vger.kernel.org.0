Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28A350B1DA
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445018AbiDVHnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 03:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444994AbiDVHm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 03:42:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A0762C0
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 00:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+bzX6unppLALgZs9OoXLQbo40iIdG37hYXyc56Z92tc=; b=NAHi85kV312BPTu4lpVF9UNmPb
        gjqYEZhmd49y17idhmp01B8yVRRl1sLXThu30fRbqCsd8dPdALX6Z0Cu86bsiJxOYaSuNvzH4+Rg/
        x9Om0U0iPmhVL4M/IF0Lr/8oC8FDN0L1hjFZFtc50sveJ2h2uMLmh1zQQ0NvvjKVdNqQerA6M4k80
        PTRQKX4HQz/0cPzgWnRre3X5uGwKlZpMXfHDHbhtm/9Oa8UNp4jcjaVEdnhAc0M35rVojd9OsbohZ
        iaiw+4O9EFFyKQTheS39n2oQmtZ6+8MrGKDjZTcVcgy5Yl+nekryID3ofJqbpMIQ2KPMXzVUsb/F3
        IbKT8Mug==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58364)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nhntY-0004Hj-5w; Fri, 22 Apr 2022 08:39:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nhntV-0003V2-TQ; Fri, 22 Apr 2022 08:39:57 +0100
Date:   Fri, 22 Apr 2022 08:39:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next 5/5] net: dsa: b53: mark as non-legacy
Message-ID: <YmJbzay/OiSAxYWF@shell.armlinux.org.uk>
References: <YhS3cko8D5c5tr+E@shell.armlinux.org.uk>
 <E1nMSDS-00A2Ru-6J@rmk-PC.armlinux.org.uk>
 <28bb4c50-c79e-8f09-2a00-ebbaa91ba1a6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28bb4c50-c79e-8f09-2a00-ebbaa91ba1a6@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 03:31:26PM -0700, Florian Fainelli wrote:
> Hi Russell,
> 
> On 2/22/22 02:16, Russell King (Oracle) wrote:
> > The B53 driver does not make use of the speed, duplex, pause or
> > advertisement in its phylink_mac_config() implementation, so it can be
> > marked as a non-legacy driver.
> > 
> > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > ---
> >   drivers/net/dsa/b53/b53_common.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
> > index 50a372dc32ae..83bf30349c26 100644
> > --- a/drivers/net/dsa/b53/b53_common.c
> > +++ b/drivers/net/dsa/b53/b53_common.c
> > @@ -1346,6 +1346,12 @@ static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
> >   	/* Get the implementation specific capabilities */
> >   	if (dev->ops->phylink_get_caps)
> >   		dev->ops->phylink_get_caps(dev, port, config);
> > +
> > +	/* This driver does not make use of the speed, duplex, pause or the
> > +	 * advertisement in its mac_config, so it is safe to mark this driver
> > +	 * as non-legacy.
> > +	 */
> > +	config->legacy_pre_march2020 = false;
> 
> This patch appears to cause a regression for me, I am not sure why I did not
> notice it back when I tested it but I suspect it had to do with me testing
> only with a copper module and not with a fiber module.
> 
> Now that I tested it again, the SFP port (port 5 in my set-up) link up
> interrupt does not fire up when setting config->legacy_pre_march2020 to
> false.
> 
> Here is a working log with phylink debugging enabled:
> 
> # udhcpc -i sfp
> udhcpc: started, v1.35.0
> [   49.479637] bgmac-enet 18024000.ethernet eth2: Link is Up - 1Gbps/Full -
> flow control off
> [   49.488139] Generic PHY fixed-0:02: PHY state change UP -> RUNNING
> [   49.488256] b53-srab-switch 18036000.ethernet-switch sfp: configuring for
> inband/1000base-x link mode
> [   49.504062] b53-srab-switch 18036000.ethernet-switch sfp: major config
> 1000base-x
> [   49.511800] b53-srab-switch 18036000.ethernet-switch sfp:
> phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown
> adv=0000000,00000201
> [   49.527504] b53-srab-switch 18036000.ethernet-switch sfp: mac link down
> [   49.535044] sfp sfp: SM: enter present:down:down event dev_up
> [   49.541006] sfp sfp: tx disable 1 -> 0
> [   49.544897] sfp sfp: SM: exit present:up:wait
> [   49.549509] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> udhcpc: broadcasting discover
> [   49.595185] sfp sfp: SM: enter present:up:wait event timeout
> [   49.601064] sfp sfp: SM: exit present:up:link_up
> [   52.388917] b53-srab-switch 18036000.ethernet-switch sfp: mac link up
> [   52.396513] b53-srab-switch 18036000.ethernet-switch sfp: Link is Up -
> 1Gbps/Full - flow control rx/tx
> [   52.406145] IPv6: ADDRCONF(NETDEV_CHANGE): sfp: link becomes ready
> udhcpc: broadcasting discover
> udhcpc: broadcasting select for 192.168.3.156, server 192.168.3.1
> udhcpc: lease of 192.168.3.156 obtained from 192.168.3.1, lease time 600
> deleting routers
> adding dns 192.168.1.1
> 
> and one that is not working with phylink debugging enabled:
> 
> # udhcpc -i sfp
> udhcpc: started, v1.35.0
> [   27.863529] bgmac-enet 18024000.ethernet eth2: Link is Up - 1Gbps/Full -
> flow control off
> [   27.872021] Generic PHY fixed-0:02: PHY state change UP -> RUNNING
> [   27.872120] b53-srab-switch 18036000.ethernet-switch sfp: configuring for
> inband/1000base-x link mode
> [   27.887952] b53-srab-switch 18036000.ethernet-switch sfp: major config
> 1000base-x
> [   27.895689] b53-srab-switch 18036000.ethernet-switch sfp:
> phylink_mac_config: mode=inband/1000base-x/Unknown/Unknown
> adv=0000000,00000201
> [   27.895802] b53-srab-switch 18036000.ethernet-switch sfp: mac link down
> [   27.911945] sfp sfp: SM: enter present:down:down event dev_up
> [   27.923947] sfp sfp: tx disable 1 -> 0
> [   27.927835] sfp sfp: SM: exit present:up:wait
> [   27.932442] IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> udhcpc: broadcasting discover
> [   27.978181] sfp sfp: SM: enter present:up:wait event timeout
> [   27.984056] sfp sfp: SM: exit present:up:link_up
> [   30.686440] b53-srab-switch 18036000.ethernet-switch sfp: mac link up
> udhcpc: broadcasting discover
> udhcpc: broadcasting discover
> 
> The mac side appears to be UP but not no carrier is set to the sfp network
> device. Do you have any idea why that would happen?

Oh, it's because setting that flag means we're wanting the PCS methods
rather than the legacy MAC methods for an_restart and getting the PCS
link state - so the patch in question was submitted too early (it
should have been _after_ the conversion to PCS.)

If we get the patch reverted in net-next, and then convert b53 to use
PCS support, we'll then be putting the patch back, so I wonder if it
would just make sense to apply the PCS conversion patch, possibly
adding a comment in the commit message pointing out that this fixes
the b53 legacy_pre_march2020 patch. Thoughts?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
