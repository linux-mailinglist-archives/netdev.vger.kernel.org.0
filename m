Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9854F1192
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 11:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346412AbiDDJC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 05:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346223AbiDDJC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 05:02:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBFB2A73E
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 02:01:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nbIZz-0000K2-4A; Mon, 04 Apr 2022 11:00:55 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-26f0-2eea-19ae-c646.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:26f0:2eea:19ae:c646])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BA0D6592C0;
        Sun,  3 Apr 2022 10:47:41 +0000 (UTC)
Date:   Sun, 3 Apr 2022 12:47:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH] can: mscan: mpc5xxx_can: Prepare cleanup of powerpc's
 asm/prom.h
Message-ID: <20220403104741.q7tipocsbevxgysj@pengutronix.de>
References: <878888f9057ad2f66ca0621a0007472bf57f3e3d.1648833432.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="knw3u4zwelprxguh"
Content-Disposition: inline
In-Reply-To: <878888f9057ad2f66ca0621a0007472bf57f3e3d.1648833432.git.christophe.leroy@csgroup.eu>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--knw3u4zwelprxguh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.04.2022 19:21:20, Christophe Leroy wrote:
> powerpc's asm/prom.h brings some headers that it doesn't
> need itself.
>=20
> In order to clean it up, first add missing headers in
> users of asm/prom.h
>=20
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>

Added to linux-can-next/testing.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--knw3u4zwelprxguh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmJJe0oACgkQrX5LkNig
012lzwf/Yz+UaYPfBv2dN7kBgYRlV7/S/l4MY3od+KXKQPOkYoXXbu2KnK+E/qsU
I19Dqm9VbvPZzUYMbkBS5cs6rO0mtvLtBnXlSmYQ+MiEsJ9YOExzEzovQqAvPBbo
xX1ahek6ZpfugefWTTZS56BELMeiuo9lC00qucRxsC0UHBzS6/HKTQfS7JanWmX5
mlt+YmHwnCj5IQHj6AvbTsb2VHtyfwFwLKr3CsOZXcLjSPJU5nHYJl400+p5YnKz
/kRVaoXynLiCCYUIUWW3nveWcfab4Wuh+qJq0LUDKF/RtqkGJmnvjc6Gw3v1+ZW4
elOAfCQUIwNVE06Ud9XV9LxG435kwA==
=glTo
-----END PGP SIGNATURE-----

--knw3u4zwelprxguh--
