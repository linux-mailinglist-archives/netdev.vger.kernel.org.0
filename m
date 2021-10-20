Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FED4345AE
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 09:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJTHHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 03:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbhJTHHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 03:07:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF29C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 00:05:32 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1md5fG-0005Cc-JX; Wed, 20 Oct 2021 09:05:30 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1md5fG-0005Eo-2R; Wed, 20 Oct 2021 09:05:30 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1md5fG-0001fL-1i; Wed, 20 Oct 2021 09:05:30 +0200
Date:   Wed, 20 Oct 2021 09:05:26 +0200
From:   Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] nfc: st95hf: Make spi remove() callback return zero
Message-ID: <20211020070526.4xsjqdi54iayen3l@pengutronix.de>
References: <20211019204916.3834554-1-u.kleine-koenig@pengutronix.de>
 <da88faf5-33db-b20d-e019-7cca6779b626@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="t6qo6sfqmqkb7uat"
Content-Disposition: inline
In-Reply-To: <da88faf5-33db-b20d-e019-7cca6779b626@canonical.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--t6qo6sfqmqkb7uat
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Krzysztof,

On Wed, Oct 20, 2021 at 08:55:51AM +0200, Krzysztof Kozlowski wrote:
> On 19/10/2021 22:49, Uwe Kleine-K=F6nig wrote:
> > If something goes wrong in the remove callback, returning an error code
> > just results in an error message. The device still disappears.
> >=20
> > So don't skip disabling the regulator in st95hf_remove() if resetting
> > the controller via spi fails. Also don't return an error code which just
> > results in two error messages.
> >=20
> > Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
> > ---
> >  drivers/nfc/st95hf/core.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
>=20
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

Given you're the listed maintainer for NFC, I wonder who will take this
patch? I expected you to take this patch and not "only" give your
Reviewed-by tag.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--t6qo6sfqmqkb7uat
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEfnIqFpAYrP8+dKQLwfwUeK3K7AkFAmFvv7MACgkQwfwUeK3K
7AnMFAf+KUqy3frIseGOlOyH1HbwhTND6fhKwRWUauJVZVizxVIo8k6d7SWuJrxz
u9NUUayoMfbl2l/5tqzHGaVRgDhlUTIeloeTfA21JuNp0WAAbsKnZLi9dqR9kiuh
iHR19cdfL+W7bY7MsHrJGCI06ynGJSXYKU1A00X15fYD3es7DqjS7tovY7WckhkT
6LMHYzcbP8bduuCLlwAO002fThF/VtFWZbHEYZrr3O9sTtdIg9VBTlBfXYiMhazC
RAZZXbaDhwzU6T8PoN8DzEzz3htcdIhL2tKHLLqCemobkgCYv8ORYjsP1jYv2dAq
yTNP4hESpM+TkE+6/RC0dt/6u5RjUw==
=jIlV
-----END PGP SIGNATURE-----

--t6qo6sfqmqkb7uat--
