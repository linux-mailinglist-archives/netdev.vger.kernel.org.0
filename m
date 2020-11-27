Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A92C622C
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgK0JrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgK0JrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:47:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D1AC0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 01:47:12 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1kiaKC-0005UC-C7; Fri, 27 Nov 2020 10:45:56 +0100
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1kiaK4-0002Ad-OH; Fri, 27 Nov 2020 10:45:48 +0100
Date:   Fri, 27 Nov 2020 10:45:47 +0100
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Geoff Levand <geoff@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] ALSA: ppc: drop if block with always false condition
Message-ID: <20201127094547.4zcyeycfrriitkqx@pengutronix.de>
References: <20201126165950.2554997-1-u.kleine-koenig@pengutronix.de>
 <CAMuHMdUbfT7ax4BhjMT_DBweab8TDm5e=xMv5f61t9QpQJt1mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="taccm5e5wyznne4d"
Content-Disposition: inline
In-Reply-To: <CAMuHMdUbfT7ax4BhjMT_DBweab8TDm5e=xMv5f61t9QpQJt1mw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--taccm5e5wyznne4d
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2020 at 09:35:39AM +0100, Geert Uytterhoeven wrote:
> Hi Uwe,
>=20
> On Thu, Nov 26, 2020 at 6:03 PM Uwe Kleine-K=F6nig
> <u.kleine-koenig@pengutronix.de> wrote:
> > The remove callback is only called for devices that were probed
> > successfully before. As the matching probe function cannot complete
> > without error if dev->match_id !=3D PS3_MATCH_ID_SOUND, we don't have to
> > check this here.
> >
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
>=20
> Thanks for your patch!
>=20
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>=20
> Note that there are similar checks in snd_ps3_driver_probe(), which
> can be removed, too:
>=20
>         if (WARN_ON(!firmware_has_feature(FW_FEATURE_PS3_LV1)))
>                 return -ENODEV;
>         if (WARN_ON(dev->match_id !=3D PS3_MATCH_ID_SOUND))
>                 return -ENODEV;

I had to invest some brain cycles here. For the first:

Assuming firmware_has_feature(FW_FEATURE_PS3_LV1) always returns the
same value, snd_ps3_driver_probe is only used after this check succeeds
because the driver is registered only after this check in
snd_ps3_init().

The second is superflous because ps3_system_bus_match() yields false if
this doesn't match the driver's match_id.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--taccm5e5wyznne4d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAl/AyscACgkQwfwUeK3K
7AmVbAf/fRHKZiIEMqPckqCjNor4UCILZvO1NJYHzctpPGBT8dETRjBW1ZmWu6MS
qxv4y7aGSfc8pP5G0LU1rJJYOf7x8PpHEbm5uNM1UOIxzSIniALG7VIeoFIBrGoQ
QuMcTv73n6ypzsNu87ynqrILEVYNrubD+Sb6B2xZEfPbIcvvwKfUvr8+lBEkabHX
LbBbYbLL/ivRvUFm/YKvY3vcnTTAj88lURLp6V8EPT+8/TDr7Bfuy5LyjFsKAYsq
QXNTBRLT8unlG99XvN4urWFVs9NMPKKWgV/e14LGumeL+mM8EQi+UPCnMTPOErWb
F4a+SZgp6g00Syvd8mJVlWUKEkQUOg==
=P7Le
-----END PGP SIGNATURE-----

--taccm5e5wyznne4d--
