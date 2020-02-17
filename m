Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6571616099F
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 05:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgBQEX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 23:23:57 -0500
Received: from ozlabs.org ([203.11.71.1]:36593 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgBQEX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 23:23:57 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48LW8B4BVdz9sRJ;
        Mon, 17 Feb 2020 15:23:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1581913435;
        bh=wU6WLl+004OrvdB4lqUTRY1YTnwxyAtzqbhd/UVj8q8=;
        h=Date:From:To:Cc:Subject:From;
        b=OFO9x8w2MYuu0eLlIPbOCDhXmtsRItWW5451EmEVlvH4ILwPr++Kh1vFQBP3U52Of
         1thWHKLioMqARGPeiBmd+A12CMwcBvUkymKAg1LVY3VTNr+m+Uc879YmgnrSGBq0eD
         wawsP6/m6YA6XjRIeFb8zacHLY98Zu+DqaQREkB8EiozawwzqO/1ohCCfXtQGDbHQF
         sQzI9p/k1cXvWj8HFQUrv9Z2LUxjJCB2KOcZ98ooQLbeVtV1chUhZiS0NCbbH/8Qg5
         ZqH6gTAAGCevsPKpGWa/B6sKyIMiJXyXauUafSj84omIWufWOlgKdQVeHapb6VuoQz
         SPWxhqErXjCOA==
Date:   Mon, 17 Feb 2020 15:23:53 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: linux-next: Fixes tag needs some work in the net-next tree
Message-ID: <20200217152353.38a3ca51@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TZboYR8kijT.a.e+K5mXf.Z";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/TZboYR8kijT.a.e+K5mXf.Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  7bf47f609f7e ("sh_eth: check sh_eth_cpu_data::no_xdfar when dumping regis=
ters")

Fixes tag

  Fixes: 4c1d45850d5 ("sh_eth: add sh_eth_cpu_data::cexcr flag")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/TZboYR8kijT.a.e+K5mXf.Z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5KFVkACgkQAVBC80lX
0GzcFwf7BBRHjmOnfBYnC6SGRTL97BUa+w9pSA1FGpWE6WqM1tFrf4narNqdJXdL
1pOFsMAvYMxZI/0mgb0rc9fR5lfwsZrQ+CiFM32fEZipxXCvAiyYOKZuZ/cgtGFs
IFdkRBuQSvQ4c3y2XgtGAbsAhBBPP1yFO0vvSN3nAW8mabv7vKvVxTiyWhYwAG0Y
84/PhBkBzbyN+uzLCuHlRzdBThjLmBdLGEluSkDfigLwTyjvRiRMpsDTGP3QrIq8
85i2++uSX56bGIA59bLNIjBz0qyOCGsSTQPozR3+tP3xWen+YcSxERYoIEn7LDpt
haoehwA27LoE560/yWdxFM9DlxfK/Q==
=z68A
-----END PGP SIGNATURE-----

--Sig_/TZboYR8kijT.a.e+K5mXf.Z--
