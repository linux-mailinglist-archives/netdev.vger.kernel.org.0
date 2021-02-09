Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489B9315787
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhBIULT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:11:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:44604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233799AbhBITyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:54:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C6CA1ADDB;
        Tue,  9 Feb 2021 19:34:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8F42B60573; Tue,  9 Feb 2021 20:34:38 +0100 (CET)
Date:   Tue, 9 Feb 2021 20:34:38 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH ethtool v2 0/5] Extend uAPI with lanes parameter
Message-ID: <20210209193438.lv45lpljgea5zlk4@lion.mk-sys.cz>
References: <20210202182513.325864-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="nhtosfgtebghhht2"
Content-Disposition: inline
In-Reply-To: <20210202182513.325864-1-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nhtosfgtebghhht2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 08:25:08PM +0200, Danielle Ratson wrote:
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
> Danielle Ratson (5):
>   ethtool: Extend ethtool link modes settings uAPI with lanes
>   netlink: settings: Add netlink support for lanes parameter
>   netlink: settings: Expose the number of lanes in use
>   shell-completion: Add completion for lanes
>   man: Add man page for setting lanes parameter
>=20
>  ethtool.8.in                  |  4 ++++
>  ethtool.c                     |  1 +
>  netlink/desc-ethtool.c        |  1 +
>  netlink/settings.c            | 14 ++++++++++++++
>  shell-completion/bash/ethtool |  4 ++++
>  uapi/linux/ethtool_netlink.h  |  1 +
>  6 files changed, 25 insertions(+)

Sorry for the delay, I was busy with other stuff last week and missed
that with kernel part accepted, I should take care of the userspace
counterpart.

The series looks good to me, except for two minor issues I'll comment to
relevant patches.

Michal

--nhtosfgtebghhht2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmAi48kACgkQ538sG/LR
dpWUeggAgIIMDhklx86BUBbpfJ+FjIJDSB1qmkhU3v1SsvoxeC1D1QvlZcwL++2A
Qg2/2Uj4g96IIT5Rv5gvBVR6mT01HZ4ewPsWsBthSd6yyfrSWhb3woI/ecqEBGlQ
YRUyl6s0E2L74qhRQ5+eOYzL8qRvUknclrCKzxuZqvW+SNQm7/grgacFk59FuIXg
Rf8dB0op6zu7TzvGQgFgsu+01X8Zu7Su5dZn7WgD0PUO+r6xbRiW4FP1Hi1O/7iz
DSEQw9eBJ1LIwyvkP4SRTExwI0pFSoj1oKAC+i0ejUDKEjwkqE3WuofiSp6tvvhP
jRUnPJ2T8w2oddpC945SNpSMeGCbIw==
=BU52
-----END PGP SIGNATURE-----

--nhtosfgtebghhht2--
