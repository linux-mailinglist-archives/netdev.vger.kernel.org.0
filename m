Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D483A7D23
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 13:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhFOLc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 07:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhFOLc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 07:32:58 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EFAC061574;
        Tue, 15 Jun 2021 04:30:53 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G45jQ12zLz9sSn;
        Tue, 15 Jun 2021 21:30:49 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623756650;
        bh=HtbS6aoHqK2sgEyeiczMdwREj/mPYDnyiC3kromkPrc=;
        h=Date:From:To:Cc:Subject:From;
        b=KnQtUHgKvZViuM62Fwb1amqXTKSOnb6xvbkXeauG510wW0+I8nmSd1Xr+QzKf2IQU
         Er5RW+hRy5XvAIbrD7Vnq3xpbQko7zluJ3Dud1AkUnMd4zoi0yPiUqzSAGof3dlGss
         qDNFK0mRh3lKmq9IY9ROHRBiD7AJ+QQ+VXWTIKDzzWBnifMRcWjsEKUbHuaw0GiZGb
         G10lWLFplwCBaVnaAhCwUHVt+nTQBlT7ZszWDZucpve5GNQPgNN6kcBADShESd/tS2
         Z+4jmEE4sMauxXzs4vqLR9xjilwdvqV0W3Ew6spaEijNBGRyPmnzww6qw8d2pRBGIK
         pPMCgeqoo0hjQ==
Date:   Tue, 15 Jun 2021 21:30:48 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210615213048.782b0c60@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ChXGY=L_uy0_mz.JDRwHsd0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ChXGY=L_uy0_mz.JDRwHsd0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/devlink/prestera.rst:3: WARNING: Title overline to=
o short.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
prestera devlink support
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Documentation/networking/devlink/prestera.rst: WARNING: document isn't incl=
uded in any toctree

Introduced by commit

  66826c43e63d ("documentation: networking: devlink: add prestera switched =
driver Documentation")

--=20
Cheers,
Stephen Rothwell

--Sig_/ChXGY=L_uy0_mz.JDRwHsd0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDIj2gACgkQAVBC80lX
0GyQqgf8DynmHrURzMYA08a3oA5Dz5JQJan3JSnZQL8GCkYCX2LT19h9sU3uIuNK
hOo5mZWeSMa7+3rSCUkjPgBJnd32woMoIdPAxUYz7pLVHr82ir8aK2AYHRMA+EfY
Vm0h2a4fQ3RpmrReswcRG9k3V5cN5WWNEXFKxXHFOrsHlfrcF8nNR/SLMq5pTemz
uZlA2eN4XkzKs+H5Ud+EvzOyih5TMqjbvjsRze2F2HaB5lga56SvTO2vkMikpmS9
6B3nvfneDLAxrGLrcEhmvHA18+HjeLHeAKZEag/gXNwdxp71w1czn7b8bjJoXAGz
ye9JhcdW06ZinrLQ+VFM4hO91Ma0eQ==
=gVLt
-----END PGP SIGNATURE-----

--Sig_/ChXGY=L_uy0_mz.JDRwHsd0--
