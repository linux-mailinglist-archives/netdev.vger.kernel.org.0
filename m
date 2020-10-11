Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB0628A619
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 09:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJKHPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 03:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgJKHPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 03:15:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838D4C0613D0
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 00:15:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kRVZz-00019G-Ch; Sun, 11 Oct 2020 09:15:39 +0200
Received: from [IPv6:2a03:f580:87bc:d400:94c5:3170:694e:9c6d] (unknown [IPv6:2a03:f580:87bc:d400:94c5:3170:694e:9c6d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 33A17576AAB;
        Sun, 11 Oct 2020 07:15:35 +0000 (UTC)
To:     Oliver Hartkopp <socketcan@hartkopp.net>, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org
References: <20201010204909.2059-1-socketcan@hartkopp.net>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH net-next 1/2] can-isotp: implement cleanups / improvements
 from review
Message-ID: <2c295ab7-882a-08de-26b5-685f0028c355@pengutronix.de>
Date:   Sun, 11 Oct 2020 09:15:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201010204909.2059-1-socketcan@hartkopp.net>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="iaXBA3O6b0w3JlJ3uNLvGR9KrmLd9XWf3"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iaXBA3O6b0w3JlJ3uNLvGR9KrmLd9XWf3
Content-Type: multipart/mixed; boundary="DqjUoOygCSmmnjCuujcZs7oqpQx4s1Mj7";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>, kuba@kernel.org,
 netdev@vger.kernel.org
Cc: davem@davemloft.net, linux-can@vger.kernel.org
Message-ID: <2c295ab7-882a-08de-26b5-685f0028c355@pengutronix.de>
Subject: Re: [PATCH net-next 1/2] can-isotp: implement cleanups / improvements
 from review
References: <20201010204909.2059-1-socketcan@hartkopp.net>
In-Reply-To: <20201010204909.2059-1-socketcan@hartkopp.net>

--DqjUoOygCSmmnjCuujcZs7oqpQx4s1Mj7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/10/20 10:49 PM, Oliver Hartkopp wrote:
> As pointed out by Jakub Kicinski here:
> https://marc.info/?l=3Dlinux-can&m=3D160229286216008
> this patch addresses the remarked issues:
>=20
> - remove empty lines in comment
> - remove default=3Dy for CAN_ISOTP in Kconfig
> - make use of pr_notice_once()
> - use GFP_KERNEL instead of gfp_any() in soft hrtimer context
>=20
> The version strings in the CAN subsystem are removed by a separate patc=
h.
>=20
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> ---
>  include/uapi/linux/can/isotp.h |  4 +---
>  net/can/Kconfig                |  3 ++-
>  net/can/isotp.c                | 14 +++++++-------
>  3 files changed, 10 insertions(+), 11 deletions(-)
>=20
> diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/is=
otp.h
> index 553006509f4e..accf0efa46f4 100644
> --- a/include/uapi/linux/can/isotp.h
> +++ b/include/uapi/linux/can/isotp.h
> @@ -151,8 +151,7 @@ struct can_isotp_ll_options {
>  #define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
>  #define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
> =20
> -/*
> - * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
> +/* Remark on CAN_ISOTP_DEFAULT_RECV_* values:

I think for uapi headers we use the default commenting style, not the net=
dev one.

>   *
>   * We can strongly assume, that the Linux Kernel implementation of
>   * CAN_ISOTP is capable to run with BS=3D0, STmin=3D0 and WFTmax=3D0.
> @@ -160,7 +159,6 @@ struct can_isotp_ll_options {
>   * these default settings can be changed via sockopts.
>   * For that reason the STmin value is intentionally _not_ checked for
>   * consistency and copied directly into the flow control (FC) frame.
> - *
>   */
> =20
>  #endif /* !_UAPI_CAN_ISOTP_H */
> diff --git a/net/can/Kconfig b/net/can/Kconfig
> index 021fe03a8ed6..224e5e0283a9 100644
> --- a/net/can/Kconfig
> +++ b/net/can/Kconfig
> @@ -57,7 +57,6 @@ source "net/can/j1939/Kconfig"
> =20
>  config CAN_ISOTP
>  	tristate "ISO 15765-2:2016 CAN transport protocol"
> -	default y
>  	help
>  	  CAN Transport Protocols offer support for segmented Point-to-Point
>  	  communication between CAN nodes via two defined CAN Identifiers.
> @@ -67,6 +66,8 @@ config CAN_ISOTP
>  	  vehicle diagnosis (UDS, ISO 14229) or IP-over-CAN traffic.
>  	  This protocol driver implements data transfers according to
>  	  ISO 15765-2:2016 for 'classic' CAN and CAN FD frame types.
> +	  If you want to perform automotive vehicle diagnostic services (UDS)=
,
> +	  say 'y'.
> =20
>  source "drivers/net/can/Kconfig"
> =20
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index e6ff032b5426..bc3a722c200b 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -222,8 +222,8 @@ static int isotp_send_fc(struct sock *sk, int ae, u=
8 flowstatus)
> =20
>  	can_send_ret =3D can_send(nskb, 1);
>  	if (can_send_ret)
> -		printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
> -			    __func__, can_send_ret);
> +		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
> +			       __func__, can_send_ret);

