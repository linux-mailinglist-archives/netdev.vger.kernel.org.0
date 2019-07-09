Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 691C362CFF
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 02:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfGIAPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 20:15:11 -0400
Received: from ozlabs.org ([203.11.71.1]:38075 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfGIAPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 20:15:11 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jNB43GBxz9sMQ;
        Tue,  9 Jul 2019 10:15:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562631309;
        bh=bBTRJ/gWh1SkD7GuJ2exaw8AXYos5TrzWaLY6dcu/b8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y+Lz+14Xq/Lg08jEVADhcc2ceRsOFmKCp7C8Cfj8vaXLbOLrRYwRNgMyURu1HPVZB
         7mPwebOGZMabD+FsSbknuZekA91CyLOBpxweZaidTkbkvgiEzufCzHP5TpumxkaWhE
         h2/h7CApLYUMwRzBPWfApmIxOI7C8H6uSOoFd+Gx9FEcNBI3koicSTr3yaa3D3kHUy
         Dc3mO0ROVivhqPHlQbcyt9YHurI7KpG7hwXST3ivZVcYs6Id5jmEPU3jIJmS/PDw42
         07putw7JthCgxczuRBR+oQpKvqttfgRT/Wd15yW43RxwugyJ7riL5rITP0yjwiS9f1
         4RiQZmPDU5Z4Q==
Date:   Tue, 9 Jul 2019 10:15:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: linux-next: manual merge of the devicetree tree with the
 net-next tree
Message-ID: <20190709101507.3022b02e@canb.auug.org.au>
In-Reply-To: <20190628145626.49859e33@canb.auug.org.au>
References: <20190628145626.49859e33@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VhABmFE8=QuldL++ZPm4n_i"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/VhABmFE8=QuldL++ZPm4n_i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 28 Jun 2019 14:56:26 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the devicetree tree got a conflict in:
>=20
>   Documentation/devicetree/bindings/net/ethernet.txt
>=20
> between commit:
>=20
>   79b647a0c0d5 ("dt-bindings: net: document new usxgmii phy mode")
>=20
> from the net-next tree and commit:
>=20
>   4e7a33bff7d7 ("dt-bindings: net: Add YAML schemas for the generic Ether=
net options")
>=20
> from the devicetree tree.
>=20
> I fixed it up (the latter seems to include the change made by the former,
> so I just used the latter) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

I am still getting this conflict (the commit ids may have changed).
Just a reminder in case you think Linus may need to know.

--=20
Cheers,
Stephen Rothwell

--Sig_/VhABmFE8=QuldL++ZPm4n_i
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0j3IsACgkQAVBC80lX
0Gy8Nwf+Pscs99EPiCOsZ7YBlxMLkeTB5tZpuzIaEqlWv4lT6C1HnIB9SzP1IGoY
HT6ch4QPAaL0gVbxrQLYXhDDkLBDoe+wEy/7sTVZCkyHgKQz1t2PDwv2vo1ptDcP
mp78BiUrL0M3QwMxgnY1pFzVpZCO/h4I4hfZ0xkVz5D/CN3/sGIa3iWKJ1hapN7j
zURYKIiN2FzGtDWLZSDMyLyyQAzsfBas3dMuL8Uz9JVmQ6aVof5oGu5fW81onTro
8PQDyqwf8uYA/6kHmhW93Ak35GTD3zNKiDp6ploGd5B5adIODEhReXD+qzJokQbX
9/rEW3OzJV69H89T4hhwYHxIzBIutw==
=KDkj
-----END PGP SIGNATURE-----

--Sig_/VhABmFE8=QuldL++ZPm4n_i--
