Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0701233EAD1
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 08:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhCQHwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 03:52:12 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:50401 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhCQHwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 03:52:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F0j6S0Ztfz9sRR;
        Wed, 17 Mar 2021 18:52:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1615967520;
        bh=ZQrrFuBbFBqvyBQTJ69O7wWdyuKPYmiezeG9xGKpJhA=;
        h=Date:From:To:Cc:Subject:From;
        b=A+dd0GjO5gMsglTBgggZez+45DxMLnjorcUyM+wAsMZh+KvZrDfMxF0HbM8BXSxC1
         +QsMZm1VchbeHcCKb6LuttS62U9txcJlm3NianAWK5/smxmn8Y4Zvg53WqMSXvaKWQ
         PLbatiY4JS5lKGKDkVJKalpD7EizQtub7fNbML1qpkPkDs9X9+ys89tl2NHbL3X6Ed
         Ok3xsfVF4eXqx1onAkmIv9C5LkG1Avln6YsgrnNJMi6wZuux9qt6j68GfoAmAXHalJ
         QE+9il0T4OQEHZHuz5GseH8xi5MXCfjz3SCSirMIWjl6qYho7J5l/vP5w7S5uTNE0r
         DGcKjPHzGdBog==
Date:   Wed, 17 Mar 2021 18:51:59 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210317185159.3d5640b0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/B.Y7MI/u5uIPBan=Fv0FCED";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/B.Y7MI/u5uIPBan=Fv0FCED
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/dsa/dsa.rst:468: WARNING: Unexpected indentation.
Documentation/networking/dsa/dsa.rst:477: WARNING: Block quote ends without=
 a blank line; unexpected unindent.

Introduced by commit

  8411abbcad8e ("Documentation: networking: dsa: mention integration with d=
evlink")

--=20
Cheers,
Stephen Rothwell

--Sig_/B.Y7MI/u5uIPBan=Fv0FCED
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBRtR8ACgkQAVBC80lX
0GzSjAf+JGvY6Xe4f5jHsQewWOjKArv2wit6C8yuTHfghXK7belOgys24Ip5BsyU
2S2MCXE20XTs8kX2HFfvoIlFkf6KyX16I2Nsvl6pUKoBv7xGpT1At495PeEFaF+A
1RloXEf33WkHCKCaVlfFZoSet85wP7rmG44z2SLpFd9YXcFpjWfBG2m3ZpR7iSCo
gOtjIFa5vj9GP83gwyNb1/WyaN/G1ttIbpzm/sncDE/HKqIArmZfSVUmjYXieoKz
NRbZzDl5GSXPyoTVTfbJvRzIr5pPBAmix9iHVbrm8lgQgD7KGqOnYOM/O+bNO6nr
3VKRRZAF6fs2eHITvN67j2UsSNWx2w==
=O+wE
-----END PGP SIGNATURE-----

--Sig_/B.Y7MI/u5uIPBan=Fv0FCED--
