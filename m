Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC71581282
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238930AbiGZL7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238918AbiGZL7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:59:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA0F3335A
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:59:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGJD6-0001C9-Dj; Tue, 26 Jul 2022 13:58:48 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B7658BAB69;
        Tue, 26 Jul 2022 11:58:45 +0000 (UTC)
Date:   Tue, 26 Jul 2022 13:58:45 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Max Staudt <max@enpas.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/6] can: slcan: remove legacy infrastructure
Message-ID: <20220726115845.4ywgubfpqfbl7qa3@pengutronix.de>
References: <20220725065419.3005015-1-dario.binacchi@amarulasolutions.com>
 <20220725065419.3005015-3-dario.binacchi@amarulasolutions.com>
 <20220725123804.ofqpq4j467qkbtzn@pengutronix.de>
 <CABGWkvrBrTqWQPBWKuKzuwQzgvc-iuWJPXt2utb60MOfych09A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xy3wdhkpwrvkuzu6"
Content-Disposition: inline
In-Reply-To: <CABGWkvrBrTqWQPBWKuKzuwQzgvc-iuWJPXt2utb60MOfych09A@mail.gmail.com>
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


--xy3wdhkpwrvkuzu6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.07.2022 12:11:33, Dario Binacchi wrote:
> Hello Marc,
>=20
> On Mon, Jul 25, 2022 at 2:38 PM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> >
> > On 25.07.2022 08:54:15, Dario Binacchi wrote:
> > > Taking inspiration from the drivers/net/can/can327.c driver and at the
> > > suggestion of its author Max Staudt, I removed legacy stuff like
> > > `SLCAN_MAGIC' and `slcan_devs' resulting in simplification of the code
> > > and its maintainability.
> > >
> > > The use of slcan_devs is derived from a very old kernel, since slip.c
> > > is about 30 years old, so today's kernel allows us to remove it.
> > >
> > > The .hangup() ldisc function, which only called the ldisc .close(), h=
as
> > > been removed since the ldisc layer calls .close() in a good place
> > > anyway.
> > >
> > > The old slcanX name has been dropped in order to use the standard canX
> > > interface naming. It has been assumed that this change does not break
> > > the user space as the slcan driver provides an ioctl to resolve from =
tty
> > > fd to netdev name.
> >
> > Is there a man page that documents this iotcl? Please add it and/or the
> > IOCTL name.
>=20
> I have not found documentation of the SIOCGIFNAME ioctl for the line disc=
ipline,
> but only for netdev (i. e.
> https://man7.org/linux/man-pages/man7/netdevice.7.html),

Ok - What about:

The old slcanX name has been dropped in order to use the standard canX
interface naming. The ioctl SIOCGIFNAME can be used to query the name of
the created interface. Further There are several ways to get stable
interfaces names in user space, e.g. udev or systemd-networkd.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--xy3wdhkpwrvkuzu6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLf1vIACgkQrX5LkNig
011rngf9GVw2jclmH7AgQ2YMJ298ay62e8P8qgG9f8WGzHWFkxrwZaQF4shqgtS1
yJ0ppY9R4Y5cNe4UxdfSGjaN3IahaWxlsuDmhx5K86dhtQf9e+FY6Cr4PQbH/aOc
+F8RD0Yq4uLLFTC3VMHxB8/0xLcQqkltMHZX24B+ikqyeWTYn/YeXlC0nOSXpepl
X0OyGNOWGJmgkwVW1ZTgvzfer+ToWoMFslh4HAf6QdJU5sj2gdK55d0sL5RiDvAb
fTCCS5DbOhDxoSG5uzMTe4pXPuVw1u0LvTrypoTm5PmMIdWOI+FAtEEaZ37Te0OA
58JS72ONsO55drbB5JEydbJCzeeuNQ==
=R+7A
-----END PGP SIGNATURE-----

--xy3wdhkpwrvkuzu6--
