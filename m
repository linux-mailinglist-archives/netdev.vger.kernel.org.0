Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC29324AC
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 21:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfFBT6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 15:58:31 -0400
Received: from sauhun.de ([88.99.104.3]:59736 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726656AbfFBT6a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 15:58:30 -0400
Received: from localhost (dslb-188-102-100-163.188.102.pools.vodafone-ip.de [188.102.100.163])
        by pokefinder.org (Postfix) with ESMTPSA id 3B0042C3559;
        Sun,  2 Jun 2019 21:58:28 +0200 (CEST)
Date:   Sun, 2 Jun 2019 21:58:27 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     mika.westerberg@linux.intel.com, linux@armlinux.org.uk,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [net-next,v4 1/2] i2c: acpi: export
 i2c_acpi_find_adapter_by_handle
Message-ID: <20190602195827.GA911@kunai>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190528230233.26772-2-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20190528230233.26772-2-ruslan@babayev.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2019 at 04:02:32PM -0700, Ruslan Babayev wrote:
> This allows drivers to lookup i2c adapters on ACPI based systems similar =
to
> of_get_i2c_adapter_by_node() with DT based systems.
>=20
> Signed-off-by: Ruslan Babayev <ruslan@babayev.com>
> Cc: xe-linux-external@cisco.com

As mentioned elsewhere, applied to for-next, thanks!


--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlz0Kl8ACgkQFA3kzBSg
KbbiJw/+JNaPS29bW8rWcKmcxAwjO1Pp7csg4rUTOEwuD15TrUAyJjvwWFn856Vz
5NiNS+mcjMs1yAWhLoqDyz8EyxwSCRBEqQR0uauprEdGJQ7cIb0PI3miHeX6VD0S
ftj7Xp+F2eMZsezDd7/xxYSVp6tewpV64W1QjNDPaUTg35b9HFIc6J6sqKejcELv
J6tgeVNnNxfFW+iTgq7TR5zxKB2pJEGLtXuiqrXPyItvHYtJQoviOhc9JvRqeDrG
OnGMlaxMjY+fw94ocEL5ITM0Jucxu0HiJrGGo0HHItxR3kAZbyxzQG0yV+xjUSY3
M4VApkKSgYskOOBNmDuPk2IBO/cS4Jr4WHAxbYzToxVcO1eDHRTxJjjeViv79Lk/
6wAREaXsqKud7D8aVUMlrgFc9SeaAhseGiI/rIwoCWK7pHCZZZt08ixdQ0PANNNT
NPwGjbf/fBvj1BQu60/QPsGprgJfV3kwIEO1SBvGkrVoizSe5BVlULrgsPvKMflO
Xup4WzwYrxtOxFb8VQ5voYhP428YgptINPj0GXTiwznoG7ZoahaGzEgYQaWQgDRd
UrkJS3e8T6uBo8W+owotjOhSJ+btT68qVqOz7A3ojem5WOirC6GkTeZ45TTfx7co
GnUUxMGglcXCv3DNFIyXXJ3zxVmZUbfldwWpq2btUSsrxuJKAq4=
=gPZj
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
