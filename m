Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3950955CC4F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiF0HaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbiF0HaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:30:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFD15FDD
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:30:14 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o5jC8-00015W-8m; Mon, 27 Jun 2022 09:30:04 +0200
Received: from pengutronix.de (p200300ea0f229100c1f120485ffcf4df.dip0.t-ipconnect.de [IPv6:2003:ea:f22:9100:c1f1:2048:5ffc:f4df])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 76C6E9FFA7;
        Mon, 27 Jun 2022 07:30:02 +0000 (UTC)
Date:   Mon, 27 Jun 2022 09:30:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Conor.Dooley@microchip.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN
 controllers
Message-ID: <20220627073001.2l6twpyt7fg252ul@pengutronix.de>
References: <20220625120335.324697-1-mkl@pengutronix.de>
 <20220625120335.324697-17-mkl@pengutronix.de>
 <ff40e50f-728d-dba3-6aa2-59db573d6f76@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kpnrfd4a6r3wvuen"
Content-Disposition: inline
In-Reply-To: <ff40e50f-728d-dba3-6aa2-59db573d6f76@microchip.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kpnrfd4a6r3wvuen
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.06.2022 07:12:47, Conor.Dooley@microchip.com wrote:
> On 25/06/2022 13:03, Marc Kleine-Budde wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know =
the content is safe
> >=20
> > From: Conor Dooley <conor.dooley@microchip.com>
> >=20
> > PolarFire SoC has a pair of CAN controllers, but as they were
> > undocumented there were omitted from the device tree. Add them.
> >=20
> > Link: https://lore.kernel.org/all/20220607065459.2035746-3-conor.dooley=
@microchip.com
> > Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>=20
> Hey Marc,
> Not entirely familiar with the process here.
> Do I apply this patch when the rest of the series gets taken,
> or will this patch go through the net tree?

Both patches:

| 38a71fc04895 riscv: dts: microchip: add mpfs's CAN controllers
| c878d518d7b6 dt-bindings: can: mpfs: document the mpfs CAN controller

are on they way to mainline via the net-next tree. No further actions
needed on your side.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kpnrfd4a6r3wvuen
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmK5XHYACgkQrX5LkNig
0125+Af/dpJV9jmeV+bmQvtsU1t/ZNy3Zu8qWv+uG98YM+4fWhGDJL8oNAQ/9QXu
+HtS/rk9YC2rBIbyHLK2m2Jn2x+InMKjP967RGlw6oIofAd03agTDkK6AQLDIy01
TxXulDibc3p9jJf5qyrO1Y/MoFnn5hz9DbZNh8g27tzdC92by1KOYfP+BZplGc/o
MUzbalGMLAQMsnQMAX6vGCKFEEE1BZxFsbH9VtNPJHO3hbymr6JFyI8x5pn6G+LO
0Xw/FKc3v2/GU9M28kE/w0zuF5AED+wczo+WQ+E6DHrAaN1eXSroa+/+qUL/7uVA
dNZtx9YS1nKmksqGTL/bPY9O8Pr+aw==
=XKUC
-----END PGP SIGNATURE-----

--kpnrfd4a6r3wvuen--
