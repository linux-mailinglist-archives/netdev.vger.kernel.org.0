Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F0055F8E1
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiF2HYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbiF2HYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:24:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA9B252AB
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 00:24:10 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1o6S2d-0005UO-4V; Wed, 29 Jun 2022 09:23:15 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o6S2S-003M3c-Vk; Wed, 29 Jun 2022 09:23:08 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ukl@pengutronix.de>)
        id 1o6S2V-001qeU-Nu; Wed, 29 Jun 2022 09:23:07 +0200
Date:   Wed, 29 Jun 2022 09:23:04 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Wolfram Sang <wsa@kernel.org>, dri-devel@lists.freedesktop.org,
        linux-serial@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-crypto@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rtc@vger.kernel.org, netdev@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        chrome-platform@lists.linux.dev, linux-input@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-media@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org,
        Support Opensource <support.opensource@diasemi.com>,
        linux-fbdev@vger.kernel.org, patches@opensource.cirrus.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pwm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kasan-dev@googlegroups.com, linux-staging@lists.linux.dev
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
Message-ID: <20220629072304.qazmloqdi5h5kdre@pengutronix.de>
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
 <60cc6796236f23c028a9ae76dbe00d1917df82a5.camel@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3yzpq2rgg2xm7tqn"
Content-Disposition: inline
In-Reply-To: <60cc6796236f23c028a9ae76dbe00d1917df82a5.camel@codeconstruct.com.au>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
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


--3yzpq2rgg2xm7tqn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

[I dropped nearly all individuals from the Cc: list because various
bounces reported to be unhappy about the long (logical) line.]

On Wed, Jun 29, 2022 at 03:03:54PM +0800, Jeremy Kerr wrote:
> Looks good - just one minor change for the mctp-i2c driver, but only
> worthwhile if you end up re-rolling this series for other reasons:
>=20
> > -static int mctp_i2c_remove(struct i2c_client *client)
> > +static void mctp_i2c_remove(struct i2c_client *client)
> > =A0{
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mctp_i2c_client *mcli =3D i2c_get_client=
data(client);
> > =A0=A0=A0=A0=A0=A0=A0=A0struct mctp_i2c_dev *midev =3D NULL, *tmp =3D N=
ULL;
> > @@ -1000,7 +1000,6 @@ static int mctp_i2c_remove(struct i2c_client *cli=
ent)
> > =A0=A0=A0=A0=A0=A0=A0=A0mctp_i2c_free_client(mcli);
> > =A0=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&driver_clients_lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0/* Callers ignore return code */
> > -=A0=A0=A0=A0=A0=A0=A0return 0;
> > =A0}
>=20
> The comment there no longer makes much sense, I'd suggest removing that
> too.

Yeah, that was already pointed out to me in a private reply. It's
already fixed in

	https://git.pengutronix.de/cgit/ukl/linux/log/?h=3Di2c-remove-void

> Either way:
>=20
> Reviewed-by: Jeremy Kerr <jk@codeconstruct.com.au>

Added to my tree, too.

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--3yzpq2rgg2xm7tqn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmK7/dUACgkQwfwUeK3K
7AnTJgf9GW2H7fk9/Je11PRlCnUOSZ1sz/49RHAm4xj66pI/hdRP++D8L5o7ntEU
Hl5hKosR36cUyX12ie+YQtiCRkjhLqUoJnPzJOtcXQNV7mlMt6ds2INSO4iHYtMa
b2UH+lLQ6K/DO0+1KquElKJhfBOKucYY1WQAVK4cfasBKMR4MtukcHAgcYClRYdj
Nvvy6bCjqr8M1+uqDTJUUR/d0rWYHxFKygYRUfK7YPpz57gaVgaR9Js9GDGkVFB4
qVL5x23NzgB/Djr1Ls1F6Z5eFMjbtVb+S1HDRsU+HJOYD6v1LkT2OFx9iFpme+8m
+4HHNR5pxKogz59u4YpP1pIb0MejhA==
=ibah
-----END PGP SIGNATURE-----

--3yzpq2rgg2xm7tqn--
