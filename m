Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31422572B8C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 04:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiGMCzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 22:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiGMCzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 22:55:38 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6B260C4;
        Tue, 12 Jul 2022 19:55:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LjMgS4LfCz4xv5;
        Wed, 13 Jul 2022 12:55:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1657680934;
        bh=LfruLt7o+TV8q2pXaKLuASGwJ623FvrOSmbp6WNG5VI=;
        h=Date:From:To:Cc:Subject:From;
        b=LUASzY+xNYLF39TrRI3a8yYTpEozXIqf+VocQ8vd1MWc/6fncSXbfKKNcRRHZUZew
         4Bi7zQFBwcjTwV3nHgz2vX/vlAtxRI4DoGOcWrxSVRQXvwozEnANzZ/1gJQqKlnMg6
         IZAxsz555W1E4ixdfIeS/5tOM3rWXN+RBuwZwqjPPOgRHPAWdbVcZYL8+nCuZ0QnQ+
         QO+RixBB+53y3xmFV/WBQlgKr4Lt4p1q7TD6W8y5gDPvUpq0zEonUb28qWynIji5ll
         WiCoWihSVlsEH133yxFbiIUR/4HyxGeNmCjvJpsJ7K9EEtc5/T8gUpVI1FCvmnv6WS
         4ie3n9VoOULTw==
Date:   Wed, 13 Jul 2022 12:55:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc:     Networking <netdev@vger.kernel.org>,
        ARM <linux-arm-kernel@lists.infradead.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the arm-soc tree
Message-ID: <20220713125526.7fcf0bbc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0Orq5.BHRW6j0SYm74Q40do";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/0Orq5.BHRW6j0SYm74Q40do
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
  arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
  arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts

between commit:

  8c1be9336e9a ("arm64: dts: marvell: adjust whitespace around '=3D'")

from the arm-soc tree and commit:

  4ce223e5ef70 ("arch: arm64: dts: marvell: rename the sfp GPIO properties")

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

diff --cc arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
index b9ba7c452a77,5f6ed735e31a..000000000000
--- a/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
+++ b/arch/arm64/boot/dts/marvell/armada-7040-mochabin.dts
@@@ -34,20 -34,20 +34,20 @@@
  	sfp_eth0: sfp-eth0 {
  		compatible =3D "sff,sfp";
  		i2c-bus =3D <&cp0_i2c1>;
- 		los-gpio =3D <&sfp_gpio 3 GPIO_ACTIVE_HIGH>;
- 		mod-def0-gpio =3D <&sfp_gpio 2 GPIO_ACTIVE_LOW>;
- 		tx-disable-gpio =3D <&sfp_gpio 1 GPIO_ACTIVE_HIGH>;
- 		tx-fault-gpio =3D <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
+ 		los-gpios =3D <&sfp_gpio 3 GPIO_ACTIVE_HIGH>;
+ 		mod-def0-gpios =3D <&sfp_gpio 2 GPIO_ACTIVE_LOW>;
+ 		tx-disable-gpios =3D <&sfp_gpio 1 GPIO_ACTIVE_HIGH>;
 -		tx-fault-gpios  =3D <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
++		tx-fault-gpios =3D <&sfp_gpio 0 GPIO_ACTIVE_HIGH>;
  	};
 =20
  	/* SFP 1G */
  	sfp_eth2: sfp-eth2 {
  		compatible =3D "sff,sfp";
  		i2c-bus =3D <&cp0_i2c0>;
- 		los-gpio =3D <&sfp_gpio 7 GPIO_ACTIVE_HIGH>;
- 		mod-def0-gpio =3D <&sfp_gpio 6 GPIO_ACTIVE_LOW>;
- 		tx-disable-gpio =3D <&sfp_gpio 5 GPIO_ACTIVE_HIGH>;
- 		tx-fault-gpio =3D <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
+ 		los-gpios =3D <&sfp_gpio 7 GPIO_ACTIVE_HIGH>;
+ 		mod-def0-gpios =3D <&sfp_gpio 6 GPIO_ACTIVE_LOW>;
+ 		tx-disable-gpios =3D <&sfp_gpio 5 GPIO_ACTIVE_HIGH>;
 -		tx-fault-gpios  =3D <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
++		tx-fault-gpios =3D <&sfp_gpio 4 GPIO_ACTIVE_HIGH>;
  	};
  };
 =20
diff --cc arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
index c0389dd17340,33c179838e24..000000000000
--- a/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi
@@@ -65,10 -65,10 +65,10 @@@
  		/* CON15,16 - CPM lane 4 */
  		compatible =3D "sff,sfp";
  		i2c-bus =3D <&sfpp0_i2c>;
