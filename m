Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1421C4EB3EB
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 21:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240840AbiC2TLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 15:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiC2TLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 15:11:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D9D6D969
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 12:09:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4CA131FD36;
        Tue, 29 Mar 2022 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1648580968; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FvaRgZWVLp/9yeE3tE9oQf+LGFbTIp9kGc+BN/VAuCY=;
        b=Y6qBeZXjH7k7W8uombOHgmoFMlQSc3Y0zCCn4FlBqB2h1XFyrYGAu/CqmkO6PArwVOqsZA
        tqJrBrEkWv8GeXasduHtNPcgzngjrTQ5xdObmGwh78XDUQPkiEGH2sNd3urnfo8EqBgSqW
        J051PJ8ZSeUVpf1QfkRKr1KI5smOyfA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1648580968;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FvaRgZWVLp/9yeE3tE9oQf+LGFbTIp9kGc+BN/VAuCY=;
        b=kYLDbwaK4+2t98QofLez4FehCB1RKk66Hs98XmRzYOOq5ortbypViEqK+XaEKtWNyJAEv7
        IH7fTC8soktwC+Dg==
Received: from lion.mk-sys.cz (mkubecek.udp.ovpn2.nue.suse.de [10.163.44.94])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 96A4BA3B87;
        Tue, 29 Mar 2022 19:09:27 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id D9A86602F9; Tue, 29 Mar 2022 21:09:24 +0200 (CEST)
Date:   Tue, 29 Mar 2022 21:09:24 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jie Wang <wangjie125@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        huangguangbin2@huawei.com, lipeng321@huawei.com,
        shenjian15@huawei.com, moyufeng@huawei.com, linyunsheng@huawei.com,
        salil.mehta@huawei.com, chenhao288@hisilicon.com
Subject: Re: [RFCv3 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
Message-ID: <20220329190924.d5gicfwoh6bp5iwd@lion.mk-sys.cz>
References: <20220329091913.17869-1-wangjie125@huawei.com>
 <20220329091913.17869-2-wangjie125@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6pkwopqbadyeu5gp"
Content-Disposition: inline
In-Reply-To: <20220329091913.17869-2-wangjie125@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6pkwopqbadyeu5gp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 29, 2022 at 05:19:12PM +0800, Jie Wang wrote:
> Currently tx push is a standard driver feature which controls use of a fa=
st
> path descriptor push. So this patch extends the ringparam APIs and data
> structures to support set/get tx push by ethtool -G/g.
>=20
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> ---
[...]
> diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
> index 9f33c9689b56..2bc2d91f2e66 100644
> --- a/net/ethtool/rings.c
> +++ b/net/ethtool/rings.c
[...]
> @@ -205,6 +210,15 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl=
_info *info)
>  		goto out_ops;
>  	}
> =20
> +	if (kernel_ringparam.tx_push &&
> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
> +		ret =3D -EOPNOTSUPP;
> +		NL_SET_ERR_MSG_ATTR(info->extack,
> +				    tb[ETHTOOL_A_RINGS_TX_PUSH],
> +				    "setting tx push not supported");
> +		goto out_ops;
> +	}
> +
>  	ret =3D dev->ethtool_ops->set_ringparam(dev, &ringparam,
>  					      &kernel_ringparam, info->extack);
>  	if (ret < 0)

This only disallows setting the parameter to true but allows requests
trying to set it to false. I would rather prefer

	if (tb[ETHTOOL_A_RINGS_TX_PUSH] &&
	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
		...
	}

and putting the check before rtnl_lock() so that we do not do useless
work if the request is invalid.

But the same can be said about the two checks we already have so those
should be probably changed and moved as well.

Michal

--6pkwopqbadyeu5gp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmJDWVoACgkQ538sG/LR
dpWUqwgAjuTUmx41XwmdwzWO9eFR7WyWeq1V3Dhoa83qPiVuK52z90dKKZrsSytS
z1JOLc/IWA6C74lIzOeYe1pbKneUS+MwnlZVUKV+/TX4k9TKWAbtBdkZmeUdoPZ8
ZdMyQ0WgRfAQiLCLGvuQbDntI7VJEMaIQkfWdXvVA8Q/vgG4L80NWS1tnJx9Vp5M
igE5E/tw8bJyj7audpIDk63kFtskHLbofn6AWhTbgoCc9aOzNsukr6WV77HIFBet
euspY1yVBWOjLKuBuL/mkYqp01486YG6n13FnBr1AOsd7aSwBgLvqYkoP8PA0Ia6
YYEv+Zn3B8JVVUxQosurtsTjwQ4FGw==
=dOQ0
-----END PGP SIGNATURE-----

--6pkwopqbadyeu5gp--
