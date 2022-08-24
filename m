Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463A75A0442
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiHXWrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHXWrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:47:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD616172B;
        Wed, 24 Aug 2022 15:47:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D96C6198C;
        Wed, 24 Aug 2022 22:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58098C433C1;
        Wed, 24 Aug 2022 22:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661381230;
        bh=o++iUflsCwyZn5hLJcJVP2cRnKEMdrvhai8XaDF0ax4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tjHqCYhApFiN+Am5tTy1b6THMaN48rxs/8usfE5mrV27W4wEY+MJTbA55I4g23Hli
         TqSTZ3ir+06U55j3lCf1KunxP/Ydplgbj3CjHKSWVJPunhtc8yISFxC65Xup5pJQN+
         xVG8dBsCFg2XReOk7ZEj3Oh6TGi4VYMY3tQk1JbN2d5Lnp4zfTPjh3dKrVIperYbCD
         ByZ8Vh8RQK3ZJb9GKDHCTukAL8B3El0Bjw7euzSiRvidIyIGMy1OiM+1ot7WRnppvO
         eFu48Ddeet49QbMmFPUSBCpdqoZ/wNJKMmEHiuxvBwWAmJowp4YK2+y9UYDwt73AH7
         gXmgpYJtoL78A==
Date:   Wed, 24 Aug 2022 23:47:03 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>, Lukas Wunner <lukas@wunner.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Andre Edich <andre.edich@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Cc:     kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: stable-rc/linux-5.18.y bisection: baseline.login on panda
Message-ID: <YwaqZ1+zm78vl4L1@sirena.org.uk>
References: <63068874.170a0220.2f9fc.b822@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="f3FHKbAcieifP/Lp"
Content-Disposition: inline
In-Reply-To: <63068874.170a0220.2f9fc.b822@mx.google.com>
X-Cookie: Equal bytes for women.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--f3FHKbAcieifP/Lp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 24, 2022 at 01:22:12PM -0700, KernelCI bot wrote:

