Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E8F3920C7
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 21:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbhEZTYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 15:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhEZTYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 15:24:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09015C061756
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 12:22:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1llz6f-00033s-Vn; Wed, 26 May 2021 21:22:18 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:405c:46a2:a678:b7b3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9E1E762CD86;
        Wed, 26 May 2021 19:22:15 +0000 (UTC)
Date:   Wed, 26 May 2021 21:22:14 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <mani@kernel.org>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] can: mcp251xfd: Fix header block to clarify
 independence from OF
Message-ID: <20210526192214.ksgyjescrtnhg5yq@pengutronix.de>
References: <20210526191801.70012-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="35obomvnpd3qtcqc"
Content-Disposition: inline
In-Reply-To: <20210526191801.70012-1-andriy.shevchenko@linux.intel.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--35obomvnpd3qtcqc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 26.05.2021 22:18:01, Andy Shevchenko wrote:
> The driver is neither dependent on OF, nor it requires any OF headers.
> Fix header block to clarify independence from OF.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Does it already work on ACPI?

Applied to linux-can-next/testing.=20

thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--35obomvnpd3qtcqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCun+QACgkQqclaivrt
76kfAwf/aK8QV0Ce/jJmkynoxALJjqE6oQDIJvq7XXLvDqfMlfk72C/bhXrL5VFq
28bknJrFjlOPuCrU/a4RIzbCocpIOE4EaL58HhnJ0uBGsOtNNzLP6Xsk+nm/gMio
Fy2KSetxowpmiYQaMJNFnBfn1a+L3Gu6P0MDpYENWG+W/fdvlaxLbjd5xe5zSPFN
wfCWyCMkhPsJVqm1eA3kO2yGE2nMMfecYAWWDSeZ8fuc+lR9xqb/5/TYXym/Tq4D
+irzNBKMR26mq2fPNumqMpXAlqnsc9euu3VufvGGV/TiIYOmxb76pXajmtJE5OgE
vpsInk2VvqJ4VDJKmGYgzVTRWM3bBA==
=KlTk
-----END PGP SIGNATURE-----

--35obomvnpd3qtcqc--
