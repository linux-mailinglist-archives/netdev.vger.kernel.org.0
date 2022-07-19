Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688BD57A6C7
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 20:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiGSSxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 14:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiGSSxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 14:53:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B319713E03
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 11:53:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oDsLQ-0001Og-H9; Tue, 19 Jul 2022 20:53:20 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 14F57B447C;
        Tue, 19 Jul 2022 18:53:17 +0000 (UTC)
Date:   Tue, 19 Jul 2022 20:53:16 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v4 6/6] can: sja1000: Add support for RZ/N1 SJA1000 CAN
 Controller
Message-ID: <20220719185316.eohz3o7d7fmhk2cb@pengutronix.de>
References: <20220710115248.190280-1-biju.das.jz@bp.renesas.com>
 <20220710115248.190280-7-biju.das.jz@bp.renesas.com>
 <20220712125623.cjjqvyqdv3jyzinh@pengutronix.de>
 <OS0PR01MB5922495C78A7B77874940D2386869@OS0PR01MB5922.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="myrypl4k2z64t64a"
Content-Disposition: inline
In-Reply-To: <OS0PR01MB5922495C78A7B77874940D2386869@OS0PR01MB5922.jpnprd01.prod.outlook.com>
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


--myrypl4k2z64t64a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.07.2022 13:03:49, Biju Das wrote:
> > Due to the use of the devm_clk_get_optional_enabled(), this patch has to
> > wait until devm_clk_get_optional_enabled() hits net-next/master, which
> > will be probably for the v5.21 merge window.
>=20
> OK, will wait for 5.21 merge window, as this driver is the first user for=
 this
> API.

I've applied patches 1...5, please repost patch 6 after
devm_clk_get_optional_enabled() has been merged to linus/master.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--myrypl4k2z64t64a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLW/ZkACgkQrX5LkNig
010+ugf6A1ineyd+BlwRonQnzgScmckQfIv4uzDT7ImE9UY7XPLDcGwFHhWXtMys
AtfSuK8XNm6hsq8eowv/vuMskx/NWmaUVw11gvV0rl4plAGeXxtXTB/oFdTSmkM/
OKu6qGXwdkb1wo1ptuEJ1Psc2cONVuN2XsFdqRnoz/EELKRpSWH+61v8BgBFUXOO
byE+KJIbN0TQnmMUECQU4tpbSt2kWzgfwll8ySsYmwdmYDFZujZMZPH9aeuetsvy
RdgJtsHJxoNxR8lfp76Vdjfce6AyUgK3TX0Q7h9MYRMvtmfEkyrKOneCQ5vRC4ko
gnfiBfGqQpJRQ4jsNm0K9AgRrEraNA==
=L/B6
-----END PGP SIGNATURE-----

--myrypl4k2z64t64a--
