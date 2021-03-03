Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74D932C4A5
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450090AbhCDAPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581470AbhCCVPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 16:15:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6820C061760
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 13:14:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lHYpX-0004BN-Sn; Wed, 03 Mar 2021 22:14:52 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:a20d:2fb6:f2cb:982e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 50FEF5ED149;
        Wed,  3 Mar 2021 21:14:50 +0000 (UTC)
Date:   Wed, 3 Mar 2021 22:14:49 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     David Miller <davem@davemloft.net>
Cc:     martin@strongswan.org, kuba@kernel.org, wg@grandegger.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH net] can: dev: Move device back to init netns on owning
 netns delete,Re: [PATCH net] can: dev: Move device back to init netns on
 owning netns delete
Message-ID: <20210303211449.m2qslfoohyxjspfi@pengutronix.de>
References: <20210302122423.872326-1-martin@strongswan.org>
 <20210302122423.872326-1-martin@strongswan.org>
 <86f703d8-d658-505a-6493-54bf09ed65b2@pengutronix.de>
 <20210303.131231.1574207832462999993.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="otblozkkaskyqcad"
Content-Disposition: inline
In-Reply-To: <20210303.131231.1574207832462999993.davem@davemloft.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--otblozkkaskyqcad
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 03.03.2021 13:12:31, David Miller wrote:
> From: Marc Kleine-Budde <mkl@pengutronix.de>
> Date: Wed, 3 Mar 2021 21:29:39 +0100
>=20
> > Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> >=20
> > David, Jakub are you taking this patch?
>=20
> Nope, please take via the can tree, thanks!

Will do.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--otblozkkaskyqcad
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA//EYACgkQqclaivrt
76lseAf/VRNhlOBH7D1RvNTuYck0SJAXvWZF/VmdvlNmS59gmE+445LJTrJ0xFaB
eNGhq2+Fk1BnuqvjkAJhaMDOkZ8odgyKwrLAAVFbADz7edBbxsxSUxCQ32PGOXZw
IHq7R5xBimwvOmoNf8/o6FfI0FsPznTw0tbSMiABdPmwViYAcFq6uyTp2Ln19oJo
QZayKwZ9UXJFBJa2dC+jJchsYq5chlqjC3GEnFkENXolGlz/9GX5pHmtNx4+8tsd
4KIXRRaLp+7xV4pP78wu9Bo7SMBCtBgw4V8DsrSWIug/0r8HPUgFUwLMKW+9uFuj
fTIqP14CoCiwnxqe+JIi5XS8GIqMmg==
=XRVQ
-----END PGP SIGNATURE-----

--otblozkkaskyqcad--
