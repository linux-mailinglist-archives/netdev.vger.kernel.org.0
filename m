Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 658F152BDD9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbiEROgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 10:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiEROgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 10:36:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE05031DFF
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 07:36:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nrKmd-0000Bl-4q; Wed, 18 May 2022 16:36:15 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 17E5B81582;
        Wed, 18 May 2022 14:36:14 +0000 (UTC)
Date:   Wed, 18 May 2022 16:36:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/4] can: skb:: move can_dropped_invalid_skb and
 can_skb_headroom_valid to skb.c
Message-ID: <20220518143613.2a7alnw6vtkw7ct2@pengutronix.de>
References: <e054f6d4-7ed1-98ac-8364-425f4ef0f760@hartkopp.net>
 <20220517141404.578d188a.max@enpas.org>
 <20220517122153.4r6n6kkbdslsa2hv@pengutronix.de>
 <20220517143921.08458f2c.max@enpas.org>
 <0b505b1f-1ee4-5a2c-3bbf-6e9822f78817@hartkopp.net>
 <CAMZ6RqJ0iCsHT-D5VuYQ9fk42ZEjHStU1yW0RfX1zuJpk5rVtQ@mail.gmail.com>
 <43768ff7-71f8-a6c3-18f8-28609e49eedd@hartkopp.net>
 <20220518132811.xfmwms2cu3bfxgrp@pengutronix.de>
 <CAMZ6RqJqeNjAtoDWADHsWocgbSXqQixcebJBhiBFS8BVeKCb3g@mail.gmail.com>
 <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wrv6rczef3xtxlyw"
Content-Disposition: inline
In-Reply-To: <3dbe135e-d13c-5c5d-e7e4-b9c13b820fb8@hartkopp.net>
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


--wrv6rczef3xtxlyw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.05.2022 16:33:58, Oliver Hartkopp wrote:
> > > > And what about the LEDS support depending on BROKEN?
> > > > That was introduced by commit 30f3b42147ba6f ("can: mark led trigge=
r as
> > > > broken") from Uwe as it seems there were some changes in 2018.
> > >=20
> > > There's a proper generic LED trigger now for network devices. So remo=
ve
> > > LED triggers, too.
> >=20
> > Yes, the broken LED topic also popped-up last year:
> >=20
> > https://lore.kernel.org/linux-can/20210906143057.zrpor5fkh67uqwi2@pengu=
tronix.de/ > I am OK to add one patch to the series for LED removal.
>=20
> Hm. We have several drivers that support LED triggers:
>=20
> $ git grep led.h
> at91_can.c:#include <linux/can/led.h>
> c_can/c_can_main.c:#include <linux/can/led.h>
> ctucanfd/ctucanfd_base.c:#include <linux/can/led.h>
> dev/dev.c:#include <linux/can/led.h>
> flexcan/flexcan-core.c:#include <linux/can/led.h>
> led.c:#include <linux/can/led.h>
> m_can/m_can.h:#include <linux/can/led.h>
> rcar/rcar_can.c:#include <linux/can/led.h>
> rcar/rcar_canfd.c:#include <linux/can/led.h>
> sja1000/sja1000.c:#include <linux/can/led.h>
> spi/hi311x.c:#include <linux/can/led.h>
> spi/mcp251x.c:#include <linux/can/led.h>
> sun4i_can.c:#include <linux/can/led.h>
> ti_hecc.c:#include <linux/can/led.h>
> usb/mcba_usb.c:#include <linux/can/led.h>
> usb/usb_8dev.c:#include <linux/can/led.h>
> xilinx_can.c:#include <linux/can/led.h>
>=20
> And I personally like the ability to be able to fire some LEDS (either as
> GPIO or probably in a window manager).
>=20
> I would suggest to remove the Kconfig entry but not all the code inside t=
he
> drivers, so that a volunteer can convert the LED support based on the
> existing trigger points in the drivers code later.

The generic netdev LED trigger code doesn't need any support in the
netdev driver.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wrv6rczef3xtxlyw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKFBFsACgkQrX5LkNig
012tlQf+LT2ROunCO3x7zZZLFd/l4EUXwAtDbMP3DxdGpd2XNnDUYupag0EPPojc
dAghmn07jvCZiV/jhC1UPhtq0LZ4vRVNQ+66NaROXooBo7eH31MALEvCaytYnfhh
/cGz0VzzhhnyZTf7pcFL3NXXffrLvFtVG93TXMOLQcS19ucysg7AVWP5mU3wI9K4
c+ZyeNpZ+17oQlYYOqb8p1uN6xKqJXuU4CU6bfcTEF9pBzimQZj0hFT+EIR7oo3F
J2LuqbV12IBoyPJalGnHgmrGU8Hk6qC9IVjKC2NwZa8JIdmUKFEPHhq3e8CkCi9U
FHgeZRMYaypDzsYmsyoWmgrHM8y8hQ==
=rdYd
-----END PGP SIGNATURE-----

--wrv6rczef3xtxlyw--
