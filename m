Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3295417E0B
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346082AbhIXXHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:07:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33460 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhIXXHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:07:13 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out1.suse.de (Postfix) with ESMTP id 19D2822485;
        Fri, 24 Sep 2021 23:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1632524739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v5l1kaPp35Y5W/y7AZQc7cQWshELlNyiKrEL/9tCSMM=;
        b=UvIWIkW3eLeS+LC97CslpHWXVscCPzhGvLX0O2te9Z2hQ6CdTTEFrI7bWAazDR4m/D2rOF
        Jmo1jIFxsmqoDQFHpeC58OGvKrF3Xq3dxoNHej2Q65ukw3uHt1JLUcx+76PLklUIth1fky
        rpYv/YTestRF3IT12QNvlycNypJYmhg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1632524739;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v5l1kaPp35Y5W/y7AZQc7cQWshELlNyiKrEL/9tCSMM=;
        b=dwIosLCOVwtw/GSit/19vYUt1NK/wtLY1hcOzn4JtzY18xkqHyalqTEBuvUhaZ2hZUZs0d
        PGgMkO77f+oU6CCA==
Received: from lion.mk-sys.cz (unknown [10.100.225.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id D496525D4A;
        Fri, 24 Sep 2021 23:05:37 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 8B06A603FF; Sat, 25 Sep 2021 01:05:37 +0200 (CEST)
Date:   Sat, 25 Sep 2021 01:05:37 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        netanel@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        saeedb@amazon.com, chris.snook@gmail.com,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        jeroendb@google.com, csully@google.com, awogbemila@google.com,
        jdmason@kudzu.us, rain.1986.08.12@gmail.com, zyjzyj2000@gmail.com,
        kys@microsoft.com, haiyangz@microsoft.com, mst@redhat.com,
        jasowang@redhat.com, doshir@vmware.com, pv-drivers@vmware.com,
        jwi@linux.ibm.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, johannes@sipsolutions.net,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH V2 net-next 1/6] ethtool: add support to set/get tx
 copybreak buf size via ethtool
Message-ID: <20210924230537.cxiopoi3mwlpgx5c@lion.mk-sys.cz>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
 <20210924142959.7798-2-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5wvzfnvubnajvh5h"
Content-Disposition: inline
In-Reply-To: <20210924142959.7798-2-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5wvzfnvubnajvh5h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 24, 2021 at 10:29:54PM +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
>=20
> Add support for ethtool to set/get tx copybreak buf size.
>=20
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  Documentation/networking/ethtool-netlink.rst | 24 ++++++++++++++++++++
>  include/uapi/linux/ethtool.h                 |  1 +
>  net/ethtool/common.c                         |  1 +
>  net/ethtool/ioctl.c                          |  1 +
>  4 files changed, 27 insertions(+)
>=20
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index d9b55b7a1a4d..a47b0255aaf9 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -1521,6 +1521,30 @@ Kernel response contents:
>    ``ETHTOOL_A_PHC_VCLOCKS_INDEX``       s32     PHC index array
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> +TUNABLE_SET
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_TX_COPYBREAK_BUF_SIZE``      u32     buf size for tx copybre=
ak
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Tx copybreak buf size is used for tx copybreak feature, the feature is u=
sed
> +for small size packet or frag. It adds a queue based tx shared bounce bu=
ffer
> +to memcpy the small packet when the len of xmitted skb is below tx_copyb=
reak
> +(value to distinguish small size and normal size), and reduce the overhe=
ad
> +of dma map and unmap when IOMMU is on.
> +
> +TUNABLE_GET
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_TX_COPYBREAK_BUF_SIZE``     u32     buf size for tx copybreak
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

I have to repeat my concerns expressed in

  https://lore.kernel.org/netdev/20210826072618.2lu6spapkzdcuhyv@lion.mk-sy=
s.cz

and earlier in more details in

  https://lore.kernel.org/netdev/20200325164958.GZ31519@unicorn.suse.cz

That being said, I don't understand why this patch adds description of
two new message types to the documentation of ethtool netlink API but it
does not actually add them to the API. Instead, it adds the new tunable
to ioctl API.

Michal

> +
>  Request translation
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index b6db6590baf0..266e95e4fb33 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -231,6 +231,7 @@ enum tunable_id {
>  	ETHTOOL_RX_COPYBREAK,
>  	ETHTOOL_TX_COPYBREAK,
>  	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
> +	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
>  	/*
>  	 * Add your fresh new tunable attribute above and remember to update
>  	 * tunable_strings[] in net/ethtool/common.c
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index c63e0739dc6a..0c5210015911 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -89,6 +89,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LE=
N] =3D {
>  	[ETHTOOL_RX_COPYBREAK]	=3D "rx-copybreak",
>  	[ETHTOOL_TX_COPYBREAK]	=3D "tx-copybreak",
>  	[ETHTOOL_PFC_PREVENTION_TOUT] =3D "pfc-prevention-tout",
> +	[ETHTOOL_TX_COPYBREAK_BUF_SIZE] =3D "tx-copybreak-buf-size",
>  };
> =20
>  const char
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 999e2a6bed13..a6600e361c34 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2381,6 +2381,7 @@ static int ethtool_tunable_valid(const struct ethto=
ol_tunable *tuna)
>  	switch (tuna->id) {
>  	case ETHTOOL_RX_COPYBREAK:
>  	case ETHTOOL_TX_COPYBREAK:
> +	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
>  		if (tuna->len !=3D sizeof(u32) ||
>  		    tuna->type_id !=3D ETHTOOL_TUNABLE_U32)
>  			return -EINVAL;
> --=20
> 2.33.0
>=20

--5wvzfnvubnajvh5h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmFOWbsACgkQ538sG/LR
dpWFMAf/YVxDwCQKjKdpDsrNeQkEvD+kQkrAxEZNDlUiKym/FDP98KqeHJeD1ZBy
lgDRX5cQqAni4wEwSgYMgplaO8W70D49d76jkIMIOBxZ77Ls44IRWEokEmji+j1H
FKj4wpzTCoB1QKNhfD884G7Jwb4yZezFr5SlfgdfR11eYDDwhwDx0W9oSYgOEM/x
Pp5wKDxYXhtEzSYtdCdtLvqOPKpD82Wog0lJLk2SH/LYOJp0o0egfvhodYANZHQU
LtSX/Ulj+ipKN+W5UjduPMVPuPZSI/qleIx/sh4kFjPz4VZJrpn5shAJoq00FUZt
imcxxyFTToRUUMu80vP80PSr1aSfhw==
=C8Zw
-----END PGP SIGNATURE-----

--5wvzfnvubnajvh5h--
