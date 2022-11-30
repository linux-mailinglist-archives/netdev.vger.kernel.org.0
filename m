Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7362B63DB99
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiK3RJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiK3RJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:09:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1D2578FC
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:04:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0QV0-0005r7-Bq; Wed, 30 Nov 2022 18:03:54 +0100
Received: from pengutronix.de (unknown [IPv6:2a0a:edc0:0:701:cf48:5678:3bb0:eeda])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1960812E2AE;
        Wed, 30 Nov 2022 17:03:52 +0000 (UTC)
Date:   Wed, 30 Nov 2022 18:03:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        linux-can <linux-can@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: devlink: add
 DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
Message-ID: <20221130170351.cjyaqr22vhqzq4hv@pengutronix.de>
References: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr>
 <Y4XCnAA2hGvqgXh0@nanopsycho>
 <CAMZ6RqJ54rfLfODB1JNaFr_pxWxzHJBoC2UmCKAZ7mSkEbcdzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="obziojiov5xhwwjh"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJ54rfLfODB1JNaFr_pxWxzHJBoC2UmCKAZ7mSkEbcdzQ@mail.gmail.com>
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


--obziojiov5xhwwjh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 29.11.2022 18:28:44, Vincent MAILHOL wrote:
> On Tue. 29 Nov. 2022 at 17:33, Jiri Pirko <jiri@resnulli.us> wrote:
> > Tue, Nov 29, 2022 at 04:14:06AM CET, mailhol.vincent@wanadoo.fr wrote:
> > >As discussed in [1], abbreviating the bootloader to "bl" might not be
> > >well understood. Instead, a bootloader technically being a firmware,
> > >name it "fw.bootloader".
> > >
> > >Add a new macro to devlink.h to formalize this new info attribute name
> > >and update the documentation.
> > >
> > >[1] https://lore.kernel.org/netdev/20221128142723.2f826d20@kernel.org/
> > >
> > >Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > >---
> > >* Changelog *
> > >
> > >v1 -> v2:
> > >
> > >  * update the documentation as well.
> > >  Link: https://lore.kernel.org/netdev/20221129020151.3842613-1-mailho=
l.vincent@wanadoo.fr/
> > >---
> > > Documentation/networking/devlink/devlink-info.rst | 5 +++++
> > > include/net/devlink.h                             | 2 ++
> > > 2 files changed, 7 insertions(+)
> > >
> > >diff --git a/Documentation/networking/devlink/devlink-info.rst b/Docum=
entation/networking/devlink/devlink-info.rst
> > >index 7572bf6de5c1..1242b0e6826b 100644
> > >--- a/Documentation/networking/devlink/devlink-info.rst
> > >+++ b/Documentation/networking/devlink/devlink-info.rst
> > >@@ -198,6 +198,11 @@ fw.bundle_id
> > >
> > > Unique identifier of the entire firmware bundle.
> > >
> > >+fw.bootloader
> > >+-------------
> > >+
> > >+Version of the bootloader.
> > >+
> > > Future work
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > >diff --git a/include/net/devlink.h b/include/net/devlink.h
> > >index 074a79b8933f..2f552b90b5c6 100644
> > >--- a/include/net/devlink.h
> > >+++ b/include/net/devlink.h
> > >@@ -621,6 +621,8 @@ enum devlink_param_generic_id {
> > > #define DEVLINK_INFO_VERSION_GENERIC_FW_ROCE  "fw.roce"
> > > /* Firmware bundle identifier */
> > > #define DEVLINK_INFO_VERSION_GENERIC_FW_BUNDLE_ID     "fw.bundle_id"
> > >+/* Bootloader */
> > >+#define DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER    "fw.bootloader"
> >
> > You add it and don't use it. You should add only what you use.
>=20
> I will use it in this series for the linux-can tree:
> https://lore.kernel.org/netdev/20221126162211.93322-4-mailhol.vincent@wan=
adoo.fr/
>=20
> If it is a problem to send this as a standalone patch, I will then
> just add it to my series and have the patch go through the linux-can
> tree.

As you have the Ok from Greg, include this in you v5 series.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--obziojiov5xhwwjh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOHjPQACgkQrX5LkNig
011yRQf/Z//khRUupApjepNa7hj73LOXKehQrdvABWt+K/GUaMpnRFtDMASWz4ZJ
D9DH4Gk9+dsV6y8/tHnE9VNMYXZCkDqLxqq3INn7b4Th+eyS6Ajfk79k51Iervdv
Q7IgNfeuEV52vnjIUrfGXIpqpV/1Tc83nmyiHM1yuhKPFv88hWAppuzZ53lTZRnE
YHfAL9iy/FaA85w0334LSuIst36Mj2CFtFWc4+ymA0aBwL2t8dbiIQ0dDgYOowep
Rk7NkT0LSsPXNUfm0KYq12z4VYG7lvWAtzWcSHwX0G+axxzWQKGY4lMAd8mBsAoY
+1jDIuaKCXorISuFceKoD2ock+4+jw==
=7wqE
-----END PGP SIGNATURE-----

--obziojiov5xhwwjh--
