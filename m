Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDD931B2EE
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 23:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhBNWCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 17:02:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:50744 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229934AbhBNWCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Feb 2021 17:02:11 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 088E6AB98;
        Sun, 14 Feb 2021 22:01:30 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BCA3F603BB; Sun, 14 Feb 2021 23:01:29 +0100 (CET)
Date:   Sun, 14 Feb 2021 23:01:29 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH ethtool v3 0/5] Extend uAPI with lanes parameter
Message-ID: <20210214220129.f32r345ft3oo3vzm@lion.mk-sys.cz>
References: <20210210134840.2187696-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cuhfgoruzxcaordz"
Content-Disposition: inline
In-Reply-To: <20210210134840.2187696-1-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cuhfgoruzxcaordz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 10, 2021 at 03:48:35PM +0200, Danielle Ratson wrote:
> Currently, there is no way of knowing how many lanes will be use to
> achieve a wanted speed.
> For example, 100G speed can be achieved using: 2X50 or 4X25.
>=20
> In order to solve that, extend ethtool uAPI with lanes as a new link
> mode setting so the command below, for example, will be supported:
> $ ethtool -s swp5 lanes N
>=20
> Patch #1: Update headers with the new parameter.
> Patch #2: Support lanes in netlink.
> Patch #3: Expose the number of lanes in use.
> Patch #4: Add auto-completion for lanes.
> Patch #5: Add lanes to man page.
>=20
> v3:
> 	* Add a seperated patch, patch #1, for uapi headers and squash
> 	* the rest of it to patch #2.

Series applied, thank you.

Michal

>=20
> Danielle Ratson (5):
>   update UAPI header copies
>   netlink: settings: Add netlink support for lanes parameter
>   netlink: settings: Expose the number of lanes in use
>   shell-completion: Add completion for lanes
>   man: Add man page for setting lanes parameter
>=20
>  ethtool.8.in                  |  4 ++++
>  ethtool.c                     |  1 +
>  netlink/desc-ethtool.c        |  1 +
>  netlink/settings.c            | 13 +++++++++++++
>  shell-completion/bash/ethtool |  4 ++++
>  uapi/linux/ethtool.h          |  2 +-
>  uapi/linux/ethtool_netlink.h  |  1 +
>  uapi/linux/if_link.h          | 10 ++++++++--
>  uapi/linux/netlink.h          |  2 +-
>  uapi/linux/rtnetlink.h        | 20 +++++++++++++++-----
>  10 files changed, 49 insertions(+), 9 deletions(-)
>=20
> --=20
> 2.26.2
>=20

--cuhfgoruzxcaordz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmApnbIACgkQ538sG/LR
dpXD2Qf+KR85buv/OKMtuv7NiUfWubq1zo4B6vL6Ip5fMNUoNg+9HEF4GsF0x4VN
SE9TMQM/rnqVmYU3a+NfWps3PeHmXjxl/KhcfGhj8cEvJMS37ZUElRQMLkzm8oXA
KVnzbRz4saZ68meK2DBEre6mm/7bOObk9d6nJV1nyPUvgbJx6WlBdm9rFdPCFODe
E5q+izq8wzAbI/5Oub3DbqxjblKCEOTfFnVuXnCD3tiEE/kdX+piZocaEwUMm9IL
O0JJ1O1vNvkrcGAlmaap15NDaQPzrJ8es7kMMAYu6EEirk6oPXY6rqLILW4aPxD2
rg0/uY9zNexarC3ZIl9WBmPDzofl8g==
=B2O8
-----END PGP SIGNATURE-----

--cuhfgoruzxcaordz--
