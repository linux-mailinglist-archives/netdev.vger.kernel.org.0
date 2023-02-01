Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD1C68707A
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 22:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBAV2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 16:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjBAV2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 16:28:53 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B26D17CFE;
        Wed,  1 Feb 2023 13:28:51 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2DFAF33D6D;
        Wed,  1 Feb 2023 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1675286930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xoprJCwqDVGxzpr+vLREMgZvu2xo3+B+3gZzNimWhck=;
        b=Z5jRd/BNVN7n0iMAof0+/phU6WZBUbqX7UYGSnX9GHMZJBMdVxgrYEROunfaTFTfGCQ5Ka
        B17loG0i4BIrnaBsCXsu5RRQc2iRhNh3iKSrTF228dJYChCzyuKONsvWUdNNVBtpNavW++
        GUdOJ5m1ziifGoBCCAeB8ety0wOKNeg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1675286930;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xoprJCwqDVGxzpr+vLREMgZvu2xo3+B+3gZzNimWhck=;
        b=7/io5znkCzIEVPAdWbqU2aLlbrdNHA59NLw7EpznmNMmnZPLmTBfQ1HjVyXDkRot3iGaZJ
        Hv0AQ8YALNWTcpBg==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn2.prg.suse.de [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 400BC2C141;
        Wed,  1 Feb 2023 21:28:49 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 9844860311; Wed,  1 Feb 2023 22:28:45 +0100 (CET)
Date:   Wed, 1 Feb 2023 22:28:45 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v4 ethtool-next 2/2] add support for IEEE 802.3cg-2019
 Clause 148 - PLCA RS
Message-ID: <20230201212845.t5qriiofktivtzse@lion.mk-sys.cz>
References: <cover.1671236215.git.piergiorgio.beruto@gmail.com>
 <1ddabd3850c3f3aea4b2ce840a053f0e917803ba.1671236216.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x372544no2ki3rmo"
Content-Disposition: inline
In-Reply-To: <1ddabd3850c3f3aea4b2ce840a053f0e917803ba.1671236216.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x372544no2ki3rmo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 17, 2022 at 01:50:39AM +0100, Piergiorgio Beruto wrote:
> This patch adds support for the Physical Layer Collision Avoidance
> Reconciliation Sublayer which was introduced in the IEEE 802.3
> standard by the 802.3cg working group in 2019.
>=20
> The ethtool interface has been extended as follows:
> - show if the device supports PLCA when ethtool is invoked without FLAGS
>    - additionally show what PLCA version is supported
>    - show the current PLCA status
> - add FLAGS for getting and setting the PLCA configuration
>=20
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
> ---
>  Makefile.am        |   1 +
>  ethtool.c          |  21 ++++
>  netlink/extapi.h   |   6 +
>  netlink/plca.c     | 295 +++++++++++++++++++++++++++++++++++++++++++++
>  netlink/settings.c |  86 ++++++++++++-

Please update also the manual page (ethtool.8.in), this should be done
whenever adding a new feature so that documented and implemented
features don't diverge.

[...]
> diff --git a/netlink/extapi.h b/netlink/extapi.h
> index 1bb580a889a8..0add156e644a 100644
> --- a/netlink/extapi.h
> +++ b/netlink/extapi.h
[...]
> @@ -114,6 +117,9 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_un=
used,
>  #define nl_getmodule		NULL
>  #define nl_gmodule		NULL
>  #define nl_smodule		NULL
> +#define nl_get_plca_cfg		NULL
> +#define nl_set_plca_cfg		NULL
> +#define nl_get_plca_status	NULL
> =20
>  #endif /* ETHTOOL_ENABLE_NETLINK */
> =20

The function names are misspelled here so that a build with
--disable-netlink fails.

[...]
> diff --git a/netlink/plca.c b/netlink/plca.c
> new file mode 100644
> index 000000000000..f7d7bdbc5c84
> --- /dev/null
> +++ b/netlink/plca.c
> @@ -0,0 +1,295 @@
> +/*
> + * plca.c - netlink implementation of plca command
> + *
> + * Implementation of "ethtool --show-plca <dev>" and
> + * "ethtool --set-plca <dev> ..."
> + */
> +
> +#include <errno.h>
> +#include <string.h>
> +#include <stdio.h>
> +
> +#include "../internal.h"
> +#include "../common.h"
> +#include "netlink.h"
> +#include "bitset.h"
> +#include "parser.h"
> +
> +/* PLCA_GET_CFG */
[...]
> +int plca_get_cfg_reply_cb(const struct nlmsghdr *nlhdr, void *data)
> +{
> +	const struct nlattr *tb[ETHTOOL_A_PLCA_MAX + 1] =3D {};
> +	DECLARE_ATTR_TB_INFO(tb);
> +	struct nl_context *nlctx =3D data;
> +	bool silent;
> +	int idv, val;
> +	int err_ret;
> +	int ret;
[...]
> +		// The node count is ignored by follower nodes. However, it can
> +		// be pre-set to enable fast coordinator role switchover.
> +		// Therefore, on a follower node we still wanto to show it,
> +		// indicating it is not currently used.
> +		if (tb[ETHTOOL_A_PLCA_NODE_ID] && idv !=3D 0)
> +			printf(" (ignored)");

The compiler warns that idv may be uninitialized here. While it's in
wrong, AFAICS, not even gcc13 is smart enough to recognize that it's not
actually possible so let's initialize the variable to make it happy.
Also, both idv and val are used to store unsigned values so they should
be unsigned int.

Other than these, the patch looks good to me. The next branch already
has the UAPI updates needed for it so patch 1 won't be needed any more
if you rebase on top of current next.

Michal

--x372544no2ki3rmo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPa2YYACgkQ538sG/LR
dpXUbggAooNGzjQR1VvHhxPWze0Qd/fvsA04bUEcuN0gKATIWDkyjsZnu0INmZvY
a65z54vZvBWwrUcu12clo4W2b72RfrYwEgdD2QJdldahVeVaJrn/vKVojauG+ujq
8Nf3zJVTvFKlb2xdaxAjLuOf9ZmTMNoTLe3W/yEspYlU7MJhT1YT0QlR4E6glY4J
Mt2xNO6PDRC0SQVqsElQKsP/rgujaxCxCdYyjYpAC8MWglXgBtI8Fo2nXgcMw+SX
4JhqkfHYl86Xo0UsiRAoYgIs7zSnuonBu190ZHMFBHyvmwJA2xd+v0I+27l37P8o
wRKJW9tV5k1cp224SljyMxbz3Y7G0Q==
=T6L7
-----END PGP SIGNATURE-----

--x372544no2ki3rmo--
