Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FC86E11A9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjDMQE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbjDMQE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:04:56 -0400
Received: from h1.cmg1.smtp.forpsi.com (h1.cmg1.smtp.forpsi.com [81.2.195.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E878A53
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:04:52 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id mzRHpFPBcPm6CmzRJpKqom; Thu, 13 Apr 2023 18:04:50 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681401890; bh=f2WuKoeOzYL0MzgmLMSFh+coxssMVyWxEY2tiHIiMGk=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=u8twZhQ8PP4/eO+fLTztelNDl9xqPZ7vnJgok9F9Ae7ND/GIYoAKwGNXaNLdeOr0H
         t1DbmzSF4XudHanPKB2vDvcLoF7dYYG2QfVC62UmZEf8cunBzosDOqO/APetwUDiI1
         gHZjwqbc5fpDoVX2tQqYjfanZlFGtaFsc+2sndrv+AqB18xbTUSE5ipzFrUs09IDVQ
         uuOicvQuRmDXrlcXOqOPF5DurOXvrJmS+t7Jd74aLOm5qFrr/6y/cdQl9SiuhvAjEc
         UTfB0GGsdUzQ+UXZ86OcZR2s0+gGYJZYS/Hcyi5GZylGMjdApJUaKJVX0RlRNOzHi+
         78Rwy8y2o/piw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681401890; bh=f2WuKoeOzYL0MzgmLMSFh+coxssMVyWxEY2tiHIiMGk=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=u8twZhQ8PP4/eO+fLTztelNDl9xqPZ7vnJgok9F9Ae7ND/GIYoAKwGNXaNLdeOr0H
         t1DbmzSF4XudHanPKB2vDvcLoF7dYYG2QfVC62UmZEf8cunBzosDOqO/APetwUDiI1
         gHZjwqbc5fpDoVX2tQqYjfanZlFGtaFsc+2sndrv+AqB18xbTUSE5ipzFrUs09IDVQ
         uuOicvQuRmDXrlcXOqOPF5DurOXvrJmS+t7Jd74aLOm5qFrr/6y/cdQl9SiuhvAjEc
         UTfB0GGsdUzQ+UXZ86OcZR2s0+gGYJZYS/Hcyi5GZylGMjdApJUaKJVX0RlRNOzHi+
         78Rwy8y2o/piw==
Date:   Thu, 13 Apr 2023 18:04:47 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Dan Carpenter <error27@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [RFC 3/3] staging: octeon: convert to use phylink
Message-ID: <ZDgoH0KQ/Q0ydxn3@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOZZb2LrlFEEbv@lenoch>
 <0af60abb-d599-4fdd-9bf6-ccf14524fe44@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0af60abb-d599-4fdd-9bf6-ccf14524fe44@kili.mountain>
X-CMAE-Envelope: MS4wfMP/QEnlCYcuOrIc9vChBJcl4OXcm5ubsslVKDA+NGdBZW6WiDUPgLlCWY96xINhwMOx6bLRpHO6UoUy6QT8Pt1YVlUy+vR6yJXGjuAUGSTuczy5m0lm
 U8lvcuZi7cU823wkEZrIpVoleIcMSEaUjso4XDINNNX75Ckn+WJf2CN3wh28w6Apmvqi4+/mrsWcJnLS5W//SCaWCHq4ekzXD5fclUN1V8yC1lCgGjubHnlX
 NaGzbH6RZeCpbKIyf3+uy7jABhnWfRBcia6sDQjIfy/X2t0XnFXnRpdqowk7ZEy0KW0u7ZNMClV/Ch3sFlT5pGJS+jXzrGSAIXoyQrg1swY=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Thu, Apr 13, 2023 at 06:35:55PM +0300, Dan Carpenter wrote:
> On Thu, Apr 13, 2023 at 04:15:01PM +0200, Ladislav Michl wrote:
> > From: Ladislav Michl <ladis@linux-mips.org>
> > 
> > Signed-off-by: Ladislav Michl <ladis@linux-mips.org>
> 
> We always insist that every commit needs a commit message.
> 
> Why are you doing this?  Does this have any effect for the user?
> Imagine you are a power user and something stops working and they are
> reviewing the git log to see if it's intentional or not.

This is just RFC, I expect much more versions until it is eventually
accepted and this patch might be posibly splitted into more patches.

I'm glad it didn't stop you from providing feedback :)

> > ---
> >  drivers/staging/octeon/Kconfig           |   2 +-
> >  drivers/staging/octeon/ethernet-mdio.c   | 171 ++++++++++++++---------
> >  drivers/staging/octeon/ethernet-rgmii.c  |  13 +-
> >  drivers/staging/octeon/ethernet.c        |  64 +++------
> >  drivers/staging/octeon/octeon-ethernet.h |   8 +-
> >  5 files changed, 136 insertions(+), 122 deletions(-)
> > 
> > diff --git a/drivers/staging/octeon/Kconfig b/drivers/staging/octeon/Kconfig
> > index 5319909eb2f6..fda90025710d 100644
> > --- a/drivers/staging/octeon/Kconfig
> > +++ b/drivers/staging/octeon/Kconfig
> > @@ -3,7 +3,7 @@ config OCTEON_ETHERNET
> >  	tristate "Cavium Networks Octeon Ethernet support"
> >  	depends on CAVIUM_OCTEON_SOC || COMPILE_TEST
> >  	depends on NETDEVICES
> > -	select PHYLIB
> > +	select PHYLINK
> >  	select MDIO_OCTEON
> >  	help
> >  	  This driver supports the builtin ethernet ports on Cavium
> > diff --git a/drivers/staging/octeon/ethernet-mdio.c b/drivers/staging/octeon/ethernet-mdio.c
> > index b3049108edc4..a14fb4dbb2fd 100644
> > --- a/drivers/staging/octeon/ethernet-mdio.c
> > +++ b/drivers/staging/octeon/ethernet-mdio.c
> > @@ -9,7 +9,7 @@
> >  #include <linux/ethtool.h>
> >  #include <linux/phy.h>
> >  #include <linux/ratelimit.h>
> > -#include <linux/of_mdio.h>
> 
> Removing this include seems unrelated?

No. We are using phylink now, so it is not needed. This file should
eventually vanish, small part being merged into ethernet.c and the
into appropriate mac files (ethernet-sgmii.c, ethernet-rgmii.c...).

> > +#include <linux/of_net.h>
> >  #include <generated/utsrelease.h>
> >  #include <net/dst.h>
> >  
> > @@ -26,23 +26,27 @@ static void cvm_oct_get_drvinfo(struct net_device *dev,
> >  	strscpy(info->bus_info, "Builtin", sizeof(info->bus_info));
> >  }
> >  
> > -static int cvm_oct_nway_reset(struct net_device *dev)
> > +static int cvm_oct_get_link_ksettings(struct net_device *dev,
> > +				      struct ethtool_link_ksettings *cmd)
> >  {
> > -	if (!capable(CAP_NET_ADMIN))
> > -		return -EPERM;
> > +	struct octeon_ethernet *priv = netdev_priv(dev);
> > +
> > +	return phylink_ethtool_ksettings_get(priv->phylink, cmd);
> > +}
> >  
> > -	if (dev->phydev)
> > -		return phy_start_aneg(dev->phydev);
> > +static int cvm_oct_set_link_ksettings(struct net_device *dev,
> > +				      const struct ethtool_link_ksettings *cmd)
> > +{
> > +	struct octeon_ethernet *priv = netdev_priv(dev);
> >  
> > -	return -EINVAL;
> > +	return phylink_ethtool_ksettings_set(priv->phylink, cmd);
> >  }
> >  
> >  const struct ethtool_ops cvm_oct_ethtool_ops = {
> >  	.get_drvinfo = cvm_oct_get_drvinfo,
> > -	.nway_reset = cvm_oct_nway_reset,
> >  	.get_link = ethtool_op_get_link,
> > -	.get_link_ksettings = phy_ethtool_get_link_ksettings,
> > -	.set_link_ksettings = phy_ethtool_set_link_ksettings,
> > +	.get_link_ksettings = cvm_oct_get_link_ksettings,
> > +	.set_link_ksettings = cvm_oct_set_link_ksettings,
> >  };
> >  
> >  /**
> > @@ -55,53 +59,80 @@ const struct ethtool_ops cvm_oct_ethtool_ops = {
> >   */
> >  int cvm_oct_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> >  {
> > -	if (!netif_running(dev))
> > -		return -EINVAL;
> > +	struct octeon_ethernet *priv = netdev_priv(dev);
> >  
> > -	if (!dev->phydev)
> > -		return -EINVAL;
> > +	return phylink_mii_ioctl(priv->phylink, rq, cmd);
> > +}
> >  
> > -	return phy_mii_ioctl(dev->phydev, rq, cmd);
> > +static void cvm_oct_mac_get_state(struct phylink_config *config,
> > +				  struct phylink_link_state *state)
> > +{
> > +	union cvmx_helper_link_info link_info;
> > +	struct net_device *dev = to_net_dev(config->dev);
> > +	struct octeon_ethernet *priv = netdev_priv(dev);
> > +
> > +	link_info = cvmx_helper_link_get(priv->port);
> > +	state->link = link_info.s.link_up;
> > +	state->duplex = link_info.s.full_duplex ? DUPLEX_FULL : DUPLEX_HALF;
> > +	state->speed = link_info.s.speed;
> >  }
> >  
> > -void cvm_oct_note_carrier(struct octeon_ethernet *priv,
> > -			  union cvmx_helper_link_info li)
> > +static void cvm_oct_mac_config(struct phylink_config *config,
> > +			       unsigned int mode,
> > +			       const struct phylink_link_state *state)
> >  {
> > -	if (li.s.link_up) {
> > -		pr_notice_ratelimited("%s: %u Mbps %s duplex, port %d, queue %d\n",
> > -				      netdev_name(priv->netdev), li.s.speed,
> > -				      (li.s.full_duplex) ? "Full" : "Half",
> > -				      priv->port, priv->queue);
> > -	} else {
> > -		pr_notice_ratelimited("%s: Link down\n",
> > -				      netdev_name(priv->netdev));
> > -	}
> >  }
> 
> Delete this dummy function.

This is not possible. Core uses this callback, but I can at least add
comment stating there is nothing do to here.

Later there should be mac initialization, but currently it is called from
cvmx-helper in arch/mips/cavium-octeon/executive/
 
> > -void cvm_oct_adjust_link(struct net_device *dev)
> > +static void cvm_oct_mac_link_down(struct phylink_config *config,
> > +				  unsigned int mode, phy_interface_t interface)
> >  {
> > +	union cvmx_helper_link_info link_info;
> > +	struct net_device *dev = to_net_dev(config->dev);
> >  	struct octeon_ethernet *priv = netdev_priv(dev);
> > +
> > +	link_info.u64		= 0;
> > +	link_info.s.link_up	= 0;
> > +	link_info.s.full_duplex = 0;
> > +	link_info.s.speed	= 0;
> 
> Just do this in the initializer:

ok.

> 	union cvmx_helper_link_info link_info = {};
> 
> > +	priv->link_info		= link_info.u64;
> 
> Best to not align anything in a .c file.  Stuff in .c files changes a
> lot and then when you change it you have to re-indent everything.  And
> it's like, *ugh*, is re-indenting supposed to be done in a follow on
> patch?
> 
> The "link_info.u64" also zeroes everything so the rest was already
> duplicative...

I used the way common in Octeon drivers, but agree here. Will drop this.

> > +
> > +	cvmx_helper_link_set(priv->port, link_info);
> > +
> > +	priv->poll_used = false;
> > +}
> > +
> > +static void cvm_oct_mac_link_up(struct phylink_config *config,
> > +				struct phy_device *phy,
> > +				unsigned int mode, phy_interface_t interface,
> > +				int speed, int duplex,
> > +				bool tx_pause, bool rx_pause)
> > +{
> >  	union cvmx_helper_link_info link_info;
> > +	struct net_device *dev = to_net_dev(config->dev);
> > +	struct octeon_ethernet *priv = netdev_priv(dev);
> >  
> >  	link_info.u64		= 0;
> > -	link_info.s.link_up	= dev->phydev->link ? 1 : 0;
> > -	link_info.s.full_duplex = dev->phydev->duplex ? 1 : 0;
> > -	link_info.s.speed	= dev->phydev->speed;
> > +	link_info.s.link_up	= 1;
> > +	link_info.s.full_duplex = duplex == DUPLEX_FULL ? 1 : 0;
> > +	link_info.s.speed	= speed;
> >  	priv->link_info		= link_info.u64;
> >  
> > -	/*
> > -	 * The polling task need to know about link status changes.
> > -	 */
> > -	if (priv->poll)
> > -		priv->poll(dev);
> > +	cvmx_helper_link_set(priv->port, link_info);
> >  
> > -	if (priv->last_link != dev->phydev->link) {
> > -		priv->last_link = dev->phydev->link;
> > -		cvmx_helper_link_set(priv->port, link_info);
> > -		cvm_oct_note_carrier(priv, link_info);
> > +	if (!phy && priv->poll) {
> > +		priv->poll_used = true;
> > +		priv->poll(dev);
> >  	}
> >  }
> >  
> > +static const struct phylink_mac_ops cvm_oct_phylink_ops = {
> > +	.validate = phylink_generic_validate,
> > +	.mac_pcs_get_state = cvm_oct_mac_get_state,
> > +	.mac_config = cvm_oct_mac_config,
> > +	.mac_link_down = cvm_oct_mac_link_down,
> > +	.mac_link_up = cvm_oct_mac_link_up,
> > +};
> > +
> >  int cvm_oct_common_stop(struct net_device *dev)
> >  {
> >  	struct octeon_ethernet *priv = netdev_priv(dev);
> > @@ -116,15 +147,14 @@ int cvm_oct_common_stop(struct net_device *dev)
> >  
> >  	priv->poll = NULL;
> >  
> > -	if (dev->phydev)
> > -		phy_disconnect(dev->phydev);
> > +	phylink_stop(priv->phylink);
> > +	phylink_disconnect_phy(priv->phylink);
> >  
> >  	if (priv->last_link) {
> >  		link_info.u64 = 0;
> >  		priv->last_link = 0;
> >  
> >  		cvmx_helper_link_set(priv->port, link_info);
> > -		cvm_oct_note_carrier(priv, link_info);
> >  	}
> >  	return 0;
> >  }
> > @@ -138,34 +168,45 @@ int cvm_oct_common_stop(struct net_device *dev)
> >   */
> >  int cvm_oct_phy_setup_device(struct net_device *dev)
> >  {
> > +	phy_interface_t phy_mode;
> > +	struct phylink *phylink;
> >  	struct octeon_ethernet *priv = netdev_priv(dev);
> > -	struct device_node *phy_node;
> > -	struct phy_device *phydev = NULL;
> >  
> > -	if (!priv->of_node)
> > -		goto no_phy;
> > -
> > -	phy_node = of_parse_phandle(priv->of_node, "phy-handle", 0);
> > -	if (!phy_node && of_phy_is_fixed_link(priv->of_node))
> > -		phy_node = of_node_get(priv->of_node);
> > -	if (!phy_node)
> > -		goto no_phy;
> > +	priv->phylink_config.dev = &dev->dev;
> > +	priv->phylink_config.type = PHYLINK_NETDEV;
> > +	priv->phylink_config.mac_capabilities = MAC_ASYM_PAUSE |
> > +						MAC_10 | MAC_100 | MAC_1000;
> > +	__set_bit(PHY_INTERFACE_MODE_MII,
> > +		  priv->phylink_config.supported_interfaces);
> > +	__set_bit(PHY_INTERFACE_MODE_RMII,
> > +		  priv->phylink_config.supported_interfaces);
> > +
> > +	switch (priv->imode) {
> > +	case CVMX_HELPER_INTERFACE_MODE_RGMII:
> > +		phy_interface_set_rgmii(priv->phylink_config.supported_interfaces);
> > +		break;
> > +	case CVMX_HELPER_INTERFACE_MODE_SGMII:
> > +		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
> > +			  priv->phylink_config.supported_interfaces);
> > +		__set_bit(PHY_INTERFACE_MODE_SGMII,
> > +			  priv->phylink_config.supported_interfaces);
> > +		__set_bit(PHY_INTERFACE_MODE_QSGMII,
> > +			  priv->phylink_config.supported_interfaces);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> >  
> > -	phydev = of_phy_connect(dev, phy_node, cvm_oct_adjust_link, 0,
> > -				priv->phy_mode);
> > -	of_node_put(phy_node);
> > +	if (of_get_phy_mode(priv->of_node, &phy_mode) == 0)
> > +		priv->phy_mode = phy_mode;
> >  
> > -	if (!phydev)
> > -		return -EPROBE_DEFER;
> > +	phylink = phylink_create(&priv->phylink_config,
> > +				 of_fwnode_handle(priv->of_node),
> > +				 priv->phy_mode, &cvm_oct_phylink_ops);
> > +	if (IS_ERR(phylink))
> > +		return PTR_ERR(phylink);
> >  
> > -	priv->last_link = 0;
> > -	phy_start(phydev);
> > +	priv->phylink = phylink;
> >  
> > -	return 0;
> > -no_phy:
> > -	/* If there is no phy, assume a direct MAC connection and that
> > -	 * the link is up.
> > -	 */
> > -	netif_carrier_on(dev);
> >  	return 0;
> >  }
> > diff --git a/drivers/staging/octeon/ethernet-rgmii.c b/drivers/staging/octeon/ethernet-rgmii.c
> > index 0c4fac31540a..8c6eb0b87254 100644
> > --- a/drivers/staging/octeon/ethernet-rgmii.c
> > +++ b/drivers/staging/octeon/ethernet-rgmii.c
> > @@ -115,17 +115,8 @@ static void cvm_oct_rgmii_poll(struct net_device *dev)
> >  
> >  	cvm_oct_check_preamble_errors(dev);
> >  
> > -	if (likely(!status_change))
>                    ^
> Negated.

On purpose.

> > -		return;
> > -
> > -	/* Tell core. */
> > -	if (link_info.s.link_up) {
> > -		if (!netif_carrier_ok(dev))
> > -			netif_carrier_on(dev);
> > -	} else if (netif_carrier_ok(dev)) {
> > -		netif_carrier_off(dev);
> > -	}
> > -	cvm_oct_note_carrier(priv, link_info);
> > +	if (likely(status_change))
> 
> Originally a status_change was unlikely but now it is likely.

Yes, but originally it returned after condition and now it executes
phylink_mac_change. This is just to emulate current bahaviour.
Later mac interrupts should be used to drive link change.

> > +		phylink_mac_change(priv->phylink, link_info.s.link_up);
> >  }
> >  
> >  int cvm_oct_rgmii_open(struct net_device *dev)
> > diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
> > index 466d43a71d34..21892f805245 100644
> > --- a/drivers/staging/octeon/ethernet.c
> > +++ b/drivers/staging/octeon/ethernet.c
> > @@ -10,7 +10,7 @@
> >  #include <linux/module.h>
> >  #include <linux/netdevice.h>
> >  #include <linux/etherdevice.h>
> > -#include <linux/phy.h>
> > +#include <linux/phylink.h>
> >  #include <linux/slab.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/of_mdio.h>
> > @@ -128,7 +128,7 @@ static void cvm_oct_periodic_worker(struct work_struct *work)
> >  						    struct octeon_ethernet,
> >  						    port_periodic_work.work);
> >  
> > -	if (priv->poll)
> > +	if (priv->poll_used && priv->poll)
> >  		priv->poll(cvm_oct_device[priv->port]);
> 
> The name poll_used was really confusing to me.  We set it before we've
> done any polling so the tense is wrong.  I think it means that we should
> not bother polling if the link is down...  Could we change the name to
> ->link_up?  Or maybe add a comment?

