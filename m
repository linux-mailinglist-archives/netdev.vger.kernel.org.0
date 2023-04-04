Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166186D65DF
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjDDOyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbjDDOyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:54:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DEC4EFD
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:54:21 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pji2y-0000dG-R9; Tue, 04 Apr 2023 16:54:08 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AB1C11A67EE;
        Tue,  4 Apr 2023 14:54:06 +0000 (UTC)
Date:   Tue, 4 Apr 2023 16:54:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Steen Hegelund <Steen.Hegelund@microchip.com>
Subject: Re: [PATCH net-next 07/10] can: rcar_canfd: ircar_canfd_probe(): fix
 plain integer in transceivers[] init
Message-ID: <20230404-linoleum-economy-2a66d23363f3@pengutronix.de>
References: <20230404113429.1590300-1-mkl@pengutronix.de>
 <20230404113429.1590300-8-mkl@pengutronix.de>
 <CAMuHMdWwLHYsbjvKuJ6M3an0nQWdcd9M8Y8io5wg0fAcgL9XDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gsz5in6zibhvb2ja"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWwLHYsbjvKuJ6M3an0nQWdcd9M8Y8io5wg0fAcgL9XDg@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gsz5in6zibhvb2ja
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.04.2023 15:54:25, Geert Uytterhoeven wrote:
> Hi Marc,
>=20
> On Tue, Apr 4, 2023 at 1:34=E2=80=AFPM Marc Kleine-Budde <mkl@pengutronix=
=2Ede> wrote:
> > From: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Fix the following compile warning with C=3D1:
> >
> > | drivers/net/can/rcar/rcar_canfd.c:1852:59: warning: Using plain integ=
er as NULL pointer
>=20
> s/ircar_canfd_probe/rcar_canfd_probe/ in the patch summary.

Doh! Switching back and forth between editors, I think :)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--gsz5in6zibhvb2ja
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQsOgsACgkQvlAcSiqK
BOi3zggAtjEbWT/nsqCrEcsR2djNggE53uCJifgtdUyDznSt2cw8p+7zK3M6uoV0
bPVqlSFaI88l45kyBcFri01GQkqoJKH6u1xmC8ZmYOuZYHSNWGhhA3TQxaSqvPwX
KyqZ+ZwjsnjgjUxSPqvdHmBKgL9NVsvPs+Q7OJ0kDWvWPpnzeRiOYTYKBSCuWuOR
n8aCmJx8NeLv64bd8K5KrmcP7dSrtLpf1TCAiuDjl+MxbGP7PrUEUU638m0uxGQM
hl2WXVxRkpgDnTZwprcf1bHGQ53kLXpkTTI4VuFD7vOXv/cFCBzy0jiiGkeOw0RA
Xc9gMOnWuN9sfXeqRfcUtM0HqfRF/g==
=mlBr
-----END PGP SIGNATURE-----

--gsz5in6zibhvb2ja--
