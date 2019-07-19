Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C173E6E6E9
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 15:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfGSNyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 09:54:02 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56217 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfGSNx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 09:53:59 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hoTKT-0006lJ-Pd; Fri, 19 Jul 2019 15:53:45 +0200
Received: from [IPv6:2a03:f580:87bc:d400:c9d4:83d5:b99:4f4d] (unknown [IPv6:2a03:f580:87bc:d400:c9d4:83d5:b99:4f4d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 98EAA43489A;
        Fri, 19 Jul 2019 13:53:38 +0000 (UTC)
To:     "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>, wg@grandegger.com
Cc:     davem@davemloft.net, f.suligoi@asem.it,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, peter_hong@fintek.com.tw,
        "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
References: <1560217652-19834-1-git-send-email-hpeter+linux_kernel@gmail.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [RESEND PATCH V1] can: sja1000: f81601: add Fintek F81601 support
Message-ID: <0579e94c-fb05-6b7d-6527-f2d137db6cb3@pengutronix.de>
Date:   Fri, 19 Jul 2019 15:53:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1560217652-19834-1-git-send-email-hpeter+linux_kernel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="SvuoA6sHyUMxv6vvgjV2uk2PbulNI7Xa4"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SvuoA6sHyUMxv6vvgjV2uk2PbulNI7Xa4
Content-Type: multipart/mixed; boundary="j58FJJrsxd12bGa9A3zAvkOxfVQx1lnOz";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: "Ji-Ze Hong (Peter Hong)" <hpeter@gmail.com>, wg@grandegger.com
Cc: davem@davemloft.net, f.suligoi@asem.it, linux-kernel@vger.kernel.org,
 linux-can@vger.kernel.org, netdev@vger.kernel.org, peter_hong@fintek.com.tw,
 "Ji-Ze Hong (Peter Hong)" <hpeter+linux_kernel@gmail.com>
Message-ID: <0579e94c-fb05-6b7d-6527-f2d137db6cb3@pengutronix.de>
Subject: Re: [RESEND PATCH V1] can: sja1000: f81601: add Fintek F81601 support
References: <1560217652-19834-1-git-send-email-hpeter+linux_kernel@gmail.com>
In-Reply-To: <1560217652-19834-1-git-send-email-hpeter+linux_kernel@gmail.com>

--j58FJJrsxd12bGa9A3zAvkOxfVQx1lnOz
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 6/11/19 3:47 AM, Ji-Ze Hong (Peter Hong) wrote:
> This patch add support for Fintek PCIE to 2 CAN controller support
>=20
> Signed-off-by: Ji-Ze Hong (Peter Hong) <hpeter+linux_kernel@gmail.com>
> ---
>  drivers/net/can/sja1000/Kconfig  |   8 ++
>  drivers/net/can/sja1000/Makefile |   1 +
>  drivers/net/can/sja1000/f81601.c | 223 +++++++++++++++++++++++++++++++=
++++++++
>  3 files changed, 232 insertions(+)
>  create mode 100644 drivers/net/can/sja1000/f81601.c
>=20
> diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/=
Kconfig
> index f6dc89927ece..8588323c5138 100644
> --- a/drivers/net/can/sja1000/Kconfig
> +++ b/drivers/net/can/sja1000/Kconfig
> @@ -101,4 +101,12 @@ config CAN_TSCAN1
>  	  IRQ numbers are read from jumpers JP4 and JP5,
>  	  SJA1000 IO base addresses are chosen heuristically (first that work=
s).
> =20
> +config CAN_F81601
> +	tristate "Fintek F81601 PCIE to 2 CAN Controller"
> +	depends on PCI
> +	help
> +	  This driver adds support for Fintek F81601 PCIE to 2 CAN Controller=
=2E
> +	  It had internal 24MHz clock source, but it can be changed by
> +	  manufacturer. We can use modinfo to get usage for parameters.
> +	  Visit http://www.fintek.com.tw to get more information.
>  endif
> diff --git a/drivers/net/can/sja1000/Makefile b/drivers/net/can/sja1000=
/Makefile
> index 9253aaf9e739..6f6268543bd9 100644
> --- a/drivers/net/can/sja1000/Makefile
> +++ b/drivers/net/can/sja1000/Makefile
> @@ -13,3 +13,4 @@ obj-$(CONFIG_CAN_PEAK_PCMCIA) +=3D peak_pcmcia.o
>  obj-$(CONFIG_CAN_PEAK_PCI) +=3D peak_pci.o
>  obj-$(CONFIG_CAN_PLX_PCI) +=3D plx_pci.o
>  obj-$(CONFIG_CAN_TSCAN1) +=3D tscan1.o
> +obj-$(CONFIG_CAN_F81601) +=3D f81601.o
> diff --git a/drivers/net/can/sja1000/f81601.c b/drivers/net/can/sja1000=
/f81601.c
> new file mode 100644
> index 000000000000..1578bb837aaf
> --- /dev/null
> +++ b/drivers/net/can/sja1000/f81601.c
> @@ -0,0 +1,223 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Fintek F81601 PCIE to 2 CAN controller driver
> + *
> + * Copyright (C) 2019 Peter Hong <peter_hong@fintek.com.tw>
> + * Copyright (C) 2019 Linux Foundation
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/netdevice.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/pci.h>
> +#include <linux/can/dev.h>
> +#include <linux/io.h>
> +#include <linux/version.h>
> +
> +#include "sja1000.h"
> +
> +#define F81601_PCI_MAX_CHAN		2
> +
> +#define F81601_DECODE_REG		0x209
> +#define F81601_IO_MODE			BIT(7)
> +#define F81601_MEM_MODE			BIT(6)
> +#define F81601_CFG_MODE			BIT(5)
> +#define F81601_CAN2_INTERNAL_CLK	BIT(3)
> +#define F81601_CAN1_INTERNAL_CLK	BIT(2)
> +#define F81601_CAN2_EN			BIT(1)
> +#define F81601_CAN1_EN			BIT(0)
> +
> +#define F81601_TRAP_REG			0x20a
> +#define F81601_CAN2_HAS_EN		BIT(4)
> +
> +struct f81601_pci_card {
> +	int channels;			/* detected channels count */

Where is this variable used? Why does it have to live inside this struct.=


> +	void __iomem *addr;
> +	spinlock_t lock;		/* for access mem io */

This description is not in sync with the source. Use use this spin lock
only for write access, not to access the iomem in general. Please update
the code or the description.

> +	struct pci_dev *dev;
> +	struct net_device *net_dev[F81601_PCI_MAX_CHAN];
> +};
> +
> +static const struct pci_device_id f81601_pci_tbl[] =3D {
> +	{ PCI_DEVICE(0x1c29, 0x1703) },
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(pci, f81601_pci_tbl);
> +
> +static bool internal_clk =3D 1;
> +module_param(internal_clk, bool, 0444);
> +MODULE_PARM_DESC(internal_clk, "Use internal clock, default 1 (24MHz)"=
);
> +
> +static unsigned int external_clk;
> +module_param(external_clk, uint, 0444);
> +MODULE_PARM_DESC(external_clk, "External Clock, must spec when interna=
l_clk =3D 0");
> +
> +static u8 f81601_pci_read_reg(const struct sja1000_priv *priv, int por=
t)
> +{
> +	return readb(priv->reg_base + port);
> +}
> +
> +static void f81601_pci_write_reg(const struct sja1000_priv *priv, int =
port,
> +				 u8 val)
> +{
> +	struct f81601_pci_card *card =3D priv->priv;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&card->lock, flags);
> +	writeb(val, priv->reg_base + port);
> +	readb(priv->reg_base);
> +	spin_unlock_irqrestore(&card->lock, flags);
> +}
> +
> +static void f81601_pci_del_card(struct pci_dev *pdev)
> +{
> +	struct f81601_pci_card *card =3D pci_get_drvdata(pdev);
> +	struct net_device *dev;
> +	int i =3D 0;
> +
> +	for (i =3D 0; i < F81601_PCI_MAX_CHAN; i++) {

Usee ARRAY_SIZE instead of F81601_PCI_MAX_CHAN.

> +		dev =3D card->net_dev[i];
> +		if (!dev)
> +			continue;
> +
> +		dev_info(&pdev->dev, "%s: Removing %s\n", __func__, dev->name);
> +
> +		unregister_sja1000dev(dev);
> +		free_sja1000dev(dev);
> +	}
> +
> +	pcim_iounmap(pdev, card->addr);
> +}
> +
> +/* Probe F81601 based device for the SJA1000 chips and register each
> + * available CAN channel to SJA1000 Socket-CAN subsystem.
> + */
> +static int f81601_pci_add_card(struct pci_dev *pdev,
> +			       const struct pci_device_id *ent)
> +{
> +	struct sja1000_priv *priv;
> +	struct net_device *dev;
> +	struct f81601_pci_card *card;
> +	int err, i;
> +	u8 tmp;
> +
> +	if (pcim_enable_device(pdev) < 0) {
> +		dev_err(&pdev->dev, "Failed to enable PCI device\n");
> +		return -ENODEV;
> +	}
> +
> +	dev_info(&pdev->dev, "Detected card at slot #%i\n",
> +		 PCI_SLOT(pdev->devfn));
> +
> +	card =3D devm_kzalloc(&pdev->dev, sizeof(*card), GFP_KERNEL);
> +	if (!card)
> +		return -ENOMEM;
> +
> +	card->channels =3D 0;
> +	card->dev =3D pdev;
> +	spin_lock_init(&card->lock);
> +
> +	pci_set_drvdata(pdev, card);
> +
> +	tmp =3D F81601_IO_MODE | F81601_MEM_MODE | F81601_CFG_MODE |
> +			F81601_CAN2_EN | F81601_CAN1_EN;

nitpick: pleas use only 2 tabs to indent here.

> +
> +	if (internal_clk) {
> +		tmp |=3D F81601_CAN2_INTERNAL_CLK | F81601_CAN1_INTERNAL_CLK;
> +
> +		dev_info(&pdev->dev,
> +			 "F81601 running with internal clock: 24Mhz\n");
> +	} else {
> +		dev_info(&pdev->dev,
> +			 "F81601 running with external clock: %dMhz\n",
> +			 external_clk / 1000000);
> +	}
> +
> +	pci_write_config_byte(pdev, F81601_DECODE_REG, tmp);
> +
> +	card->addr =3D pcim_iomap(pdev, 0, pci_resource_len(pdev, 0));
> +
> +	if (!card->addr) {
> +		err =3D -ENOMEM;
> +		dev_err(&pdev->dev, "%s: Failed to remap BAR\n", __func__);
> +		goto failure_cleanup;
> +	}
> +
> +	/* Detect available channels */
> +	for (i =3D 0; i < F81601_PCI_MAX_CHAN; i++) {
> +		/* read CAN2_HW_EN strap pin */
> +		pci_read_config_byte(pdev, F81601_TRAP_REG, &tmp);

Why do you read this inside the loop? Read it outside and adjust the end
of the for loop instead.

> +		if (i =3D=3D 1 && !(tmp & F81601_CAN2_HAS_EN))
> +			break;
> +
> +		dev =3D alloc_sja1000dev(0);
> +		if (!dev) {
> +			err =3D -ENOMEM;
> +			goto failure_cleanup;
> +		}
> +
> +		card->net_dev[i] =3D dev;
> +		dev->irq =3D pdev->irq;
> +
> +		priv =3D netdev_priv(dev);
> +		priv->priv =3D card;
> +		priv->irq_flags =3D IRQF_SHARED;
> +		priv->reg_base =3D card->addr + 0x80 * i;
> +		priv->read_reg =3D f81601_pci_read_reg;
> +		priv->write_reg =3D f81601_pci_write_reg;
> +
> +		if (internal_clk)
> +			priv->can.clock.freq =3D 24000000 / 2;
> +		else
> +			priv->can.clock.freq =3D external_clk / 2;
> +
> +		priv->ocr =3D OCR_TX0_PUSHPULL | OCR_TX1_PUSHPULL;
> +		priv->cdr =3D CDR_CBP;
> +
> +		SET_NETDEV_DEV(dev, &pdev->dev);
> +		dev->dev_id =3D i;
> +
> +		/* Register SJA1000 device */
> +		err =3D register_sja1000dev(dev);
> +		if (err) {
> +			dev_err(&pdev->dev,
> +				"%s: Registering device failed: %x\n", __func__,
> +				err);
> +			goto failure_cleanup;

If this fails you still call a unregister_sja1000dev() in
f81601_pci_del_card()

> +		}
> +
> +		card->channels++;
> +
> +		dev_info(&pdev->dev, "Channel #%d, %s at 0x%p, irq %d\n", i,
> +			 dev->name, priv->reg_base, dev->irq);
> +	}
> +
> +	if (!card->channels) {
> +		err =3D -ENODEV;
> +		goto failure_cleanup;
> +	}
> +
> +	return 0;
> +
> +failure_cleanup:
> +	dev_err(&pdev->dev, "%s: failed: %d. Cleaning Up.\n", __func__, err);=

> +	f81601_pci_del_card(pdev);
> +
> +	return err;
> +}
> +
> +static struct pci_driver f81601_pci_driver =3D {
> +	.name =3D		"f81601",
> +	.id_table =3D	f81601_pci_tbl,
> +	.probe =3D	f81601_pci_add_card,
> +	.remove =3D	f81601_pci_del_card,
> +};
> +
> +MODULE_DESCRIPTION("Fintek F81601 PCIE to 2 CANBUS adaptor driver");
> +MODULE_AUTHOR("Peter Hong <peter_hong@fintek.com.tw>");
> +MODULE_LICENSE("GPL v2");
> +
> +module_pci_driver(f81601_pci_driver);
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--j58FJJrsxd12bGa9A3zAvkOxfVQx1lnOz--

--SvuoA6sHyUMxv6vvgjV2uk2PbulNI7Xa4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl0xy1wACgkQWsYho5Hk
nSDx6ggAhrc2DYelS2PlFnSzj+orDWXZ3K3FkYr7pm1B+2mPz/5XfB+ZX/HASK2Z
e5ExMUE1PaM3UmsMlxFbzOEzFnRceN8xXjguWnQfTwgreazlzdPR6W/dLvGE/tDc
Nb9CjTlWL1dF+dWCzVg+zyzx40loAuJgAiJAvEow9Hcm/mmheSRrJFm5iG8JwmHR
h0nn7xCQBIG/9MH73Vy0T0o7flyL3qRmMuDJzx/TWaPwtAedaMGK74/ied3K4Woo
LAKWtF4h0TQ40LXuCFvOYALdG2QpS5C9hgjg/dluUnCSblAa9VpjAe6eRT83HOn6
VHG0E8Z/giGQWo1CWo1Q7F2nbLx6UA==
=GSC7
-----END PGP SIGNATURE-----

--SvuoA6sHyUMxv6vvgjV2uk2PbulNI7Xa4--