please define a pr_fmt for the "can-isotp: " prefix.

> =20
>  	dev_put(dev);
> =20
> @@ -769,7 +769,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(=
struct hrtimer *hrtimer)
> =20
>  isotp_tx_burst:
>  		skb =3D alloc_skb(so->ll.mtu + sizeof(struct can_skb_priv),
> -				gfp_any());
> +				GFP_KERNEL);
>  		if (!skb) {
>  			dev_put(dev);
>  			break;
> @@ -798,8 +798,8 @@ static enum hrtimer_restart isotp_tx_timer_handler(=
struct hrtimer *hrtimer)
> =20
>  		can_send_ret =3D can_send(skb, 1);
>  		if (can_send_ret)
> -			printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
> -				    __func__, can_send_ret);
> +			pr_notice_once("can-isotp: %s: can_send_ret %d\n",
> +				       __func__, can_send_ret);
> =20
>  		if (so->tx.idx >=3D so->tx.len) {
>  			/* we are done */
> @@ -942,8 +942,8 @@ static int isotp_sendmsg(struct socket *sock, struc=
t msghdr *msg, size_t size)
>  	err =3D can_send(skb, 1);
>  	dev_put(dev);
>  	if (err) {
> -		printk_once(KERN_NOTICE "can-isotp: %s: can_send_ret %d\n",
> -			    __func__, err);
> +		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
> +			       __func__, err);
>  		return err;
>  	}
> =20
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |


--DqjUoOygCSmmnjCuujcZs7oqpQx4s1Mj7--

--iaXBA3O6b0w3JlJ3uNLvGR9KrmLd9XWf3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAl+CsRAACgkQqclaivrt
76lf4ggAj954XeLxDfyz5rkdJ7kU9V3ZdEZDDQ7Kug5IJ9MhoynECC3nVY0jkdMR
UYYyXRP9NcD1LkLtiTCc8unRqFpExHtaVyuIKZ2JrpFx2z3Tm5/ilrL0TqQlk7KM
bMK1t8g0ok9dMGnPomBpiGM1z6zydqzPnC5uZHkrU1glB9w01Z/cRSD9TgrY9s2L
1H3hrhKkzSOh+viTJ4zx7PfBgOK1QAZi1OjV/RFA241t6Jksimj69o3sWEyNEliw
B+hPKiBBdsO0b4ZiriYBxNVOgvkctpKbF1eGm1Gtc1yn2gnw9YIVtNaoT+BBuXZT
zrkKuxXwr3mytOGM9jxuP2y2n3ZS8A==
=Esj9
-----END PGP SIGNATURE-----

--iaXBA3O6b0w3JlJ3uNLvGR9KrmLd9XWf3--
