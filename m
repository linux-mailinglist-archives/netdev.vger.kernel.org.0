Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D8853D6D7
	for <lists+netdev@lfdr.de>; Sat,  4 Jun 2022 14:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245567AbiFDMnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 08:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245403AbiFDMnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 08:43:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BB133A0B
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 05:43:12 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxT7R-0008Cq-IP; Sat, 04 Jun 2022 14:43:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AED6B8C339;
        Sat,  4 Jun 2022 12:43:04 +0000 (UTC)
Date:   Sat, 4 Jun 2022 14:43:04 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/7] can: Kconfig: turn menu "CAN Device Drivers" into
 a menuconfig using CAN_DEV
Message-ID: <20220604124304.ds5eyjnxxvcl543l@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-3-mailhol.vincent@wanadoo.fr>
 <20220604112707.z4zjdjydqy5rkyfe@pengutronix.de>
 <CAMZ6RqLRf=oyo0HXDSBAMD=Ce-RxtgO=TrhT5Xf1sqR6jWDoCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kiq4zve2baid4qzh"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLRf=oyo0HXDSBAMD=Ce-RxtgO=TrhT5Xf1sqR6jWDoCQ@mail.gmail.com>
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


--kiq4zve2baid4qzh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2022 21:30:57, Vincent MAILHOL wrote:
> > > diff --git a/drivers/net/can/dev/Makefile b/drivers/net/can/dev/Makef=
ile
> > > index 5b4c813c6222..919f87e36eed 100644
> > > --- a/drivers/net/can/dev/Makefile
> > > +++ b/drivers/net/can/dev/Makefile
> > > @@ -1,9 +1,11 @@
> > >  # SPDX-License-Identifier: GPL-2.0
> > >
> > > -obj-$(CONFIG_CAN_NETLINK) +=3D can-dev.o
> > > +obj-$(CONFIG_CAN_DEV) +=3D can-dev.o
> >        ^^^^^^^^^^^^^^^^^^^^^
> >
> > Nitpick: I think you can directly use "y" here.
>=20
> I see. So the idea would be that if we deselect CONFIG_CAN_DEV, then
> despite of can-dev.o being always "yes", it would be empty and thus
> ignored.

ACK

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kiq4zve2baid4qzh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKbU1UACgkQrX5LkNig
012j/gf9H0jLCIOgNudqg9EpeJUg9kt6kqe7g1xpRxAmbPs8FgERZXZrf4cvRKao
cYepV5pZX9vy4+sH/EoAjzmJLz9Z5Undty0301Ejetfjqv5C6C7h2vVOpBism5t5
ZvTneDkQaGdL3roPHEvrgPUhprfhMP7VqMx7uRTGBykBmdvko6xWiXDm8U97MbML
+dfSfFdxC/pI7RBnebeLSiiq3GAOr5ueXpqBBjtkjQFzweHhsLDRnoOsolUMqwkW
sWFC4I7UIds8iUyJRb2eM0uOvyMEVmuo/x4SKr0jLCpwcBOaUwRPYoMeEdpmUvaM
a5r5QbscSEDe4v6gnp8KCZzLwjiTew==
=Mc5r
-----END PGP SIGNATURE-----

--kiq4zve2baid4qzh--
