Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E0B31C6C3
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhBPHY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:24:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbhBPHYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 02:24:24 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD51C061574;
        Mon, 15 Feb 2021 23:23:43 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Dfss74jn1z9sVJ;
        Tue, 16 Feb 2021 18:23:39 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1613460220;
        bh=rEaruMpoYcfErqCESTwvdKApaMT8l7KJrGro1hs6ARY=;
        h=Date:From:To:Cc:Subject:From;
        b=ffE+IUQ6wk7RYgpgsT+L+JtCp3aD5cxTsNiv08FvCu08yKtJMiR/F3FO2ItD9yTpy
         8LvqnQ39cSqrq2ZJL0al86KNlxDWu1PzLkU1FT5XKcP3mVGZHLQG2TmBZdoVsxiRj2
         bkKnPnpPDtmCiqfwDh4Zq3akwZ5puZgr506bhzFF27ORhQRoiSqcuBRb5Lhxsq8dRe
         PDWFZWCrZjYPYdPivJOCTGg66tM4D/JvJL7IK/guyI9Orftcy5KKY7lJLbhlHB0H4l
         +fH8DWK3M2MRIDW6zduIAbItD45KdtAhh4Us1L0UvXgkJ6V/iJmWRQByz42s7Qo2rG
         l3TUXUsU/xWNQ==
Date:   Tue, 16 Feb 2021 18:23:38 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        ARM <linux-arm-kernel@lists.infradead.org>
Cc:     Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: linux-next: manual merge of the gpio-brgl tree with the arm-soc,
 net-next trees
Message-ID: <20210216182338.35915450@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/OJ5L35vA/7r0URmArYbGtqD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/OJ5L35vA/7r0URmArYbGtqD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the gpio-brgl tree got a conflict in:

  arch/arm64/boot/dts/toshiba/tmpv7708-rm-mbrc.dts

between commits:

  4fd18fc38757 ("arm64: dts: visconti: Add watchdog support for TMPV7708 So=
C")
  0109a17564fc ("arm: dts: visconti: Add DT support for Toshiba Visconti5 G=
PIO driver")
  ec8a42e73432 ("arm: dts: visconti: Add DT support for Toshiba Visconti5 e=
thernet controller")

from the arm-soc, net-next trees and commit:

  c988ae37c722 ("arm: dts: visconti: Add DT support for Toshiba Visconti5 G=
PIO driver")

from the gpio-brgl tree.

I fixed it up (I used the former version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/OJ5L35vA/7r0URmArYbGtqD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmArcvoACgkQAVBC80lX
0GwVsQf9FXV57Nj1WmR2vKTbRJnIrGhow6TU7NcxStXVGxHcU72o95qnx9RoFFT8
UfOVf7EC9EJBiFwNFwwmSwxEvk+Nrvj9huj9TPhX0ZzX3G3DAmI6XJyWNI46+e2R
mJlUxsaq8qDXUU8ZiJQ3k9TWPYuc4zF4Rwc3t9rMZfGNwepDlQL9w8yBc6os3lUH
cJrTT6f0Znyjl8HJjfJYJd9+nDWDn4QaGLyXBocb0WZwvvH+AKrzqMeAdkZQxWUO
iTCiTECS2iv2zNeJcXUxKH3PFe5K72ImKO+DTjX0PQGQhn3M1Ol1QlmvVTLM0IJ2
5+07+yUuN/KpIqaYcwjUgqzXk3bqQw==
=CTFM
-----END PGP SIGNATURE-----

--Sig_/OJ5L35vA/7r0URmArYbGtqD--
