Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D852517F8E
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 10:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbiECIR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 04:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbiECIR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 04:17:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876492127F
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 01:13:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlnf9-0002aG-UZ; Tue, 03 May 2022 10:13:39 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2FA9E749ED;
        Tue,  3 May 2022 08:13:36 +0000 (UTC)
Date:   Tue, 3 May 2022 10:13:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH 0/2] dt-bindings: can: renesas,rcar-canfd: Make
 interrupt-names required
Message-ID: <20220503081335.opely3c2gmhrfqic@pengutronix.de>
References: <cover.1651512451.git.geert+renesas@glider.be>
 <20220502182635.2ntwjifykmyzbjgx@pengutronix.de>
 <CAMuHMdU2RfBUO7SVJ8N2dUVqzvgptLX61UJY5Wdiyobj=rQgJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uxlmfeeoboac3pfs"
Content-Disposition: inline
In-Reply-To: <CAMuHMdU2RfBUO7SVJ8N2dUVqzvgptLX61UJY5Wdiyobj=rQgJw@mail.gmail.com>
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


--uxlmfeeoboac3pfs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.05.2022 09:25:45, Geert Uytterhoeven wrote:
> Hi Marc,
>=20
> On Mon, May 2, 2022 at 8:27 PM Marc Kleine-Budde <mkl@pengutronix.de> wro=
te:
> > On 02.05.2022 19:33:51, Geert Uytterhoeven wrote:
> > > The Renesas R-Car CAN FD Controller always uses two or more interrupt=
s.
> > > Hence it makes sense to make the interrupt-names property a required
> > > property, to make it easier to identify the individual interrupts, and
> > > validate the mapping.
> > >
> > >   - The first patch updates the various R-Car Gen3 and RZ/G2 DTS files
> > >     to add interrupt-names properties, and is intended for the
> > >     renesas-devel tree,
> > >   - The second patch updates the CAN-FD DT bindings to mark the
> > >     interrupt-names property required, and is intended for the DT or =
net
> > >     tree.
> > >
> > > Thanks!
> >
> > LGTM. Who takes this series?
>=20
> I'll take the first patch.
>=20
> The second patch is up to you and the DT maintainers.

Sounds good.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uxlmfeeoboac3pfs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJw5CwACgkQrX5LkNig
012WTAgAqcQ9+pnG2CPLJp4EWZyVr5g4FuCaaukAX99H+VHhFatrxEtj7dkLq9CN
OGoyx/blkxfzxO6HlpKWD7qs4jgAUG5JuZDxinEhoYDUU7fvMFmyvGZI2ZXoKx2Q
UvdygIyw4173BTjp72xIQGMM9S2rhbbSo2+aLl+EkgO4TnSWzJWvFbv7fLOa+lGz
kUctfHsFxAeoW5gNzPKk3YRg8hyLx69EHyjrSeBst84d8vZW3Cenw03YuWx65DoC
cyK3usWCPtkVBTGzmKiYOlGYBvWYh3h2bQpkVkmLU5F+3cLqraxh3rrpB0XjSsg7
PzFmWzzK2JdejS5KrAbXxyZfl00EGg==
=70Nk
-----END PGP SIGNATURE-----

--uxlmfeeoboac3pfs--
