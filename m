Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7055C2AC5C8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgKIUMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKIUMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:12:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0556C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 12:12:09 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kcDWJ-0001Eh-Co; Mon, 09 Nov 2020 21:12:07 +0100
Received: from [IPv6:2a03:f580:87bc:d400:487:91c8:e2ec:9b3f] (unknown [IPv6:2a03:f580:87bc:d400:487:91c8:e2ec:9b3f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits)
         client-signature RSA-PSS (4096 bits))
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B895558E240;
        Mon,  9 Nov 2020 20:12:05 +0000 (UTC)
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, mailhol.vincent@wanadoo.fr
Cc:     netdev@vger.kernel.org
References: <20201109153657.17897-1-socketcan@hartkopp.net>
 <20201109153657.17897-9-socketcan@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v5 8/8] can-dev: add len8_dlc support for various CAN USB
 adapters
Message-ID: <c9b7ec89-0892-89fa-1f8d-af9c973e4544@pengutronix.de>
Date:   Mon, 9 Nov 2020 21:12:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201109153657.17897-9-socketcan@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="PFzdi0ghITbQ2PCBD8L9O1kBpLszx8jUy"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PFzdi0ghITbQ2PCBD8L9O1kBpLszx8jUy
Content-Type: multipart/mixed; boundary="b4G6alFjrTu9nlMET1VbK2XLT3PEYxLmp";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>, linux-can@vger.kernel.org,
 mailhol.vincent@wanadoo.fr
Cc: netdev@vger.kernel.org
Message-ID: <c9b7ec89-0892-89fa-1f8d-af9c973e4544@pengutronix.de>
Subject: Re: [PATCH v5 8/8] can-dev: add len8_dlc support for various CAN USB
 adapters
References: <20201109153657.17897-1-socketcan@hartkopp.net>
 <20201109153657.17897-9-socketcan@hartkopp.net>
In-Reply-To: <20201109153657.17897-9-socketcan@hartkopp.net>

--b4G6alFjrTu9nlMET1VbK2XLT3PEYxLmp
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 11/9/20 4:36 PM, Oliver Hartkopp wrote:
> Support the Classical CAN raw DLC functionality to send and receive DLC=

> values from 9 .. 15 on various Classical CAN capable USB network driver=
s:
>=20
> - gs_usb
> - pcan_usb
> - pcan_usb_fd
> - usb_8dev
>=20
> Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>  drivers/net/can/usb/gs_usb.c               |  8 ++++++--
>  drivers/net/can/usb/peak_usb/pcan_usb.c    |  8 ++++++--
>  drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 17 ++++++++++++-----
>  drivers/net/can/usb/usb_8dev.c             |  9 ++++++---
>  4 files changed, 30 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.=
c
> index 940589667a7f..cc0c30a33335 100644
> --- a/drivers/net/can/usb/gs_usb.c
> +++ b/drivers/net/can/usb/gs_usb.c
> @@ -330,10 +330,13 @@ static void gs_usb_receive_bulk_callback(struct u=
rb *urb)
>  			return;
> =20
>  		cf->can_id =3D hf->can_id;
> =20
>  		cf->len =3D can_cc_dlc2len(hf->len);
> +		cf->len8_dlc =3D can_get_len8_dlc(dev->can.ctrlmode, cf->len,
> +						hf->len);

What about introducing a function that sets len and len8_dlc at the same =
time:

void can_frame_set_length(const struct can_priv *can, struct can_frame *c=
fd, u8
dlc);

And maybe a function that takes a canfd_frame, so that we don't need to c=
ast....

