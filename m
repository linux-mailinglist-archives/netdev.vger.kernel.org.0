Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E803F4BF5
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 15:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhHWNzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 09:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbhHWNzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 09:55:32 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B51C061760
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 06:54:49 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIAPS-00010A-Dd; Mon, 23 Aug 2021 15:54:42 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-787b-f288-55eb-85b5.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:787b:f288:55eb:85b5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 26F9C66D6F1;
        Mon, 23 Aug 2021 13:54:40 +0000 (UTC)
Date:   Mon, 23 Aug 2021 15:54:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     tangbin <tangbin@cmss.chinamobile.com>
Cc:     davem@davemloft.net, wg@grandegger.com, kuba@kernel.org,
        kevinbrace@bracecomputerlab.com, romieu@fr.zoreil.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] can: mscan: mpc5xxx_can: Useof_device_get_match_data
 to simplify code
Message-ID: <20210823135438.kqsrkolixcgepyqq@pengutronix.de>
References: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
 <20210823113338.3568-4-tangbin@cmss.chinamobile.com>
 <20210823123715.j4khoyld5mfl6kdv@pengutronix.de>
 <eafd35fd-bf71-167a-b1c8-50e3117e4be4@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jixblqe2faubctur"
Content-Disposition: inline
In-Reply-To: <eafd35fd-bf71-167a-b1c8-50e3117e4be4@cmss.chinamobile.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jixblqe2faubctur
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23.08.2021 21:52:03, tangbin wrote:
> On 2021/8/23 20:37, Marc Kleine-Budde wrote:
> > On 23.08.2021 19:33:38, Tang Bin wrote:
> > > Retrieve OF match data, it's better and cleaner to use
> > > 'of_device_get_match_data' over 'of_match_device'.
> > >=20
> > > Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> > Thanks for the patch!
> >=20
> > LGTM, comment inside.

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

> >=20
> > > ---
> > >   drivers/net/can/mscan/mpc5xxx_can.c | 6 ++----
> > >   1 file changed, 2 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/ms=
can/mpc5xxx_can.c
> > > index e254e04ae..3b7465acd 100644
> > > --- a/drivers/net/can/mscan/mpc5xxx_can.c
> > > +++ b/drivers/net/can/mscan/mpc5xxx_can.c
> > > @@ -279,7 +279,6 @@ static u32 mpc512x_can_get_clock(struct platform_=
device *ofdev,
> > >   static const struct of_device_id mpc5xxx_can_table[];
> > >   static int mpc5xxx_can_probe(struct platform_device *ofdev)
> > >   {
> > > -	const struct of_device_id *match;
> > >   	const struct mpc5xxx_can_data *data;
> > >   	struct device_node *np =3D ofdev->dev.of_node;
> > >   	struct net_device *dev;
> > > @@ -289,10 +288,9 @@ static int mpc5xxx_can_probe(struct platform_dev=
ice *ofdev)
> > >   	int irq, mscan_clksrc =3D 0;
> > >   	int err =3D -ENOMEM;
> > > -	match =3D of_match_device(mpc5xxx_can_table, &ofdev->dev);
> > > -	if (!match)
> > > +	data =3D of_device_get_match_data(&ofdev->dev);
> > > +	if (!data)
> > >   		return -EINVAL;
> > Please remove the "BUG_ON(!data)", which comes later.
>=20
> For this place, may I send another patch to fix this 'BUG_ON()' by itself,
> not in this patch series?

Ok, fine with me.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jixblqe2faubctur
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEjqJsACgkQqclaivrt
76kZ6Qf+LZK9RK41ugfpxym8HcN369Qtbad2R93j0TZne2/WOmoQ+EKbZgp9NRIJ
XOXPmVJolpJFnqxjiRL9aGVo/8uJZSdl9irwafrhw+qy9voEjbcV8jtnxgc4m6oU
L6kFRfnHJ8KZvBUytRNdn7n+wzveE/Eo45U22TjNY7Jdc6AqK7bzoCOdd2SqiVs+
qxA+UOUtS9Yq1QR+EDxlmKpSLieN2CAhdwCJpJXwGrw31eU099bqXbIyiRbzdzUy
NKCfzjNGGIN9DgO+l7zYRcPlSscH50Whven/X9uoMyVBV7SzP0frHcfgHsA39XAJ
GQIO6fZQwNRu+2GTzGECNMw6GU/wtg==
=MepM
-----END PGP SIGNATURE-----

--jixblqe2faubctur--
