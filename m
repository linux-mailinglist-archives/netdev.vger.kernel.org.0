Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE13A325F62
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 09:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhBZIpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 03:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBZIpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 03:45:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B4CC061756
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 00:45:10 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lFYk6-0000ml-8e; Fri, 26 Feb 2021 09:44:58 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:adc1:3ee1:6274:c5d0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 076B45E9946;
        Fri, 26 Feb 2021 08:44:56 +0000 (UTC)
Date:   Fri, 26 Feb 2021 09:44:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Federico Vaga <federico.vaga@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/6] can: c_can: fix control interface used by
 c_can_do_tx
Message-ID: <20210226084456.l2oztlesjzl6t2nm@pengutronix.de>
References: <20210225215155.30509-1-dariobin@libero.it>
 <20210225215155.30509-4-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g2copbah44yv5ij6"
Content-Disposition: inline
In-Reply-To: <20210225215155.30509-4-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--g2copbah44yv5ij6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.02.2021 22:51:52, Dario Binacchi wrote:
> According to commit 640916db2bf7 ("can: c_can: Make it SMP safe") let RX =
use
> IF1 (i.e. IF_RX) and TX use IF2 (i.e. IF_TX).

Is this a fix?

Marc

>=20
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> ---
>=20
> (no changes since v1)
>=20
>  drivers/net/can/c_can/c_can.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
> index dbcc1c1c92d6..69526c3a671c 100644
> --- a/drivers/net/can/c_can/c_can.c
> +++ b/drivers/net/can/c_can/c_can.c
> @@ -732,7 +732,7 @@ static void c_can_do_tx(struct net_device *dev)
>  		idx--;
>  		pend &=3D ~(1 << idx);
>  		obj =3D idx + C_CAN_MSG_OBJ_TX_FIRST;
> -		c_can_inval_tx_object(dev, IF_RX, obj);
> +		c_can_inval_tx_object(dev, IF_TX, obj);
>  		can_get_echo_skb(dev, idx, NULL);
>  		bytes +=3D priv->dlc[idx];
>  		pkts++;
> --=20
> 2.17.1
>=20
>=20

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--g2copbah44yv5ij6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA4tQYACgkQqclaivrt
76l/2Qf/bS/uDTfQ72q3MKQ4xEMnNW++auVYPg7fsxHA6B3qxuiXSEHUZTqJrGL0
MktjVjXanDBtSkUEf+uHNusRgj9he5SkJHF2jFvAbaqW+0UbRl71r+HIvucgVDZF
1w3i22XrNbvDRrDv/IqPhYvwnrQJed4EiTEtluDcN3lwT6ibQA79QbjhmB4SjR4W
3MGlRvarItVS8jxraU25jQm9LkLyJ3jNTWup6bkEZwZIC3MZO52aMGczNeT5MCBH
MLubiGXDz4nNouaYS621nIOnPtQDRX+QIBWswtYF1YSGbJFnjtp2e07GPx2HWL2U
GrVJ7KIapfsmRrlxJF+hOTZUwcZByA==
=ofw4
-----END PGP SIGNATURE-----

--g2copbah44yv5ij6--
