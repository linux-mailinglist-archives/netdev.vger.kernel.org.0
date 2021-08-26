Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6693E3F8319
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 09:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240087AbhHZH1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 03:27:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59498 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238975AbhHZH1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 03:27:09 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 564CC2016B;
        Thu, 26 Aug 2021 07:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629962782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2tHgLhrt84gRdZjfUEE7NiZfbx+Qebm4AzYlsWwxbBU=;
        b=z3IqUen/t8j08JAyK0jU90NXoJznle9uwfVVdYaqQjd4ApVMhe4Sr/d7XzYNgcoxm1hh4t
        li7sRMDu6rNxJ5Y2dLcid2YNR+WY598gYQoHauIT5/NNW6CnJONBJzony0UbIPWbZf5VHI
        9qRHR5my4b4NzmTo8MQYmNpv8wj49ko=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629962782;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2tHgLhrt84gRdZjfUEE7NiZfbx+Qebm4AzYlsWwxbBU=;
        b=aCrsre8VDMkwclnL0DU+mHLI5KqX1NQe5WoS/ay9qjvcUHf8+KUPF2fccGvbG+Tf7QQ/Yf
        milihvdB5V1FphDg==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn2.prg.suse.de [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D30F6A3B89;
        Thu, 26 Aug 2021 07:26:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1BB56603F6; Thu, 26 Aug 2021 09:26:18 +0200 (CEST)
Date:   Thu, 26 Aug 2021 09:26:18 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        amitc@mellanox.com, idosch@idosch.org, danieller@nvidia.com,
        netdev@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Subject: Re: [PATCH net-next 1/5] ethtool: add support to set/get tx spare
 buf size
Message-ID: <20210826072618.2lu6spapkzdcuhyv@lion.mk-sys.cz>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
 <1629873655-51539-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="h7lueuhy5quh57zt"
Content-Disposition: inline
In-Reply-To: <1629873655-51539-2-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--h7lueuhy5quh57zt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 25, 2021 at 02:40:51PM +0800, Guangbin Huang wrote:
> From: Hao Chen <chenhao288@hisilicon.com>
>=20
> Add support for ethtool to set/get tx spare buf size.
>=20
> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  include/uapi/linux/ethtool.h | 1 +
>  net/ethtool/ioctl.c          | 1 +
>  2 files changed, 2 insertions(+)
>=20
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
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index f2abc3152888..9fc801298fde 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2377,6 +2377,7 @@ static int ethtool_tunable_valid(const struct ethto=
ol_tunable *tuna)
>  	switch (tuna->id) {
>  	case ETHTOOL_RX_COPYBREAK:
>  	case ETHTOOL_TX_COPYBREAK:
> +	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
>  		if (tuna->len !=3D sizeof(u32) ||
>  		    tuna->type_id !=3D ETHTOOL_TUNABLE_U32)
>  			return -EINVAL;
> --=20
> 2.8.1
>=20

IMHO this illustrates quite well what I had in mind some time ago when
I expressed my doubts if the concept of tunables in this form still
makes sense as the main benefit - workaround for lack of extensibility
of the ioctl interface - is gone. With this patch, 3 out of 4 tunables
are related to copybreak and it would IMHO make sense to group them
together as attributes of a new message and ethtool subcommand.
Configuration of header split could also belong there when/if
implemented.

Michal

--h7lueuhy5quh57zt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmEnQhMACgkQ538sG/LR
dpWGmwf/VTga2fgR96S/MytJOhH1y4G9cHncJ8CWBTsE1+CltSo6kXXbR9PrHqw8
sWr+Gk5E7vbHDPgR+xu6KvIAO/DpyHc2wboeBsCUPmLmaiel1KhID0Nb2hyOcVgZ
gdrBnaNftcIWGcUmu3WrV8szoVzUSuq/wXSEaLjrn2ikw4rDvel/8Ugdf6CBCn6a
n1COjehiXjrta3vDNAjSDlTXgn8knxsSLGh87mxddafFr2KvpNab+ARL6YxOwHfy
EnDuzLhlmhY3+WiYgwuDzrepypJvoAj0t8dxsgvoDkc2G7lBgMYcdL05sIiSChfL
uVohLQWbWXBLdnyguBaxEf/IlkHTyA==
=UYjg
-----END PGP SIGNATURE-----

--h7lueuhy5quh57zt--
