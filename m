Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E9D517687
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386841AbiEBSan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244630AbiEBSam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:30:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBB765F5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:27:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nlal8-0007de-Dc; Mon, 02 May 2022 20:26:58 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2C39D736B9;
        Mon,  2 May 2022 18:26:40 +0000 (UTC)
Date:   Mon, 2 May 2022 20:26:35 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 0/2] dt-bindings: can: renesas,rcar-canfd: Make
 interrupt-names required
Message-ID: <20220502182635.2ntwjifykmyzbjgx@pengutronix.de>
References: <cover.1651512451.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jffgi6vo3uhzqvde"
Content-Disposition: inline
In-Reply-To: <cover.1651512451.git.geert+renesas@glider.be>
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


--jffgi6vo3uhzqvde
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.05.2022 19:33:51, Geert Uytterhoeven wrote:
> 	Hi all,
>=20
> The Renesas R-Car CAN FD Controller always uses two or more interrupts.
> Hence it makes sense to make the interrupt-names property a required
> property, to make it easier to identify the individual interrupts, and
> validate the mapping.
>=20
>   - The first patch updates the various R-Car Gen3 and RZ/G2 DTS files
>     to add interrupt-names properties, and is intended for the
>     renesas-devel tree,
>   - The second patch updates the CAN-FD DT bindings to mark the
>     interrupt-names property required, and is intended for the DT or net
>     tree.
>=20
> Thanks!

LGTM. Who takes this series?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--jffgi6vo3uhzqvde
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJwIlgACgkQrX5LkNig
011lfwf/fCGxFOEtPnRjGxlwBS2xd5xFsE3Cul/MniMDUFUpTn+ICLBF/3Ti8PY9
OWQpsCwY761/qwf0dFNDhlfHM6Ed3tIzyhfFEB+o3oj+CDHPS4nbhKG5ivyRtDzF
XF1jhGMhXOR5Fn53cyz4ylI4QeDAB3XXTaBnfqguoYbDT2rp1l9QrXwHwvFWV1Hz
ZBeaoN+mba0YOizYhzok6iun3Ggi0RhckEOlv91ZEyQ3L0v25niXGGQBrk2DqP1F
hq8elNDCxYYV81qBFvPu+x08Y6XdLeRY10l64D2FRjeAxLCzo7G4S+3KJN/ruRc2
Y0OxdRx5Fov5MWXa0rCAH9Hl+sblmg==
=LG84
-----END PGP SIGNATURE-----

--jffgi6vo3uhzqvde--
