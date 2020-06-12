Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D451F7890
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 15:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFLNKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 09:10:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:33958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgFLNKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 09:10:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88582AD46;
        Fri, 12 Jun 2020 13:10:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 020EE60739; Fri, 12 Jun 2020 15:10:31 +0200 (CEST)
Date:   Fri, 12 Jun 2020 15:10:31 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>,
        Amit Cohen <amitc@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v4 0/3] Add support for SQI and master-slave
Message-ID: <20200612131031.pwzz24xybl3e2qug@lion.mk-sys.cz>
References: <20200610083744.21322-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jp7kzxckg7nmaaqr"
Content-Disposition: inline
In-Reply-To: <20200610083744.21322-1-o.rempel@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jp7kzxckg7nmaaqr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 10, 2020 at 10:37:41AM +0200, Oleksij Rempel wrote:
> This patch set is extending ethtool to make it more usable on automotive
> PHYs like NXP TJA11XX.
>=20
> They make use of new KAPI (currently in net-next, will go probably to the
> kernel 5.8-rc1):
> - PHY master-slave role configuration and status informaton. Mostly needed
>   for 100Base-T1 PHYs due the lack of autonegatiation support.
> - Signal Quality Index to investigate cable related issues.
>=20
> changes v4:
> - rebase is against current ethtool master
> - pull headers from current kernel master
> - use tabs instead of spaces in the manual
>=20
> changes v3:
> - rename "Port mode" to "master-slave"
> - use [preferred|forced]-[master|slave] for information and
>   configuration
>=20
> changes v2:
> - add master-slave information to the "ethtool --help" and man page
> - move KAPI update changes to the separate patch.=20
>=20
> Oleksij Rempel (3):
>   update UAPI header copies
>   netlink: add master/slave configuration support
>   netlink: add LINKSTATE SQI support
>=20
>  ethtool.8.in                 |  19 +++++
>  ethtool.c                    |   1 +
>  netlink/desc-ethtool.c       |   4 +
>  netlink/settings.c           |  66 +++++++++++++++
>  uapi/linux/ethtool.h         |  16 +++-
>  uapi/linux/ethtool_netlink.h | 153 ++++++++++++++++++++++++++++++++++-
>  uapi/linux/genetlink.h       |   2 +
>  uapi/linux/if_link.h         |   1 +
>  uapi/linux/netlink.h         | 103 +++++++++++++++++++++++
>  uapi/linux/rtnetlink.h       |   6 ++
>  10 files changed, 369 insertions(+), 2 deletions(-)
>=20

Series applied, thank you.

In the future, please use "ethtool" in subject prefix (e.g.
"[PATCH ethtool v4]") to distinguish ethtool patches from kernel ones.

Michal

--jp7kzxckg7nmaaqr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7jfscACgkQ538sG/LR
dpXI5wf/d7Hwy4j2NW12es9l2sz+mIgJsPz/t7zJUU2IrfKZ25Kn/zY4P8L4ykHh
bH6hHcvbvDKu0o18zklKgoTXNw4iP2p/xhUvJjegMCWuzLkIjpRGEIdLL6osiUxq
DAsOEbXij3LFtOhlsAq97j6TA7Q9Xf4THVIi1z0mPXWevcL8YN0lsUOfrCHDS4tt
0bE8LwrvitQjeD6eR0xRm/i2pGib/bYb/mUaZ5ueBgzuiggbhj3vTOXTfKb18gRP
EUX3BtJvM1g0NPtggolaKg8lGPA3hZ8X+beFMVc+d++I8muS40UH5ybuvO6znvol
AwCpEm2pbumRMRgOgn/RBt3k4v99Sg==
=RwD/
-----END PGP SIGNATURE-----

--jp7kzxckg7nmaaqr--