Yes. I was just trying to make changes minimal. I'd preffer to clean this
up in the follow up patches.

> >  	cvm_oct_device[priv->port]->netdev_ops->ndo_get_stats
> > @@ -446,23 +446,20 @@ int cvm_oct_common_init(struct net_device *dev)
> >  
> >  void cvm_oct_common_uninit(struct net_device *dev)
> >  {
> > -	if (dev->phydev)
> > -		phy_disconnect(dev->phydev);
> > +	struct octeon_ethernet *priv = netdev_priv(dev);
> > +
> > +	cancel_delayed_work_sync(&priv->port_periodic_work);
> > +	phylink_destroy(priv->phylink);
> >  }
> >  
> >  int cvm_oct_common_open(struct net_device *dev,
> >  			void (*link_poll)(struct net_device *))
> >  {
> > +	int err;
> 
> This is networking code so declarations need to be in reverse Christmas
> tree order.
> 
> 	long long_variable_name;
> 	medium variable_name;
> 	short name;

Ok.

> >  	union cvmx_gmxx_prtx_cfg gmx_cfg;
> >  	struct octeon_ethernet *priv = netdev_priv(dev);
> >  	int interface = INTERFACE(priv->port);
> >  	int index = INDEX(priv->port);
> > -	union cvmx_helper_link_info link_info;
> > -	int rv;
> > -
> > -	rv = cvm_oct_phy_setup_device(dev);
> > -	if (rv)
> > -		return rv;
> >  
> >  	gmx_cfg.u64 = cvmx_read_csr(CVMX_GMXX_PRTX_CFG(index, interface));
> >  	gmx_cfg.s.en = 1;
> > @@ -473,20 +470,17 @@ int cvm_oct_common_open(struct net_device *dev,
> >  	if (octeon_is_simulation())
> >  		return 0;
> >  
> > -	if (dev->phydev) {
> > -		int r = phy_read_status(dev->phydev);
> > -
> > -		if (r == 0 && dev->phydev->link == 0)
> > -			netif_carrier_off(dev);
> > -		cvm_oct_adjust_link(dev);
> > -	} else {
> > -		link_info = cvmx_helper_link_get(priv->port);
> > -		if (!link_info.s.link_up)
> > -			netif_carrier_off(dev);
> > -		priv->poll = link_poll;
> > -		link_poll(dev);
> > +	err = phylink_of_phy_connect(priv->phylink, priv->of_node, 0);
> > +	if (err) {
> > +		netdev_err(dev, "Could not attach PHY (%d)\n", err);
> > +		return err;
> >  	}
> >  
> > +	priv->poll_used = false;
> > +	priv->poll = link_poll;
> > +
> > +	phylink_start(priv->phylink);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -504,13 +498,7 @@ void cvm_oct_link_poll(struct net_device *dev)
> >  	else
> >  		priv->link_info = link_info.u64;
> >  
> > -	if (link_info.s.link_up) {
> > -		if (!netif_carrier_ok(dev))
> > -			netif_carrier_on(dev);
> > -	} else if (netif_carrier_ok(dev)) {
> > -		netif_carrier_off(dev);
> > -	}
> > -	cvm_oct_note_carrier(priv, link_info);
> > +	phylink_mac_change(priv->phylink, link_info.s.link_up);
> >  }
> >  
> >  static int cvm_oct_xaui_open(struct net_device *dev)
> > @@ -797,7 +785,6 @@ static int cvm_oct_probe(struct platform_device *pdev)
> >  		}
> >  	}
> >  
> > -	num_interfaces = cvmx_helper_get_number_of_interfaces();
> 
> This change is correct, but I wish it were in a different commit.  It
> is unrelated.

