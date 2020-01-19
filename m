Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A589141AC3
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 02:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgASBGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 20:06:09 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:59575 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgASBGJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 20:06:09 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 480c7L6K7fz9sP3;
        Sun, 19 Jan 2020 12:06:06 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1579395967;
        bh=WB2vHqaSoZLAA5Tp3IIAjL7KxrkZjeK/A4htgKEjG4w=;
        h=Date:From:To:Cc:Subject:From;
        b=VSivGPphpDCu4Q0KxR1BvrvEeK1LJPqqWpFU/5d812sWpydkXsYUSalp7dGKmyr58
         GtAoxqqXaZY26fpML9o4ZBmAsheL6pJJyVKnBJgGR5kdrdS2WRJax3vRat1L9OCvp+
         gVa9ViHYQYfTBRd0f8l4TZlVKO3/95c0Er6vi4RCR5MgJTwg1XjHAQQciZ6V107Lu5
         m7sVDsTLVkL5PY+FkegFcvam859+iJma21bTBxdoKgmI5tr7Xk5Ukob4Veeev7y6tQ
         gw7TV6OnxxGWGMRylzea/pZ6xudOAO55NjXg1NQPxWHpVaLQ6gEwbs1ZNASEH6S3rU
         Psj3MTgixW9qw==
Date:   Sun, 19 Jan 2020 12:06:05 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200119120605.5417fc50@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_MFy/01xHWYblFpWPCbdiXU";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/_MFy/01xHWYblFpWPCbdiXU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")

Fixes tag

  Fixes: 01b0ac07589e ("net: dsa: bcm_sf2: Add support for optional reset c=
ontroller line")

has these problem(s):

  - Target SHA1 does not exist

Maybe you meant

Fixes: eee87e4377a4 ("net: dsa: bcm_sf2: Add support for optional reset con=
troller line")

--=20
Cheers,
Stephen Rothwell

--Sig_/_MFy/01xHWYblFpWPCbdiXU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl4jq30ACgkQAVBC80lX
0GzFxQf/Wcy8+0nzLxFi7ni6yXKnLjkIUGFrYNj3oCR8jerj+z6uWVMaQxqhMuBj
4NGpsfulLGT20d47bx/IZix8BjvFOAb+plHwSpHYO5NMKwcbjADoPYJPn5dS553E
ojubAqbfet8qwAPSMeHjjoeCpEE/TDdBE3nhUNhusOJbrrKsoiXGCItIWvd+taV0
r4NZ+sFYpzxlFWjbML5o9GgzHW0NYwj75T3C7Z0EML7R0dbtL3Bl1LobQHMhgP+t
ceVUMBeRQHNTg0PWd3UsbqmbjVDqwveRyylQDOgsGalsA76jy16rr+QEzR9Yq3Kx
SNPVspKfcsiB51qhnkXRuw12kYS2Aw==
=P1JM
-----END PGP SIGNATURE-----

--Sig_/_MFy/01xHWYblFpWPCbdiXU--
