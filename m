Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBC521CDEE
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 06:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgGMECm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 00:02:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37043 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgGMECm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 00:02:42 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B4qjp6mDkz9sR4;
        Mon, 13 Jul 2020 14:02:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594612959;
        bh=vWeQzD85atpg+LjMgT4McIZoQRyk/+HkVAXmS4w/2c0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rr2m+A6YFY7yH7vjsBrmHnpkNQ2Pw/szNrPHXda2KEkIAbCML+ZoPE4Cs/l85Yyh4
         F4tIdB4UcV5S3rNa9sbeTXB29a+n1uGqn510Za7aMK/h/eIafM32XNggwG/1V5nz/J
         BoGwmHFbAEjhs1Exrv4g//EY5PJ4FNyD3UM8gvWz5wJhmnrTep54XfdDojC3/HYH5O
         wtvCg7CXvrxW18YbtC+/0NS0ABznm/LEJsBZCwc195wEcjKL6q+6OmG9fS4HU0HVYF
         EFxtvV/8HkDdAYgS14yup5Iv0ir3n5/GW1yV3IgBWNjt08KFu3cK7OTll1N0OTLWft
         TJD4wRChymSxw==
Date:   Mon, 13 Jul 2020 14:02:38 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>, broonie@kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, mhocko@suse.cz,
        mm-commits@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: mmotm 2020-07-09-21-00 uploaded
 (drivers/net/ethernet/mellanox/mlx5/core/en_main.c)
Message-ID: <20200713140238.72649525@canb.auug.org.au>
In-Reply-To: <8a6f8902-c36c-b46c-8e6f-05ae612d25ea@infradead.org>
References: <20200710040047.md-jEb0TK%akpm@linux-foundation.org>
        <8a6f8902-c36c-b46c-8e6f-05ae612d25ea@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/a.F=98_FQpFriK6K_UyZ8YF";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/a.F=98_FQpFriK6K_UyZ8YF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 10 Jul 2020 10:40:29 -0700 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> on i386:
>=20
> In file included from ../drivers/net/ethernet/mellanox/mlx5/core/en_main.=
c:49:0:
> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h: In functi=
on =E2=80=98mlx5e_accel_sk_get_rxq=E2=80=99:
> ../drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h:153:12: er=
ror: implicit declaration of function =E2=80=98sk_rx_queue_get=E2=80=99; di=
d you mean =E2=80=98sk_rx_queue_set=E2=80=99? [-Werror=3Dimplicit-function-=
declaration]
>   int rxq =3D sk_rx_queue_get(sk);
>             ^~~~~~~~~~~~~~~
>             sk_rx_queue_set

Caused by commit

  1182f3659357 ("net/mlx5e: kTLS, Add kTLS RX HW offload support")

from the net-next tree.  Presumably CONFIG_XPS is not set.

--=20
Cheers,
Stephen Rothwell

--Sig_/a.F=98_FQpFriK6K_UyZ8YF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8L3N4ACgkQAVBC80lX
0GxeJQf/f6Wyg7WRuxi4cpGEg9Z6M6hlgGSMFlkj3ZiCJ+L9O0HC3d21ZBJm8oOS
PQBMbSZI8KnWqWIlIW922w82Wz3plpENMPiQZFo7rqAev47OHt/6ICuHLBcVyvVk
REoOq5rp4cAIVrynBaOpldxRfiA+ympEdq8Mefz3/LYB60FRAoXIHe2G1xbXiv/x
v9TPVFNef5TOurprjSmv4UkBz2myohPfn5m57Ps9veUrZldgB49eoTUTIOwrLUGz
alWdiIW5hCAXttqNqnpMhtQJUNLxuR52gIxOBhPgm7f+8J0BT2lqvFtLGLghFVkg
9VjdxhP5ut4zxxHzMzurJuSAR/XvHA==
=M9pq
-----END PGP SIGNATURE-----

--Sig_/a.F=98_FQpFriK6K_UyZ8YF--
