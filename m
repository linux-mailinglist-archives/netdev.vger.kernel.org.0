Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163F463ECEA
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiLAJvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLAJvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:51:31 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E6545436F
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:51:29 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p0gDp-0001Zy-PO; Thu, 01 Dec 2022 10:51:13 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:dc5e:59bf:44a8:4077])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1E96512F41D;
        Thu,  1 Dec 2022 09:51:10 +0000 (UTC)
Date:   Thu, 1 Dec 2022 10:51:08 +0100
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
Message-ID: <20221201095108.4q3frhsktsbvw7at@pengutronix.de>
References: <20221129031406.3849872-1-mailhol.vincent@wanadoo.fr>
 <Y4XCnAA2hGvqgXh0@nanopsycho>
 <CAMZ6RqJ54rfLfODB1JNaFr_pxWxzHJBoC2UmCKAZ7mSkEbcdzQ@mail.gmail.com>
 <20221130170351.cjyaqr22vhqzq4hv@pengutronix.de>
 <CAMZ6RqLy_H-A-=_jgPh6dUdHa_wMLB20X0rCFY7vkgBwvS1Uyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ymtbgkasf62ps6zq"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLy_H-A-=_jgPh6dUdHa_wMLB20X0rCFY7vkgBwvS1Uyg@mail.gmail.com>
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


--ymtbgkasf62ps6zq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 02:52:17, Vincent MAILHOL wrote:
> > > I will use it in this series for the linux-can tree:
> > > https://lore.kernel.org/netdev/20221126162211.93322-4-mailhol.vincent=
@wanadoo.fr/
> > >
> > > If it is a problem to send this as a standalone patch, I will then
> > > just add it to my series and have the patch go through the linux-can
> > > tree.
> >
> > As you have the Ok from Greg, include this in you v5 series.
>=20
> This is a different patch. Greg gave me his ACK to export usb_cache_strin=
g():
>   https://lore.kernel.org/linux-usb/Y3zyCz5HbGdsxmRT@kroah.com/

Right, thanks for the clarification. - Too many patches :)

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ymtbgkasf62ps6zq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOIeQkACgkQrX5LkNig
011mWwf9ECdOBcKUiwp2BsQhmB7fN/5C7S4dIfJPQ5DzDvUT3dg3CGPo2RjP64Jr
kV4GGX612N48tlHfmY683OthL3t5GrbJl2HU2jHLPEjC2UUv7ci+VlP8DrGYB6th
DnEzHEB+0KSsGuZyw64DnONZbTpTlwW0DlqFaKlbGTuFJXwwXfJ4sVSCBUD60vtZ
eIPv7kRBMqoe2DpOP+Cm8TKFR3MbIjIr43bFcfJv+wFHp73GxjoqgVq/WKMfiaZo
NupBpVcd+bGSEel+6aojv0kvQ2Oi5dNmuSyNI3HHpWeZHffF5eRd+xJBDjy2rkmO
P77W0AamMH5PMlny+N/89kaBmmTUYA==
=E7Aa
-----END PGP SIGNATURE-----

--ymtbgkasf62ps6zq--
