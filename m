Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3560660D2B6
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiJYRpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 13:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiJYRpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 13:45:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25EA09AC33
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:45:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onNyj-00083L-TA; Tue, 25 Oct 2022 19:44:41 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F10BF109A5E;
        Tue, 25 Oct 2022 17:44:37 +0000 (UTC)
Date:   Tue, 25 Oct 2022 19:44:34 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: RE: [PATCH 1/3] can: rcar_canfd: Fix IRQ storm on global fifo
 receive
Message-ID: <20221025174434.cjrbpobb7st2hn5c@pengutronix.de>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
 <20221022081503.1051257-2-biju.das.jz@bp.renesas.com>
 <20221024153726.72avg6xbgzwyboms@pengutronix.de>
 <20221024155342.bz2opygr62253646@pengutronix.de>
 <OS0PR01MB5922B66F44AEF91CDCED8374862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <20221024180708.5zfti5whtpfowk5c@pengutronix.de>
 <OS0PR01MB59224B2AE8F84B961D2A061C862E9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB59221FB0C29220B7D4794CEE86319@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="prc4fzu7ja2ebda3"
Content-Disposition: inline
In-Reply-To: <OS0PR01MB59221FB0C29220B7D4794CEE86319@OS0PR01MB5922.jpnprd01.prod.outlook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--prc4fzu7ja2ebda3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2022 15:50:18, Biju Das wrote:
[...]
> > > index 567620d215f8..ea828c1bd3a1 100644
> > > --- a/drivers/net/can/rcar/rcar_canfd.c
> > > +++ b/drivers/net/can/rcar/rcar_canfd.c
> > > @@ -1157,11 +1157,13 @@ static void
> > > rcar_canfd_handle_global_receive(struct rcar_canfd_global *gpriv, u3
> > {
> > >         struct rcar_canfd_channel *priv =3D gpriv->ch[ch];
> > >         u32 ridx =3D ch + RCANFD_RFFIFO_IDX;
> > > -       u32 sts;
> > > +       u32 sts, cc;
> > >
> > >         /* Handle Rx interrupts */
> > >         sts =3D rcar_canfd_read(priv->base, RCANFD_RFSTS(gpriv,
> > ridx));
> > > -       if (likely(sts & RCANFD_RFSTS_RFIF)) {
> > > +       cc =3D rcar_canfd_read(priv->base, RCANFD_RFCC(gpriv, ridx));
> > > +       if (likely(sts & RCANFD_RFSTS_RFIF &&
> > > +                  cc & RCANFD_RFCC_RFIE)) {
> > >                 if (napi_schedule_prep(&priv->napi)) {
> > >                         /* Disable Rx FIFO interrupts */
> > >                         rcar_canfd_clear_bit(priv->base,
> > >
> > > Please check if that fixes your issue.
>=20
> Yes, it fixes the issue.

\o/

> I will send V2 with these changes.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--prc4fzu7ja2ebda3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNYIH8ACgkQrX5LkNig
010RKAf+KeLuPIN7xWZc3tQ1/T35iryOK1o5Kg3Mb29xS8YjtIoo8XEhihEhG/Hn
09lNw6nIe+U9Fde7/BvKRM7sc4bmVSrge0lr/KoKtXeodYq2tvUvkvs9cUzBkdoT
3/BJZy2qE4fr+hn5qlCth4BDVQbeTg0Xj6otsQq5w/fFrLXL5oxI32KWiFcfqcyz
wHdVoqO5SxJsVwXlNkWGu4TXT2V3CzSho7z5D2uxJ6b2ZOG0PLdsAro4qtO10C1/
L1dbzjPAG1sH/STOfQ+xpoMdkMBAIf78rEkYEtWeeX8UR0xdfNsQIhQHiBhG0fbq
ULlm08dMCXaghL604CraXA2+Kekgbw==
=KNOj
-----END PGP SIGNATURE-----

--prc4fzu7ja2ebda3--
