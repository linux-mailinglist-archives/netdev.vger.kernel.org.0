Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C4E2C7A47
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgK2ReI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2ReH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 12:34:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB62C0613D3
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 09:33:27 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kjQYS-0006zE-4U; Sun, 29 Nov 2020 18:32:08 +0100
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kjQYH-0003Mg-0E; Sun, 29 Nov 2020 18:31:57 +0100
Date:   Sun, 29 Nov 2020 18:31:53 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Takashi Iwai <tiwai@suse.de>, Michael Ellerman <mpe@ellerman.id.au>
Cc:     Geoff Levand <geoff@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Jim Paris <jim@jtan.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 2/2] powerpc/ps3: make system bus's remove and shutdown
 callbacks return void
Message-ID: <20201129173153.jbt3epcxnasbemir@pengutronix.de>
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
 <20201126165950.2554997-2-u.kleine-koenig@pengutronix.de>
 <s5hv9dphnoh.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="q5fwi2prasbljs5f"
Content-Disposition: inline
In-Reply-To: <s5hv9dphnoh.wl-tiwai@suse.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--q5fwi2prasbljs5f
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Michael,

On Sat, Nov 28, 2020 at 09:48:30AM +0100, Takashi Iwai wrote:
> On Thu, 26 Nov 2020 17:59:50 +0100,
> Uwe Kleine-K=F6nig wrote:
> >=20
> > The driver core ignores the return value of struct device_driver::remove
> > because there is only little that can be done. For the shutdown callback
> > it's ps3_system_bus_shutdown() which ignores the return value.
> >=20
> > To simplify the quest to make struct device_driver::remove return void,
> > let struct ps3_system_bus_driver::remove return void, too. All users
> > already unconditionally return 0, this commit makes it obvious that
> > returning an error code is a bad idea and ensures future users behave
> > accordingly.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> For the sound bit:
> Acked-by: Takashi Iwai <tiwai@suse.de>

assuming that you are the one who will apply this patch: Note that it
depends on patch 1 that Takashi already applied to his tree. So you
either have to wait untils patch 1 appears in some tree that you merge
before applying, or you have to take patch 1, too. (With Takashi
optinally dropping it then.)

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--q5fwi2prasbljs5f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl/D2wYACgkQwfwUeK3K
7AmmxQf+IiMtqhw/kONuYhwVAdprYhlgZyY9iZSe5xHA/6/1zNmBbfhPRm6PfStb
RRMTewx97J4joVbCv7OhlZBsoA7lnpUKJD05Qt7eXIEMdnuscbTx8YZr/z94s9/Y
/ElFT8e2Wx6crnEbjWeFcYVTLkGgf1pnUhpFmTq4LwQqqV5lQWUu6JMnS8THMhay
RCwTJR+P84Nw4wv39uvWN4LFmuDeM5hjnPjoEFBbnAeUtQr62AAh7itX8pTNEyZp
t6M09QdoxpJWDPe/vRxYZSZdsuE+vXsCuMWH5Kyo0hodOX9m6JpOhsPm/YiaCK5B
IW1LSeEeHe9uPQSACw7mkNft9x6Zfg==
=TO3P
-----END PGP SIGNATURE-----

--q5fwi2prasbljs5f--
