Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD6F315747
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhBIT4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 14:56:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:37886 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhBITlj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 14:41:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4B882AD24;
        Tue,  9 Feb 2021 19:40:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 11FA460573; Tue,  9 Feb 2021 20:40:20 +0100 (CET)
Date:   Tue, 9 Feb 2021 20:40:20 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH ethtool v2 1/5] ethtool: Extend ethtool link modes
 settings uAPI with lanes
Message-ID: <20210209194020.a7yjjd6hxj33l6ld@lion.mk-sys.cz>
References: <20210202182513.325864-1-danieller@nvidia.com>
 <20210202182513.325864-2-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gmj6d6mgliwdas4c"
Content-Disposition: inline
In-Reply-To: <20210202182513.325864-2-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--gmj6d6mgliwdas4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 08:25:09PM +0200, Danielle Ratson wrote:
> Add ETHTOOL_A_LINKMODES_LANES, expand ethtool_link_settings with
> lanes attribute and define valid lanes in order to support a new
> lanes-selector.
>=20
> Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> ---

When updating the UAPI header copies, please do it in a separate commit
which updates the whole uapi/ subdirectory to the state of a specific
kernel commit. You can use the script at

  https://www.kernel.org/pub/software/network/ethtool/ethtool-import-uapi

It expects the LINUX_GIT environment variable to point to your local git
repository with kernel tree and takes one argument identifying the
commit you want to import the uapi headers from (commit id, tag or
branch name can be used). In your case, net-next would be the most
likely choice.

Michal

> Notes:
>     v2:
>     	* Update headers after changes in upstream patches.
>=20
>  netlink/desc-ethtool.c       | 1 +
>  uapi/linux/ethtool_netlink.h | 1 +
>  2 files changed, 2 insertions(+)
>=20
> diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
> index 96291b9..fe5d7ba 100644
> --- a/netlink/desc-ethtool.c
> +++ b/netlink/desc-ethtool.c
> @@ -87,6 +87,7 @@ static const struct pretty_nla_desc __linkmodes_desc[] =
=3D {
>  	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_DUPLEX),
>  	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG),
>  	NLATTR_DESC_U8(ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE),
> +	NLATTR_DESC_U32(ETHTOOL_A_LINKMODES_LANES),
>  };
> =20
>  static const struct pretty_nla_desc __linkstate_desc[] =3D {
> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
> index c022883..0cd6906 100644
> --- a/uapi/linux/ethtool_netlink.h
> +++ b/uapi/linux/ethtool_netlink.h
> @@ -227,6 +227,7 @@ enum {
>  	ETHTOOL_A_LINKMODES_DUPLEX,		/* u8 */
>  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,	/* u8 */
>  	ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,	/* u8 */
> +	ETHTOOL_A_LINKMODES_LANES,		/* u32 */
> =20
>  	/* add new constants above here */
>  	__ETHTOOL_A_LINKMODES_CNT,
> --=20
> 2.26.2
>=20

--gmj6d6mgliwdas4c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmAi5R4ACgkQ538sG/LR
dpU+eAf/YeQur0sKEiCEqXCvQbrw1XPmHm0pGrjsJDUzU7oce6kJ27qxt0wz08H2
sclxFHHWJEDAfFJ93WwYAtB8rG9Zg52eFp54cY0ns+a6kli1yDNsHVOqxq3/qJSU
SYrmYnAAEYFdwjN1o7Yq+CX/UP8G08JH0Yw3ZGHo8RbraYhZ/L4mAuU2dqsrEXsi
1cJofgGRMDEPUOy+PsYpZhhHDEmqcoDXRamRwRO2YpYtmbw7a0HTCD9GhTbH9gxF
8GZ3QPqvjV4J51YHlGeQpeD05k/PU+TW69oClx+7CXPilUUvKoOMOOWuP5uo7yZX
h7wWOCwIr9hhJx24fLOBFAMsCkG1/Q==
=GY9c
-----END PGP SIGNATURE-----

--gmj6d6mgliwdas4c--
