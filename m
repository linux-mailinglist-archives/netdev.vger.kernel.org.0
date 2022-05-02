Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD451770B
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 21:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387004AbiEBTD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 15:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387005AbiEBTD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 15:03:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CA4654C
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:59:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlbGg-0002Y4-To; Mon, 02 May 2022 20:59:34 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C6DE8736FE;
        Mon,  2 May 2022 18:59:30 +0000 (UTC)
Date:   Mon, 2 May 2022 20:59:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>, netdev@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Biju Das <biju.das@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL
 support
Message-ID: <20220502185929.hgjuitw4mnu4ye3c@pengutronix.de>
References: <20220423130743.123198-1-biju.das.jz@bp.renesas.com>
 <YnAlVQr1A6UU0tB3@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vz3iylc7uzhlbnhj"
Content-Disposition: inline
In-Reply-To: <YnAlVQr1A6UU0tB3@robh.at.kernel.org>
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


--vz3iylc7uzhlbnhj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.05.2022 13:39:17, Rob Herring wrote:
> On Sat, 23 Apr 2022 14:07:43 +0100, Biju Das wrote:
> > Add CANFD binding documentation for Renesas R9A07G043 (RZ/G2UL) SoC.
> >=20
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> >  .../devicetree/bindings/net/can/renesas,rcar-canfd.yaml          | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
>=20
> Applied, thanks!

That just got into net-next/master as
| 35a78bf20033 dt-bindings: can: renesas,rcar-canfd: Document RZ/G2UL suppo=
rt

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--vz3iylc7uzhlbnhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJwKg8ACgkQrX5LkNig
012yfwf+Id2UNwmrDlurQlemVLbxIRUY+mkcOs73m7ATG33wKOTEqlEVX39qip4O
vTKXP649wTWkWVSomhy01bziXcB9ut3VEsEYIVK9qR1gMctUYdJfyG/D3rk/NFKN
5dc1JkS6UJu6KKuFY2sB+5/uDYOD24cWPSqoe9OvQ+tysQSfTcNaU0ft/QckBjbz
aX7M7TeLb/lywnXhTcptKw6a5Qz+zIbM3qQPfbM9ABCnrpT+kWAE6eiFAX0VhKbt
yXtzkK4/gmmEH8gQqsly0O3s3Tfx6P+lZ1KmYmK4vFsAzNIZEZ2y+DuAlIji/uXA
Gd8Z++lW9XP8/t2NDNWq9dwX1woD0g==
=nF1c
-----END PGP SIGNATURE-----

--vz3iylc7uzhlbnhj--
