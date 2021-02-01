Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90C130A247
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 08:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhBAHA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 02:00:57 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:56701 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhBAHA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 02:00:26 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DTf2H4gPkz9tkd;
        Mon,  1 Feb 2021 17:59:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612162775;
        bh=6EUWeozn2gOtd6OsNWzU6TOpVifdYqCM/JwIhZZ9ooQ=;
        h=Date:From:To:Cc:Subject:From;
        b=RVheMq0gPg1+ieiVbtFxPinHSqFSohAgC0FWh9nfyG2t7O1evViWLATGMLEZnFnQT
         ViiTcaJu85PFqostk04UATDWpQiGgA4NscV/R2UVT8bVSRIngzWuXQA6csJbJPQ7AJ
         230eDImrdI8/p6rjZM+T2T7jXuLuWv6szcg4z52qB3fusPrDR1yFoPIlGGc032RhOl
         sPqcTvoxj5lY+Yu6Y2ZtrIeiWj/5vH9+7Gr9/q7636tTqtHJgBlp97KBgWJsGXJN55
         zkLSODOnwRpzeaLt8+92sFZ3c39KdIsbqwDN51Kb/Txs0bjxRfX4Qyz9ldiGTPqfIQ
         WwLCPlDPt8qFQ==
Date:   Mon, 1 Feb 2021 17:59:33 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210201175933.12cbc38c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/WfIzfcW3RCLJxfPwZPxL=R0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/WfIzfcW3RCLJxfPwZPxL=R0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst:16: WARN=
ING: Unknown target name: "mlx5 port function".

Introduced by commit

  142d93d12dc1 ("net/mlx5: Add devlink subfunction port documentation")

--=20
Cheers,
Stephen Rothwell

--Sig_/WfIzfcW3RCLJxfPwZPxL=R0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAXptUACgkQAVBC80lX
0Gz1cAgAiVJzZbT9ypLlFxOR79WTntr8/TU78Oqh99x2xdvCVsbC/ARE1Q9/wWaW
9ZfqD4esknaAPttEy+WUz0+1BdPlFSDMlwwwwna8V3rYJj0Uo3XrgoX0nTxH47qs
FVydBBzelRs53t1bzI4AeAPfdic44/S+CBP/hMtE2PDGRitwEeIjM89H+5pRtml3
Ih9nnkblWpJOYI4oFv5p/J88i6MYkUDBS1BkB4pM/3DMBeIG1v8Thf6x2ztyM8SB
D28eghVry1yoQbOlRkcMGf0uYctdAdUYA6rrrcEVG8khpimKPvjCvztvF/CKEi41
GIYepwNqkGd/AginQJx/TyPUAfeJ9w==
=OBaQ
-----END PGP SIGNATURE-----

--Sig_/WfIzfcW3RCLJxfPwZPxL=R0--
