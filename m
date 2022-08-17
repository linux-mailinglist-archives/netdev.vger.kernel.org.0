Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 704D2596D8A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbiHQL1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbiHQL1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:27:34 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9F88050E
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 04:27:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A369A20139;
        Wed, 17 Aug 2022 11:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660735650; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rcI0cnmIrWTkOBA9yYvG1XDIOAKErnqlGQA71ljpg7w=;
        b=24/vgDZJOlrkcG8bYZCUF9RPYOwGYbYOXuHtbNag5au0GFE4BikvjBKrceSHaBvMG0brmQ
        TAmmsWAY6LY95QwTTn9X6pUZ415+/BaBdr4yIRfW475JXpPT6KAQXq/6Y1VtnyQIMMRHdQ
        pbPDPRlbfSipIuLNJ3dMtUBbuOPwR8A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660735650;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rcI0cnmIrWTkOBA9yYvG1XDIOAKErnqlGQA71ljpg7w=;
        b=dDnXpnzE5bspJLeuv2Rt0oGGmdzjgCkUNLB6wLIyUn49jO++EYuYWHmqvlrp5RIZLfd4Ha
        YhVfkkafhlSNqnCQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 018182C178;
        Wed, 17 Aug 2022 11:27:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id A270A6094A; Wed, 17 Aug 2022 13:27:29 +0200 (CEST)
Date:   Wed, 17 Aug 2022 13:27:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 1/7] net: ethtool: netlink: introduce
 ethnl_update_bool()
Message-ID: <20220817112729.4aniwysblnarakwx@lion.mk-sys.cz>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
 <20220816222920.1952936-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zv2bsdbaciwwsdzs"
Content-Disposition: inline
In-Reply-To: <20220816222920.1952936-2-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zv2bsdbaciwwsdzs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2022 at 01:29:14AM +0300, Vladimir Oltean wrote:
> For a reason I can't really understand, ethnl_update_bool32() exists,
> but the plain function that operates on a boolean value kept in an
> actual u8 netlink attribute doesn't.

I can explain that: at the moment these helpers were introduced, only
members of traditional structures shared with ioctl interface were
updated and all attributes which were booleans logically were
represented as u32 in them so that no other helper was needed back then.


>                                       Introduce it; it's needed for
> things like verify-disabled for the MAC merge configuration.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/ethtool/netlink.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
> index c0d587611854..1653fd2cf0cf 100644
> --- a/net/ethtool/netlink.h
> +++ b/net/ethtool/netlink.h
> @@ -111,6 +111,32 @@ static inline void ethnl_update_u8(u8 *dst, const st=
ruct nlattr *attr,
>  	*mod =3D true;
>  }
> =20
> +/**
> + * ethnl_update_bool() - update bool from NLA_U8 attribute
> + * @dst:  value to update
> + * @attr: netlink attribute with new value or null
> + * @mod:  pointer to bool for modification tracking
> + *
> + * Use the u8 value from NLA_U8 netlink attribute @attr to set bool vari=
able
> + * pointed to by @dst to false (if zero) or 1 (if not); do nothing if @a=
ttr is
                                               ^ true

Looks good otherwise.

Michal

> + * null. Bool pointed to by @mod is set to true if this function changed=
 the
> + * logical value of *dst, otherwise it is left as is.
> + */
> +static inline void ethnl_update_bool(bool *dst, const struct nlattr *att=
r,
> +				     bool *mod)
> +{
> +	u8 val;
> +
> +	if (!attr)
> +		return;
> +	val =3D !!nla_get_u8(attr);
> +	if (*dst =3D=3D val)
> +		return;
> +
> +	*dst =3D val;
> +	*mod =3D true;
> +}
> +
>  /**
>   * ethnl_update_bool32() - update u32 used as bool from NLA_U8 attribute
>   * @dst:  value to update
> --=20
> 2.34.1
>=20

--zv2bsdbaciwwsdzs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmL80JwACgkQ538sG/LR
dpWXHQf/eYgCy9dMP+zINGQ/gDzfoLQSDxZbEz47zmV0GrqlU2YvhjQk6x6Vf7tW
q69IXwrA4dogzm8FIIljJUxT+WR8ipCT+UgIVK250W9wvF6KPnHbQ8fIzmSIU3wz
K2xnZTa7WFM4Mhsdqkv4J/vZ6t1wRVIGwKC66WCuED9T35FvhxLYmnczqTx7MtK9
LNnlbo9TtFDnVLFc/VE8pxWW2yVRd4i8x/60qIa2F0LuYwEL6djqE6lh/cggZpcq
KEFMAXGYi5gyIE8YFk3F8zvrf9BYKcJdIWzVDn9viempLBzf1SBVQrBZb0u+MROi
LAcvtOIVTnEK2M6LOgUxZ2Hw4NacQA==
=/x2Z
-----END PGP SIGNATURE-----

--zv2bsdbaciwwsdzs--
