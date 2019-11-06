Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A46F1401
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 11:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbfKFKew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 05:34:52 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47317 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfKFKew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 05:34:52 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iSIe5-0004os-2G; Wed, 06 Nov 2019 11:34:37 +0100
Received: from [IPv6:2a03:f580:87bc:d400:591d:c131:e96:905c] (unknown [IPv6:2a03:f580:87bc:d400:591d:c131:e96:905c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AA64A475D65;
        Wed,  6 Nov 2019 10:34:33 +0000 (UTC)
To:     Pankaj Sharma <pankj.sharma@samsung.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, davem@davemloft.net,
        eugen.hristev@microchip.com, ludovic.desroches@microchip.com,
        pankaj.dubey@samsung.com, rcsekar@samsung.com,
        Sriram Dash <sriram.dash@samsung.com>
References: <CGME20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60@epcas5p2.samsung.com>
 <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v3] can: m_can: add support for one shot mode
Message-ID: <38ade7ff-0e0c-afe9-a927-17317f0f27b9@pengutronix.de>
Date:   Wed, 6 Nov 2019 11:34:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="aeTzOOUikqsVKEOsx0QyyLYXFesD57WRP"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aeTzOOUikqsVKEOsx0QyyLYXFesD57WRP
Content-Type: multipart/mixed; boundary="016AdyxrEnrgKM0NsyoJtaE66CTZDe96W";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Pankaj Sharma <pankj.sharma@samsung.com>, linux-can@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: wg@grandegger.com, davem@davemloft.net, eugen.hristev@microchip.com,
 ludovic.desroches@microchip.com, pankaj.dubey@samsung.com,
 rcsekar@samsung.com, Sriram Dash <sriram.dash@samsung.com>
Message-ID: <38ade7ff-0e0c-afe9-a927-17317f0f27b9@pengutronix.de>
Subject: Re: [PATCH v3] can: m_can: add support for one shot mode
References: <CGME20191021120513epcas5p2fd23f5dbdff6a0e6aa3b0726b30e4b60@epcas5p2.samsung.com>
 <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>
In-Reply-To: <1571659480-29109-1-git-send-email-pankj.sharma@samsung.com>

--016AdyxrEnrgKM0NsyoJtaE66CTZDe96W
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

On 10/21/19 2:04 PM, Pankaj Sharma wrote:
> According to the CAN Specification (see ISO 11898-1:2015, 8.3.4
> Recovery Management), the M_CAN provides means for automatic
> retransmission of frames that have lost arbitration or that
> have been disturbed by errors during transmission. By default
> automatic retransmission is enabled.
>=20
> The Bosch MCAN controller has support for disabling automatic
> retransmission.
>=20
> To support time-triggered communication as described in ISO
> 11898-1:2015, chapter 9.2, the automatic retransmission may be
> disabled via CCCR.DAR.
>=20
> CAN_CTRLMODE_ONE_SHOT is used for disabling automatic retransmission.
>=20
> Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
> Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
> ---
>=20
> changes in v3:=20
> - resolving build errors for net-next branch
>=20
> changes in v2:
> - rebase to net-next
>=20
>  drivers/net/can/m_can/m_can.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_ca=
n.c
> index 562c8317e3aa..75e7490c4299 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -123,6 +123,7 @@ enum m_can_reg {
>  #define CCCR_CME_CANFD_BRS	0x2
>  #define CCCR_TXP		BIT(14)
>  #define CCCR_TEST		BIT(7)
> +#define CCCR_DAR		BIT(6)
>  #define CCCR_MON		BIT(5)
>  #define CCCR_CSR		BIT(4)
>  #define CCCR_CSA		BIT(3)
> @@ -1135,7 +1136,7 @@ static void m_can_chip_config(struct net_device *=
dev)
>  	if (cdev->version =3D=3D 30) {
>  	/* Version 3.0.x */
> =20
> -		cccr &=3D ~(CCCR_TEST | CCCR_MON |
> +		cccr &=3D ~(CCCR_TEST | CCCR_MON | CCCR_DAR |
>  			(CCCR_CMR_MASK << CCCR_CMR_SHIFT) |
>  			(CCCR_CME_MASK << CCCR_CME_SHIFT));
> =20
> @@ -1145,7 +1146,7 @@ static void m_can_chip_config(struct net_device *=
dev)
>  	} else {
>  	/* Version 3.1.x or 3.2.x */
>  		cccr &=3D ~(CCCR_TEST | CCCR_MON | CCCR_BRSE | CCCR_FDOE |
> -			  CCCR_NISO);
> +			  CCCR_NISO | CCCR_DAR);
> =20
>  		/* Only 3.2.x has NISO Bit implemented */
>  		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD_NON_ISO)
> @@ -1165,6 +1166,10 @@ static void m_can_chip_config(struct net_device =
*dev)
>  	if (cdev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
>  		cccr |=3D CCCR_MON;
> =20
> +	/* Disable Auto Retransmission (all versions) */
> +	if (cdev->can.ctrlmode & CAN_CTRLMODE_ONE_SHOT)
> +		cccr |=3D CCCR_DAR;
> +
>  	/* Write config */
>  	m_can_write(cdev, M_CAN_CCCR, cccr);
>  	m_can_write(cdev, M_CAN_TEST, test);
> @@ -1310,7 +1315,8 @@ static int m_can_dev_setup(struct m_can_classdev =
*m_can_dev)
>  	m_can_dev->can.ctrlmode_supported =3D CAN_CTRLMODE_LOOPBACK |
>  					CAN_CTRLMODE_LISTENONLY |
>  					CAN_CTRLMODE_BERR_REPORTING |
> -					CAN_CTRLMODE_FD;
> +					CAN_CTRLMODE_FD |
> +					CAN_CTRLMODE_ONE_SHOT;
> =20
>  	/* Set properties depending on M_CAN version */
>  	switch (m_can_dev->version) {

What happens if you have called netif_stop_queue() and the controller
was not able to send a single frame?

What happens to the echo_skb, if the controller was not able to send a
frame?

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--016AdyxrEnrgKM0NsyoJtaE66CTZDe96W--

--aeTzOOUikqsVKEOsx0QyyLYXFesD57WRP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl3CobIACgkQWsYho5Hk
nSA7sQf/er69fJSsoOBvGBnxpQKBjmWY1mb8W24+ZjzyfK54b6h5XI/PgTebMYZt
O8nrRzTbhV+vTshWwN2ik77LrWDQ/YnfYtqKvz/Tyo1abacbGJKHZpORwY3zQk0t
DXdy0XaktNnf846YGywsj2mBzUXCTClttcsW7mJ0jj0u2cCarrUZzqKgN1fGyE+W
Zw3TtP6XiFSLPFFus4g2DH298EfL3ODPzR8Rz6bboT9p/X+jZl8V30gxjoJBKgye
uuDHXoSLqAqr0YAMIBJ2zt4Rf4zx1omjI3vuXfvstSEUoasatcc8LCA7gKYpmLTS
OifZ8cgIBmG+F/jbOVDG8LsPMZN02g==
=LZVO
-----END PGP SIGNATURE-----

--aeTzOOUikqsVKEOsx0QyyLYXFesD57WRP--
