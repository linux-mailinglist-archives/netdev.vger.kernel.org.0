Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53E435F808
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350580AbhDNPln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350554AbhDNPli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:41:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF025C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:41:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWhdW-00056s-1I; Wed, 14 Apr 2021 17:41:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:69d2:43d8:822b:d361])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6AB1160EA59;
        Wed, 14 Apr 2021 15:41:00 +0000 (UTC)
Date:   Wed, 14 Apr 2021 17:40:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2 4/6] phy: phy-can-transceiver: Add support for generic
 CAN transceiver driver
Message-ID: <20210414154059.3uq2blnee5knfkha@pengutronix.de>
References: <20210414140521.11463-1-a-govindraju@ti.com>
 <20210414140521.11463-5-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="tkjb36vvgctovqee"
Content-Disposition: inline
In-Reply-To: <20210414140521.11463-5-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tkjb36vvgctovqee
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.04.2021 19:35:19, Aswath Govindraju wrote:
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -61,6 +61,15 @@ config USB_LGM_PHY
>  	  interface to interact with USB GEN-II and USB 3.x PHY that is part
>  	  of the Intel network SOC.
> =20
> +config PHY_CAN_TRANSCEIVER
> +	tristate "CAN transceiver PHY"
> +	select GENERIC_PHY
> +	help
> +	  This option enables support for CAN transceivers as a PHY. This
> +	  driver provides function for putting the transceivers in various
> +	  functional modes using gpios and sets the attribute max link
> +	  rate, for mcan drivers.
> +
>  source "drivers/phy/allwinner/Kconfig"
>  source "drivers/phy/amlogic/Kconfig"
>  source "drivers/phy/broadcom/Kconfig"
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index adac1b1a39d1..9c66101c9605 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -9,6 +9,7 @@ obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+=3D phy-lpc18xx-usb-ot=
g.o
>  obj-$(CONFIG_PHY_XGENE)			+=3D phy-xgene.o
>  obj-$(CONFIG_PHY_PISTACHIO_USB)		+=3D phy-pistachio-usb.o
>  obj-$(CONFIG_USB_LGM_PHY)		+=3D phy-lgm-usb.o
> +obj-$(CONFIG_PHY_CAN_TRANSCEIVER)	+=3D phy-can-transceiver.o
>  obj-y					+=3D allwinner/	\
>  					   amlogic/	\
>  					   broadcom/	\

I'm not sure how the phy framework handles this, but I assume it's
alphabetically sorted, too.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--tkjb36vvgctovqee
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB3DQgACgkQqclaivrt
76mmBgf/UVJvC3LyyxxsHlIki0bqM9azxpljxBEijh6bYMp3McfGtrceY+uekf1Z
BbgUckVw3gwtEV54ZksGr7jy1uWOqimOPTsr7NHm+AoqrhbfwwZP5vWdcfYUC04J
OcdyAtxJk0T0T+7bLk9sRuPF9T9viN7CTBWVGrNwT9zTdKo0eQDClVGXoVK+RoGO
VpNh/cYAXoJdKh5Sg6faoK8TJwyy+GVZRYqolPSB8mxDVVCFNBZBMjh8GIQjUdmK
GAx+G13i/NiM01X/gZcznY9j1TzGmAp/sdUjBF0t53eVVbZ7tLUwhy8urUGmPm8n
PSPYUomuv+5Zq6t47oA2Hwk/CkYvyA==
=OYMs
-----END PGP SIGNATURE-----

--tkjb36vvgctovqee--
