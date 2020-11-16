Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECED2B4A36
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgKPQCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:02:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:48454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728858AbgKPQCK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 11:02:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 90B08AC1F;
        Mon, 16 Nov 2020 16:02:09 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 2279C604F6; Mon, 16 Nov 2020 17:02:09 +0100 (CET)
Date:   Mon, 16 Nov 2020 17:02:09 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v3 1/4] ethtool: add ETHTOOL_COALESCE_ALL_PARAMS
 define
Message-ID: <20201116160209.enpnpypha6wuajbw@lion.mk-sys.cz>
References: <20201113231655.139948-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xqjc7yx3a3doiz2i"
Content-Disposition: inline
In-Reply-To: <20201113231655.139948-1-acardace@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--xqjc7yx3a3doiz2i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2020 at 12:16:52AM +0100, Antonio Cardace wrote:
> This bitmask represents all existing coalesce parameters.
>=20
> Signed-off-by: Antonio Cardace <acardace@redhat.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  include/linux/ethtool.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 6408b446051f..e3da25b51ae4 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -215,6 +215,7 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *leg=
acy_u32,
>  #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
>  #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
>  #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
> +#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(21, 0)
> =20
>  #define ETHTOOL_COALESCE_USECS						\
>  	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
> --=20
> 2.28.0
>=20

--xqjc7yx3a3doiz2i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+yonsACgkQ538sG/LR
dpXYrwf/Yj1QPGT2sbVuJJGSx4QSFYKhYStqCrBUAYQT8I5hrP4d7DYVBjzyTsSc
9Dawg/lwZ8pywCUI/iAwu3IlUtHb714COfwyuv8BFROk1z28T86s2pckJbEuPSL0
+P89JtDXok/FuB47tYQTb/O0oytsZNr6oP36o5Cfd/jf2hsiL4LFepDRW/9wrhd/
ph30b8mzBEoml6cp0irFsBA0av7oXRrh+kbk57uC/8lenNaoOawxcPyklJIvhZsl
YD36/HKf3JVHhLnXlZyfQjr4TU6bQTvzggorp+RpCrnp9N7JtZaVPSNtl4b4OYPH
dNKcm412+/3gcSWUx0JpTiaK+ZqOAQ==
=ddl7
-----END PGP SIGNATURE-----

--xqjc7yx3a3doiz2i--
