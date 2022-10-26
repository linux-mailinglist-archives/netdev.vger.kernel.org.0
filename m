Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CB560DC56
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiJZHla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233259AbiJZHlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:41:23 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427999E2E2
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:41:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onb28-00078a-0O; Wed, 26 Oct 2022 09:41:04 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 70B9B109F9D;
        Wed, 26 Oct 2022 07:41:02 +0000 (UTC)
Date:   Wed, 26 Oct 2022 09:41:00 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 3/3] can: rcar_canfd: Use
 devm_reset_control_get_optional_exclusive
Message-ID: <20221026074100.2nwc7u7soekbfb3l@pengutronix.de>
References: <20221025155657.1426948-1-biju.das.jz@bp.renesas.com>
 <20221025155657.1426948-4-biju.das.jz@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="e6qkpbpfo3v5e2nv"
Content-Disposition: inline
In-Reply-To: <20221025155657.1426948-4-biju.das.jz@bp.renesas.com>
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


--e6qkpbpfo3v5e2nv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.10.2022 16:56:57, Biju Das wrote:
> Replace devm_reset_control_get_exclusive->devm_reset_control_
> get_optional_exclusive so that we can avoid unnecessary
> SoC specific check in probe().
>=20
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>

Applied this patch to linux-can-next/main only. The other will go into
can/main after final review.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--e6qkpbpfo3v5e2nv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNY5IkACgkQrX5LkNig
011zOQf+MSXg1I4BS0paFUNv/096tRBixT1Ish7T9sGh2vspiaXgfRVhHTtzAmXh
2YEf9OpAqSdN9K2mbM3q1GEjSZ6j8HbGtZ2ItV5+Kok8c0vzYt4YtHWykmvAEp/0
F7zmupQE4A5fgPE1dxRmh6l5o2OEanLAuVy9TN18XM8hfuic3H6fAt/F0H4iu+HH
7I8vDjNPm6YLk2hBBGXosPGIa6iD574WNx52/ZK66xngrbrUqpf3q/l5YXgbNc3x
Sun8eO6hOiofx/5yvyAjsxJnNfMAsoXL1M156NDsDKYJJkdPGhxOBSIosUHhmbjL
5oFSDy1L1MXo221IhXuU0eqMJ9Avxw==
=LwaK
-----END PGP SIGNATURE-----

--e6qkpbpfo3v5e2nv--