Ok. I'll move it to separate preparation commit.

> >  	for (interface = 0; interface < num_interfaces; interface++) {
> >  		int num_ports, port_index;
> >  		const struct net_device_ops *ops;
> > @@ -889,18 +876,15 @@ static int cvm_oct_probe(struct platform_device *pdev)
> >  			dev->min_mtu = VLAN_ETH_ZLEN - mtu_overhead;
> >  			dev->max_mtu = OCTEON_MAX_MTU - mtu_overhead;
> >  
> > -			if (priv->of_node && of_phy_is_fixed_link(priv->of_node)) {
> > -				if (of_phy_register_fixed_link(priv->of_node)) {
> > -					netdev_err(dev, "Failed to register fixed link for interface %d, port %d\n",
> > -						   interface, priv->port);
> > -					free_netdev(dev);
> > -					continue;
> > -				}
> > +			if (cvm_oct_phy_setup_device(dev)) {
> > +				free_netdev(dev);
> > +				continue;
> 
> This was in the original code, but I don't think this is correct.  If
> there is an error then we should return instead of continuing.  This
> is especially true because cvm_oct_phy_setup_device() returns
> -EPROBE_DEFER so in theory errors are a matter of course and we have a
> way to recover from them.

You are right, but this is very hard to achieve. I'd rather convert driver
to phylink first and then fix all this as doing it in different order is more
painfull.

Please note, there are many things in this driver which we would consider
incorrect. Most code is two decades old and got only cosmetic changes.

> >  			}
> >  
> >  			if (register_netdev(dev) < 0) {
> >  				pr_err("Failed to register ethernet device for interface %d, port %d\n",
> >  				       interface, priv->port);
> > +				phylink_destroy(priv->phylink);
> 
> Could you create a wrapper around this so that it's more clear that
> this matches cvm_oct_phy_setup_device()?
> 
> void cvm_oct_phy_free_device(struct net_device *dev)
> {
> 	struct octeon_ethernet *priv = netdev_priv(dev);
> 
> 	phylink_destroy(priv->phylink);
> }

Ok.

> >  				free_netdev(dev);
> >  			} else {
> >  				cvm_oct_device[priv->port] = dev;
> > @@ -938,8 +922,7 @@ static int cvm_oct_probe(struct platform_device *pdev)
> >  			struct net_device *dev = cvm_oct_device[port];
> >  			struct octeon_ethernet *priv = netdev_priv(dev);
> >  
> > -			cancel_delayed_work_sync(&priv->port_periodic_work);
> > -
> > +			phylink_destroy(priv->phylink);
> 
> I don't understand how this works.  This call to:
> 
> 	cancel_delayed_work_sync(&priv->port_periodic_work);
> 
> moved to cvm_oct_common_uninit().  But then why are we adding a
> phylink_destroy(priv->phylink); when the phylink_destroy() is also done
> in cvm_oct_common_uninit().

Ooops... Sorry about that. I forgot it here from an attempt to put phylink
creation/destruction into ndo_init and ndo_uninit, but that does not work;
see cover letter.

> >  			unregister_netdev(dev);
> >  			free_netdev(dev);
> >  			cvm_oct_device[port] = NULL;
> > @@ -969,9 +952,8 @@ static int cvm_oct_remove(struct platform_device *pdev)
> >  			struct net_device *dev = cvm_oct_device[port];
> >  			struct octeon_ethernet *priv = netdev_priv(dev);
> >  
> > -			cancel_delayed_work_sync(&priv->port_periodic_work);
> > -
> >  			cvm_oct_tx_shutdown_dev(dev);
> > +			phylink_destroy(priv->phylink);
> 
> Same.
> 
> >  			unregister_netdev(dev);
> >  			free_netdev(dev);
> >  			cvm_oct_device[port] = NULL;
> 
> regards,
> dan carpenter

Thank you,
	ladis
