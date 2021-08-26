Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AEC3F84BA
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhHZJqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 05:46:21 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54130 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbhHZJqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 05:46:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8DB491FE6C;
        Thu, 26 Aug 2021 09:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629971132; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2atUv5vEag2HCQOkDlj47aAmdp/mgyP2yvG1LRSYxGE=;
        b=ql72lb8aMx6dIQFz2QyRoQocdqrWJPOcTHMf0MRz84gZ2ykWuAHXkqNhXKWcvxxf8dAZac
        zIghAtm0y3ZWMaiWMZ5wGlzcX8AmgqZzQDUryhO781/oSrMDHjEAQXdtF4NfNL4w/YYSOP
        vH/H3OOzZbaSMgKQ3zLy7KNFNGpMivM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629971132;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2atUv5vEag2HCQOkDlj47aAmdp/mgyP2yvG1LRSYxGE=;
        b=c/tVIBaAq/e0gF3GVJSnu+1BZA8Rzr9Mhp5NgYr09AR0hv826MubFjv/nRgF25v4GD6QYr
        O55Tee19RzH2OCCA==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 48235A3B91;
        Thu, 26 Aug 2021 09:45:32 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2A964603F6; Thu, 26 Aug 2021 11:45:30 +0200 (CEST)
Date:   Thu, 26 Aug 2021 11:45:30 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitc@mellanox.com,
        idosch@idosch.org, andrew@lunn.ch, o.rempel@pengutronix.de,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        netdev@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH V2 ethtool-next 1/2] update UAPI header copies
Message-ID: <20210826094530.x4m3pvkuvtorwz6d@lion.mk-sys.cz>
References: <1629877513-23501-1-git-send-email-huangguangbin2@huawei.com>
 <1629877513-23501-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iruwmubuahyozzfj"
Content-Disposition: inline
In-Reply-To: <1629877513-23501-2-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iruwmubuahyozzfj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 25, 2021 at 03:45:12PM +0800, Guangbin Huang wrote:
> Update to kernel commit 5b4ecc3d4c4a.
>=20
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  uapi/linux/ethtool.h | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> index c6ec1111ffa3..bd1f09b23cf5 100644
> --- a/uapi/linux/ethtool.h
> +++ b/uapi/linux/ethtool.h
> @@ -637,6 +637,8 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
>  enum ethtool_link_ext_substate_bad_signal_integrity {
>  	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS =3D 1,
>  	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST,
> +	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS,
>  };
> =20
>  /* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
> --=20
> 2.8.1
>=20

I replaced this commit with a full update of uapi headers. The point is
that if we keep cherry picking only specific changes in the headers, it
will become harder and harder to check if something is missing or if we
diverged from kernel. This is why an update of uapi headers should
always update all of them to the state of the same kernel commit
(usually current master or net-next tree).

I added the link to ethtool-import-uapi script to devel documentation on
the ethtool web page make things easier.

Michal

--iruwmubuahyozzfj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmEnYrMACgkQ538sG/LR
dpVEOAgAgeJFOzr1SiZMvvWRIjbAt4ffpEX7qFFuPaCMKZ5d1ftf9QQ/nfVNiWhP
GE4OPP0rkLJ3Wg41P9Su85+o0rZndNdPmK0wTc9vBKVVuagchiyuE17qJtD0q+dx
8/afSDMlXdf/pW5xVihxUDX3Y6lq1Vq5yPskN+kIOrz+0i+texv1FhIZy8TH8Ok7
jUFHAhUvnoAjVGDCHhzQUQmU3Qcn6NcPfEFAOYbR0lrFyRidaluoxxRFD2b54nNS
55cmClehyDyvAwpP589Oi6dy057lPtWWQYWGfrfw7NV2rZstNCR5spinex5F4HYX
ls883WA77ggz5XG4JuNV50IAF5mM0w==
=Acmp
-----END PGP SIGNATURE-----

--iruwmubuahyozzfj--
