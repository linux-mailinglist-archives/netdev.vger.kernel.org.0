Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C34610E6B
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiJ1KZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbiJ1KZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:25:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1B4E638
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:25:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ooMXu-0002pA-VD; Fri, 28 Oct 2022 12:25:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 71CD310CA55;
        Fri, 28 Oct 2022 10:24:59 +0000 (UTC)
Date:   Fri, 28 Oct 2022 12:24:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     biju.das.jz@bp.renesas.com,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 6/6] can: rcar_canfd: Add has_gerfl_eef to struct
 rcar_canfd_hw_info
Message-ID: <20221028102458.6qcuojc5xk46jbuo@pengutronix.de>
References: <20221027082158.95895-1-biju.das.jz@bp.renesas.com>
 <20221027082158.95895-7-biju.das.jz@bp.renesas.com>
 <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lzkvswxk2o4rmw7l"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXayck0o9=Oc2+X7pDSx=Y+SHHdi3QtmYz+U-rumpc92Q@mail.gmail.com>
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


--lzkvswxk2o4rmw7l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.10.2022 12:12:22, Geert Uytterhoeven wrote:
> Hi Biju,
>=20
> On Thu, Oct 27, 2022 at 10:22 AM Biju Das <biju.das.jz@bp.renesas.com> wr=
ote:
> > R-Car has ECC error flags in global error interrupts whereas it is
> > not available on RZ/G2L.
> >
> > Add has_gerfl_eef to struct rcar_canfd_hw_info so that rcar_canfd_
> > global_error() will process ECC errors only for R-Car.
> >
> > whilst, this patch fixes the below checkpatch warnings
> >   CHECK: Unnecessary parentheses around 'ch =3D=3D 0'
> >   CHECK: Unnecessary parentheses around 'ch =3D=3D 1'
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
>=20
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>=20
> > --- a/drivers/net/can/rcar/rcar_canfd.c
> > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > @@ -955,13 +958,15 @@ static void rcar_canfd_global_error(struct net_de=
vice *ndev)
> >         u32 ridx =3D ch + RCANFD_RFFIFO_IDX;
> >
> >         gerfl =3D rcar_canfd_read(priv->base, RCANFD_GERFL);
> > -       if ((gerfl & RCANFD_GERFL_EEF0) && (ch =3D=3D 0)) {
> > -               netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> > -               stats->tx_dropped++;
> > -       }
> > -       if ((gerfl & RCANFD_GERFL_EEF1) && (ch =3D=3D 1)) {
> > -               netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> > -               stats->tx_dropped++;
> > +       if (gpriv->info->has_gerfl_eef) {
> > +               if ((gerfl & RCANFD_GERFL_EEF0) && ch =3D=3D 0) {
> > +                       netdev_dbg(ndev, "Ch0: ECC Error flag\n");
> > +                       stats->tx_dropped++;
> > +               }
> > +               if ((gerfl & RCANFD_GERFL_EEF1) && ch =3D=3D 1) {
> > +                       netdev_dbg(ndev, "Ch1: ECC Error flag\n");
> > +                       stats->tx_dropped++;
> > +               }
>=20
> BTW, this fails to check the ECC error flags for channels 2-7 on R-Car
> V3U, which is a pre-existing problem.  As that is a bug, I have sent
> a fix[1], which unfortunately conflicts with your patch. Sorry for that.

I'll add Geert's fix to can/main and upstream via net/main. Please
re-spin this series after net/main has been merged to net-next/main.

This way we'll avoid a merge conflict.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--lzkvswxk2o4rmw7l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNbrfgACgkQrX5LkNig
013U5wf/XjunyQiWXDyQwoiVIgePKcZ0DBJxteyGaNgkoTe2/oQbVTiWCJgYYLNu
elyoZQf/+vNW4OXi6HCy+pQgoXIaReeKuWdVrdlKvRRBHqCQD/pG8AnSrGjU1aLY
QPoTyEYk+vCD0xMJIB+XZ2NcTqFCu95cFmXyNyjS5dKy5pvilLYSnSkPaQ60Pema
EDsehFz+wLVG45MbwwRtImIQDd5HhYf7mjeGxAQQtvgG41hY9UTmAiZDRkBCbzLN
RigrLqZOyDTk+mji+Z1Q+xuDhl73ZI5m++otwXTgTxlcv+4E6u8gC1+y1T5jFkvZ
RK89/oE9XT3bGXXaRrfN63kXoJxJVA==
=LNpu
-----END PGP SIGNATURE-----

--lzkvswxk2o4rmw7l--
