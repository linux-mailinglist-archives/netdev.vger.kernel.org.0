Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800B13FC846
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbhHaNdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbhHaNdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:33:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E930C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:32:51 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mL3sY-0000xs-Fm; Tue, 31 Aug 2021 15:32:42 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-251e-7a0a-4ec6-bf9c.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:251e:7a0a:4ec6:bf9c])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id BD320674096;
        Tue, 31 Aug 2021 13:32:39 +0000 (UTC)
Date:   Tue, 31 Aug 2021 15:32:38 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] can: rcar: Drop unneeded ARM dependency
Message-ID: <20210831133238.75us5ipf25wzqkuq@pengutronix.de>
References: <362d9ced19f3524ee8917df5681b3880c13cac85.1630416373.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="srzl6ahi5ee46qdy"
Content-Disposition: inline
In-Reply-To: <362d9ced19f3524ee8917df5681b3880c13cac85.1630416373.git.geert+renesas@glider.be>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--srzl6ahi5ee46qdy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 31.08.2021 15:27:40, Geert Uytterhoeven wrote:
> The dependency on ARM predates the dependency on ARCH_RENESAS.
> The latter was introduced for Renesas arm64 SoCs first, and later
> extended to cover Renesas ARM SoCs, too.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied to linux-can-next/testing.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--srzl6ahi5ee46qdy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEuL3MACgkQqclaivrt
76miCQgAnAZxW8kG/d0p+m5teLbGjtg/Ay3Paa1gufGRAaoufrQq7DqQ/gmrEKjW
Izq+CNSzSQnd2SqYHOdeTQgn6gCMRCNiNnpPqo+ERvgm+veU8u1FiTHQYZCx+jjX
v3IH4xCtZcIaRmATo2qWxFttVE1rZlVT6Pvkv+UJAPlkTBxTPr/LtswE7lrYa5WV
baHtesfrkI6dy72vnZWL3SN7YzysHTw/k6Z3fDGX0TUgkhjvhFApcnj9JppVBCyj
1irSai1oL3RP2xblXo0W51Xi+MKwJA85LNorc/yV3JHmrJRunh+nDvqC3ZhouKHI
hIuPU2KhM1nGMixGJkPVJu1nFyaZUw==
=xBj4
-----END PGP SIGNATURE-----

--srzl6ahi5ee46qdy--
