Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2518D3D4EBE
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 18:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhGYPuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 11:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbhGYPuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 11:50:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3284C061757
        for <netdev@vger.kernel.org>; Sun, 25 Jul 2021 09:30:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7h1V-0007Ue-NA; Sun, 25 Jul 2021 18:30:41 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:4c93:5280:877:c958])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4F3C2657694;
        Sun, 25 Jul 2021 16:30:40 +0000 (UTC)
Date:   Sun, 25 Jul 2021 18:30:39 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, wg@grandegger.com,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Yasushi SHOJI <yashi@spacecubics.com>
Subject: Re: [PATCH] net: can: add missing urb->transfer_dma initialization
Message-ID: <20210725163039.kyugkdmyn5p3o5r2@pengutronix.de>
References: <20210725094246.pkdpvl5aaaftur3a@pengutronix.de>
 <20210725103630.23864-1-paskripkin@gmail.com>
 <CAELBRWKfyOBanMBteO=LpL9R1QMp97zTYtKY689jeR2gDOa_Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6c5tzy4pflvjriu6"
Content-Disposition: inline
In-Reply-To: <CAELBRWKfyOBanMBteO=LpL9R1QMp97zTYtKY689jeR2gDOa_Gw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6c5tzy4pflvjriu6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2021 22:27:37, Yasushi SHOJI wrote:
> Hi Pavel,
>=20
> I've tested this patch on top of v5.14-rc2.  All good.
>=20
> Tested-by: Yasushi SHOJI <yashi@spacecubics.com>
>=20
> Some nitpicks.
>=20
> On Sun, Jul 25, 2021 at 7:36 PM Pavel Skripkin <paskripkin@gmail.com> wro=
te:
> >
> > Yasushi reported, that his Microchip CAN Analyzer stopped working since
> > commit 91c02557174b ("can: mcba_usb: fix memory leak in mcba_usb").
> > The problem was in missing urb->transfer_dma initialization.
> >
> > In my previous patch to this driver I refactored mcba_usb_start() code =
to
> > avoid leaking usb coherent buffers. To achive it, I passed local stack
>=20
> achieve
>=20
> > variable to usb_alloc_coherent() and then saved it to private array to
> > correctly free all coherent buffers on ->close() call. But I forgot to
> > inialize urb->transfer_dma with variable passed to usb_alloc_coherent().
>=20
> initialize

Fixed while applying.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6c5tzy4pflvjriu6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmD9ka0ACgkQqclaivrt
76k0owf8D7/UgJq6FTxUfwa8X6GgsUGtuxduh6myuhV82vfV/Bq9YiGDoyIHp6ho
asnWUi34JmPh3Qxfbmrb3If4GJmCjfENMbxdQCKXYpgPr/ED0b77VBKr/X+FkJN6
VEVpfu/lndw+xtrZE+o7uBM/F1TzAlcyOd8j8zsHrND8aUhnSXc7apxGeFdyYiev
3AjuwNZPn8LyArQVPptlB2uZPhQXzpajEYdxdmEwU5tKbg5td3RbR1iUECgQ8mg7
VbFOTDa2ivDuVyl/zcqg87McltmxfzxsCTxC4oqeatFTjKVPYNWFc6X5adWwQ1+d
noIrZtR34OORwPkE9HUeR5/s6RTpsA==
=tmG8
-----END PGP SIGNATURE-----

--6c5tzy4pflvjriu6--
