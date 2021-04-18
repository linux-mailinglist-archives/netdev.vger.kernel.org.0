Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6293637ED
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhDRVxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbhDRVxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:53:49 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A695DC06174A;
        Sun, 18 Apr 2021 14:53:20 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FNkGN588zz9vFw;
        Mon, 19 Apr 2021 07:53:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1618782797;
        bh=fIzDG0i9+CR/iZ/zDgMcO3BiPzoBqo5hv6K6xQMj08Q=;
        h=Date:From:To:Cc:Subject:From;
        b=bm3S7SEu6zPA1ZES2KKCdqQnJ2aYv5CcQNZiupuHmR23dvtEERoFViJuKG2jm95tb
         79mXw8x2tu+PAFhjx25N4J97lSQElDmZ8y+yJb+hyQDIpAL0KVIx3PVUg/jdG/EUBO
         NyzwZrLDM7Z3F93WpCnnr/a22rIqKM7ci85Q1FDeZK7UHp3IfQnIeWaxDJWF1qr846
         9QPBuq+tRa7f/Ly4JD1oXE2jseN2XZYHkedXzNnIMga/tJnVK5frDoByMi4lW+tVls
         5ZPqOEkITuJUCmkhSok7TINO3NeH+3eNOIr927gSwVxkKW6kWxBijB3KD1RSE2y49l
         S90UOwSfwCy6Q==
Date:   Mon, 19 Apr 2021 07:53:14 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20210419075314.40c9132e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/us_yVVTPNbT6W6yB1yCWyyI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/us_yVVTPNbT6W6yB1yCWyyI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  0e672f306a28 ("veth: check for NAPI instead of xdp_prog before xmit of XD=
P frame")

Fixes tag

  Fixes: 6788fa154546 ("veth: allow enabling NAPI even without XDP")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: d3256efd8e8b ("veth: allow enabling NAPI even without XDP")

--=20
Cheers,
Stephen Rothwell

--Sig_/us_yVVTPNbT6W6yB1yCWyyI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmB8qksACgkQAVBC80lX
0GxyRwf+LnDd1f1bSL/wD8l95FOZAtUItD92/QKjvkkRm5GiQkIj1QAaari974it
GAD0gum29XKaSBhKaLzpW8yUTWCsuINIpyU9rcP0zNaWNhvyh18GtdrWrhp3dk6u
825bFcdiYx/tcEqAMAIddFKpoIGFnCGi009fo4zSO92Ks+ys1jlG7y0Z46cP5ZmZ
8VeK9vaEkHdmVmTpGALTjLZpV4cApFhpfIEBFSuMpa6pAc0H469/wGNVYEbYc3ia
JDGmCvRnayVribCrhSwDt9JvuV1OqIrqjcFx8f07tMPyyUmGzE5xamGvdqNCkw/H
4bvhj7gbQzijZbcIT5LIhD+os1Jjkg==
=UWIe
-----END PGP SIGNATURE-----

--Sig_/us_yVVTPNbT6W6yB1yCWyyI--
