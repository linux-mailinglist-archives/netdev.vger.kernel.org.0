Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4455B2F47AC
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbhAMJel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727185AbhAMJel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:34:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF85C061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 01:34:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzcXI-0005MT-3n; Wed, 13 Jan 2021 10:33:52 +0100
Received: from [IPv6:2a03:f580:87bc:d400:fee8:1d97:dec2:c25] (unknown [IPv6:2a03:f580:87bc:d400:fee8:1d97:dec2:c25])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4C7785C2905;
        Wed, 13 Jan 2021 09:33:48 +0000 (UTC)
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org
Cc:     Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
Message-ID: <7643bd48-6594-9ede-b791-de6e155c62c1@pengutronix.de>
Date:   Wed, 13 Jan 2021 10:33:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Ccz1nnbT3WQhOT9ZEzqelTfRHpUOwUMJF"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ccz1nnbT3WQhOT9ZEzqelTfRHpUOwUMJF
Content-Type: multipart/mixed; boundary="gMlG8Be2GbcgrZh4SVCXpfBU7bd7B97OD";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Vincent Mailhol <mailhol.vincent@wanadoo.fr>, linux-can@vger.kernel.org
Cc: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
 Wolfgang Grandegger <wg@grandegger.com>,
 "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Jimmy Assarsson <extja@kvaser.com>, Masahiro Yamada <masahiroy@kernel.org>,
 "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Message-ID: <7643bd48-6594-9ede-b791-de6e155c62c1@pengutronix.de>
Subject: Re: [PATCH v10 1/1] can: usb: etas_es58X: add support for ETAS ES58X
 CAN USB interfaces
References: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
 <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210112130538.14912-2-mailhol.vincent@wanadoo.fr>

