Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE197370F5F
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhEBVhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:37:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:52968 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhEBVhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 17:37:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4962DB02D;
        Sun,  2 May 2021 21:36:40 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1BE1B607D7; Sun,  2 May 2021 23:36:40 +0200 (CEST)
Date:   Sun, 2 May 2021 23:36:40 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH ethtool-next v2 7/7] netlink: stats: add on --all-groups
 option
Message-ID: <20210502213640.lqykslgktlvjpaa5@lion.mk-sys.cz>
References: <20210422154050.3339628-1-kuba@kernel.org>
 <20210422154050.3339628-8-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pup3mtzjftpxv73x"
Content-Disposition: inline
In-Reply-To: <20210422154050.3339628-8-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pup3mtzjftpxv73x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 22, 2021 at 08:40:50AM -0700, Jakub Kicinski wrote:
> Subject: [PATCH ethtool-next v2 7/7] netlink: stats: add on --all-groups =
option

"on" should be "an" here?

> Add a switch for querying all statistic groups available
> in the kernel.
>=20
> To reject --groups and --all-groups being specified
> for one request add a concept of "parameter equivalency"

I like the idea but the term "equivalency" may be a bit misleading.
Maybe "alternatives" would express the relation better.

Michal

--pup3mtzjftpxv73x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmCPG2MACgkQ538sG/LR
dpWQiAf+PC8HTjPncuCiRs6Qj1wdJkY3ut2CNy+4eKuE01NfjPbH/st9uXd8+bLg
JQNdZnmxGVZ+mZI+xb3cgWhIlZn2fxvjFi/GSZBhBcLJvpssCKpjvec73kJgZgfg
1TTGVV1i0Gl0PtICBLYOAJgho0LBPqNopdCfaKluBpGYtZL59T6BzD/nmCdQDhnY
bmMLCaLOkVDdJe5lN082z/fWMJ0ow3yPcGq48fXb1v5XFj2VrHcFDbbd04RWH4sJ
c4LfuKjTyuOozB8hd1R1BOlOSicoeKedDw9AFOyVGIVXZY/4XCDY4Cy4188P7leI
FMew5Mpz++xjhnwPNK5mYxnqTfSbFg==
=YA1G
-----END PGP SIGNATURE-----

--pup3mtzjftpxv73x--
