Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3741F43C848
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 13:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239585AbhJ0LJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 07:09:51 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:41779 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbhJ0LJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 07:09:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HfQrW06xPz4xbr;
        Wed, 27 Oct 2021 22:07:22 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635332844;
        bh=4sHge8763CJK2clqMibxDCAuVJF3/iHsShOOAzO+BYg=;
        h=Date:From:To:Cc:Subject:From;
        b=Wu6Ors1cEnPmoZ/+gl/NNBd1PrBlP7LaNRZfYPNRT/7CO5hjVBxsV9v5E+ANhe3j1
         SmNOB7SaOVjY0iFyX4zbPGiZrBMl6pWus1iG0iiSx8PS2P3AIcP+xk47AOyqaWNSbH
         mf5PsQchz1Cl3AgkAWeIi4Gior7GccGHFQf3g+m2whVTxcfdT6gFQoTs5xksCr9KQc
         EpFXi7G3PYjTdf7sEBHbOUF4P5oDwDX8uOZHJ1Gs2ll/YdwKB3e7A4hWd3eGDOrE43
         8f8QRCx10LAZG+b59yaRad3TcY3etfA7Cj/79c7ZiadDqu2uYM3xBQDoeQrOS3wrM/
         6+7H2LOQSbumg==
Date:   Wed, 27 Oct 2021 22:07:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20211027220721.5a941815@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MJjPCj/iSdr=wKw1Jypjx_H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MJjPCj/iSdr=wKw1Jypjx_H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

include/linux/phylink.h:82: warning: Function parameter or member 'DECLARE_=
PHY_INTERFACE_MASK(supported_interfaces' not described in 'phylink_config'

Introduced by commit

  38c310eb46f5 ("net: phylink: add MAC phy_interface_t bitmap")

Or maybe this is a problem with the tool ...

--=20
Cheers,
Stephen Rothwell

--Sig_/MJjPCj/iSdr=wKw1Jypjx_H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF5MukACgkQAVBC80lX
0GzmXwgAh8aMswCJnCrTDV4QukJi0E2XpCQ9nj8Tp2TivazsKnGhM3/HF9XnPJBr
OA6vCkBc3H9YsQDMrdY/JUuUOXEPyGihVE9d0jIA5L2XMK1UxZL/VmwmmfUSp+UH
S9Yh2tzLRhrpwG//WgE+rEaJluZy7F+sWxrLl0IppTxUVn+DsiPl7bhWps996Eit
iqVP/H8oK9MZ/fR7siJ8yDZE2lHU1wCJDSuI0ncCCFRx7155IYIYsxjmDcX6Xmyc
PJgK1fr5fhDxkOTGSOVkqbHUj+1WvB2Obu65OP9NY33OhFm6MgEU0R0tvpaCnqua
nzr8k1+ZPltMRroFSbcmZp8puQ2Yiw==
=6kzS
-----END PGP SIGNATURE-----

--Sig_/MJjPCj/iSdr=wKw1Jypjx_H--