The KernelCI bisection bot identified 7eea9a60703ca ("usbnet: smsc95xx:
Forward PHY interrupts to PHY driver to avoid polling") as causing a
boot regression on Panda in v5.18.  The board stops detecting a link
which breks NFS boot:

<6>[    4.953613] smsc95xx 2-1.1:1.0 eth0: register 'smsc95xx' at usb-4a064=
c00.ehci-1.1, smsc95xx USB 2.0 Ethernet, 02:03:01:8c:13:b0
<6>[    5.032928] smsc95xx 2-1.1:1.0 eth0: hardware isn't capable of remote=
 wakeup
<6>[    5.044036] smsc95xx 2-1.1:1.0 eth0: Link is Down
<6>[   25.053924] Waiting up to 100 more seconds for network.
<6>[   45.074005] Waiting up to 80 more seconds for network.
<6>[   65.093933] Waiting up to 60 more seconds for network.
<6>[   85.123992] Waiting up to 40 more seconds for network.
<6>[  105.143951] Waiting up to 20 more seconds for network.
<5>[  125.084014] Sending DHCP requests ...... timed out!
<6>[  207.765808] smsc95xx 2-1.1:1.0 eth0: hardware isn't capable of remote=
 wakeup
<3>[  207.773468] IP-Config: Reopening network devices...
<6>[  207.840332] smsc95xx 2-1.1:1.0 eth0: hardware isn't capable of remote=
 wakeup
<6>[  207.851226] smsc95xx 2-1.1:1.0 eth0: Link is Down
<6>[  227.873931] Waiting up to 100 more seconds for network.
<6>[  247.873931] Waiting up to 80 more seconds for network.

We're seen other failures on this board in mainline which stop boot
sooner so can't confirm if there's a similar issue there.

I've left the whole report, including links to more details like full
logs and a tag for the bot below:

> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
> * This automated bisection report was sent to you on the basis  *
> * that you may be involved with the breaking commit it has      *
> * found.  No manual investigation has been done to verify it,   *
> * and the root cause of the problem may be somewhere else.      *
> *                                                               *
> * If you do send a fix, please include this trailer:            *
> *   Reported-by: "kernelci.org bot" <bot@kernelci.org>          *
> *                                                               *
> * Hope this helps!                                              *
> * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
>=20
> stable-rc/linux-5.18.y bisection: baseline.login on panda
>=20
> Summary:
>   Start:      22a992953741a Linux 5.18.19
>   Plain log:  https://storage.kernelci.org/stable-rc/linux-5.18.y/v5.18.1=
9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
>   HTML log:   https://storage.kernelci.org/stable-rc/linux-5.18.y/v5.18.1=
9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
>   Result:     7eea9a60703ca usbnet: smsc95xx: Forward PHY interrupts to P=
HY driver to avoid polling
>=20
> Checks:
>   revert:     PASS
>   verify:     PASS
>=20
> Parameters:
>   Tree:       stable-rc
>   URL:        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linu=
x-stable-rc.git
>   Branch:     linux-5.18.y
>   Target:     panda
>   CPU arch:   arm
>   Lab:        lab-baylibre
>   Compiler:   gcc-10
>   Config:     multi_v7_defconfig
>   Test case:  baseline.login
>=20
> Breaking commit found:
>=20
> -------------------------------------------------------------------------=
------
> commit 7eea9a60703caf1b04eccba93cd103f1c8fc6809
> Author: Lukas Wunner <lukas@wunner.de>
> Date:   Thu May 12 10:42:05 2022 +0200
>=20
>     usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid polli=
ng
>    =20
>     [ Upstream commit 1ce8b37241ed291af56f7a49bbdbf20c08728e88 ]
>    =20
>     Link status of SMSC LAN95xx chips is polled once per second, even tho=
ugh
>     they're capable of signaling PHY interrupts through the MAC layer.
>    =20
>     Forward those interrupts to the PHY driver to avoid polling.  Benefits
>     are reduced bus traffic, reduced CPU overhead and quicker interface
>     bringup.
>    =20
>     Polling was introduced in 2016 by commit d69d16949346 ("usbnet:
>     smsc95xx: fix link detection for disabled autonegotiation").
>     Back then, the LAN95xx driver neglected to enable the ENERGYON interr=
upt,
>     hence couldn't detect link-up events when auto-negotiation was disabl=
ed.
>     The proper solution would have been to enable the ENERGYON interrupt
>     instead of polling.
>    =20
>     Since then, PHY handling was moved from the LAN95xx driver to the SMSC
>     PHY driver with commit 05b35e7eb9a1 ("smsc95xx: add phylib support").
>     That PHY driver is capable of link detection with auto-negotiation
>     disabled because it enables the ENERGYON interrupt.
>    =20
>     Note that signaling interrupts through the MAC layer not only works w=
ith
>     the integrated PHY, but also with an external PHY, provided its
>     interrupt pin is attached to LAN95xx's nPHY_INT pin.
>    =20
>     In the unlikely event that the interrupt pin of an external PHY is
>     attached to a GPIO of the SoC (or not connected at all), the driver c=
an
>     be amended to retrieve the irq from the PHY's of_node.
>    =20
>     To forward PHY interrupts to phylib, it is not sufficient to call
>     phy_mac_interrupt().  Instead, the PHY's interrupt handler needs to r=
un
>     so that PHY interrupts are cleared.  That's because according to page
>     119 of the LAN950x datasheet, "The source of this interrupt is a leve=
l.
>     The interrupt persists until it is cleared in the PHY."
>    =20
>     https://www.microchip.com/content/dam/mchp/documents/UNG/ProductDocum=
ents/DataSheets/LAN950x-Data-Sheet-DS00001875D.pdf
>    =20
>     Therefore, create an IRQ domain with a single IRQ for the PHY.  In the
>     future, the IRQ domain may be extended to support the 11 GPIOs on the
>     LAN95xx.
>    =20
>     Normally the PHY interrupt should be masked until the PHY driver has
>     cleared it.  However masking requires a (sleeping) USB transaction and
>     interrupts are received in (non-sleepable) softirq context.  I decided
>     not to mask the interrupt at all (by using the dummy_irq_chip's noop
>     ->irq_mask() callback):  The USB interrupt endpoint is polled in 1 ms=
ec
>     intervals and normally that's sufficient to wake the PHY driver's IRQ
>     thread and have it clear the interrupt.  If it does take longer, worst
>     thing that can happen is the IRQ thread is woken again.  No big deal.
>    =20
>     Because PHY interrupts are now perpetually enabled, there's no need to
>     selectively enable them on suspend.  So remove all invocations of
>     smsc95xx_enable_phy_wakeup_interrupts().
>    =20
>     In smsc95xx_resume(), move the call of phy_init_hw() before
>     usbnet_resume() (which restarts the status URB) to ensure that the PHY
>     is fully initialized when an interrupt is handled.
>    =20
>     Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/95=
00
>     Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
>     Signed-off-by: Lukas Wunner <lukas@wunner.de>
>     Reviewed-by: Andrew Lunn <andrew@lunn.ch> # from a PHY perspective
>     Cc: Andre Edich <andre.edich@microchip.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index f5a208948d22a..358b170cc8fb7 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -18,6 +18,8 @@
>  #include <linux/usb/usbnet.h>
>  #include <linux/slab.h>
>  #include <linux/of_net.h>
> +#include <linux/irq.h>
> +#include <linux/irqdomain.h>
>  #include <linux/mdio.h>
>  #include <linux/phy.h>
>  #include <net/selftests.h>
> @@ -53,6 +55,9 @@
>  #define SUSPEND_ALLMODES		(SUSPEND_SUSPEND0 | SUSPEND_SUSPEND1 | \
>  					 SUSPEND_SUSPEND2 | SUSPEND_SUSPEND3)
> =20
> +#define SMSC95XX_NR_IRQS		(1) /* raise to 12 for GPIOs */
> +#define PHY_HWIRQ			(SMSC95XX_NR_IRQS - 1)
> +
>  struct smsc95xx_priv {
>  	u32 mac_cr;
>  	u32 hash_hi;
> @@ -61,6 +66,9 @@ struct smsc95xx_priv {
>  	spinlock_t mac_cr_lock;
>  	u8 features;
>  	u8 suspend_flags;
> +	struct irq_chip irqchip;
> +	struct irq_domain *irqdomain;
> +	struct fwnode_handle *irqfwnode;
>  	struct mii_bus *mdiobus;
>  	struct phy_device *phydev;
>  };
> @@ -597,6 +605,8 @@ static void smsc95xx_mac_update_fullduplex(struct usb=
net *dev)
> =20
>  static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
>  {
> +	struct smsc95xx_priv *pdata =3D dev->driver_priv;
> +	unsigned long flags;
>  	u32 intdata;
> =20
>  	if (urb->actual_length !=3D 4) {
> @@ -608,11 +618,15 @@ static void smsc95xx_status(struct usbnet *dev, str=
uct urb *urb)
>  	intdata =3D get_unaligned_le32(urb->transfer_buffer);
>  	netif_dbg(dev, link, dev->net, "intdata: 0x%08X\n", intdata);
> =20
> +	local_irq_save(flags);
> +
>  	if (intdata & INT_ENP_PHY_INT_)
> -		;
> +		generic_handle_domain_irq(pdata->irqdomain, PHY_HWIRQ);
>  	else
>  		netdev_warn(dev->net, "unexpected interrupt, intdata=3D0x%08X\n",
>  			    intdata);
> +
> +	local_irq_restore(flags);
>  }
> =20
>  /* Enable or disable Tx & Rx checksum offload engines */
> @@ -1098,8 +1112,9 @@ static int smsc95xx_bind(struct usbnet *dev, struct=
 usb_interface *intf)
>  {
>  	struct smsc95xx_priv *pdata;
>  	bool is_internal_phy;
> +	char usb_path[64];
> +	int ret, phy_irq;
>  	u32 val;
> -	int ret;
> =20
>  	printk(KERN_INFO SMSC_CHIPNAME " v" SMSC_DRIVER_VERSION "\n");
> =20
> @@ -1139,10 +1154,38 @@ static int smsc95xx_bind(struct usbnet *dev, stru=
ct usb_interface *intf)
>  	if (ret)
>  		goto free_pdata;
> =20
> +	/* create irq domain for use by PHY driver and GPIO consumers */
> +	usb_make_path(dev->udev, usb_path, sizeof(usb_path));
> +	pdata->irqfwnode =3D irq_domain_alloc_named_fwnode(usb_path);
> +	if (!pdata->irqfwnode) {
> +		ret =3D -ENOMEM;
> +		goto free_pdata;
> +	}
> +
> +	pdata->irqdomain =3D irq_domain_create_linear(pdata->irqfwnode,
> +						    SMSC95XX_NR_IRQS,
> +						    &irq_domain_simple_ops,
> +						    pdata);
> +	if (!pdata->irqdomain) {
> +		ret =3D -ENOMEM;
> +		goto free_irqfwnode;
> +	}
> +
> +	phy_irq =3D irq_create_mapping(pdata->irqdomain, PHY_HWIRQ);
> +	if (!phy_irq) {
> +		ret =3D -ENOENT;
> +		goto remove_irqdomain;
> +	}
> +
> +	pdata->irqchip =3D dummy_irq_chip;
> +	pdata->irqchip.name =3D SMSC_CHIPNAME;
> +	irq_set_chip_and_handler_name(phy_irq, &pdata->irqchip,
> +				      handle_simple_irq, "phy");
> +
>  	pdata->mdiobus =3D mdiobus_alloc();
>  	if (!pdata->mdiobus) {
>  		ret =3D -ENOMEM;
> -		goto free_pdata;
> +		goto dispose_irq;
>  	}
> =20
>  	ret =3D smsc95xx_read_reg(dev, HW_CFG, &val);
> @@ -1175,6 +1218,7 @@ static int smsc95xx_bind(struct usbnet *dev, struct=
 usb_interface *intf)
>  		goto unregister_mdio;
>  	}
> =20
> +	pdata->phydev->irq =3D phy_irq;
>  	pdata->phydev->is_internal =3D is_internal_phy;
> =20
>  	/* detect device revision as different features may be available */
> @@ -1217,6 +1261,15 @@ static int smsc95xx_bind(struct usbnet *dev, struc=
t usb_interface *intf)
>  free_mdio:
>  	mdiobus_free(pdata->mdiobus);
> =20
> +dispose_irq:
> +	irq_dispose_mapping(phy_irq);
> +
> +remove_irqdomain:
> +	irq_domain_remove(pdata->irqdomain);
> +
> +free_irqfwnode:
> +	irq_domain_free_fwnode(pdata->irqfwnode);
> +
>  free_pdata:
>  	kfree(pdata);
>  	return ret;
> @@ -1229,6 +1282,9 @@ static void smsc95xx_unbind(struct usbnet *dev, str=
uct usb_interface *intf)
>  	phy_disconnect(dev->net->phydev);
>  	mdiobus_unregister(pdata->mdiobus);
>  	mdiobus_free(pdata->mdiobus);
> +	irq_dispose_mapping(irq_find_mapping(pdata->irqdomain, PHY_HWIRQ));
> +	irq_domain_remove(pdata->irqdomain);
> +	irq_domain_free_fwnode(pdata->irqfwnode);
>  	netif_dbg(dev, ifdown, dev->net, "free pdata\n");
>  	kfree(pdata);
>  }
> @@ -1253,29 +1309,6 @@ static u32 smsc_crc(const u8 *buffer, size_t len, =
int filter)
>  	return crc << ((filter % 2) * 16);
>  }
> =20
> -static int smsc95xx_enable_phy_wakeup_interrupts(struct usbnet *dev, u16=
 mask)
> -{
> -	int ret;
> -
> -	netdev_dbg(dev->net, "enabling PHY wakeup interrupts\n");
> -
> -	/* read to clear */
> -	ret =3D smsc95xx_mdio_read_nopm(dev, PHY_INT_SRC);
> -	if (ret < 0)
> -		return ret;
> -
> -	/* enable interrupt source */
> -	ret =3D smsc95xx_mdio_read_nopm(dev, PHY_INT_MASK);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret |=3D mask;
> -
> -	smsc95xx_mdio_write_nopm(dev, PHY_INT_MASK, ret);
> -
> -	return 0;
> -}
> -
>  static int smsc95xx_link_ok_nopm(struct usbnet *dev)
>  {
>  	int ret;
> @@ -1442,7 +1475,6 @@ static int smsc95xx_enter_suspend3(struct usbnet *d=
ev)
>  static int smsc95xx_autosuspend(struct usbnet *dev, u32 link_up)
>  {
>  	struct smsc95xx_priv *pdata =3D dev->driver_priv;
> -	int ret;
> =20
>  	if (!netif_running(dev->net)) {
>  		/* interface is ifconfig down so fully power down hw */
> @@ -1461,27 +1493,10 @@ static int smsc95xx_autosuspend(struct usbnet *de=
v, u32 link_up)
>  		}
> =20
>  		netdev_dbg(dev->net, "autosuspend entering SUSPEND1\n");
> -
> -		/* enable PHY wakeup events for if cable is attached */
> -		ret =3D smsc95xx_enable_phy_wakeup_interrupts(dev,
> -			PHY_INT_MASK_ANEG_COMP_);
> -		if (ret < 0) {
> -			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
> -			return ret;
> -		}
> -
>  		netdev_info(dev->net, "entering SUSPEND1 mode\n");
>  		return smsc95xx_enter_suspend1(dev);
>  	}
> =20
> -	/* enable PHY wakeup events so we remote wakeup if cable is pulled */
> -	ret =3D smsc95xx_enable_phy_wakeup_interrupts(dev,
> -		PHY_INT_MASK_LINK_DOWN_);
> -	if (ret < 0) {
> -		netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
> -		return ret;
> -	}
> -
>  	netdev_dbg(dev->net, "autosuspend entering SUSPEND3\n");
>  	return smsc95xx_enter_suspend3(dev);
>  }
> @@ -1547,13 +1562,6 @@ static int smsc95xx_suspend(struct usb_interface *=
intf, pm_message_t message)
>  	}
> =20
>  	if (pdata->wolopts & WAKE_PHY) {
> -		ret =3D smsc95xx_enable_phy_wakeup_interrupts(dev,
> -			(PHY_INT_MASK_ANEG_COMP_ | PHY_INT_MASK_LINK_DOWN_));
> -		if (ret < 0) {
> -			netdev_warn(dev->net, "error enabling PHY wakeup ints\n");
> -			goto done;
> -		}
> -
>  		/* if link is down then configure EDPD and enter SUSPEND1,
>  		 * otherwise enter SUSPEND0 below
>  		 */
> @@ -1787,11 +1795,12 @@ static int smsc95xx_resume(struct usb_interface *=
intf)
>  			return ret;
>  	}
> =20
> +	phy_init_hw(pdata->phydev);
> +
>  	ret =3D usbnet_resume(intf);
>  	if (ret < 0)
>  		netdev_warn(dev->net, "usbnet_resume error\n");
> =20
> -	phy_init_hw(pdata->phydev);
>  	return ret;
>  }
> -------------------------------------------------------------------------=
------
>=20
>=20
> Git bisection log:
>=20
> -------------------------------------------------------------------------=
------
> git bisect start
> # good: [9aa5a042881d4a99657f82c774e9e15353ebeb2d] Linux 5.18.14
> git bisect good 9aa5a042881d4a99657f82c774e9e15353ebeb2d
> # bad: [22a992953741ad79c07890d3f4104585e52ef26b] Linux 5.18.19
> git bisect bad 22a992953741ad79c07890d3f4104585e52ef26b
> # good: [77d5174ed962c259965226386f71575790646ec0] drm/mediatek: dpi: Rem=
ove output format of YUV
> git bisect good 77d5174ed962c259965226386f71575790646ec0
> # good: [598bc9541e2f82a7fe8dfe23891201b355a56cda] usb: dwc3: core: Do no=
t perform GCTL_CORE_SOFTRESET during bootup
> git bisect good 598bc9541e2f82a7fe8dfe23891201b355a56cda
> # good: [876f57cc94922896cc71dd4696013a7c0558c9b4] f2fs: give priority to=
 select unpinned section for foreground GC
