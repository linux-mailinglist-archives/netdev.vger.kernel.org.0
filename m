Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21E63AB2C7
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhFQLkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFQLkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 07:40:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347E9C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 04:38:28 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltqLo-0004eZ-TD; Thu, 17 Jun 2021 13:38:25 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:653d:6f2f:e25e:5f2e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 85A0163E04B;
        Thu, 17 Jun 2021 11:38:23 +0000 (UTC)
Date:   Thu, 17 Jun 2021 13:38:22 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210617113822.gdpesbumwnoixjqs@pengutronix.de>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
 <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
 <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com>
 <20210616142940.wxllr3c55rk66rij@pengutronix.de>
 <CAMZ6RqJWeexWTGVkEJWMvBs1f=HQOc4zjd-PqPsxKnCr_XDFZQ@mail.gmail.com>
 <20210616144640.l4hjc6mc3ndw25hj@pengutronix.de>
 <CAMZ6RqLZAO3UX=B8yVUse=4DAVG_zGPrdoYpd-7Cp_To58CChw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wmbiwwgij6c7c54c"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLZAO3UX=B8yVUse=4DAVG_zGPrdoYpd-7Cp_To58CChw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wmbiwwgij6c7c54c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.06.2021 00:44:12, Vincent MAILHOL wrote:
> > > Did you try to compile?
> >
> > Not before sending that mail :)
> >
> > > I am not sure if bittiming.h is able to see struct can_priv which is
> > > defined in dev.h.
> >
> > Nope it doesn't, I moved the can_tdc_is_enabled() to
> > include/linux/can/dev.h
>=20
> Ack. It seems to be the only solution=E2=80=A6
>=20
> Moving forward, I will do one more round of tests and send the
> patch for iproute2-next (warning, the RFC I sent last month has
> some issues, if you wish to test it on your side, please wait).
>=20
> I will also apply can_tdc_is_enabled() to the etas_es58x driver.
>=20
> Could you push the recent changes on the testing branch of linux-can-next=
? It
> would be really helpful for me!

done

Marc.

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--wmbiwwgij6c7c54c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDLNCwACgkQqclaivrt
76m0agf/b+zqU+/7C7Jr48RNm7EXvLLK8LrH6QU5JhByWuozN3adqsbR3VkhwLg4
vi/46MXTWQ3sZOffrPSwzWotpBp0dNRUXCmTlk1+aStany3ekVHhmQqeemo0SR25
7Ef4mr1omagm19TGFAdGxQcj/bjIw/3pk2d1TFsEjj8OS7AHCAByWiPSGvhyEYev
PLyAjqjMCzdxaraMNuBFcttH7wZrgdj4ew5R7WSOoSNm48JvieMef8Ar4WhzxID3
4Y4DCHMrMEUPhThAYeR5pFlcRP7YISa62f865o/16IJVe0NnKyQugadk3lk9DdVM
S2IpApA4V3JoQpZukzqo6i7tqT9/CA==
=nuoX
-----END PGP SIGNATURE-----

--wmbiwwgij6c7c54c--
