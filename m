Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF4F1A86FD
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407545AbgDNRHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 13:07:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407530AbgDNRHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 13:07:51 -0400
Received: from earth.universe (dyndsl-095-033-159-070.ewe-ip-backbone.de [95.33.159.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81CFD2074D;
        Tue, 14 Apr 2020 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586884070;
        bh=Vq4RyNksC8DDC/pNKSHRikXKLRBl9aRiMuYYTuWMuJ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IzIsvxNgjJigEKMiIreQ3YE6eW+3lbwHLAwHesLbS15fjCQKgzLdZKxDApCeJqKHd
         vB6zikfIqgxQWL+Oxnyc09eg5TpFBpQQ5Lk6YDvxeB4Hskmn6SJQ58WbZ5ZQXWAHin
         rVklotnuEjhKlc9MRTpsSBtfvcwVNd4Qk+YM5wT0=
Received: by earth.universe (Postfix, from userid 1000)
        id 4B1923C08C7; Tue, 14 Apr 2020 19:07:48 +0200 (CEST)
Date:   Tue, 14 Apr 2020 19:07:48 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Borislav Petkov <bp@suse.de>, Ion Badulescu <ionut@badula.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-pm@vger.kernel.org,
        netdev@vger.kernel.org, Pensando Drivers <drivers@pensando.io>,
        Shannon Nelson <snelson@pensando.io>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: Re: [PATCH net-next 1/4] drivers: Remove inclusion of vermagic header
Message-ID: <20200414170748.7ewsmecbhv4lphor@earth.universe>
References: <20200414155732.1236944-1-leon@kernel.org>
 <20200414155732.1236944-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uwof7mblmg76pybk"
Content-Disposition: inline
In-Reply-To: <20200414155732.1236944-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uwof7mblmg76pybk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 14, 2020 at 06:57:29PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>=20
> Get rid of linux/vermagic.h includes, so that MODULE_ARCH_VERMAGIC from
> the arch header arch/x86/include/asm/module.h won't be redefined.
>=20
>   In file included from ./include/linux/module.h:30,
>                    from drivers/net/ethernet/3com/3c515.c:56:
>   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC"
> redefined
>      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
>         |
>   In file included from drivers/net/ethernet/3com/3c515.c:25:
>   ./include/linux/vermagic.h:28: note: this is the location of the
> previous definition
>      28 | #define MODULE_ARCH_VERMAGIC ""
>         |
>=20
> Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3c=
om drivers")
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---

# for drivers/power/supply/test_power.c
Acked-by: Sebastian Reichel <sre@kernel.org>

-- Sebastian

>  drivers/net/bonding/bonding_priv.h               | 2 +-
>  drivers/net/ethernet/3com/3c509.c                | 1 -
>  drivers/net/ethernet/3com/3c515.c                | 1 -
>  drivers/net/ethernet/adaptec/starfire.c          | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_main.c | 2 +-
>  drivers/power/supply/test_power.c                | 2 +-
>  net/ethtool/ioctl.c                              | 3 +--
>  7 files changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bon=
ding_priv.h
> index 45b77bc8c7b3..48cdf3a49a7d 100644
> --- a/drivers/net/bonding/bonding_priv.h
> +++ b/drivers/net/bonding/bonding_priv.h
> @@ -14,7 +14,7 @@
> =20
>  #ifndef _BONDING_PRIV_H
>  #define _BONDING_PRIV_H
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
> =20
>  #define DRV_NAME	"bonding"
>  #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3co=
m/3c509.c
> index b762176a1406..139d0120f511 100644
> --- a/drivers/net/ethernet/3com/3c509.c
> +++ b/drivers/net/ethernet/3com/3c509.c
> @@ -85,7 +85,6 @@
>  #include <linux/device.h>
>  #include <linux/eisa.h>
>  #include <linux/bitops.h>
> -#include <linux/vermagic.h>
> =20
>  #include <linux/uaccess.h>
>  #include <asm/io.h>
> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3co=
m/3c515.c
> index 90312fcd6319..47b4215bb93b 100644
> --- a/drivers/net/ethernet/3com/3c515.c
> +++ b/drivers/net/ethernet/3com/3c515.c
> @@ -22,7 +22,6 @@
> =20
>  */
> =20
> -#include <linux/vermagic.h>
>  #define DRV_NAME		"3c515"
> =20
>  #define CORKSCREW 1
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethern=
et/adaptec/starfire.c
> index 2db42211329f..a64191fc2af9 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -45,7 +45,6 @@
>  #include <asm/processor.h>		/* Processor type for cache alignment. */
>  #include <linux/uaccess.h>
>  #include <asm/io.h>
> -#include <linux/vermagic.h>
> =20
>  /*
>   * The current frame processor firmware fails to checksum a fragment
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/n=
et/ethernet/pensando/ionic/ionic_main.c
> index 588c62e9add7..3ed150512091 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -6,7 +6,7 @@
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <linux/utsname.h>
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
> =20
>  #include "ionic.h"
>  #include "ionic_bus.h"
> diff --git a/drivers/power/supply/test_power.c b/drivers/power/supply/tes=
t_power.c
> index 65c23ef6408d..b3c05ff05783 100644
> --- a/drivers/power/supply/test_power.c
> +++ b/drivers/power/supply/test_power.c
> @@ -16,7 +16,7 @@
>  #include <linux/power_supply.h>
>  #include <linux/errno.h>
>  #include <linux/delay.h>
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
> =20
>  enum test_power_id {
>  	TEST_AC,
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 89d0b1827aaf..d3cb5a49a0ce 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -17,7 +17,6 @@
>  #include <linux/phy.h>
>  #include <linux/bitops.h>
>  #include <linux/uaccess.h>
> -#include <linux/vermagic.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sfp.h>
>  #include <linux/slab.h>
> @@ -28,7 +27,7 @@
>  #include <net/xdp_sock.h>
>  #include <net/flow_offload.h>
>  #include <linux/ethtool_netlink.h>
> -
> +#include <generated/utsrelease.h>
>  #include "common.h"
> =20
>  /*
> --=20
> 2.25.2
>=20

--uwof7mblmg76pybk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl6V7dwACgkQ2O7X88g7
+pp34w//Zh9saQxQKi4S40xZw8/5nhgqSqqXNP5pExXtTFW7kYOmYjjzelYlR2ST
dMOGPPw2eD1m9bWTY0JUXH5cW1UEMZWeqqdJzYPf4JFne/43Guk5L/cBELD/XSgJ
ltovKo84bKZgbo+LOhXyeOA5C2d/5RaduSEYMzxlSYj7mjfNX9xawiV8THmEiAGH
ag0UQhRiM8l8pCrSb76CpnOEbbBzb/sziwLi5JMBHT4Vfez/JErkLs81Qbu7wi4w
Qlx2ij/UEaYNF6R5CT5GqEyyEqJ0peKuNVRN9W3nP0ZNnBtZcPeLLWG1b4OQdkXH
AH97wi4RrzVSig1Y9l97sqzvxlql6aZY4ugzEF2F3617muJuQNdA8x1HUeJuTcjF
L55OHk73Glji8lTKEDri9BAMJ3XOzK3EZSfa9O1QRqybmBXmAtoXRe0ykBX3fV1E
CIogn66sYrMta2sy6jfyukF2RpnVpWcVd+ctHuRpNjIp53HHo/rbJzQdMF5zTB1a
8sgSlA64kUiX4sK36MozmWs4/noqwVVNL0pkI16yfq7KQVfCHbRji9QI9g0+aVvN
oN6LKDj1ClLaihFYznsy+NvGzxpg5PQxAxyqvnlQiJyJa7O18CHVdgM/1FY9TXh9
PjgYvBdQ1ldDePYZoSXg99stzU0bfNTPr+qq0nTwhYrynqUq+bM=
=HD4p
-----END PGP SIGNATURE-----

--uwof7mblmg76pybk--
