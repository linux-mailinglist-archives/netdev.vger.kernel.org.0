Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C4F51976D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 08:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344991AbiEDGiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 02:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344979AbiEDGiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 02:38:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FC010FF7
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 23:34:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nm8aO-0007Ou-Jp; Wed, 04 May 2022 08:34:08 +0200
Received: from pengutronix.de (unknown [IPv6:2a00:20:7058:1382:cdf5:b54c:dde5:a5a5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9022575640;
        Wed,  4 May 2022 06:34:03 +0000 (UTC)
Date:   Wed, 4 May 2022 08:34:02 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-can@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>, Pavel Machek <pavel@ucw.cz>,
        Drew Fustini <pdp7pdp7@gmail.com>
Subject: Re: [PATCH v8 5/7] can: ctucanfd: CTU CAN FD open-source IP core -
 platform/SoC support.
Message-ID: <20220504063402.deowqy5lnmgg2mfy@pengutronix.de>
References: <cover.1647904780.git.pisa@cmp.felk.cvut.cz>
 <4d5c53499bafe7717815f948801bd5aedaa05c12.1647904780.git.pisa@cmp.felk.cvut.cz>
 <CAMuHMdXY_sHw4W8_y+r1LMhGM+CF7RQtRFQzEC8wYKYSR98Daw@mail.gmail.com>
 <202205031707.21405.pisa@cmp.felk.cvut.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mnhfuo3af4c2bg3a"
Content-Disposition: inline
In-Reply-To: <202205031707.21405.pisa@cmp.felk.cvut.cz>
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


--mnhfuo3af4c2bg3a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.05.2022 17:07:21, Pavel Pisa wrote:
> Hello Geert,
>=20
> On Tuesday 03 of May 2022 13:37:46 Geert Uytterhoeven wrote:
> > Hi Pavel,
> > > --- /dev/null
> > > +++ b/drivers/net/can/ctucanfd/ctucanfd_platform.c
> > >
> > > +/* Match table for OF platform binding */
> > > +static const struct of_device_id ctucan_of_match[] =3D {
> > > +       { .compatible =3D "ctu,ctucanfd-2", },
> >
> > Do you need to match on the above compatible value?
> > The driver seems to treat the hardware the same, and the DT
> > bindings state the compatible value below should always be present.
>=20
> I would keep it because there will be newer revisions and releases
> of the core and I consider "ctu,ctucanfd" as the match to generic
> one with maximal attempt to adjust to the version from provided
> info registers but identification with the fixed version
> "ctu,ctucanfd-2" ensures that some old hardware which is
> in the wild is directly recognized even at /sys level
> and if we need to do some workarounds for autodetection
> etc. it can be recognized.

As Geert said:
- There are 2 bindings in the driver which are (currently) treated the
  same.
- The binding documentation says devices must always have the
  ctu,ctucanfd compatible.

This means (currently) the ctu,ctucanfd-2 is not needed in the driver.
We can add it back once we need it.

Or are there devices that have a compatible of ctu,ctucanfd-2 without
stating to be compatible with ctu,ctucanfd?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mnhfuo3af4c2bg3a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJyHlcACgkQrX5LkNig
0137/wf7Bt5X5J7njOAv8Nj3JgmHyfGQNLtw4QwMPQ8+F3y8I/rihTthe/4ua7sp
pDDRiRFpzJQXgfKv6oE70VLug2RxISnRQ1jW9rNqX2yf0xGn82U2QFG9qjoJEkiG
5lLNpaQG9E+xMO7OcN07MnB5UNnJ568AmhMtUf5JZInvpvzdr85/+1U6bP4Wo87m
IZgjGn9sioBCOvl+13MUEW9YwWQRgS+7snjJ4c4Mnvc1T/no5DbK9nFViNs2Z78X
qD6TwtJ2E/G0KGbtr8wR8+nY3vvlJLOLZHBhecyx1/996NxFe5OQsBDKmbDAG0d3
6P9hP95RDc65hCOLyBX5N+q35qaVkg==
=kcsI
-----END PGP SIGNATURE-----

--mnhfuo3af4c2bg3a--
