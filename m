Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C3D31C6BE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBPHUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:20:32 -0500
Received: from ozlabs.org ([203.11.71.1]:40473 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229694AbhBPHUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 02:20:25 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DfsmX2SbRz9sVF;
        Tue, 16 Feb 2021 18:19:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613459982;
        bh=3P27M9m1bE4lXBRrOgw2cWwHbWML7zfQnxL4LNa6cw8=;
        h=Date:From:To:Cc:Subject:From;
        b=npj3HmdxN7QyA3i3g3V1gPjx4L6vT/IuGeWAnvPkocIDdmlhSHPBiSjNg+/Zs5prm
         9pjV0FfqSaJV5jhEhZrF2ZG4cp298lkQcwl8tURzE4DFnFGHh/VKsfou1Alotj1eLl
         Pu8JZMzaSl410TdGW6IOptqgLb0QruvnOy6Pco3WxBKVPQBzq3u2T92w1BmHzX6hc3
         ONtEjos3TA5kmg3d9x7wsuXtGmRpm7oDJlw9Aqi0QJPNFdLkg7Ua6pYqzO5Mp91ptd
         2DLk780wSai8b1vi26OjDfulYaNRwziz3YsJbFT1rr0YeYW9VgZtzjllbBQWtYSs1T
         dHsrxYzbXzACQ==
Date:   Tue, 16 Feb 2021 18:19:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: linux-next: manual merge of the gpio-brgl tree with the net-next
 tree
Message-ID: <20210216181938.7c35ac22@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/po3tO9cpc4HSuGJ.MVQXWNg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/po3tO9cpc4HSuGJ.MVQXWNg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the gpio-brgl tree got a conflict in:

  MAINTAINERS

between commit:

  df53e4f48e8d ("MAINTAINERS: Add entries for Toshiba Visconti ethernet con=
troller")

from the net-next tree and commit:

  5103c90d133c ("MAINTAINERS: Add entries for Toshiba Visconti GPIO control=
ler")

from the gpio-brgl tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc MAINTAINERS
index 9a8285485f0d,656ae6685430..000000000000
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@@ -2615,13 -2641,11 +2615,15 @@@ L:	linux-arm-kernel@lists.infradead.or
  S:	Supported
  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/iwamatsu/linux-visco=
nti.git
  F:	Documentation/devicetree/bindings/arm/toshiba.yaml
+ F:	Documentation/devicetree/bindings/gpio/toshiba,gpio-visconti.yaml
 +F:	Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
  F:	Documentation/devicetree/bindings/pinctrl/toshiba,tmpv7700-pinctrl.yaml
 +F:	Documentation/devicetree/bindings/watchdog/toshiba,visconti-wdt.yaml
  F:	arch/arm64/boot/dts/toshiba/
+ F:	drivers/gpio/gpio-visconti.c
 +F:	drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
  F:	drivers/pinctrl/visconti/
 +F:	drivers/watchdog/visconti_wdt.c
  N:	visconti
 =20
  ARM/UNIPHIER ARCHITECTURE

--Sig_/po3tO9cpc4HSuGJ.MVQXWNg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmArcgoACgkQAVBC80lX
0GyTVwf/QCZohdcnqqRPpLoyc+0iJJEWuLDW4ysm4y/ZNp2vejiVSeVAoDch7ijU
L5gICvJmKNwRCvcqXacuaAR26t+fOBV50Tqn+neB+qTs+YSvtWj6eqtnv4TGzmzs
SuQ7A1+6M9T9+zi0jZeXPo/W7wM9TeuPQ9RFOGJ9tjQdEcTgCypZqCLYr+2MS8ut
MzXVi4fKdN0eHvK0DYylLlFsgkSQwb5jMArvqCP1+IYbsB04SOgPJFOoONjBk2fp
DMwkTIufsWHRRmRZefbHC//rwQSlLVzn2QpRgLTXg5smZFSQunrQuySC4FokDA1O
l/DN44GgYTr43VxlxcjPL022NDs9lg==
=SDgm
-----END PGP SIGNATURE-----

--Sig_/po3tO9cpc4HSuGJ.MVQXWNg--
