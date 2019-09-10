Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C242AED7A
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393471AbfIJOnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:43:01 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54817 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387754AbfIJOnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 10:43:00 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46SSS526h2z9s00;
        Wed, 11 Sep 2019 00:42:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1568126577;
        bh=8CHR1ql8lKCJuN/K0/AQDkfcgpKFggsliYfzwtuDJ98=;
        h=Date:From:To:Cc:Subject:From;
        b=PNqyeqmDVdVq6K+6REELrKsztbNZKrd5WGpOjpEnhPfzu2rLQnPFqH1IilTDFZfBZ
         n+sE9SEt1KtBG70rzKp4v/RaqUpRwX7gj4LHSBT57uNZvG1x6uixEZAZChrFlUUtoU
         eLgaAPvlXOBua93qVNfS8QU1U+dJtmbUiJFGIONTYq2Ib9wIdwXL8QASYeP0w9hvGQ
         NcKxw19HzvqtyqnJdo1gCRgcl+UfSKaNS70oQO/VQHn5L1GeAuL02Wn2+xeLhLfcu5
         sOKt5OwvQmOBKHfewQBRdZ2OxNOg3pL4durRyRpX7Z0xxppDSbm8u4PU3uRspiz+Le
         6JuI31/t8HR8g==
Date:   Wed, 11 Sep 2019 00:42:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Alex Malamud <alex.malamud@intel.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20190911004229.74d2763a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IXCx+HMwnXfQfdjl0Ux6jLA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IXCx+HMwnXfQfdjl0Ux6jLA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  aa43ae121675 ("iwlwifi: LTR updates")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/IXCx+HMwnXfQfdjl0Ux6jLA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl13tlUACgkQAVBC80lX
0Gxcogf+MfRk9WaWMCUTd8A0rPx9ITXCXhJlI3BVLAvjeF3ENW/O/ZhM7Z+/WiKY
oHfUS9MlBWjawP43S0p5wy5nfG4fqbXhdlFTi8m02FMmE0Qy/uWskMgnwL9MTlcy
ydPKNytrIcGNtQn5LC330OfqpTwPJnV2YqohZ4exljA303yi068J2/ZkPnD/os2/
8oC9fIoQC1CvhZIs5EWrPLs4aquNGsi2fwac3sIMHA2pIdptDGUwCLS3JaX64e9g
UmtVFzGE/+7vX8Rc1p18exv0S8F142Z5MXlORJgFt4dtAt1/CWVHO7uoOtMNz6AM
TLpXWg7BuCrSHAuY+j/viVJ2LsFaYg==
=MMVg
-----END PGP SIGNATURE-----

--Sig_/IXCx+HMwnXfQfdjl0Ux6jLA--
