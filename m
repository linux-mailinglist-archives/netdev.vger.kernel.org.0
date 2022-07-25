Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FA957FF22
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiGYMlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiGYMlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:41:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3C8D3
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:41:49 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oFxP0-000534-0D; Mon, 25 Jul 2022 14:41:38 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5A7BFB98CE;
        Mon, 25 Jul 2022 12:41:35 +0000 (UTC)
Date:   Mon, 25 Jul 2022 14:41:34 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 6/6] MAINTAINERS: Add maintainer for the slcan driver
Message-ID: <20220725124134.2dhqfjqhv6wmzqb6@pengutronix.de>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
 <20220725065419.3005015-7-dario.binacchi@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zyj3ee4vghl7eput"
Content-Disposition: inline
In-Reply-To: <20220725065419.3005015-7-dario.binacchi@amarulasolutions.com>
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


--zyj3ee4vghl7eput
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.07.2022 08:54:19, Dario Binacchi wrote:
> At the suggestion of its author Oliver Hartkopp ([1]), I take over the
> maintainer-ship and add myself to the authors of the driver.
>=20
> [1] https://marc.info/?l=3Dlinux-can&m=3D165806705927851&w=3D2

Please use the lore.k.o link:
https://lore.kernel.org/all/507b5973-d673-4755-3b64-b41cb9a13b6f@hartkopp.n=
et

Suggested-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--zyj3ee4vghl7eput
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLej3wACgkQrX5LkNig
012koggAnd8VfgVZ76OHV68XceKS7x9Jp/zuXfZK3cxaNywBBRhncO8Q8abTz7JN
Tl4rDmsgwNkRn1hhCVfw9NHggLpzBb1YCkpAUfhyP3zB9p02w4ym+16mVXLFYN8P
NhquMssGyfm/3SrE8kQoOTZ3FHC7F28UYimmttbfIv0k6h/MBHsbLfxCxonvZ14E
5DFoEuKhK+/P+pUhaYesUYIq/Aay0lMZAnudU3JkPIOt4+Ts+XvE74wn9TEi4YQ5
Ev+6SgZhGfq2xz7C0y8w20j02f1Kh9jp8IVPDrQKHPeqszKFxnz+yT06YQhvHS6C
Tf4hTBmyg4degdlE3iywmTlGJYljFw==
=/pKJ
-----END PGP SIGNATURE-----

--zyj3ee4vghl7eput--
