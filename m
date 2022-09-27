Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97E75EC62B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 16:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiI0Oc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 10:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbiI0Och (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 10:32:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B351550721
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 07:32:36 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1odBdT-0005tX-4C; Tue, 27 Sep 2022 16:32:35 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1odBdS-003F7h-A5; Tue, 27 Sep 2022 16:32:32 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1odBdP-003uny-P8; Tue, 27 Sep 2022 16:32:31 +0200
Date:   Tue, 27 Sep 2022 16:32:25 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     broonie@kernel.org, Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: linux-next: manual merge of the net-next tree with the i2c tree
Message-ID: <20220927143225.j4yztggdqqozdiwa@pengutronix.de>
References: <20220927130206.368099-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7mgoxxaeekmkd6jf"
Content-Disposition: inline
In-Reply-To: <20220927130206.368099-1-broonie@kernel.org>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7mgoxxaeekmkd6jf
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Tue, Sep 27, 2022 at 02:02:06PM +0100, broonie@kernel.org wrote:
> Hi all,
>=20
> Today's linux-next merge of the net-next tree got conflicts in:
>=20
>   drivers/net/dsa/lan9303_i2c.c
>   drivers/net/dsa/microchip/ksz9477_i2c.c
>   drivers/net/dsa/xrs700x/xrs700x_i2c.c
>=20
> between commit:
>=20
>   ed5c2f5fd10dd ("i2c: Make remove callback return void")
>=20
> from the i2c tree and commits:
>=20
>   db5d451c4640a ("net: dsa: lan9303: remove unnecessary i2c_set_clientdat=
a()")
>   008971adb95d3 ("net: dsa: microchip: ksz9477: remove unnecessary i2c_se=
t_clientdata()")
>   6387bf7c390a1 ("net: dsa: xrs700x: remove unnecessary i2c_set_clientdat=
a()")
>=20
> from the net-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc drivers/net/dsa/lan9303_i2c.c
> index b25e91b26d991,79be5fc044bd4..0000000000000
> --- a/drivers/net/dsa/lan9303_i2c.c
> +++ b/drivers/net/dsa/lan9303_i2c.c
> @@@ -70,11 -70,11 +70,9 @@@ static void lan9303_i2c_remove(struct i
>   	struct lan9303_i2c *sw_dev =3D i2c_get_clientdata(client);
>  =20
>   	if (!sw_dev)
>  -		return 0;
>  +		return;
>  =20
>   	lan9303_remove(&sw_dev->chip);
> --
> - 	i2c_set_clientdata(client, NULL);
>  -	return 0;
>   }
>  =20
>   static void lan9303_i2c_shutdown(struct i2c_client *client)
> diff --cc drivers/net/dsa/microchip/ksz9477_i2c.c
> index 4a719ab8aa89c,e111756f64735..0000000000000
> --- a/drivers/net/dsa/microchip/ksz9477_i2c.c
> +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> @@@ -58,8 -58,8 +58,6 @@@ static void ksz9477_i2c_remove(struct i
>  =20
>   	if (dev)
>   		ksz_switch_remove(dev);
> --
> - 	i2c_set_clientdata(i2c, NULL);
>  -	return 0;
>   }
>  =20
>   static void ksz9477_i2c_shutdown(struct i2c_client *i2c)
> diff --cc drivers/net/dsa/xrs700x/xrs700x_i2c.c
> index bbaf5a3fbf000,cd533b9e17eca..0000000000000
> --- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> +++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
> @@@ -110,11 -110,11 +110,9 @@@ static void xrs700x_i2c_remove(struct i
>   	struct xrs700x *priv =3D i2c_get_clientdata(i2c);
>  =20
>   	if (!priv)
>  -		return 0;
>  +		return;
>  =20
>   	xrs700x_switch_remove(priv);
> --
> - 	i2c_set_clientdata(i2c, NULL);
>  -	return 0;
>   }
>  =20
>   static void xrs700x_i2c_shutdown(struct i2c_client *i2c)

To fix that issue before sending a PR to Linus you might want to pull

	https://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux i2c/make_remove_=
callback_void-immutable

into your tree.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--7mgoxxaeekmkd6jf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmMzCXYACgkQwfwUeK3K
7AmW1Qf/bgiNo2Mo68dWX3kd8AOMpEiW4YG/Hy6lGGWSOzLC473XhiRnN2nzM/cJ
TnIf5vRyVks8DYhy31HY5nnnJRYFiJMqHm1J9XzsYO3f6mY7P1BhmW1toagFKRdg
nxOCZTDh+Aos2m4FSXm91HUExFJ1hMaH4CH7nPjr+584+ZN+0ILVovTTchHuEzjl
Cy3+UN+d83DmLUoEjAVFKdURWggKpO5TYAbPluB5jZ1PsR4xeRMe72EU9FcWS0X8
+Pp+gUduEnEYgsWrJNBXmpSz2yWAiYEGYrsVNdfMt3PuuWAjWxW/3lYAX6YNXmJd
miAKxj5Akk0JK22aBXVj51nkKXblVQ==
=ONMS
-----END PGP SIGNATURE-----

--7mgoxxaeekmkd6jf--
