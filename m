Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F4F370F49
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 23:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhEBVRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 17:17:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:44676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232492AbhEBVRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 17:17:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4A70CB20E;
        Sun,  2 May 2021 21:16:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 218DA607D7; Sun,  2 May 2021 23:16:15 +0200 (CEST)
Date:   Sun, 2 May 2021 23:16:15 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, idosch@idosch.org
Subject: Re: [PATCH ethtool-next v2 1/7] update UAPI header copies
Message-ID: <20210502211615.diirz64l2rhudeh6@lion.mk-sys.cz>
References: <20210422154050.3339628-1-kuba@kernel.org>
 <20210422154050.3339628-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6cxhcn6mateida5i"
Content-Disposition: inline
In-Reply-To: <20210422154050.3339628-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6cxhcn6mateida5i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 22, 2021 at 08:40:44AM -0700, Jakub Kicinski wrote:
> Update to kernel commit 6ecaf81d4ac6.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  uapi/linux/ethtool.h         | 109 ++++++++++++++------
>  uapi/linux/ethtool_netlink.h | 187 +++++++++++++++++++++++++++++++++++
>  uapi/linux/rtnetlink.h       |  13 +++
>  3 files changed, 277 insertions(+), 32 deletions(-)

There should be also a change in uapi/linux/if_link.h (diff below).

Michal

diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index c96880c51c93..50193377e5e4 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -809,7 +809,6 @@ enum {
 	IFLA_GTP_FD1,
 	IFLA_GTP_PDP_HASHSIZE,
 	IFLA_GTP_ROLE,
-	IFLA_GTP_COLLECT_METADATA,
 	__IFLA_GTP_MAX,
 };
 #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)

--6cxhcn6mateida5i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmCPFpkACgkQ538sG/LR
dpXhMwf/SWpkX1bXo7kCfguYT2hiR1r9RT6r6HLywgTyY/+FI7eQhR9/16WrOMVR
BNfqzM49f9LHc9aLyMEW+jXBvlwj9vPw9YLcloIFkBbgIIp9MxEGvHLwZOX8G/UK
m9o/zy+DqvMfLbkWMndzokuWCU0l0e/uZ+RdYJrJoQNQeGLTE+T3Lr6YDO20gsfI
6LnyZIxlLv0GEzr/bqchDX5ruM0feNzCGD2HafjeMfNQF5e+ncMek5jm7VLIbNOY
bautEGINso3I/o4OGTtJjdQ1P48HSjX33tWz2wrneO/KikMSA1ydUph2kDYUGday
ZnL+dg8E/PSNHKk288WLn5UXVdkUtA==
=lyp4
-----END PGP SIGNATURE-----

--6cxhcn6mateida5i--
