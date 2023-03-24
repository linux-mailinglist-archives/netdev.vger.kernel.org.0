Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605896C8231
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbjCXQNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbjCXQNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:13:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077B8196AD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 09:13:48 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pfk2j-0006RS-R7; Fri, 24 Mar 2023 17:13:29 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6AD9119BA18;
        Fri, 24 Mar 2023 16:13:21 +0000 (UTC)
Date:   Fri, 24 Mar 2023 17:13:20 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     "Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
        wg@grandegger.com, michal.swiatkowski@linux.intel.com,
        Steen.Hegelund@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        frank.jungclaus@esd.eu, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        hpeter+linux_kernel@gmail.com
Subject: Re: [PATCH V2] can: usb: f81604: add Fintek F81604 support
Message-ID: <20230324161320.jutuyor7jrbqu37p@pengutronix.de>
References: <20230321081152.26510-1-peter_hong@fintek.com.tw>
 <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ul6oruy6cmrmas5h"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJWg1H6Yo3nhsa-Kk-WdU=ZH39ecWaE6wiuKRJe1gLMkQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ul6oruy6cmrmas5h
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.03.2023 00:50:20, Vincent MAILHOL wrote:
> Hi Peter,
>=20
> Welcome to the linux-can mailing list.
> This is my first review, I will wait for the next version to give a
> more thorough look.
>=20
> On Tue. 21 Mar 2023 at 17:14, Ji-Ze Hong (Peter Hong)
> <peter_hong@fintek.com.tw> wrote:
>=20
> From your email header:
> > Content-Type: text/plain; charset=3D"y"
>=20
> It gives me below error when applying:
>=20
>   $ wget -o f81604.patch
> https://lore.kernel.org/linux-can/20230321081152.26510-1-peter_hong@finte=
k.com.tw/raw
>   $ git am f81604.patch
>   error : cannot convert from y to UTF-8
>   fatal : could not parse patch

I'm using b4 [1] for this:

$ b4 shazam -l -s 20230321081152.26510-1-peter_hong@fintek.com.tw

and it works.

Marc

[1] https://github.com/mricon/b4

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ul6oruy6cmrmas5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQdzB0ACgkQvlAcSiqK
BOhOLwf+IA/6cxPWXp0P3mZ8oxuZk5hBKe0zEC4xRcOqLECtcb98HHwDN8aSPO/h
KwTSer7luMLSI1XOp7Z5xzI4unZIFcoJs+8ARJ1qSZU8BpxJk3wWkgNQKs4Uof1b
whX5N+0pl+dgZE5KujUiC01shK7kJs52a/JvEIZVgL2KHVYv8jiHbrhcpM1gD/FO
06jhufbklHOMDVBoNsi2CqWU915diRGYtT4DRJVQgm0yuNfcNbdUXf/H/grwtmoU
bHcFlLs1sMiJo/SnuTPFa8YmK0T0v1XUwtCM/fYRaGiulC6BjggaU7Ck9extZiZt
d3kIeCl5NjpTgYGhOkrhT1V+b+/dIA==
=kfUO
-----END PGP SIGNATURE-----

--ul6oruy6cmrmas5h--
