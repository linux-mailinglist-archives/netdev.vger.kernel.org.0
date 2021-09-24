Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82090417E17
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbhIXXPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:15:37 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33888 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245569AbhIXXPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:15:36 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 75F4622487;
        Fri, 24 Sep 2021 23:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632525241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ftKH3Meg+rHTHxrerz6jLZXFoYb96A6HHtnJeYJJeg=;
        b=bn/gV4Wx1vodeT8XvPLbHCOE7HDzUrIFLX1d0k3gLt32OKN90Q1Nzwsr0YrIRrHZknIqju
        XnKdXTqh7I3Nyn3GeVR/4oF+00pq5FCF870JaxzSzjTlw6OqEX0ZbnC2AZwqo6AF7Gtbth
        gwJMlyjHuk3IFqvobpXZJPSQ7vO6MyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632525241;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ftKH3Meg+rHTHxrerz6jLZXFoYb96A6HHtnJeYJJeg=;
        b=m9SWKqvq6tlBMsmEX7YRA41f8EjgRxgGf6nxtnGkJJYcoXeLYBQgnJ3nmUq9Km8s2//vuI
        Xk4ExkqLo56r59BA==
Received: from lion.mk-sys.cz (unknown [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 5244325D44;
        Fri, 24 Sep 2021 23:14:00 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id C4C84603FF; Sat, 25 Sep 2021 01:14:00 +0200 (CEST)
Date:   Sat, 25 Sep 2021 01:14:00 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, saeedb@amazon.com,
        chris.snook@gmail.com, ulli.kroll@googlemail.com,
        linus.walleij@linaro.org, jeroendb@google.com, csully@google.com,
        awogbemila@google.com, jdmason@kudzu.us, rain.1986.08.12@gmail.com,
        zyjzyj2000@gmail.com, kys@microsoft.com, haiyangz@microsoft.com,
        mst@redhat.com, jasowang@redhat.com, doshir@vmware.com,
        pv-drivers@vmware.com, jwi@linux.ibm.com, kgraul@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V2 net-next 3/6] ethtool: add support to set/get rx buf
 len via ethtool
Message-ID: <20210924231400.aettgmbwx6m4pdok@lion.mk-sys.cz>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
 <20210924142959.7798-4-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5tlrcpiss2xqxqsp"
Content-Disposition: inline
In-Reply-To: <20210924142959.7798-4-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5tlrcpiss2xqxqsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 24, 2021 at 10:29:56PM +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
>=20
> Add support to set rx buf len via ethtool -G parameter and get
> rx buf len via ethtool -g parameter.
>=20
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  Documentation/networking/ethtool-netlink.rst |  2 ++
>  include/linux/ethtool.h                      | 18 ++++++++++++++++--
>  include/uapi/linux/ethtool.h                 |  8 ++++++++
>  include/uapi/linux/ethtool_netlink.h         |  1 +
>  net/ethtool/netlink.h                        |  2 +-
>  net/ethtool/rings.c                          | 17 ++++++++++++++++-
>  6 files changed, 44 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index a47b0255aaf9..9734b7c1e05d 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -841,6 +841,7 @@ Kernel response contents:
>    ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
>    ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
>    ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the r=
ing
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> =20
> @@ -857,6 +858,7 @@ Request contents:
>    ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
>    ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
>    ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the r=
ing
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  Kernel checks that requested ring sizes do not exceed limits reported by

Would it make sense to let driver report also maximum supported value
like it does for existing ring parameters (ring sizes)?

Michal

--5tlrcpiss2xqxqsp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmFOW7MACgkQ538sG/LR
dpUaZAgAwk2KWH0eA5QIm+danLzNaAPBPB53CjHmCJD44vHgdniatWE2N306ob4N
x9FOkGdjeiUe0o44BSxySUeqxOsXL1TgLbcByQRibdrota79jTOMm2ggNr1kAk+/
OeCslVmVbiq/iG/RDxknwZaun+bGpSSlMFdWf72ES074StU3zdBzVuBoZetv5ZX6
im0nBFN5WFwkaZ6Bd80t1mFNDZ1PR9FqH/7WA07t73Cj0qJSkH/rRNxyANmpJjxW
D5HQ0nfB6ZxctVF2gcu4futcEMDZk9emb5qD0HysAfscYh+DR1RrOCk8X5QSodva
mRVlHTxp6xUvpaJczXfEQlI6a/34nQ==
=fa0B
-----END PGP SIGNATURE-----

--5tlrcpiss2xqxqsp--
