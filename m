Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67C1571A98
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiGLM4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 08:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGLM4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 08:56:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4CEA5E73
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 05:56:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oBFRC-0000dr-U7; Tue, 12 Jul 2022 14:56:26 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-2099-0011-e8c0-354d.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:2099:11:e8c0:354d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E8992AF0CC;
        Tue, 12 Jul 2022 12:56:23 +0000 (UTC)
Date:   Tue, 12 Jul 2022 14:56:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Message-ID: <20220712125623.cjjqvyqdv3jyzinh@pengutronix.de>
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-7-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="weudbjljffyd7qen"
Content-Disposition: inline
In-Reply-To: <20220710115248.190280-7-biju.das.jz@bp.renesas.com>
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


--weudbjljffyd7qen
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.07.2022 12:52:48, Biju Das wrote:
> The SJA1000 CAN controller on RZ/N1 SoC has no clock divider register
> (CDR) support compared to others.
>=20
> This patch adds support for RZ/N1 SJA1000 CAN Controller, by adding
> SoC specific compatible to handle this difference as well as using
> clk framework to retrieve the CAN clock frequency.
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
> v3->v4:
>  * Updated commit description.
>  * Updated clock handling as per bindings.
> v2->v3:
>  * No change.
> v1->v2:
>  * Updated commit description as SJA1000_NO_HW_LOOPBACK_QUIRK is removed
>  * Added error handling on clk error path
>  * Started using "devm_clk_get_optional_enabled" for clk get,prepare and =
enable.

Due to the use of the devm_clk_get_optional_enabled(), this patch has to
wait until devm_clk_get_optional_enabled() hits net-next/master, which
will be probably for the v5.21 merge window.

We either have to wait or you have to manually enable and disable the
clock.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--weudbjljffyd7qen
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLNb3QACgkQrX5LkNig
010tAgf/Ro9pFkMUc+6B+7f/KlfJ/6agkecuieMn1TH2Nw4JiT4E9EplhLB04oNM
lizzeZIDcWrXt2zPaZzI9GBz9yMChCm2gU9FM4phNTpaNEp/vLDnuSpaTnC7bSfa
vhxrIlo83ZBfuS2ctZOEF+M+ElhdZ2spJkAsDsHFm5qvnfxHNIk/4WgBaDLRkDaM
FAyaFwxmB1tPEBsOxtS3nuHBwDkuTmsf/QhpzT8S0o/slWqsHfdZA3nrnI1DWocz
SlakWX7tMXOnSlqbmw0kAU8WJmmQ/PgOtp+vwKzX5vNCmCSfNCVbWKPn7QOPbPyL
u6gDGD4np1pz2UowD0acmQ/AyaEbTA==
=xhvI
-----END PGP SIGNATURE-----

--weudbjljffyd7qen--
