Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF4D215065
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgGEXpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 19:45:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:59404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgGEXpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 19:45:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D3EBDACF0;
        Sun,  5 Jul 2020 23:45:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 20E48602E3; Mon,  6 Jul 2020 01:45:51 +0200 (CEST)
Date:   Mon, 6 Jul 2020 01:45:51 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     netdev@vger.kernel.org, o.rempel@pengutronix.de, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com
Subject: Re: [PATCH ethtool v2 0/3] Add extended link state
Message-ID: <20200705234551.l23rujrtb4klkvgw@lion.mk-sys.cz>
References: <20200702131111.23105-1-amitc@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ng4rfy4yarfccjlk"
Content-Disposition: inline
In-Reply-To: <20200702131111.23105-1-amitc@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ng4rfy4yarfccjlk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 02, 2020 at 04:11:08PM +0300, Amit Cohen wrote:
> Currently, device drivers can only indicate to user space if the network
> link is up or down, without additional information.
>=20
> This patch set expand link-state to allow these drivers to expose more
> information to user space about the link state. The information can save
> users' time when trying to understand why a link is not operationally up,
> for example.
>=20
> The above is achieved by extending the existing ethtool LINKSTATE_GET
> command with attributes that carry the extended state.
>=20
> For example, no link due to missing cable:
>=20
> $ ethtool ethX
> ...
> Link detected: no (No cable)
>=20
> Beside the general extended state, drivers can pass additional
> information about the link state using the sub-state field. For example:
>=20
> $ ethtool ethX
> ...
> Link detected: no (Autoneg, No partner detected)
>=20
> Changes since v1:
>=20
> * Do not mix uapi header updates with other changes
> * Update header files in uapi/ to a net-next snapshot
> * Move helper functions from common.c to netlink/settings.c
> * Use string tables for enum strings
> * Report the numeric value in case of unknown value
> * Use banner once, change print concept

Applied to branch next (to be merged after 5.8 release), thank you.

Michal

> Amit Cohen (3):
>   uapi: linux: update kernel UAPI header files
>   netlink: desc-ethtool.c: Add descriptions of extended state attributes
>   netlink: settings: expand linkstate_reply_cb() to support link
>     extended state
>=20
>  netlink/desc-ethtool.c       |   2 +
>  netlink/settings.c           | 147 ++++++++++++++++++++++++++++++++++-
>  uapi/linux/ethtool.h         |  70 +++++++++++++++++
>  uapi/linux/ethtool_netlink.h |   2 +
>  4 files changed, 220 insertions(+), 1 deletion(-)
>=20
> --=20
> 2.20.1
>=20

--ng4rfy4yarfccjlk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8CZi4ACgkQ538sG/LR
dpUeDgf/QfzgjMSeKduROKCJW0dMNJlzrKXmou13Ljog5E3NjnQrPEEcRuj01JyK
dA0Zm4+mGvT2wNfRqHyvEdupCUw+NFzETATWvq8kMVwu3xn2s4zJ1kV+c3zoUryZ
L3HekfiAouxe3qnbjHx8Hyvo6QmaG1XAlHGgHIGzYK2J9s+0qP+zNsCboEjTb4nW
ayNAXDXh/XzyYesapquRQ2FQtqk8ALydNUvASSKauuxgN7CeZtU0fq1v5q9WlM4K
fV4LH6lGX4VM4RZWBANX/kZiZtsbrJfXV8zMMi4WyzukcHWC3NQVD1Pe/+Nh7eho
kPrW7oVYyMCP2DVCUWhjdJ+26rh5/Q==
=o3NE
-----END PGP SIGNATURE-----

--ng4rfy4yarfccjlk--
