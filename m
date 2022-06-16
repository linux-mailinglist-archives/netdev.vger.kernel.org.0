Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ACE54D6D2
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 03:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349037AbiFPBQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 21:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233633AbiFPBQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 21:16:46 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513BF4EA1E;
        Wed, 15 Jun 2022 18:16:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LNkln3LZ5z4xYC;
        Thu, 16 Jun 2022 11:16:37 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1655342198;
        bh=lNqyG8XwfJtBuzCQk59rRCi+bT/18UbzTgmK3XAvQiA=;
        h=Date:From:To:Cc:Subject:From;
        b=l6abejwIJq2NGEg3u3S8nfSC3Y2tLS9RvKpxGOQeLnIV3UtRfk+apsQ1O+yFRXcCd
         0sqzDX7GjJnQ9BRtn3XQ/8HzoHaii33p8b/T4q1RUa5xFqF8n+xrBbqzTZQJ+ZXAq1
         2ngXa/nelP70REhdmcHxcREjzbltwNOvayxmwCq26eBScI80IhUj86bL9njJkA4poL
         +z1DVP+1Mb8FEw8g22N2cJK7UqHwv6U2sSJ1ZUDW48R1S3EhX7QNQwyN5Hy820yBzp
         whMoPzitzbPkSSt3Viz2RogLlJvYgXHoNhsmL/elIt4jjF/PA/VF689sYzI4OQOaEn
         10kshaEguIdUg==
Date:   Thu, 16 Jun 2022 11:16:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Heiko Stuebner <heiko@sntech.de>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the rockchip
 tree
Message-ID: <20220616111635.3e27c15b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/v/4G4xOP4Ty3+FxJBYJaREF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/v/4G4xOP4Ty3+FxJBYJaREF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts

between commit:

  f48387c005fa ("arm64: dts: rockchip: Enable HDMI audio on BPI R2 Pro")

from the rockchip tree and commit:

  c1804463e5c6 ("arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro bo=
ard")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 1d3ffbf3cde8,7df8cfb1d3b9..000000000000
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@@ -453,11 -394,54 +453,59 @@@
  	status =3D "disabled";
  };
 =20
 +&i2s0_8ch {
 +	/* hdmi sound */
 +	status =3D "okay";
 +};
 +
+ &mdio0 {
+ 	#address-cells =3D <1>;
+ 	#size-cells =3D <0>;
+=20
+ 	switch@0 {
+ 		compatible =3D "mediatek,mt7531";
+ 		reg =3D <0>;
+=20
+ 		ports {
+ 			#address-cells =3D <1>;
+ 			#size-cells =3D <0>;
+=20
+ 			port@1 {
+ 				reg =3D <1>;
+ 				label =3D "lan0";
+ 			};
+=20
+ 			port@2 {
+ 				reg =3D <2>;
+ 				label =3D "lan1";
+ 			};
+=20
+ 			port@3 {
+ 				reg =3D <3>;
+ 				label =3D "lan2";
+ 			};
+=20
+ 			port@4 {
+ 				reg =3D <4>;
+ 				label =3D "lan3";
+ 			};
+=20
+ 			port@5 {
+ 				reg =3D <5>;
+ 				label =3D "cpu";
+ 				ethernet =3D <&gmac0>;
+ 				phy-mode =3D "rgmii";
+=20
+ 				fixed-link {
+ 					speed =3D <1000>;
+ 					full-duplex;
+ 					pause;
+ 				};
+ 			};
+ 		};
+ 	};
+ };
+=20
  &mdio1 {
  	rgmii_phy1: ethernet-phy@0 {
  		compatible =3D "ethernet-phy-ieee802.3-c22";

--Sig_/v/4G4xOP4Ty3+FxJBYJaREF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmKqhHMACgkQAVBC80lX
0GyxaQf9EdEj2sX8aMYt2oYtRDFAKtZfWyu5uPxXRy/XIxSeHhWwbsJN5jxX7LCO
hnkkChhYYpuKQ3V701jv6Dsp5fhwutUhAfKEnNSKoTNBMGsQEIfzj1O4j37z4vvF
+XvEasJnVBF9bGAlto4Mn/LGDx6fxlS73tzl5Vl4Mqg7wKrRrKaEr5M4EIr8hdt7
fHyOU6o1fXsO4m89N+fxDMYcgqgk3O0BUySONLLVVNVwDAjt5CFqddVs99crEBKz
iXreBnIc3zoCFSL5woFrNO6/87Jx/QGmRA9eRLA+B1AcWU3gJM17rLGutQQi7Pl4
UTlb6HGnjs0q1/zJXoAsD4XGRfQFiQ==
=t6C+
-----END PGP SIGNATURE-----

--Sig_/v/4G4xOP4Ty3+FxJBYJaREF--
