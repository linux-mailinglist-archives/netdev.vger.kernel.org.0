Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37FB697A2C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbjBOKsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjBOKsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:48:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8CA1F932
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:48:11 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 16AA52298B;
        Wed, 15 Feb 2023 10:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676458090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uaue2bbWebqwvMCAcObtTDGA6qDrUxXJj5NiPymbpI0=;
        b=2R+B3FG8cInoGvthSjVF42PqkagKdv2BsxGIHEt1/4WjFAN4KZO/EQ8T9yD/Wv6HU81nTI
        BNc1vJERdcXsEzQ81zFoh2/GBUNVer8IqbP42CU2RVciovI7CTGoiFMQ/JhE+YYI5LMhbe
        qWcrnVe3fUBSv7UKGI6P39Ujo1/JEJ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676458090;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uaue2bbWebqwvMCAcObtTDGA6qDrUxXJj5NiPymbpI0=;
        b=jO8VNIB2FmZ1ShynvWllTt53Yty1gyc+zEKrQLSM4iF0BiCM1SZAy6StXKKjzkaJdROZnz
        11WFDE8gSydDDwBg==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id BC4F12C141;
        Wed, 15 Feb 2023 10:48:09 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1CFA26052C; Wed, 15 Feb 2023 11:48:04 +0100 (CET)
Date:   Wed, 15 Feb 2023 11:48:04 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH ethtool-next 1/2] ethtool: uapi update for RX_PUSH
 ringparam attribute
Message-ID: <20230215104804.a76pukyorknilfw3@lion.mk-sys.cz>
References: <20230213203008.2321-1-shannon.nelson@amd.com>
 <20230213203008.2321-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wlwazu5uh2prnr7e"
Content-Disposition: inline
In-Reply-To: <20230213203008.2321-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wlwazu5uh2prnr7e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2023 at 12:30:07PM -0800, Shannon Nelson wrote:
> Adds the new uapi ETHTOOL_A_RINGS_RX_PUSH attribute as found in the
> next-next commit
> 5b4e9a7a71ab ("net: ethtool: extend ringparam set/get APIs for rx_push")
>=20
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  uapi/linux/ethtool_netlink.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
> index 4cf91e5..13493c9 100644
> --- a/uapi/linux/ethtool_netlink.h
> +++ b/uapi/linux/ethtool_netlink.h
> @@ -356,6 +356,7 @@ enum {
>  	ETHTOOL_A_RINGS_TCP_DATA_SPLIT,			/* u8 */
>  	ETHTOOL_A_RINGS_CQE_SIZE,			/* u32 */
>  	ETHTOOL_A_RINGS_TX_PUSH,			/* u8 */
> +	ETHTOOL_A_RINGS_RX_PUSH,			/* u8 */
> =20
>  	/* add new constants above here */
>  	__ETHTOOL_A_RINGS_CNT,

I replaced this patch with a full update from current net-next head
(kernel commit 1ed32ad4a3cb), next time please follow the guidelines at

  https://mirrors.edge.kernel.org/pub/software/network/ethtool/devel.html

(third paragraph in section "Submitting patches").

Michal

--wlwazu5uh2prnr7e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmPsuF8ACgkQ538sG/LR
dpUpqwf/SVHdi9KJU/E6lrsn1JreAElGpZOjegmhJnGmx6o3lZ9aTlGwYb0MjZ2c
RT8yOTFfCsXqDLsD4wF3FRbwvRwZmjjUCsTJKwl+lK7NBzZlVGc7UNsny1aLg3zz
laPlf+sbpB8Yekk2PGZFDLIBpOQUKkRDM4cWpYU4NDw3eYbjvERWq5cyhN2Lm689
1kdaIuCyxhNddSy3LCJiv83jrleIT+ItFllhOwXo6mA6ZWlhmSnmKlo/hXqbvM94
3m74ae7oUgJ6iT1giMbfFL8VAcs8bgz9tkyF7VJxuw5Z+8B3ZONxgAzhhRjk5rgW
o1No0YlcHKlcegjKtLLrn63YxnjLfQ==
=Gpqd
-----END PGP SIGNATURE-----

--wlwazu5uh2prnr7e--
