Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600B123CC64
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgHEQmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgHEQkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:40:07 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEECC034616;
        Wed,  5 Aug 2020 05:31:32 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BM9wD3YVbz9sPB;
        Wed,  5 Aug 2020 22:31:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596630685;
        bh=j8w8EuBO1+cpbq1KuEU666Od/hNNRqCbcp1rNpt5oEw=;
        h=Date:From:To:Cc:Subject:From;
        b=pLUXTHxN42q9ByPuE33ruB4nmahaXsszt8bpAIpPTfA6RA1vO3vbs/fHmKQ+Hon7N
         Rafklf5W/B5SmRE6vzqx9F2Y7PsQwz4/mIPgrol71jEPN6wJrmRmjra7ujp74MvY+2
         qZShvYTEL+37aiR7F4zoRwfN+OHIdBjBMY8EkLhBMBIXxI4WJMysVIQYXHugBfP8vJ
         zHllSfM+6WcZadDDNLzl2oopZTBVZcVRYkV+QjeIsJ1Z0esXc6Z26NdfLOx+WxUDvr
         DpLa2OG6x8bvZ3ZagFq/OnaM6lTv4npM9iU2hiqUDcF3JlSAyQPYiP472j3D3/3uhY
         ZPMww51D7nJLA==
Date:   Wed, 5 Aug 2020 22:31:21 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        <heiko.carstens@de.ibm.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20200805223121.7dec86de@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/iGNImgk4v6HDXIvgTQwoqbm";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/iGNImgk4v6HDXIvgTQwoqbm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (s390 defconfig)
failed like this:

net/ipv4/ip_tunnel_core.c:335:2: error: implicit declaration of function 'c=
sum_ipv6_magic' [-Werror=3Dimplicit-function-declaration]

Caused by commit

  4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP pa=
ckets")

--=20
Cheers,
Stephen Rothwell

--Sig_/iGNImgk4v6HDXIvgTQwoqbm
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8qppkACgkQAVBC80lX
0Gz4Hgf5AcOL3mJwLlnnFj7+zFUXWc6JxU8HniK9p2KGwMa5ISQE9lbmSUVTOXoC
ssxig80+QPKSO4XASSwEcB7RzdfkdE/phan/zxIKirQlPFlbaOlSb209yzGsyZLe
WaMCkuMIdPcT7Fi8clOk+yjwyujx7FTfxDcayUqphOmMMb+CxKKcqnXhe7Fv0sPc
25na5ErrG9A02+zS25XzE/KCielqumhgKfEyDmJDH7kZvQJrNlG8h8zof8juLIww
7o5UdQt9VIzVwlBy7FKZo9Pu0tltbL6tSm0DXtO5tRwYbd7Qub6QeZig34u0rtfB
zEMFJTpJriTcP3EHxbpo3vP4AVTn7g==
=216g
-----END PGP SIGNATURE-----

--Sig_/iGNImgk4v6HDXIvgTQwoqbm--
