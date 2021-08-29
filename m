Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B63E3FAD5D
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbhH2RFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 13:05:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46170 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhH2RFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 13:05:10 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B12941FDB0;
        Sun, 29 Aug 2021 17:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630256656; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bLgQdzP6bhd67bN1DZe9rkZ0DYRzmF2k6+soDOEtgRM=;
        b=tBzjrgGfB1fKD2xYUDW9/X8wTMDxvMk7jozI0OmW9/OFSFAFfMTgY5UA+p+M2TlRPoLAYJ
        NS18bVoZqTTBJgebOAicEfMBNAYhoneCL0HR1do81c3NiqoGo3T/HEJpuSCu1geO4b5b4w
        JGDixFxjNJzyjUjN1QAyEADpmRx+JeE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630256656;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bLgQdzP6bhd67bN1DZe9rkZ0DYRzmF2k6+soDOEtgRM=;
        b=zbKAW/xPVH4XrPhah5ZTsWnTQTrxXGNY+f1zDGqZT5/y5bCxYMU1MtNfBYGPWUjeJsksEQ
        GwIzFvYTNQMpBiAw==
Received: from lion.mk-sys.cz (unknown [10.163.29.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9800AA3BA0;
        Sun, 29 Aug 2021 17:04:16 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 7B554603F7; Sun, 29 Aug 2021 19:04:15 +0200 (CEST)
Date:   Sun, 29 Aug 2021 19:04:15 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, mptcp@lists.linux.dev,
        Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Rui Sousa <rui.sousa@nxp.com>,
        Sebastien Laveze <sebastien.laveze@nxp.com>
Subject: Re: [net-next, v4, 05/11] ethtool: add a new command for getting PHC
 virtual clocks
Message-ID: <20210829170415.hztnbqswszx27hvf@lion.mk-sys.cz>
References: <20210625093513.38524-1-yangbo.lu@nxp.com>
 <20210625093513.38524-6-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cpandjdf6zkdwu7z"
Content-Disposition: inline
In-Reply-To: <20210625093513.38524-6-yangbo.lu@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cpandjdf6zkdwu7z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 25, 2021 at 05:35:07PM +0800, Yangbo Lu wrote:
> Add an interface for getting PHC (PTP Hardware Clock)
> virtual clocks, which are based on PHC physical clock
> providing hardware timestamp to network packets.
>=20
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Hello,

do you plan to submit also an ethtool (userspace utility) patch using
this interface?

Michal

> ---
> Changes for v3:
> 	- Added this patch.
> Changes for v4:
> 	- Updated doc.
> 	- Removed ioctl command.
> 	- Replied only the number of vclock index.
> ---
>  Documentation/networking/ethtool-netlink.rst | 22 +++++
>  include/linux/ethtool.h                      | 10 +++
>  include/uapi/linux/ethtool_netlink.h         | 15 ++++
>  net/ethtool/Makefile                         |  2 +-
>  net/ethtool/common.c                         | 13 +++
>  net/ethtool/netlink.c                        | 10 +++
>  net/ethtool/netlink.h                        |  2 +
>  net/ethtool/phc_vclocks.c                    | 94 ++++++++++++++++++++
>  8 files changed, 167 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/phc_vclocks.c
>=20
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation=
/networking/ethtool-netlink.rst
> index 6ea91e41593f..c86628e6a235 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -212,6 +212,7 @@ Userspace to kernel:
>    ``ETHTOOL_MSG_FEC_SET``               set FEC settings
>    ``ETHTOOL_MSG_MODULE_EEPROM_GET``     read SFP module EEPROM
>    ``ETHTOOL_MSG_STATS_GET``             get standard statistics
> +  ``ETHTOOL_MSG_PHC_VCLOCKS_GET``       get PHC virtual clocks info
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  Kernel to userspace:
> @@ -250,6 +251,7 @@ Kernel to userspace:
>    ``ETHTOOL_MSG_FEC_NTF``                  FEC settings
>    ``ETHTOOL_MSG_MODULE_EEPROM_GET_REPLY``  read SFP module EEPROM
>    ``ETHTOOL_MSG_STATS_GET_REPLY``          standard statistics
> +  ``ETHTOOL_MSG_PHC_VCLOCKS_GET_REPLY``    PHC virtual clocks info
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> =20
>  ``GET`` requests are sent by userspace applications to retrieve device
> @@ -1477,6 +1479,25 @@ Low and high bounds are inclusive, for example:
>   etherStatsPkts512to1023Octets 512  1023
>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D
> =20
> +PHC_VCLOCKS_GET
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Query device PHC virtual clocks information.
> +
> +Request contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PHC_VCLOCKS_HEADER``      nested  request header
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Kernel response contents:
> +
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +  ``ETHTOOL_A_PHC_VCLOCKS_HEADER``      nested  reply header
> +  ``ETHTOOL_A_PHC_VCLOCKS_NUM``         u32     PHC virtual clocks number
> +  ``ETHTOOL_A_PHC_VCLOCKS_INDEX``       s32     PHC index array
> +  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[...]

--cpandjdf6zkdwu7z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmErvgkACgkQ538sG/LR
dpUBjQgAzjPJSDO8EKxGkhwYCeYjwC8Lv8dHqiKoAD2OAdxIwq8euaCfCq0/Qcek
6fFdwPXYkxLS17T33E/UKS/7LoVRl8FeLADMoEFmEsjVD/H+bRwSSJUs2emlgC8g
GVgLWXiECd9wSB6OvMd7Z8SfWtmD7RTCQFz8HwVoHWUy3TK45KC8/wx7eDu6xMia
zp1uqECkH9r7CefjL1XA7VHl9WiBU2a21Zs7OyQVtRQrn+389e8v1+CdutbHZsKD
XIcFnSYzOOLh0MleQXRuKsg9qSEshQ5jF2Id+pv52jw2MaMIivoekAtDmxHDp9hV
rfrgj32E5JqDphIX1x7QTf2l4T5Izw==
=LHra
-----END PGP SIGNATURE-----

--cpandjdf6zkdwu7z--
