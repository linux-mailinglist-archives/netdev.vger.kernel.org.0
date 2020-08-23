Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BF724EE07
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgHWPyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 11:54:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:60778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgHWPyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 11:54:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 735EEAD68;
        Sun, 23 Aug 2020 15:54:37 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id B4D856030D; Sun, 23 Aug 2020 17:54:07 +0200 (CEST)
Date:   Sun, 23 Aug 2020 17:54:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, vadimp@mellanox.com, andrew@lunn.ch,
        mlxsw@mellanox.com, idosch@mellanox.com, roopa@nvidia.com,
        paschmidt@nvidia.com
Subject: Re: [PATCH ethtool v5] Add QSFP-DD support
Message-ID: <20200823155407.i3cy6dpys2nvbzsh@lion.mk-sys.cz>
References: <20200813150826.16680-1-popadrian1996@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xwlld7pcdclihdmc"
Content-Disposition: inline
In-Reply-To: <20200813150826.16680-1-popadrian1996@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xwlld7pcdclihdmc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2020 at 06:08:26PM +0300, Adrian Pop wrote:
> The Common Management Interface Specification (CMIS) for QSFP-DD shares
> some similarities with other form factors such as QSFP or SFP, but due to
> the fact that the module memory map is different, the current ethtool
> version is not able to provide relevant information about an interface.
>=20
> This patch adds QSFP-DD support to ethtool. The changes are similar to
> the ones already existing in qsfp.c, but customized to use the memory
> addresses and logic as defined in the specifications document.
>=20
> Several functions from qsfp.c could be reused, so an additional parameter
> was added to each and the functions were moved to sff-common.c.
>=20
> Diff from v1:
> * Report cable length in meters instead of kilometers
> * Fix bad value for QSFP_DD_DATE_VENDOR_LOT_OFFSET
> * Fix initialization for struct qsfp_dd_diags
> * Remove unrelated whitespace cleanups in qsfp.c and Makefile.am
>=20
> Diff from v2:
> * Remove functions assuming the existance of page 0x10 and 0x11
> * Remove structs and constants related to the page 0x10 and 0x11
>=20
> Diff from v3:
> * Added missing Signed-off-by and Tested-by tags
>=20
> Diff from v4:
> * Fix whitespace formatting problems
>=20
> Signed-off-by: Adrian Pop <popadrian1996@gmail.com>
> Tested-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Applied, thank you.

Michal

--xwlld7pcdclihdmc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl9CkRoACgkQ538sG/LR
dpXxzwgAyHO8oE0jgibb9ZvLPJGr1lni7ukLHtJNeEHwUqIcy9HpWzoO93GdB99Z
FNb6L7y4ZbOAuif+W7UEDIxo8p43OepyGkJHhyw+Xr6O5hn6RhKK+pQu13m0Vj8n
Sc4gKh4DriFRcvUPGKJNHzJrvgk9OEa6NRZXQ36cXLQccUpLowUpqlg7CANOeXLx
o6mnynSwWU4js1E+H5vewgHdTaoxfKi0/DM5EnlyZ9hq8jXUw/6P/KcrqBZW3ngd
RnpE1wwURIvNcpnIFseVkS/M3Tu4jQEVff1bJknb7+p4tgNz33Zw1dI96uA6hfMu
yTCRQH6KGRW5cx8J2VWxTrMK3oHe5Q==
=HzGL
-----END PGP SIGNATURE-----

--xwlld7pcdclihdmc--