--gMlG8Be2GbcgrZh4SVCXpfBU7bd7B97OD
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 1/12/21 2:05 PM, Vincent Mailhol wrote:
> This driver supports the ES581.4, ES582.1 and ES584.1 interfaces from
> ETAS GmbH (https://www.etas.com/en/products/es58x.php).
>=20
> Co-developed-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.=
com>
> Signed-off-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.co=
m>
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[...]

> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/=
can/usb/etas_es58x/es58x_core.c
> new file mode 100644
> index 000000000000..30692d78d8e6
> --- /dev/null
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -0,0 +1,2589 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
> + *
> + * File es58x_core.c: Core logic to manage the network devices and the=

> + * USB interface.
> + *
> + * Copyright (C) 2019 Robert Bosch Engineering and Business
> + * Solutions. All rights reserved.
> + * Copyright (C) 2020 ETAS K.K.. All rights reserved.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/usb.h>
> +#include <linux/crc16.h>
> +#include <linux/spinlock.h>
> +#include <asm/unaligned.h>
> +
> +#include "es58x_core.h"
> +
> +#define DRV_VERSION "1.00"
> +MODULE_AUTHOR("Mailhol Vincent <mailhol.vincent@wanadoo.fr>");
> +MODULE_AUTHOR("Arunachalam Santhanam <arunachalam.santhanam@in.bosch.c=
om>");
> +MODULE_DESCRIPTION("Socket CAN driver for ETAS ES58X USB adapters");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE("GPL v2");
> +
> +/* Vendor and product id */
> +#define ES58X_MODULE_NAME "etas_es58x"
> +#define ES58X_VENDOR_ID 0x108C
> +#define ES581_4_PRODUCT_ID 0x0159
> +#define ES582_1_PRODUCT_ID 0x0168
> +#define ES584_1_PRODUCT_ID 0x0169
> +
> +/* Table of devices which work with this driver */
> +static const struct usb_device_id es58x_id_table[] =3D {
> +	{USB_DEVICE(ES58X_VENDOR_ID, ES581_4_PRODUCT_ID)},
> +	{USB_DEVICE(ES58X_VENDOR_ID, ES582_1_PRODUCT_ID)},
> +	{USB_DEVICE(ES58X_VENDOR_ID, ES584_1_PRODUCT_ID)},
> +	{}			/* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, es58x_id_table);
> +
> +#define es58x_print_hex_dump(buf, len)					\
> +	print_hex_dump(KERN_DEBUG,					\
> +		       ES58X_MODULE_NAME " " __stringify(buf) ": ",	\
> +		       DUMP_PREFIX_NONE, 16, 1, buf, len, false)
> +
> +#define es58x_print_hex_dump_debug(buf, len)				 \
> +	print_hex_dump_debug(ES58X_MODULE_NAME " " __stringify(buf) ": ",\
> +			     DUMP_PREFIX_NONE, 16, 1, buf, len, false)
> +
> +/* The last two bytes of an ES58X command is a CRC16. The first two
> + * bytes (the start of frame) are skipped and the CRC calculation
> + * starts on the third byte.
> + */
> +#define ES58X_CRC_CALC_OFFSET	2
> +
> +/**
> + * es58x_calculate_crc() - Compute the crc16 of a given URB.
> + * @urb_cmd: The URB command for which we want to calculate the CRC.
> + * @urb_len: Length of @urb_cmd. Must be at least bigger than 4
> + *	(ES58X_CRC_CALC_OFFSET + sizeof(crc))
> + *
> + * Return: crc16 value.
> + */
> +static u16 es58x_calculate_crc(const union es58x_urb_cmd *urb_cmd, u16=
 urb_len)
> +{
> +	u16 crc;
> +	ssize_t len =3D urb_len - ES58X_CRC_CALC_OFFSET - sizeof(crc);
> +
> +	WARN_ON(len < 0);

Is it possible to ensure earlier, that the urbs are of correct length?

> +	crc =3D crc16(0, &urb_cmd->raw_cmd[ES58X_CRC_CALC_OFFSET], len);
> +	return crc;
> +}

[...]

> +/**
> + * struct es58x_priv - All information specific to a CAN channel.
> + * @can: struct can_priv must be the first member (Socket CAN relies
> + *	on the fact that function netdev_priv() returns a pointer to
> + *	a struct can_priv).
> + * @es58x_dev: pointer to the corresponding ES58X device.
> + * @tx_urb: Used as a buffer to concatenate the TX messages and to do
> + *	a bulk send. Please refer to es58x_start_xmit() for more
> + *	details.
> + * @echo_skb_spinlock: Spinlock to protect the access to the echo skb
> + *	FIFO.
> + * @current_packet_idx: Keeps track of the packet indexes.
> + * @echo_skb_tail_idx: beginning of the echo skb FIFO, i.e. index of
> + *	the first element.
> + * @echo_skb_head_idx: end of the echo skb FIFO plus one, i.e. first
> + *	free index.
> + * @num_echo_skb: actual number of elements in the FIFO. Thus, the end=

> + *	of the FIFO is echo_skb_head =3D (echo_skb_tail_idx +
> + *	num_echo_skb) % can.echo_skb_max.
> + * @tx_total_frame_len: sum, in bytes, of the length of each of the
> + *	CAN messages contained in @tx_urb. To be used as an input of
> + *	netdev_sent_queue() for BQL.
> + * @tx_can_msg_cnt: Number of messages in @tx_urb.
> + * @tx_can_msg_is_fd: false: all messages in @tx_urb are Classical
> + *	CAN, true: all messages in @tx_urb are CAN FD. Rationale:
> + *	ES58X FD devices do not allow to mix Classical CAN and FD CAN
> + *	frames in one single bulk transmission.
> + * @err_passive_before_rtx_success: The ES58X device might enter in a
> + *	state in which it keeps alternating between error passive
> + *	and active state. This counter keeps track of the number of
> + *	error passive and if it gets bigger than
> + *	ES58X_CONSECUTIVE_ERR_PASSIVE_MAX, es58x_rx_err_msg() will
> + *	force the status to bus-off.
> + * @channel_idx: Channel index, starts at zero.
> + */
> +struct es58x_priv {
> +	struct can_priv can;
> +	struct es58x_device *es58x_dev;
> +	struct urb *tx_urb;
> +
> +	spinlock_t echo_skb_spinlock;	/* Comments: c.f. supra */
> +	u32 current_packet_idx;
> +	u16 echo_skb_tail_idx;
> +	u16 echo_skb_head_idx;
> +	u16 num_echo_skb;

Can you explain me how the tx-path works, especially why you need the
current_packet_idx.

In the mcp251xfd driver, the number of TX buffers is a power of two, that=
 makes
things easier. tx_heads % len points to the next buffer to be filled, tx_=
tail %
len points to the next buffer to be completed. tx_head - tx_tail is the f=
ill
level of the FIFO. This works without spinlocks.

> +
> +	u16 tx_total_frame_len;
> +	u8 tx_can_msg_cnt;
> +	bool tx_can_msg_is_fd;
> +
> +	u8 err_passive_before_rtx_success;
> +
> +	u8 channel_idx;
> +};

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--gMlG8Be2GbcgrZh4SVCXpfBU7bd7B97OD--

--Ccz1nnbT3WQhOT9ZEzqelTfRHpUOwUMJF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl/+vnMACgkQqclaivrt
76lJUQf/eK0/ukT+q2OpJO/s9tezTw8zmtyDP5rNFKyjb5KHz8Y1RGG3GaFFeMv3
IN24SDwEdRbKAyGaYxGvFGS5liKnjA1iOsDryNPIyCCR19qKkl0plUJsVQIGlRlA
4lmS7m1tn4Zo59QqvjByT2PIR78oJGyciVItzQd55DfqTHa1RNBtJaVcFa+mwx4A
s/fmjqtGvIwzSyW8OpDRSHjt4qZorm9eWh36XDlP1F970FTnq+xqC3pi5tWeTdsy
l6nFT2W5WjeC90mde+ruloDfNyYjyqz3yHXnnNy8DhERb8N2RDl8t5bB2wR+YsVi
HXLXXbmfXfJOqvyf+sam2ROHu5ZwHw==
=pZj6
-----END PGP SIGNATURE-----

--Ccz1nnbT3WQhOT9ZEzqelTfRHpUOwUMJF--
