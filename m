Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B1933EACA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 08:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCQHuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 03:50:06 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:52757 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229675AbhCQHth (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 03:49:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F0j3g1csWz9sRR;
        Wed, 17 Mar 2021 18:49:34 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1615967375;
        bh=PGGR8WBQK7cqYJb7tmlnZjM+Il5OssCHJpWZmont0iM=;
        h=Date:From:To:Cc:Subject:From;
        b=iz/un/FBfVu3soN1PO39e8LaQyfFyQolIzti/3ndTKCx3r/FU2CS3C0TY5lbK1ycW
         ELLFB77UhMYLDdQ/hpQhyDnAUuHautuvRd12pPTHdzEtuQGYUTuncgOlqBVsigRxRw
         3WjPLrcMAUh9jGAh9j268BXsO16RHbIke/+oDsC2w6jhDqXU4SsZjKsgDAeLc/zBWl
         nv8+UFQH3ps3Ciso5vkCTz7EBCzHxn7kFNp6we3sy1Sd0Z7uyLmhokM9rcl2BmnQLP
         TnrGnhMs7p+4O93t+x49YM1XaI7u9xrgQrtaHBhvWPab9jF4VaVWqDreTTdogfLZaB
         F1r9Htac99cbQ==
Date:   Wed, 17 Mar 2021 18:49:33 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20210317184933.6e9e6075@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_N516kEJuNgIY/RLg4TCh.U";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_N516kEJuNgIY/RLg4TCh.U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (htmldocs)
produced this warning:

Documentation/networking/switchdev.rst:482: WARNING: Unexpected indentation.

Introduced by commit

  0f22ad45f47c ("Documentation: networking: switchdev: clarify device drive=
r behavior")

--=20
Cheers,
Stephen Rothwell

--Sig_/_N516kEJuNgIY/RLg4TCh.U
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBRtI0ACgkQAVBC80lX
0GzKWgf8Ct1o18YHaLVe+zUvqQxiheOtxbHGujQZTP8L1MrNswRLgkTKMKL8taJn
thBNFFbSJNtPNnKfUoFmUa5IRy7bcogYEV7R8H0oOmE6p2kctub+wOSWPBpyT7D1
CjJab25OfRJkFFKuQcJ3liS1aFob8BvJPnS+Gm68eI2UiecI8lZGZUGVJZ6+a6u6
pWUnjIT9JALyOdCeWdijs1dxHYyViAARnTgxBFdahI0BM/TTpBBlYeAIbL2hNJnF
gh4HN+0gs75BypWaDz/EAHfmytSU5Bi9r0KW4FAsBtMBYwSfGOOn4N/exjmTxv4h
YsEMaBZ5Qy6UZaqwCl6JxbZwfuLCCQ==
=2NEX
-----END PGP SIGNATURE-----

--Sig_/_N516kEJuNgIY/RLg4TCh.U--
