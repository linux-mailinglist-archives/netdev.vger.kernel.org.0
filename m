Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75E2564156
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiGBQOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 12:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiGBQOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 12:14:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F0DE0EC
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 09:14:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o7fkx-0003BA-8Q; Sat, 02 Jul 2022 18:14:03 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 867A6A5969;
        Sat,  2 Jul 2022 16:14:00 +0000 (UTC)
Date:   Sat, 2 Jul 2022 18:13:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 0/6] Add support for RZ/N1 SJA1000 CAN controller
Message-ID: <20220702161359.dy64er2lkrueyzh7@pengutronix.de>
References: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e5v2drfk7z245owm"
Content-Disposition: inline
In-Reply-To: <20220702140130.218409-1-biju.das.jz@bp.renesas.com>
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


--e5v2drfk7z245owm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 02.07.2022 15:01:24, Biju Das wrote:
> This patch series aims to add support for RZ/N1 SJA1000 CAN controller.
>=20
> The SJA1000 CAN controller on RZ/N1 SoC has some differences compared
> to others like it has no clock divider register (CDR) support and it has
> no HW loopback(HW doesn't see tx messages on rx), so introduced a new
               ^^^

please add a space here.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--e5v2drfk7z245owm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLAbsUACgkQrX5LkNig
010y/gf+IQzZgWL7TmLZ7VFp6MGb1/3J4o98S3yKAz/q1z6YhKMuIr7dyEjTwZ4R
DAs1ggOpAMO5sr8d9v1Vviq9tWVaS4dkEtde30FSkcjlqoAx3GUKH9cWlAibvpau
dlHMTcxyUiLl4CC7q3S5H863X9HjYrUGJTwnEYgKXh+X7tJm0IlPVrZugCodb/5o
WwrNa+3P/bzcKTPR1CAKxE9FWBQLDcQKMQ3b95m2KnTQ0dDpP4MRvD7tzeMQI76k
rxbgo2tgEs1K7qFIPsbgyyd10Dk/7wNv8t7Ao898z+zmA2a6dZPitYIsmoiYmeVp
s13YQx6+JgwFZTB/O9NV+47ugf9TvQ==
=Be/H
-----END PGP SIGNATURE-----

--e5v2drfk7z245owm--
