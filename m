Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1E4370F62
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhEBVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:40:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:54266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232405AbhEBVkZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 17:40:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 89781B03E;
        Sun,  2 May 2021 21:39:31 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5FFCC607D7; Sun,  2 May 2021 23:39:31 +0200 (CEST)
Date:   Sun, 2 May 2021 23:39:31 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [PATCH ethtool-next v2 5/7] ethtool: add nlchk for redirecting
 to netlink
Message-ID: <20210502213931.iqb6zyn6nlkiy7ke@lion.mk-sys.cz>
References: <20210422154050.3339628-1-kuba@kernel.org>
 <20210422154050.3339628-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bureglb6sggk5svx"
Content-Disposition: inline
In-Reply-To: <20210422154050.3339628-6-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bureglb6sggk5svx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 22, 2021 at 08:40:48AM -0700, Jakub Kicinski wrote:
> To support commands which differ from the ioctl implementation
> add a new callback which can check if the arguments on the command
> line indicate that the request should be sent over netlink.
> The decision should be inferred from the arguments, rather
> than an explicit --netlink argument.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

This breaks build with --disable-netlink, the !ETHTOOL_ENABLE_NETLINK
version of netlink_run_handler() needs to be updated as well.

Other than this and the two minor nitpicks, the series looks good to me.

Michal

--bureglb6sggk5svx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmCPHA0ACgkQ538sG/LR
dpVnWQgAye4TkbCiQvNLjIoL/am/DIQKpmA426GUYP3wa4LpByYZLaVuFOqlL5YZ
epoqHMrTSnw1VZOlvTyeW200AR8AIb1hxuqolX8NBAIXTB1iw8uxa7GPCvjJMUdC
8HJdWaeM8hA3A+uHuNTM06tl/f2uOOfDhfe/yKNKhhmRQOx6zP4OQdDNozciSywp
ZfwRWMndAIo1xJQIWmny96S5mEYIlfwTeByVlHPsV+ZGL5RvEWLN2hBF/46J1UZy
P1yRUwXcrzLhh5wlEAvVklK7tBILUC0xBmkS/QbhGb6vT7rnp5gACLjrhxZ3JLBC
KfeZyOeNfNPst9up1IbBT8NYyG5NnA==
=Htck
-----END PGP SIGNATURE-----

--bureglb6sggk5svx--
