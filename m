Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FDE3F67F9
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242100AbhHXRjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:39:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49370 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241343AbhHXRhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:37:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C6DE2220FC;
        Tue, 24 Aug 2021 17:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1629826574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M8Onpp9sd6nINjjS7fypRmQwJX7oYnMUIBtqtDjiGJQ=;
        b=gAk/AcOZQUqil4ulHVwmLyRENsXEtQcWr7xuPu1ckXHiFGg1eTUU1cIUezR+mTiUzCWhhd
        L1yDeC4HFj3EEwLkyn80jpeBAsJBbNIMO8a00pIZoFlw4TMwtzzqVuLS0TfbkoHy8cUSxw
        wBglYqTzqaV3+mwii5VmTOud9qaNA8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1629826574;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M8Onpp9sd6nINjjS7fypRmQwJX7oYnMUIBtqtDjiGJQ=;
        b=pNavi2EJjL/czon1+iarHA9lTbfiZ+55tTcP1eP7seLyPC9/xKkZ5YQYX/OkOV0HbUemDQ
        m9w603LuYr4egLCQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6F78BA3BBC;
        Tue, 24 Aug 2021 17:36:14 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2C1B9603F6; Tue, 24 Aug 2021 19:36:14 +0200 (CEST)
Date:   Tue, 24 Aug 2021 19:36:14 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitc@mellanox.com,
        idosch@idosch.org, andrew@lunn.ch, o.rempel@pengutronix.de,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        netdev@vger.kernel.org, lipeng321@huawei.com
Subject: Re: [PATCH RESEND ethtool-next] netlink: settings: add two link
 extended substates of bad signal integrity
Message-ID: <20210824173614.mkv5i72sutxtdvrk@lion.mk-sys.cz>
References: <1629771291-31425-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jm4gttuytbiaj4yb"
Content-Disposition: inline
In-Reply-To: <1629771291-31425-1-git-send-email-huangguangbin2@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jm4gttuytbiaj4yb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 24, 2021 at 10:14:51AM +0800, Guangbin Huang wrote:
> Add two link extended substates of bad signal integrity available in the
> kernel.
>=20
> ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST means the input
> external clock signal for SerDes is too weak or lost.
>=20
> ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS means the received signal for
> SerDes is too weak because analog loss of signal.
>=20
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  netlink/settings.c   | 4 ++++
>  uapi/linux/ethtool.h | 2 ++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/netlink/settings.c b/netlink/settings.c
> index e47a38f3058f..6d10a0703861 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -639,6 +639,10 @@ static const char *const names_bad_signal_integrity_=
link_ext_substate[] =3D {
>  		"Large number of physical errors",
>  	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE]		=3D
>  		"Unsupported rate",
> +	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST]	=3D
> +		"Serdes reference clock lost",
> +	[ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS]			=3D
> +		"Serdes ALOS",
>  };
> =20
>  static const char *const names_cable_issue_link_ext_substate[] =3D {
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

Please split the uapi header update into a separate patch and update all
headers to a specific commit (preferrably current net-next head) as
described in the last section of

  https://www.kernel.org/pub/software/network/ethtool/devel.html

The patch looks good otherwise.

Michal

--jm4gttuytbiaj4yb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmElLggACgkQ538sG/LR
dpUYswgAiryTWu/K1dyVeTlS0dvOmdc1vRf9gvpwRH4n2GkMEPOKIJjXk9bAQP/2
GlfrwEglwFMV4UPtj1vw/t32n2jVQ5EgKKvXZqa42xQBwU+n5LG1FmRbpCCi01Em
GcSkTJpGc1oRSJmXlyTfXUdRXeC+pmHczRtK8AOxD3pkk+8yfwa1EmROjisLetht
D4NujtWTAeiUh3ELbW7rzIcR6s03/n25CEhfyvrI5JKe25Uw0wmLNuUiG7g5uF4c
cK4nEl/GH24PArSdGQfdaB0wTTkcykpjyOH0ewVyvDQge53WC4gSlJGGb1epbk9R
une+MnS0ie7maIWlTC3pUzrdAOJ+Uw==
=/3mn
-----END PGP SIGNATURE-----

--jm4gttuytbiaj4yb--
