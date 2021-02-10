Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74697316686
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhBJMWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:22:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:56354 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231470AbhBJMUT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 07:20:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 737EBAFBF;
        Wed, 10 Feb 2021 12:19:35 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 37632602E7; Wed, 10 Feb 2021 13:19:35 +0100 (CET)
Date:   Wed, 10 Feb 2021 13:19:35 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>, mlxsw <mlxsw@nvidia.com>
Subject: Re: [PATCH ethtool v2 1/5] ethtool: Extend ethtool link modes
 settings uAPI with lanes
Message-ID: <20210210121935.4ia5ubavws2hz5jj@lion.mk-sys.cz>
References: <20210202182513.325864-1-danieller@nvidia.com>
 <20210202182513.325864-2-danieller@nvidia.com>
 <20210209194020.a7yjjd6hxj33l6ld@lion.mk-sys.cz>
 <DM6PR12MB4516B1725F9B19B7975F8373D88D9@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l5rshhfqvp2qoahj"
Content-Disposition: inline
In-Reply-To: <DM6PR12MB4516B1725F9B19B7975F8373D88D9@DM6PR12MB4516.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--l5rshhfqvp2qoahj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 10, 2021 at 12:06:04PM +0000, Danielle Ratson wrote:
> > When updating the UAPI header copies, please do it in a separate
> > commit which updates the whole uapi/ subdirectory to the state of a
> > specific kernel commit. You can use the script at
> >=20
> >   https://www.kernel.org/pub/software/network/ethtool/ethtool-import-ua=
pi
> >=20
> > It expects the LINUX_GIT environment variable to point to your local
> > git repository with kernel tree and takes one argument identifying
> > the commit you want to import the uapi headers from (commit id, tag
> > or branch name can be used). In your case, net-next would be the
> > most likely choice.
>=20
> Should I use the commit in net-next that I added it uapi headers, or
> generally the last commit of net-next?

That's up to you, I'm fine with either. The important point is to have
a consistent snapshot of all copied (and sanitized) uapi headers.

Michal

--l5rshhfqvp2qoahj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmAjz1EACgkQ538sG/LR
dpWqpggAlr6S34Bg8f8MlV/CFruXCLhHBF2OdCxAmj2L0ez8zLQwDcMd/r/m5i3S
Kzz6L969tM1ijRISaClNXjj/ZXkClZZjlPoKtFH/2W9iVToYZjcqwvX7Dwnwxm2b
+skPtF0qWjL9wogw8Ro9hw32X/REf9J39JEemOEHZAExDzchGovhIZim8eBgCKie
3PBMAY+tjP9Zx94/RN2fYYYGIIQMZFnoq5WixZ7IujefcfdLu1Q6XwPeQkuZHvLK
11qlU9Mz8g5zmFYLlTtLvxKG3djDxZob15sz5GX4KilWAqBZKI53fPjxoVzOcPSs
1YTevwPAjbsjNM79z9pLs8PyAprh+Q==
=h8Cn
-----END PGP SIGNATURE-----

--l5rshhfqvp2qoahj--
