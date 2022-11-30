Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6020963D339
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 11:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiK3KWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 05:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiK3KWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 05:22:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37052C649
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:22:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0KE4-0001I7-Et; Wed, 30 Nov 2022 11:22:00 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:38ad:958d:3def:4382])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C106012DD15;
        Wed, 30 Nov 2022 10:21:58 +0000 (UTC)
Date:   Wed, 30 Nov 2022 11:21:57 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <Frank.Jungclaus@esd.eu>
Cc:     Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mailhol.vincent@wanadoo.fr" <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH RESEND 1/1] can: esd_usb: Allow REC and TEC to return to
 zero
Message-ID: <20221130102157.ip7w35ufc6xepb5w@pengutronix.de>
References: <20221124203806.3034897-1-frank.jungclaus@esd.eu>
 <20221124203806.3034897-2-frank.jungclaus@esd.eu>
 <20221125155651.ilwfs64mtzcn2zvi@pengutronix.de>
 <567bb7208c29388eb5a4fe7a270f2c3192a87e0e.camel@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="txnwk44n5fupu5xm"
Content-Disposition: inline
In-Reply-To: <567bb7208c29388eb5a4fe7a270f2c3192a87e0e.camel@esd.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--txnwk44n5fupu5xm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.11.2022 17:15:56, Frank Jungclaus wrote:
> Hello Marc,
> thanks for commenting.
>=20
> On Fri, 2022-11-25 at 16:56 +0100, Marc Kleine-Budde wrote:
> > On 24.11.2022 21:38:06, Frank Jungclaus wrote:
> > > We don't get any further EVENT from an esd CAN USB device for changes
> > > on REC or TEC while those counters converge to 0 (with ecc =3D=3D 0).
> > > So when handling the "Back to Error Active"-event force
> > > txerr =3D rxerr =3D 0, otherwise the berr-counters might stay on
> > > values like 95 forever ...
> > >=20
> > > Also, to make life easier during the ongoing development a
> > > netdev_dbg() has been introduced to allow dumping error events send by
> > > an esd CAN USB device.
> > >=20
> > > Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
> >=20
> > Please add a Fixes tag.
> >=20
> > https://elixir.bootlin.com/linux/v6.0/source/Documentation/process/hand=
ling-regressions.rst#L107
> >=20
> From my point of view this is not a regression, it's a sort of
> imperfection existing since the initial add of esd_usb(2).c to the
> kernel. So should I add a "Fixes:" referring to the initial commit?
> (Currently) I'm slow on the uptake ;)

Please add a fixes tag that refers to the code that this patch fixes.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--txnwk44n5fupu5xm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHLsMACgkQrX5LkNig
0103zQf/ZAgtOyPFAuMRQXXBwGvOD1FH/DO/cXRKQXSUcdSJDwPjg4ztdxsWa1Sp
jSg3bsvFTtRkSO7aOurWCjg8WZs6arv2YT80Kp7tB9rQ8YxxIXF7SVnt2L9KaxQS
KFgSUEC5liQt1VYTQtXTkf3fKkMpA+wi14jjuuOWWDD1dSDFVx/vYyMmC9z+/pDm
VzBVRxngUzjf1EgPHP8P9qOj4SOfOXbwLhN65A3TaxRJBQLZwqaqGWVF911Uwizi
x4YDkFnLqnMGJXQOfiZZjK9H92cpyKuwaaiMhfGEDnHgvDM/0x3idvqUN96nHUIv
m6xh2ULrXchDJVHHwbFRcUbM5IyKxA==
=cWlk
-----END PGP SIGNATURE-----

--txnwk44n5fupu5xm--