> git bisect good 876f57cc94922896cc71dd4696013a7c0558c9b4
> # bad: [5f4e505909fe50a4e256704076594ee3def0b9b1] block: add a bdev_max_z=
one_append_sectors helper
> git bisect bad 5f4e505909fe50a4e256704076594ee3def0b9b1
> # good: [b9c3401f7cac6ae291a16784dadcd1bf116218fe] x86/kprobes: Update kc=
b status flag after singlestepping
> git bisect good b9c3401f7cac6ae291a16784dadcd1bf116218fe
> # bad: [73ce2046e04ad488cecc66757c36cbe1bdf089d4] iommu/vt-d: avoid inval=
id memory access via node_online(NUMA_NO_NODE)
> git bisect bad 73ce2046e04ad488cecc66757c36cbe1bdf089d4
> # good: [f624c94ad56b663693a9413d8c8c03635435f369] drm/vc4: drv: Adopt th=
e dma configuration from the HVS or V3D component
> git bisect good f624c94ad56b663693a9413d8c8c03635435f369
> # bad: [87c4896d5dd7fd9927c814cf3c6289f41de3b562] firmware: arm_scpi: Ens=
ure scpi_info is not assigned if the probe fails
> git bisect bad 87c4896d5dd7fd9927c814cf3c6289f41de3b562
> # good: [9b61971cab92a918cab7168d439a351b1c799aca] usbnet: smsc95xx: Avoi=
d link settings race on interrupt reception
> git bisect good 9b61971cab92a918cab7168d439a351b1c799aca
> # bad: [e81395cfbe62518f41af79a1b287fc8fe7c96b37] usbnet: smsc95xx: Fix d=
eadlock on runtime resume
> git bisect bad e81395cfbe62518f41af79a1b287fc8fe7c96b37
> # bad: [7eea9a60703caf1b04eccba93cd103f1c8fc6809] usbnet: smsc95xx: Forwa=
rd PHY interrupts to PHY driver to avoid polling
> git bisect bad 7eea9a60703caf1b04eccba93cd103f1c8fc6809
> # first bad commit: [7eea9a60703caf1b04eccba93cd103f1c8fc6809] usbnet: sm=
sc95xx: Forward PHY interrupts to PHY driver to avoid polling
> -------------------------------------------------------------------------=
------
>=20
>=20
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
> Groups.io Links: You receive all messages sent to this group.
> View/Reply Online (#30878): https://groups.io/g/kernelci-results/message/=
30878
> Mute This Topic: https://groups.io/mt/93235418/1131744
> Group Owner: kernelci-results+owner@groups.io
> Unsubscribe: https://groups.io/g/kernelci-results/unsub [broonie@kernel.o=
rg]
> -=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
>=20
>=20

--f3FHKbAcieifP/Lp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmMGqmcACgkQJNaLcl1U
h9AGhgf8CqDDi4XwHEn4RHW4x11InntF/Zdc6KgNcMrBvOvN3jifr2Q5RJ15IzCF
94z37qjdbhIzKs8x/gL7cwgo5QUnFo3eNvAUbOfU4Xw2iQeP+JQzKhkdOHnbPv7F
JexZIhzOFT3qkeCY8AXTGyDOKViu8mQcXCUzsH4H2Rn4aDH10BtjBBXOGMUTGtQp
02wcI8KyZuietjHezqo5TJnpY8iil4BYlYIuJluBk+r4G6Px+FV2P09KCgjhVIQ/
IlOt4ncXDrEYGHR+SKZJBs6P3RYwz3w3jIDz/4lYWmj17i3EFine4ObX0o85FbjM
3GqSm2m0R8NM6RpIqY8mPtrtBbICAg==
=HATN
-----END PGP SIGNATURE-----

--f3FHKbAcieifP/Lp--
