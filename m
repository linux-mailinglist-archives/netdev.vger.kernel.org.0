Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F17A1988D5
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgCaAXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:23:40 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:34781 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729019AbgCaAXk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 20:23:40 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48rqn46N8rz9sSJ;
        Tue, 31 Mar 2020 11:23:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1585614218;
        bh=9r7wDHIFILZ0hqXYju725jtK4PGLc9++mStNdgrkjew=;
        h=Date:From:To:Cc:Subject:From;
        b=msadQkSpYy+CKYaF0PSoRTvR8gj1QlSaoTeTtdfhYz0FjO4F+Qj62Y65u+Es+gi3p
         KP9BuIBN7OoYPZpzZiida8O5MmVSyNQtFtuSoSN6kc6O+5DqUyr53/E3d81GT1SPXP
         R33h5C48ZPCMoej/oOM6+0+IIvTfEgNhPokCPkjm6uDNLPyl/d1PZTRKiS3treD/LO
         VwX+tQG+zt4HJcWDak18+RrUV5S1KD1epO6dlNPuhQXqleQ5ZvFIGv0qqUq7ZNh8IT
         YwQ5trMFAi238uC98f912is0VCDvJtg85hsOxQQlHi1LnotUJK+jJo6U/wKOdFfXRz
         ++TVLLEJCV1bw==
Date:   Tue, 31 Mar 2020 11:23:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jian Yang <jianyang@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: linux-next: manual merge of the net-next tree with the spdx tree
Message-ID: <20200331112334.213ea512@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xF.fursOG1Ek/.9ANGWx=Gg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xF.fursOG1Ek/.9ANGWx=Gg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/networking/timestamping/.gitignore

between commit:

  d198b34f3855 (".gitignore: add SPDX License Identifier")

from the spdx tree and commit:

  5ef5c90e3cb3 ("selftests: move timestamping selftests to net folder")

from the net-next tree.

I fixed it up (I just deleted the file) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/xF.fursOG1Ek/.9ANGWx=Gg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6CjYYACgkQAVBC80lX
0GxUigf9HpgzmG8qDby9zCuA+R4g4pTJY9RqOIjjbSqO2+B70vYN2L3NHZiD8GI3
SIXXZX4DTRd/p9LbHr7+ojWqR1Ru4lFQpxYh7HQnuX+rNiNwwL8N3FxNVGJ7RXwx
LaV3EbqsLyVlNeg+OvPaqLwRRAb3/gTFg+5oWGAiM8jR674WKVTNqFMJiQgE7asZ
mV+DNcThLxGgmqdJv2VqNJ4T1qxQ2GKZhm8TQJlyKHp6fXXgr5RKP4XzND2zTFwR
ZGcN2kVqpg6+jyvhX7v+zbFJgVVIMUXEg02WBQMr6RGVdrx81bjs6AdzGolyIpN4
VGKZMvdsrb/5IFIi13RlrDtR3LSMmA==
=gT/b
-----END PGP SIGNATURE-----

--Sig_/xF.fursOG1Ek/.9ANGWx=Gg--