- 		los-gpio =3D <&cp1_gpio1 28 GPIO_ACTIVE_HIGH>;
- 		mod-def0-gpio =3D <&cp1_gpio1 27 GPIO_ACTIVE_LOW>;
- 		tx-disable-gpio =3D <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
- 		tx-fault-gpio =3D <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
+ 		los-gpios =3D <&cp1_gpio1 28 GPIO_ACTIVE_HIGH>;
+ 		mod-def0-gpios =3D <&cp1_gpio1 27 GPIO_ACTIVE_LOW>;
+ 		tx-disable-gpios =3D <&cp1_gpio1 29 GPIO_ACTIVE_HIGH>;
 -		tx-fault-gpios  =3D <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
++		tx-fault-gpios =3D <&cp1_gpio1 26 GPIO_ACTIVE_HIGH>;
  		pinctrl-names =3D "default";
  		pinctrl-0 =3D <&cp1_sfpp0_pins>;
  		maximum-power-milliwatt =3D <2000>;
diff --cc arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
index cf868e0bbb9c,72e9b0f671a9..000000000000
--- a/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
+++ b/arch/arm64/boot/dts/marvell/armada-8040-puzzle-m801.dts
@@@ -67,20 -67,20 +67,20 @@@
  	sfp_cp0_eth0: sfp-cp0-eth0 {
  		compatible =3D "sff,sfp";
  		i2c-bus =3D <&sfpplus0_i2c>;
- 		los-gpio =3D <&sfpplus_gpio 11 GPIO_ACTIVE_HIGH>;
- 		mod-def0-gpio =3D <&sfpplus_gpio 10 GPIO_ACTIVE_LOW>;
- 		tx-disable-gpio =3D <&sfpplus_gpio 9 GPIO_ACTIVE_HIGH>;
- 		tx-fault-gpio =3D <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
+ 		los-gpios =3D <&sfpplus_gpio 11 GPIO_ACTIVE_HIGH>;
+ 		mod-def0-gpios =3D <&sfpplus_gpio 10 GPIO_ACTIVE_LOW>;
+ 		tx-disable-gpios =3D <&sfpplus_gpio 9 GPIO_ACTIVE_HIGH>;
 -		tx-fault-gpios  =3D <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
++		tx-fault-gpios =3D <&sfpplus_gpio 8 GPIO_ACTIVE_HIGH>;
  		maximum-power-milliwatt =3D <3000>;
  	};
 =20
  	sfp_cp1_eth0: sfp-cp1-eth0 {
  		compatible =3D "sff,sfp";
  		i2c-bus =3D <&sfpplus1_i2c>;
- 		los-gpio =3D <&sfpplus_gpio 3 GPIO_ACTIVE_HIGH>;
- 		mod-def0-gpio =3D <&sfpplus_gpio 2 GPIO_ACTIVE_LOW>;
- 		tx-disable-gpio =3D <&sfpplus_gpio 1 GPIO_ACTIVE_HIGH>;
- 		tx-fault-gpio =3D <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
+ 		los-gpios =3D <&sfpplus_gpio 3 GPIO_ACTIVE_HIGH>;
+ 		mod-def0-gpios =3D <&sfpplus_gpio 2 GPIO_ACTIVE_LOW>;
+ 		tx-disable-gpios =3D <&sfpplus_gpio 1 GPIO_ACTIVE_HIGH>;
 -		tx-fault-gpios  =3D <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
++		tx-fault-gpios =3D <&sfpplus_gpio 0 GPIO_ACTIVE_HIGH>;
  		maximum-power-milliwatt =3D <3000>;
  	};
 =20

--Sig_/0Orq5.BHRW6j0SYm74Q40do
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLONB4ACgkQAVBC80lX
0GzKWAgAmBKBKIcK5/nJBTZ4m+QkFeY2EaRInTpxkn07bS9h6ecGcHsD4Q8Y7wvU
jnNNayvwn9Pr9KJ7+NpGQskl2cqqwGKH2wqiNvxUEYtOUebMOeEEPXwF3wMdXZWU
LAxv8NUqMoXkAaZaaJBS6qhyHouYcoDKx0eCRPtD49O6Bs03jovmRdFNA4Lx4fMs
efRdSQfEcGlot2sQiunjNz2vOyHW83opaQnFiufTDmd1sU4yLSnf7sIRjemm6bI0
JPwFieJ9apT4OxPm8HcJKgylWOZVISMT6MVQNVezlpJYwF4PJe7tqoAvZptefzzG
IDIseJeUq3AVQnNbZnhAvYPGSNZ6Hw==
=swrQ
-----END PGP SIGNATURE-----

--Sig_/0Orq5.BHRW6j0SYm74Q40do--
