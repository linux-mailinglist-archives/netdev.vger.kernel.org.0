Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBDB4347E6
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhJTJba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbhJTJba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:31:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3F5C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 02:29:16 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1md7uK-0005MZ-Jm; Wed, 20 Oct 2021 11:29:12 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1md7uJ-0005Sk-9b; Wed, 20 Oct 2021 11:29:11 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1md7uJ-0002cs-8c; Wed, 20 Oct 2021 11:29:11 +0200
Date:   Wed, 20 Oct 2021 11:29:06 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] nfc: st95hf: Make spi remove() callback return zero
Message-ID: <20211020092906.2dcvghsuu7j2zyly@pengutronix.de>
References: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
 <da88faf5-33db-b20d-e019-7cca6779b626@canonical.com>
 <20211020070526.4xsjqdi54iayen3l@pengutronix.de>
 <5eaa4875-3d7a-f1cd-578b-c1ea8db2bf19@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7sxlxhtzs44ta4tt"
Content-Disposition: inline
In-Reply-To: <5eaa4875-3d7a-f1cd-578b-c1ea8db2bf19@canonical.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7sxlxhtzs44ta4tt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2021 at 09:09:04AM +0200, Krzysztof Kozlowski wrote:
> On 20/10/2021 09:05, Uwe Kleine-K=F6nig wrote:
> > Hello Krzysztof,
> >=20
> > On Wed, Oct 20, 2021 at 08:55:51AM +0200, Krzysztof Kozlowski wrote:
> >> On 19/10/2021 22:49, Uwe Kleine-K=F6nig wrote:
> >>> If something goes wrong in the remove callback, returning an error co=
de
> >>> just results in an error message. The device still disappears.
> >>>
> >>> So don't skip disabling the regulator in st95hf_remove() if resetting
> >>> the controller via spi fails. Also don't return an error code which j=
ust
> >>> results in two error messages.
> >>>
> >>> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> >>> ---
> >>>  drivers/nfc/st95hf/core.c | 6 ++----
> >>>  1 file changed, 2 insertions(+), 4 deletions(-)
> >>
> >> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> >=20
> > Given you're the listed maintainer for NFC, I wonder who will take this
> > patch? I expected you to take this patch and not "only" give your
> > Reviewed-by tag.
> >=20
>=20
> Yeah, it's not that obvious. Maybe I should write subsystem/maintainer
> guide for NFC...
>=20
> All NFC patches are taken by netdev folks (David and Jakub) via
> patchwork. You did not CC them here, but you CC-ed the netdev, so let's
> hope it is enough. You also skipped linux-nfc, so you might need a file:
>=20
>   $ cat .get_maintainer.conf
>   --s

Ah, I handpicked the recipents from the get_maintainer.pl output. (My
intention was to pick linux-nfc, not netdev. Either I misremember or cut
the wrong line.)

Anyhow, I added David and Jakub to Cc: to maybe increase my chances this
patch is noticed by them.

Thanks
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--7sxlxhtzs44ta4tt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFv4V8ACgkQwfwUeK3K
7AlJ4ggAjhYhmIhcAnZqW8R2daae/1MzoAZ7gTcWw4IPoNuqCR+anrsbs1/zb68S
rR7wHT/1ucVb8vCIiokiiUSTjt6hOWMGuKnzXkzdsgL3mGAMG5hy9ewcU/hgIulK
XE7WSBT9GMMzzEuvn1o3z8qBPw2gZi/UlxE2dKem2c05GbGkiWIvIv0e8bRtQUvM
SgRzCERGXP6HDYUbrAgVtfMzPWcruKvvTVvR6sSKoZxISrlY9kEJ3Qml83Azl2rP
RT3LlaeJguASy0PxLbC68cfl2Ld9CwFsHQBS0qZ2Li4BH6mKjtJB7Gj6AwZx+QXZ
5lqtKSwQKNNdqoJXHkPlZAGjXGlKrQ==
=Wjft
-----END PGP SIGNATURE-----

--7sxlxhtzs44ta4tt--
