Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4A4483845
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 22:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiACVSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 16:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiACVSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 16:18:46 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAE2C061785;
        Mon,  3 Jan 2022 13:18:45 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4JSTBW75YYz4y41;
        Tue,  4 Jan 2022 08:18:43 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1641244724;
        bh=Hh0Xu8CzloJ18V1XW3SwWA1qevripO3Bu5X5uKT101E=;
        h=Date:From:To:Cc:Subject:From;
        b=M9HaJx3/tOuTkm9Fmk7aOy5QwPDkOLq6bNsuhLIwL2t8/81zuQeCDNJy4ITxl5ElF
         IPjB8+R1SSY2czXXZCicqB6hSGoWeXIa+rjXrLdYspKGuwiLzZQp/9oTIFswKVH4sr
         fanYzbXzoIS1xVpM02cau6+jJB0ahWV2kCXuvTFX109/tjs7fHuEWRKrrTmqD/gPcf
         hb5D6kSjKoDcn9C/2/l6JXieiqL0qiCPiS6gTEEs3+H4nFNG3Qbe1VReZxaSFXf6Hk
         Ha4X9RexQYsMpe+6+zERXrxoYQVcsjoEIrmXlOCaswbjFFP1ZZofO6Jsf1yPcKdqYk
         m7c8Smb9ldwHQ==
Date:   Tue, 4 Jan 2022 08:18:42 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20220104081842.0fd7d1e2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UQ5wYEelhfA+eJJ/QtD0dxh";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UQ5wYEelhfA+eJJ/QtD0dxh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commits

  aa36c94853b2 ("net/mlx5: Set SMFS as a default steering mode if device su=
pports it")
  4ff725e1d4ad ("net/mlx5: DR, Ignore modify TTL if device doesn't support =
it")
  cc2295cd54e4 ("net/mlx5: DR, Improve steering for empty or RX/TX-only mat=
chers")
  f59464e257bd ("net/mlx5: DR, Add support for matching on geneve_tlv_optio=
n_0_exist field")
  09753babaf46 ("net/mlx5: DR, Support matching on tunnel headers 0 and 1")
  8c2b4fee9c4b ("net/mlx5: DR, Add misc5 to match_param structs")
  0f2a6c3b9219 ("net/mlx5: Add misc5 flow table match parameters")
  b54128275ef8 ("net/mlx5: DR, Warn on failure to destroy objects due to re=
fcount")
  e3a0f40b2f90 ("net/mlx5: DR, Add support for UPLINK destination type")
  9222f0b27da2 ("net/mlx5: DR, Add support for dumping steering info")
  7766c9b922fe ("net/mlx5: DR, Add missing reserved fields to dr_match_para=
m")
  89cdba3224f0 ("net/mlx5: DR, Add check for flex parser ID value")
  08fac109f7bb ("net/mlx5: DR, Rename list field in matcher struct to list_=
node")
  32e9bd585307 ("net/mlx5: DR, Remove unused struct member in matcher")
  c3fb0e280b4c ("net/mlx5: DR, Fix lower case macro prefix "mlx5_" to "MLX5=
_"")
  84dfac39c61f ("net/mlx5: DR, Fix error flow in creating matcher")

are missing a Signed-off-by from their committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/UQ5wYEelhfA+eJJ/QtD0dxh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmHTaDIACgkQAVBC80lX
0GwczggAhf01PzOu8pvO3cPuESZB3B+7nuX0/gLE3YR9EHbi7Th+v7mPThk177A4
MCBipWJxq7XuC1WqIi7zBRHO7Ps6Cl1j+06F5yM5fnP+DrdMyPdY2F5D8Fm3k4Bm
RaMBlCRG4zubTErgvnHmibiWrS6sysCYbd7OCu55mSJJ7W0BkSOBinhb3PYYQ/5t
XXhNmo9PHfODK52q1VOTdk3KqMx9ujhlBNDgdEFcvRFmDeRudLLARwOuuUF7x1Te
WfpBOUN619g6ncqMOYCv3V5R1kO3lX2Pdj1AKDfkrKPN8Fwj/RYV18VPXhfgBuur
yA6VoIyB4c8ISR4sGWMg2U2GY32l8A==
=7Cqa
-----END PGP SIGNATURE-----

--Sig_/UQ5wYEelhfA+eJJ/QtD0dxh--
