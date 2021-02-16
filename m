Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A9931D1F6
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhBPVSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:18:36 -0500
Received: from ozlabs.org ([203.11.71.1]:53331 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhBPVSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 16:18:32 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DgDMS4M1jz9s1l;
        Wed, 17 Feb 2021 08:17:40 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613510270;
        bh=R0LNSibBu3OIIlayy5e6FVxII6mrY/kC2W+SZs3BLVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oTrkyjlLVK00IS0LaRzkcsrwt8Qbghswlun+/yWZxyKc3ovlz7bNQY9jjyS6z2Znk
         cyHktHl8g6EFE9o0/9SfQTB/dn61HnjdQ46mrQT+ftgKe3q7bfQtPCjku/maM6fA1A
         +wMApI/2Sc4mI0PXTyy5GCdcnHqy2cIDEFJDyFT6/niISBfgTxEwJqToP1QJ+R2HJC
         Hjg9tL2qlLQmyZkdvdaAJwsK/2b7QbsfpQvbYW3qUzuHca+PZKyEH01p9dKUPiLNfs
         p5EVm0e502bgAEqzoJk5k8r8W1UztsOPVgn8kIsc+qGkj9Z0+MIlNOCnW7oZt4vi5v
         wGZARl4kvFAvA==
Date:   Wed, 17 Feb 2021 08:17:39 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM <linux-arm-kernel@lists.infradead.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the arm-soc
 tree
Message-ID: <20210217081739.6dfac3ab@canb.auug.org.au>
In-Reply-To: <TY2PR01MB3692F75AF6192AB0B082B493D8879@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210216130449.3d1f0338@canb.auug.org.au>
        <TY2PR01MB3692F75AF6192AB0B082B493D8879@TY2PR01MB3692.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/B_6obi80OI0A4YzQ7Y4XyJb";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/B_6obi80OI0A4YzQ7Y4XyJb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Yoshihiro,

On Tue, 16 Feb 2021 11:53:56 +0000 Yoshihiro Shimoda <yoshihiro.shimoda.uh@=
renesas.com> wrote:
>
> > From: Stephen Rothwell, Sent: Tuesday, February 16, 2021 11:05 AM =20
> <snip>
> > diff --cc arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> > index 2407b2d89c1e,48fa8776e36f..000000000000
> > --- a/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> > +++ b/arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts
> > @@@ -42,11 -42,20 +42,29 @@@
> >   	clock-names =3D "apb_pclk";
> >   };
> >=20
> >  +&wdt {
> >  +	status =3D "okay";
> >  +	clocks =3D <&wdt_clk>;
> >  +};
> >  +
> >  +&gpio {
> >  +	status =3D "okay";
> > ++};` =20
>=20
> This ` causes the following build error on the next-20210216.
>=20
>   DTC     arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dtb
> Error: arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts:52.3-4 syntax err=
or
> FATAL ERROR: Unable to parse input tree
> scripts/Makefile.lib:336: recipe for target 'arch/arm64/boot/dts/toshiba/=
tmpv7708-rm-mbrc.dtb' failed
> make[2]: *** [arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dtb] Error 1
> scripts/Makefile.build:530: recipe for target 'arch/arm64/boot/dts/toshib=
a' failed

Sorry about that ( ` is nect to ESC on my keyboard) it will be fixed up
in today's resolution.

--=20
Cheers,
Stephen Rothwell

--Sig_/B_6obi80OI0A4YzQ7Y4XyJb
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAsNnMACgkQAVBC80lX
0GzpZgf/fagFUK8DB5v3q2R3ZIAUt9Hdf040aIL1C9twogfZ2rZDWfnnkuBUthdR
3QG5CWWj1op+fuuCp0IWC7n18bcVHVmv5e3J6Y91JkjO+OUIsZKv27BP/enBHl0D
rhJKLVDDN0xA1mKtTV8u8dQh23puMVun8zXx9yFgQjKwUbEu6UiUtKCRCYU0MfKR
+KkPGZ/IdRrhUJhaqbWwbxoTC9yj2F1MEXJYXfgAZxyTKg2rpesbIIEickIkXkIx
2sGVDmduHb+yQS5Sqfjul9l4sjGxaHj+CaLlw5HqAO9lKAdkY9EQsmEiUuybpL9g
V2x6WDPo5wo9R3BEZWeX6/dGzdAruw==
=ZIv2
-----END PGP SIGNATURE-----

--Sig_/B_6obi80OI0A4YzQ7Y4XyJb--
