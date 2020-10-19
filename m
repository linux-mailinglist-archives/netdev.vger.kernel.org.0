Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD54829263A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 13:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgJSLLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 07:11:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:45808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgJSLLU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 07:11:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35BA5AC55;
        Mon, 19 Oct 2020 11:11:19 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EA37160563; Mon, 19 Oct 2020 13:11:18 +0200 (CEST)
Date:   Mon, 19 Oct 2020 13:11:18 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org
Subject: Re: [PATCH ethtool v3 0/7] pause frame stats
Message-ID: <20201019111118.g6uykflw57tevhqu@lion.mk-sys.cz>
References: <20201018213151.3450437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tntd5v4aoa4chghy"
Content-Disposition: inline
In-Reply-To: <20201018213151.3450437-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tntd5v4aoa4chghy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 18, 2020 at 02:31:44PM -0700, Jakub Kicinski wrote:
> Hi!
>=20
> Sorry about the delay from v2.

Actually, I'm rather surprised you were able to get back to this so
early, given the situation.

> This set adds support for pause frame statistics.
>=20
> First pause frame info is extended to support --json.
>=20
> Pause stats are first of this kind of statistics so add
> support for a new flag (--include-statistics).
>=20
> Next add support for dumping policy to check if the statistics
> flag is supported for a given subcommand.
>=20
> Last but not least - display statistics.
>=20
> v3:
>  - rename the ctx variable to policy_ctx
>  - instead of returning the flags policy save it to a member
>    of struct nl_context, for potential reuse. Also we don't
>    have to worry about returning flags and negative errors
>    from the read helper this way :)
>=20
> Jakub Kicinski (7):
>   update UAPI header copies
>   pause: add --json support
>   separate FLAGS out in -h
>   add support for stats in subcommands
>   netlink: prepare for more per-op info
>   netlink: use policy dumping to check if stats flag is supported
>   pause: add support for dumping statistics
>=20
>  ethtool.8.in           |   7 ++
>  ethtool.c              |  17 +++-
>  internal.h             |   1 +
>  netlink/coalesce.c     |   6 +-
>  netlink/msgbuff.h      |   6 ++
>  netlink/netlink.c      | 179 ++++++++++++++++++++++++++++++++++++++---
>  netlink/netlink.h      |  31 +++++--
>  netlink/pause.c        | 111 ++++++++++++++++++++++---
>  uapi/linux/genetlink.h |  11 +++
>  uapi/linux/netlink.h   |   4 +
>  10 files changed, 336 insertions(+), 37 deletions(-)

Series applied, thank you.

Michal

--tntd5v4aoa4chghy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+NdFIACgkQ538sG/LR
dpVjEwgApS28w90CYAWty5rIgXHpYQVQ6USQcOafCn6Ih/0tvPRW79g36jBjSYe4
gpvj42CatpqsmxsA4WWsXDFlk/KrX5zTT+JJAH7Q/vRsvOh9lABqzhvSw7AukOir
BlWQPBCuGUwZZN/MPkMWJqYDBGT00jPZ2oU6MbLJa2kuokju9yJ2m6YRXG7kTtQO
rkRZQ5xJq0uwEkbrgyGSS4lwk0jqcUskB7tb0iDWr2lOQthgqYP3d3Cq0x9bDPlx
ielCyDW9WwXVr2n8awDoEplC9iWYgaMc0GRBdyAPvAK0ZDWmO+P0aqyKbCcpkkQb
6RZ5y0BK/jmyb1LxF5fkv6w2K20LOQ==
=R4/I
-----END PGP SIGNATURE-----

--tntd5v4aoa4chghy--
