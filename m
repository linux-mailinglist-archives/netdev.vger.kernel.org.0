Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728623E3440
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 11:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhHGJMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 05:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhHGJMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 05:12:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F1BC0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 02:12:05 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mCIMv-00079k-AT; Sat, 07 Aug 2021 11:11:49 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mCIMp-0007S4-8u; Sat, 07 Aug 2021 11:11:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1mCIMp-00079k-7J; Sat, 07 Aug 2021 11:11:43 +0200
Date:   Sat, 7 Aug 2021 11:11:35 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Corey Minyard <minyard@acm.org>
Cc:     kernel@pengutronix.de, alsa-devel@alsa-project.org,
        linux-parisc@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Helge Deller <deller@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-scsi@vger.kernel.org, Takashi Iwai <tiwai@suse.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        openipmi-developer@lists.sourceforge.net,
        Jaroslav Kysela <perex@perex.cz>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] parisc: Make struct parisc_driver::remove() return void
Message-ID: <20210807091135.xgenctifq3wgn3ro@pengutronix.de>
References: <20210806093938.1950990-1-u.kleine-koenig@pengutronix.de>
 <20210806174927.GJ3406@minyard.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="45vk6qaqgnzlimcx"
Content-Disposition: inline
In-Reply-To: <20210806174927.GJ3406@minyard.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--45vk6qaqgnzlimcx
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, Aug 06, 2021 at 12:49:27PM -0500, Corey Minyard wrote:
> On Fri, Aug 06, 2021 at 11:39:38AM +0200, Uwe Kleine-K=F6nig wrote:
> > -int ipmi_si_remove_by_dev(struct device *dev)
> > +void ipmi_si_remove_by_dev(struct device *dev)
>=20
> This function is also used by ipmi_si_platform.c, so you can't change
> this.

Did you see that I adapted ipmi_si_platform.c below? That is an instance
of "Make [ipmi_si_remove_by_dev] return void, too, as for all other
callers the value is ignored, too." (In ipmi_si_platform.c the return
value is used in a struct platform_driver::remove function. The value
returned there is ignored, see commit
e5e1c209788138f33ca6558bf9f572f6904f486d.)

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--45vk6qaqgnzlimcx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmEOTkQACgkQwfwUeK3K
7Alj/wf+K39kaQNGHDkIhb/MnReZtTqJ7A4TTKfWOCggUIlF0kf2wXSKnlTK2HPV
BPYqMYRAi5ZeO6n1X4beQCN8FSCnnD+s52mCB1nRELRizA8xhnIdK0uD8tqGR43c
iRUEonO4k6ZppBtRgK5uABKENDAaDRQvylQZ9PAzunPbORpMEJJ9U9uaL7fUDtSz
wwjGdfUTeuKFdZN8Ac+OfR7pgHkixcvH9/ECq/VzrsclVCB5DMtP9hckr0LPn5u1
9mtgbkWMsFcj+FfkPo8KZgKoPA+NuTmhK6X17hUR5m7eNrPDt05uVH+MiBmmsY+s
p6siiJxoVX8l60PKy7apKloWP9Ku8w==
=Hx8e
-----END PGP SIGNATURE-----

--45vk6qaqgnzlimcx--
