Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4846B130FFC
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 11:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgAFKGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 05:06:05 -0500
Received: from sauhun.de ([88.99.104.3]:37032 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbgAFKGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 05:06:04 -0500
Received: from localhost (p54B338AC.dip0.t-ipconnect.de [84.179.56.172])
        by pokefinder.org (Postfix) with ESMTPSA id 8DC052C0686;
        Mon,  6 Jan 2020 11:06:01 +0100 (CET)
Date:   Mon, 6 Jan 2020 11:05:58 +0100
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] treewide: remove redundent IS_ERR() before error code
 check
Message-ID: <20200106100558.GA4831@kunai>
References: <20200106045833.1725-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20200106045833.1725-1-masahiroy@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2020 at 01:58:33PM +0900, Masahiro Yamada wrote:
> 'PTR_ERR(p) =3D=3D -E*' is a stronger condition than IS_ERR(p).
> Hence, IS_ERR(p) is unneeded.
>=20
> The semantic patch that generates this commit is as follows:
>=20
> // <smpl>
> @@
> expression ptr;
> constant error_code;
> @@
> -IS_ERR(ptr) && (PTR_ERR(ptr) =3D=3D - error_code)
> +PTR_ERR(ptr) =3D=3D - error_code
> // </smpl>
>=20
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

For drivers/i2c:

Acked-by: Wolfram Sang <wsa@the-dreams.de>

Thanks!


--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl4TBoIACgkQFA3kzBSg
KbYycQ/9HHMMaJuiDZs2ZZyg9Szbt/uDs6lfGNwX2WQjjgoo0FHwIISx26fwUSS0
sfKb1VukurwS3gKvijHI2Tgo+f8Vb5W76AfDl7l2Pt+/1Fc3udj81ejuq6hrwDtX
8lb3i4K7U7mReQW1CuGDL2a15XNeUCNSocbEz9r/fSMSCcO7vtYFQdJ1PRCiO40n
Z9RU/AGK5/6Dm8H6JaPvBbkL4cSaKu0fWTLYwZfm5lUqpj8ERaGKdlz4W/DEy5nw
/FLsLSoRRKpkrWFzohHUjEplvrX5Xv7//Pl4GHVxH25rPhKgXL7M4bkJUrAOG8Ap
zRni09tOZTNrB2zkt3dFgDSUXwPHJOM0KLrVyFeze3ZtA/8rDaDxbr7a0lK0Jgi6
X3+CMoirCftC9W2ub9a9h/IOhLqzFzVoWNN3QsHr4XxLYmE1EvhoIYbCRs3JpVrV
cgbYECZxZElbp6K6u7sEsETPvGjvHi4gzXBZUwxYpdZyWaUsV+XIzxqQyeQIqkFF
Yp6Cjmd/cjgLLUMwxL2QaopFPm+Ul+f5AojzQbMP6ScKbrjYfKn8S60q4fwrShk1
yDlNFlQgdSrn1Dt1PfGllfjLz1bcQ/tsZsmP/ulyPE0Ph9Mv5ixDhEse7mZmOVjm
8khnVJiGQcIi1CMl8mR8uDU6319aQvxcYWlG84KlF7nXsigrRqA=
=e1Dd
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
