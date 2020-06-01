Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C101EA248
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgFAKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:54:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgFAKyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 06:54:33 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57B5820679;
        Mon,  1 Jun 2020 10:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591008872;
        bh=oaGk8vAyn0kRfIUe/ON9uK9hS/EuWcvt8kVlcyUjunw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bDxTwFJKiHlUrsrB3f3tuoUCr0Xp1ILGURyOuNBDe68woZyYFM2gPuUAQqYAUThfL
         XQo0sa0T7L8N+Q+9jQpURIdXqhsv/hh7aAVq8mXJucr5nWpRa1/ozMlsKnbsjH3y0p
         yoO1h9NTWO4yHdCcOS3UABWW5Ad2daiA4dUJ4tzA=
Date:   Mon, 1 Jun 2020 11:54:30 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Subject: Re: [PATCH v3 net-next 01/13] regmap: add helper for per-port
 regfield initialization
Message-ID: <20200601105430.GB5234@sirena.org.uk>
References: <20200531122640.1375715-1-olteanv@gmail.com>
 <20200531122640.1375715-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20200531122640.1375715-2-olteanv@gmail.com>
X-Cookie: hangover, n.:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 31, 2020 at 03:26:28PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>=20
> Similar to the standalone regfields, add an initializer for the users
> who need to set .id_size and .id_offset in order to use the
> regmap_fields_update_bits_base API.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Link: https://lore.kernel.org/r/20200527234113.2491988-2-olteanv@gmail.com
> Signed-off-by: Mark Brown <broonie@kernel.org>

Please either just wait till after the merge window or ask for a pull
request like I said when I applied the patch.

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl7U3mUACgkQJNaLcl1U
h9DcWwf/UW6KEsY+lWS6fGBywDt0QLop0dW7wE1sFPIqwwjkPyYt3mP7SyV0oF/M
aUUKCF/F18Pd3f/v5nv+O/TMPMfZ2XOBYCiN7KMenfNxo5qBplyWfd/hH2moqzt7
8lPfguYGdAx8x5pG31SOzaL+yKyqfBRAGU5MkESS1EO/aPSp1yLrm0Y091cLh5kX
+GkMnjdurfiKnZ9o550K7sR/JDhMjdeOmFBgAHG+F1ILfNNPIjCgkQQQ2kU7rSKt
zw9PNVkfEdYDyVhoyeIhBKcuAo5j+yTSp2PKxKE21cTKj3pp3q82puiUSOyx7y/Y
Orgh5clSzZ7NLlzRaEBIi6pXPduopw==
=8p6G
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
