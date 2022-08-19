Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43AE75997D9
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 10:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347763AbiHSIp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 04:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347736AbiHSIpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 04:45:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFBEC59DC
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:45:52 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oOxdJ-0008I8-6U; Fri, 19 Aug 2022 10:45:37 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1011CCE430;
        Fri, 19 Aug 2022 08:45:34 +0000 (UTC)
Date:   Fri, 19 Aug 2022 10:45:32 +0200
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
Message-ID: <20220819084532.ywtziogd7ycuozxx@pengutronix.de>
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-7-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7mbwvgyie7jnnaxh"
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


--7mbwvgyie7jnnaxh
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

Applied to linux-can-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7mbwvgyie7jnnaxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmL/TaoACgkQrX5LkNig
011BIwgApYLVtfJ7eiu/fg+tUiaoLoOjp/ZoG16KUJaoEsC5EDCnzR/rmlBFXK2k
sy9g8X7jvgqA5KgHz+vWJFVYPHkxehpOpqw+h9bp5K81lXn4iZIL3XAjEfxoOqFa
YUdYHhkZBsZ8iYuk/P7EL4WBGm2W/y4RNKmPg6QNVdhN2cU7dw++HuLVOpmjDmes
AjJBlpz8hj6VrDBoaGT/GHO7nAKRRAvRagucMRJd03ZP7JnxTDf+T+Bp1JkUbK/z
7M8R1IVGCQfrw713DwBSl7V8UZIPISQiff+FSlZiq4bouXEEWv5ZcGokf0rnVdC/
nBK/IpBFB0K3vTPzC8Q1AnKBmDi1bQ==
=Plk0
-----END PGP SIGNATURE-----

--7mbwvgyie7jnnaxh--
