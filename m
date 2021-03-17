Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2C333EFC9
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhCQLtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 07:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhCQLtq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 07:49:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEE4C06175F
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 04:49:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lMUgG-0006KX-Po; Wed, 17 Mar 2021 12:49:40 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:31e3:6e40:b1cd:40a8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BFDF65F7A7C;
        Wed, 17 Mar 2021 11:49:38 +0000 (UTC)
Date:   Wed, 17 Mar 2021 12:49:38 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-can@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        davem@davemloft.net
Subject: Re: [BUG] Re: [net 3/6] can: flexcan: invoke flexcan_chip_freeze()
 to enter freeze mode
Message-ID: <20210317114938.lcqudto75wc6nkzq@pengutronix.de>
References: <20210301112100.197939-1-mkl@pengutronix.de>
 <20210301112100.197939-4-mkl@pengutronix.de>
 <65137c60-4fbe-6772-6d48-ac360930f62b@pengutronix.de>
 <20210317081831.osalrszbje4oofoh@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ph7ivpa2lrsmgzwc"
Content-Disposition: inline
In-Reply-To: <20210317081831.osalrszbje4oofoh@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ph7ivpa2lrsmgzwc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17.03.2021 09:18:31, Marc Kleine-Budde wrote:
> A fix for this in on its way to net/master:
>=20
> https://lore.kernel.org/linux-can/20210316082104.4027260-6-mkl@pengutroni=
x.de/

It's already in net/master.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ph7ivpa2lrsmgzwc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmBR7M8ACgkQqclaivrt
76kXswf+NgFkyfI/JDlRfKLVHVrtWLvjgm2+hreZIvoo9zfbtmptXe5VqcKyCT3t
hwdndozckQi05oBtIGJ7t+QxFO1C0yiNXi6pBZ/RGuS9gVy0FVCzvR259r6vbhR8
nog+Cjh4csFs1zRwQ1wAAQKSCC+DwRSxDOoevoBLYA71L8UYvphnSjYonEpSJEnS
hVFxNbWwTKeZlJLqhPh19BSvh1Ai0zvWKqoZrkXwPP6NuwTVoH4NU6WOP29jRQJ6
SXVoN5g9ajfryZmYeu/naQMMLx+Uw7md5MZZeF3gJyQy+Zsf7TaCLkl8E9lhrD5b
1QOPpMYOWD/KL6Y9M3Nn45YgUKdddw==
=eWaE
-----END PGP SIGNATURE-----

--ph7ivpa2lrsmgzwc--