> +
>  		memcpy(cf->data, hf->data, 8);
> =20
>  		/* ERROR frames tell us information about the controller */
>  		if (hf->can_id & CAN_ERR_FLAG)
>  			gs_update_state(dev, cf);
> @@ -502,11 +505,12 @@ static netdev_tx_t gs_can_start_xmit(struct sk_bu=
ff *skb,
>  	hf->channel =3D dev->channel;
> =20
>  	cf =3D (struct can_frame *)skb->data;
> =20
>  	hf->can_id =3D cf->can_id;
> -	hf->len =3D cf->len;
> +	hf->len =3D can_get_cc_dlc(dev->can.ctrlmode, cf->len, cf->len8_dlc);=

> +
>  	memcpy(hf->data, cf->data, cf->len);
> =20
>  	usb_fill_bulk_urb(urb, dev->udev,
>  			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
>  			  hf,
> @@ -856,11 +860,11 @@ static struct gs_can *gs_make_candev(unsigned int=
 channel,
>  	dev->can.state =3D CAN_STATE_STOPPED;
>  	dev->can.clock.freq =3D bt_const->fclk_can;
>  	dev->can.bittiming_const =3D &dev->bt_const;
>  	dev->can.do_set_bittiming =3D gs_usb_set_bittiming;
> =20
> -	dev->can.ctrlmode_supported =3D 0;
> +	dev->can.ctrlmode_supported =3D CAN_CTRLMODE_CC_LEN8_DLC;
> =20
>  	if (bt_const->feature & GS_CAN_FEATURE_LISTEN_ONLY)
>  		dev->can.ctrlmode_supported |=3D CAN_CTRLMODE_LISTENONLY;
> =20
>  	if (bt_const->feature & GS_CAN_FEATURE_LOOP_BACK)
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb.c b/drivers/net/can/=
usb/peak_usb/pcan_usb.c
> index ec34f87cc02c..5a8dffacc24e 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb.c
> @@ -733,10 +733,12 @@ static int pcan_usb_decode_data(struct pcan_usb_m=
sg_context *mc, u8 status_len)
> =20
>  		cf->can_id =3D le16_to_cpu(tmp16) >> 5;
>  	}
> =20
>  	cf->len =3D can_cc_dlc2len(rec_len);
> +	cf->len8_dlc =3D can_get_len8_dlc(mc->pdev->dev.can.ctrlmode, cf->len=
,
> +					rec_len);
> =20
>  	/* Only first packet timestamp is a word */
>  	if (pcan_usb_decode_ts(mc, !mc->rec_ts_idx))
>  		goto decode_failed;
> =20
> @@ -836,11 +838,12 @@ static int pcan_usb_encode_msg(struct peak_usb_de=
vice *dev, struct sk_buff *skb,
>  	obuf[1] =3D 1;
> =20
>  	pc =3D obuf + PCAN_USB_MSG_HEADER_LEN;
> =20
>  	/* status/len byte */
> -	*pc =3D cf->len;
> +	*pc =3D can_get_cc_dlc(dev->can.ctrlmode, cf->len, cf->len8_dlc);
> +
>  	if (cf->can_id & CAN_RTR_FLAG)
>  		*pc |=3D PCAN_USB_STATUSLEN_RTR;
> =20
>  	/* can id */
>  	if (cf->can_id & CAN_EFF_FLAG) {
> @@ -990,11 +993,12 @@ static const struct can_bittiming_const pcan_usb_=
const =3D {
>  const struct peak_usb_adapter pcan_usb =3D {
>  	.name =3D "PCAN-USB",
>  	.device_id =3D PCAN_USB_PRODUCT_ID,
>  	.ctrl_count =3D 1,
>  	.ctrlmode_supported =3D CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENO=
NLY |
> -			      CAN_CTRLMODE_BERR_REPORTING,
> +			      CAN_CTRLMODE_BERR_REPORTING |
> +			      CAN_CTRLMODE_CC_LEN8_DLC,
>  	.clock =3D {
>  		.freq =3D PCAN_USB_CRYSTAL_HZ / 2 ,
>  	},
>  	.bittiming_const =3D &pcan_usb_const,
> =20
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c b/drivers/net/c=
an/usb/peak_usb/pcan_usb_fd.c
> index 761e78d8e647..8020071c9067 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_fd.c
> @@ -492,16 +492,21 @@ static int pcan_usb_fd_decode_canmsg(struct pcan_=
usb_fd_if *usb_if,
>  		if (rx_msg_flags & PUCAN_MSG_ERROR_STATE_IND)
>  			cfd->flags |=3D CANFD_ESI;
> =20
>  		cfd->len =3D can_fd_dlc2len(pucan_msg_get_dlc(rm));
>  	} else {
> +		struct can_frame *cf;
> +
>  		/* CAN 2.0 frame case */
>  		skb =3D alloc_can_skb(netdev, (struct can_frame **)&cfd);
>  		if (!skb)
>  			return -ENOMEM;
> =20
>  		cfd->len =3D can_cc_dlc2len(pucan_msg_get_dlc(rm));
> +		cf =3D (struct can_frame *)cfd;
> +		cf->len8_dlc =3D can_get_len8_dlc(dev->can.ctrlmode, cf->len,
> +						pucan_msg_get_dlc(rm));
>  	}
> =20
>  	cfd->can_id =3D le32_to_cpu(rm->can_id);
> =20
>  	if (rx_msg_flags & PUCAN_MSG_EXT_ID)
> @@ -764,12 +769,14 @@ static int pcan_usb_fd_encode_msg(struct peak_usb=
_device *dev,
>  			tx_msg_flags |=3D PUCAN_MSG_BITRATE_SWITCH;
> =20
>  		if (cfd->flags & CANFD_ESI)
>  			tx_msg_flags |=3D PUCAN_MSG_ERROR_STATE_IND;
>  	} else {
> +		struct can_frame *cf =3D (struct can_frame *)cfd;
> +
>  		/* CAND 2.0 frames */
> -		len =3D cfd->len;
> +		len =3D can_get_cc_dlc(dev->can.ctrlmode, cf->len, cf->len8_dlc);
> =20
>  		if (cfd->can_id & CAN_RTR_FLAG)
>  			tx_msg_flags |=3D PUCAN_MSG_RTR;
>  	}
> =20
> @@ -1033,11 +1040,11 @@ static const struct can_bittiming_const pcan_us=
b_fd_data_const =3D {
> =20
>  const struct peak_usb_adapter pcan_usb_fd =3D {
>  	.name =3D "PCAN-USB FD",
>  	.device_id =3D PCAN_USBFD_PRODUCT_ID,
>  	.ctrl_count =3D PCAN_USBFD_CHANNEL_COUNT,
> -	.ctrlmode_supported =3D CAN_CTRLMODE_FD |
> +	.ctrlmode_supported =3D CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
>  			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,

Please add the new CTRLMODE at the end, so that the list ist sorted. I do=
n't
mind if the diff is a bit larger.

>  	.clock =3D {
>  		.freq =3D PCAN_UFD_CRYSTAL_HZ,
>  	},
>  	.bittiming_const =3D &pcan_usb_fd_const,
> @@ -1105,11 +1112,11 @@ static const struct can_bittiming_const pcan_us=
b_chip_data_const =3D {
> =20
>  const struct peak_usb_adapter pcan_usb_chip =3D {
>  	.name =3D "PCAN-Chip USB",
>  	.device_id =3D PCAN_USBCHIP_PRODUCT_ID,
>  	.ctrl_count =3D PCAN_USBFD_CHANNEL_COUNT,
> -	.ctrlmode_supported =3D CAN_CTRLMODE_FD |
> +	.ctrlmode_supported =3D CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
>  		CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,

same here

>  	.clock =3D {
>  		.freq =3D PCAN_UFD_CRYSTAL_HZ,
>  	},
>  	.bittiming_const =3D &pcan_usb_chip_const,
> @@ -1177,11 +1184,11 @@ static const struct can_bittiming_const pcan_us=
b_pro_fd_data_const =3D {
> =20
>  const struct peak_usb_adapter pcan_usb_pro_fd =3D {
>  	.name =3D "PCAN-USB Pro FD",
>  	.device_id =3D PCAN_USBPROFD_PRODUCT_ID,
>  	.ctrl_count =3D PCAN_USBPROFD_CHANNEL_COUNT,
> -	.ctrlmode_supported =3D CAN_CTRLMODE_FD |
> +	.ctrlmode_supported =3D CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
>  			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,

same here

>  	.clock =3D {
>  		.freq =3D PCAN_UFD_CRYSTAL_HZ,
>  	},
>  	.bittiming_const =3D &pcan_usb_pro_fd_const,
> @@ -1249,11 +1256,11 @@ static const struct can_bittiming_const pcan_us=
b_x6_data_const =3D {
> =20
>  const struct peak_usb_adapter pcan_usb_x6 =3D {
>  	.name =3D "PCAN-USB X6",
>  	.device_id =3D PCAN_USBX6_PRODUCT_ID,
>  	.ctrl_count =3D PCAN_USBPROFD_CHANNEL_COUNT,
> -	.ctrlmode_supported =3D CAN_CTRLMODE_FD |
> +	.ctrlmode_supported =3D CAN_CTRLMODE_FD | CAN_CTRLMODE_CC_LEN8_DLC |
>  			CAN_CTRLMODE_3_SAMPLES | CAN_CTRLMODE_LISTENONLY,

same here

>  	.clock =3D {
>  		.freq =3D PCAN_UFD_CRYSTAL_HZ,
>  	},
>  	.bittiming_const =3D &pcan_usb_x6_const,
> diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8=
dev.c
> index 6517aaeb4bc0..57e689cb87c9 100644
> --- a/drivers/net/can/usb/usb_8dev.c
> +++ b/drivers/net/can/usb/usb_8dev.c
> @@ -469,10 +469,12 @@ static void usb_8dev_rx_can_msg(struct usb_8dev_p=
riv *priv,
>  		if (!skb)
>  			return;
> =20
>  		cf->can_id =3D be32_to_cpu(msg->id);
>  		cf->len =3D can_cc_dlc2len(msg->dlc & 0xF);
> +		cf->len8_dlc =3D can_get_len8_dlc(priv->can.ctrlmode, cf->len,
> +						msg->dlc & 0xF);
> =20
>  		if (msg->flags & USB_8DEV_EXTID)
>  			cf->can_id |=3D CAN_EFF_FLAG;
> =20
>  		if (msg->flags & USB_8DEV_RTR)
> @@ -635,11 +637,11 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_=
buff *skb,
> =20
>  	if (cf->can_id & CAN_EFF_FLAG)
>  		msg->flags |=3D USB_8DEV_EXTID;
> =20
>  	msg->id =3D cpu_to_be32(cf->can_id & CAN_ERR_MASK);
> -	msg->dlc =3D cf->len;
> +	msg->dlc =3D can_get_cc_dlc(priv->can.ctrlmode, cf->len, cf->len8_dlc=
);
>  	memcpy(msg->data, cf->data, cf->len);
>  	msg->end =3D USB_8DEV_DATA_END;
> =20
>  	for (i =3D 0; i < MAX_TX_URBS; i++) {
>  		if (priv->tx_contexts[i].echo_index =3D=3D MAX_TX_URBS) {
> @@ -925,12 +927,13 @@ static int usb_8dev_probe(struct usb_interface *i=
ntf,
>  	priv->can.clock.freq =3D USB_8DEV_ABP_CLOCK;
>  	priv->can.bittiming_const =3D &usb_8dev_bittiming_const;
>  	priv->can.do_set_mode =3D usb_8dev_set_mode;
>  	priv->can.do_get_berr_counter =3D usb_8dev_get_berr_counter;
>  	priv->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK |
> -				      CAN_CTRLMODE_LISTENONLY |
> -				      CAN_CTRLMODE_ONE_SHOT;
> +				       CAN_CTRLMODE_LISTENONLY |
> +				       CAN_CTRLMODE_ONE_SHOT |
> +				       CAN_CTRLMODE_CC_LEN8_DLC;
> =20
>  	netdev->netdev_ops =3D &usb_8dev_netdev_ops;
> =20
>  	netdev->flags |=3D IFF_ECHO; /* we support local echo */
> =20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--b4G6alFjrTu9nlMET1VbK2XLT3PEYxLmp--

--PFzdi0ghITbQ2PCBD8L9O1kBpLszx8jUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+popEACgkQqclaivrt
76liXgf9H6fksxWN5WdIQOVFBpLGC7VY0DS6bREGyJ0jyG9qw5kSRgP4WaMouOSC
cjYBOcoqnDhi77R2EfxrgHm4NHfQ5kk5Jf99rzGSwbtXH+drZ51NjhmFIe/iDb+8
2TosPrFlAo88cBCRZchB2Mw6UEg3mVuAQDlwokIA/29EnBOYCP1ONX4cVVoUrzGR
Ri/tXjXUi7zZaQXKo/YOP8A9jt0zFhgeF9qh8V7eSvrWCpJmPO6DNDYsrpPwbuC9
qdN1v+CTsYVPyi/bn7CcUMgDpO2F/D5bUPf0nvyWsXgkLCsTtX99U7rzbu47yFYZ
Z1KCa1ycX8ydtrGmvkIKk2D6uKO4vQ==
=cGuE
-----END PGP SIGNATURE-----

--PFzdi0ghITbQ2PCBD8L9O1kBpLszx8jUy--
