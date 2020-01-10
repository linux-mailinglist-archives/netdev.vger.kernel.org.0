Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D35351368D6
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgAJIP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:15:56 -0500
Received: from ozlabs.org ([203.11.71.1]:58839 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbgAJIP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 03:15:56 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47vG5P3y58z9sRV;
        Fri, 10 Jan 2020 19:15:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1578644154;
        bh=L78XeBokIql9jpsHUpVD/DbiFKAMEXYZFmR+XrULacU=;
        h=Date:From:To:Cc:Subject:From;
        b=ulAy98SCMDO0FEG8f0mdBAKFFCv0N/PZVG8qdORNmYRAp5aNEsH1NUR5ga1wjMW96
         zezF03ahMoxSJYGk9Pmry0yV2uH7O3z5q6mpl21JolaVd5T9/IYnIG4d2JLfag16st
         dAgBtOSfbGv6Fye96oxiHsIh4nvcQyljvSouZOHLd4L3sjj2ILdIBPsBBb1F94joRn
         /+DBZITOj5TYvgV/+Q8Dm9wp7XvNLEtYTnn6kHCeAIOssFxatPA6kf8QDQ8c1uLPzK
         1zKdj03Id8A3NrGFBT7dMKgnW6aYV7IfgZWhnsikOMYyjYXeuZr9fa1LPrttvMOpuy
         OpAjtpO7s8tvg==
Date:   Fri, 10 Jan 2020 19:15:49 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Radoslaw Tyl <radoslawx.tyl@intel.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200110191549.5d0a66e6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ibss0P6tDW9Y0q=rfHgHp41";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ibss0P6tDW9Y0q=rfHgHp41
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  aa604651d523 ("ixgbevf: Remove limit of 10 entries for unicast filter lis=
t")

Fixes tag

  Fixes: 46ec20ff7d ("ixgbevf: Add macvlan support in the set rx mode op")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/ibss0P6tDW9Y0q=rfHgHp41
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4YMrUACgkQAVBC80lX
0Gy++Af/c9IKMnyHGxyL/2jJAB75pFrjuyExYS2U+vWV5Ft4skPOOs4BxZXIV3Q1
OGPRpO5ShcK1I9ajvXrIeNUGsbo7pj2hSAJ1ZEinN58ceFrWjmYDoiE8ROYlHnjP
jIwJCL+fN2wXrYzHeCDk1Knhh1QJF7bObT7zUo0a69/SE2s5nuK1JzUwzfzaTGhg
Thnx0eSYbrCRQ8d8SE6SAbLkk7pOWpMWqBNdwzWVz0Hxa5KGg/uSMv1j0uZwvxzY
LYsb5CuniESpXWQDS0oHFOqYrINL1Xq6WXct2yigMJAChsdecJm9SmFd6zXHBuoL
s5CZqvju4JpJUogDrWoQUKrJTXnMpQ==
=B/YE
-----END PGP SIGNATURE-----

--Sig_/ibss0P6tDW9Y0q=rfHgHp41--
