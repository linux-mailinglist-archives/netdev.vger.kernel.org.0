Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E16660B7B0
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiJXTai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiJXT2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:28:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27A9A59AF
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:00:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1omyGL-00058R-To; Mon, 24 Oct 2022 16:17:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:1bbf:91f6:fcf3:6f78])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id D732E1089C1;
        Mon, 24 Oct 2022 14:17:07 +0000 (UTC)
Date:   Mon, 24 Oct 2022 16:16:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Rob Herring <robh@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 0/3] R-Car CANFD fixes
Message-ID: <20221024141659.62rtawuce7mczbt2@pengutronix.de>
References: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qb5jtsrmrf5tic7f"
Content-Disposition: inline
In-Reply-To: <20221022081503.1051257-1-biju.das.jz@bp.renesas.com>
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


--qb5jtsrmrf5tic7f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.10.2022 09:15:00, Biju Das wrote:
> This patch series fixes the below issues in R-Car CAN FD driver.
>=20
>  1) Race condition in CAN driver under heavy CAN load condition
>     with both channels enabled results in IRQ stom on global fifo
                                                ^^^^ typo
>     receive irq line.
>  2) Add channel specific tx interrupts handling for RZ/G2L SoC as it has
>     separate IRQ lines for each tx.
>  3) Remove unnecessary SoC specific checks in probe.

Fixed typo while applying.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qb5jtsrmrf5tic7f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNWnlgACgkQrX5LkNig
013+yQf/Z095gwUkiZoaqt0KdEx/ukxJmGdZh13W3abgRyYtlESSzC4PAozPyK9/
CZDCmXi1N3QtMAiuma1sYDDDSNynCbTNV2lSO807ghQ4J2mGOwX1sBVezlNR4H3b
834fC5y2pATiLJDGs0uj0Z/Ae919+cSqId8BYJVSqAPtWabpDsdAT9+aCuRQBe4X
EixLG11stSKN5AM7F2bBS/R3ir5INdnZ7itVa7SQQT3H3bbYAah5G9CnBukXNUSS
aQXA/Mkgxlyn8xGq+x9DwsjATyYqyvuVhztvnEPphBPB12ScxfFO1GRoLX7DwTDx
hRcvV1Gahs6N+q3/EW8DdLR2uodCLQ==
=XC8V
-----END PGP SIGNATURE-----

--qb5jtsrmrf5tic7f--
