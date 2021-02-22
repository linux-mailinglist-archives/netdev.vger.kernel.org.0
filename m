Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18C03211F5
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 09:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhBVIZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 03:25:28 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:54779 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229947AbhBVIZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 03:25:24 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DkZwm6N81z9sCD;
        Mon, 22 Feb 2021 19:24:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613982282;
        bh=yZq9IVi4sJ8JZMajzERvb4K12caMOUxVcC7d+cAK+6g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ggJBaVQ5VHtgUUuUZJdQ+HW0f5Mc7H5t2ZdH4wpGIw8q2sTMF2KtqM98JHKk4ILuH
         k9W6zaVTz/qs+12U+z5s/tZIHokP5Ll7+unt42Ph/QHy6G9cX+sNRz8N6im8DcJIh0
         Xprrbu8yXwg8f09i4GRj8H0Hm7V5wekaGAtb9fjbTqRuikp3ZBKiyLDT7V7nTydclF
         6MccQZZ0SC6Rb886k+NoVGTDXFmO75iJTTVr6di+jWPYoG8Dw4sZWcey2ViR33qMn+
         bt0quNzy+p7ZLWK/RtbUYSJJ++QzDuyKXeyz9FzJqbB0u+WRcloCy1NDg7qyWw68My
         72ZK4JAJKCDRA==
Date:   Mon, 22 Feb 2021 19:24:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: Re: linux-next: manual merge of the gpio-brgl tree with the
 net-next tree
Message-ID: <20210222192439.0365f800@canb.auug.org.au>
In-Reply-To: <20210216181938.7c35ac22@canb.auug.org.au>
References: <20210216181938.7c35ac22@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2rqMnUArb4awWk8DIog3VXs";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2rqMnUArb4awWk8DIog3VXs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 16 Feb 2021 18:19:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the gpio-brgl tree got a conflict in:
>=20
>   MAINTAINERS
>=20
> between commit:
>=20
>   df53e4f48e8d ("MAINTAINERS: Add entries for Toshiba Visconti ethernet c=
ontroller")
>=20
> from the net-next tree and commit:
>=20
>   5103c90d133c ("MAINTAINERS: Add entries for Toshiba Visconti GPIO contr=
oller")
>=20
> from the gpio-brgl tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> diff --cc MAINTAINERS
> index 9a8285485f0d,656ae6685430..000000000000
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@@ -2615,13 -2641,11 +2615,15 @@@ L:	linux-arm-kernel@lists.infradead.or
>   S:	Supported
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwamatsu/linux-vis=
conti.git
>   F:	Documentation/devicetree/bindings/arm/toshiba.yaml
> + F:	Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
>  +F:	Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
>   F:	Documentation/devicetree/bindings/pinctrl/toshiba,tmpv7700-pinctrl.y=
aml
>  +F:	Documentation/devicetree/bindings/watchdog/toshiba,visconti-wdt.yaml
>   F:	arch/arm64/boot/dts/toshiba/
> + F:	drivers/gpio/gpio-visconti.c
>  +F:	drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
>   F:	drivers/pinctrl/visconti/
>  +F:	drivers/watchdog/visconti_wdt.c
>   N:	visconti
>  =20
>   ARM/UNIPHIER ARCHITECTURE

This is now a comflict between the gpio-brgl tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/2rqMnUArb4awWk8DIog3VXs
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAzakgACgkQAVBC80lX
0GxSrQf+OrChGU0BTbZIjsTbQciFyLsRxTpPPHXCp602Hacj0Xn0ax5oTs3ZIL1N
AnZxjqZGaoA1ob9+toWEpjqztqwa5u4jQM4cdigC93+uqyiUaYNa8bgFJzdkWdwS
nDq35FtzwGWBfyOTebIXS1X5PtL2A4J8pNfYgHJGKNCyC+by+p6j20xBbbAUa+Ry
n/WIvXfSEgeQOgFbLKxtrvLJyxUjcvg5FErx/9uMIRlgHGMaWjnzQ0YDqmeoEFvM
27dekyCL2M0DSJLX5GpNcercqm611Gqj2PUCwc1J91pqh2t6IJvMBHDyO+IKpLkY
4aWfPgr/JiUi7WzlTpKmFGpeH5VTuA==
=IEzn
-----END PGP SIGNATURE-----

--Sig_/2rqMnUArb4awWk8DIog3VXs--
