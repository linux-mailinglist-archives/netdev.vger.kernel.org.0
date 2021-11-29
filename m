Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2203A462647
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhK2Wtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbhK2WtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:49:08 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9093C0698DB;
        Mon, 29 Nov 2021 12:32:36 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J2xqM3DC2z4xPv;
        Tue, 30 Nov 2021 07:32:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638217951;
        bh=l9w9TSvhh87po2E861l9G8UwZN2i/VH+QsHq1D21drs=;
        h=Date:From:To:Cc:Subject:From;
        b=fi1gpbz+M5JzVx0HugxH98Da6n0wzsxC7+YsEr0EesKnrnmBRSMIGC+nVMjrVljuV
         p3h5qLjYKhyfoLF83swpTOFp/zWmKjiQM92+qseKRzY2o7qKsUAVETeOtB0e3skTvK
         ibK5EW/aYcW9Llc29UogmXXcx3G4c+xb81L1UPEQo2K75AZHR7iRgommcZ7BLwPuti
         HGlYQ1D66PeoPT2ZDUynNfQ5AuSQeoFWXlStyMhyiQ1Qj2mpvDwXSPRCvcZVXmQhxw
         gg/SjPISgPWRldg+p5G6NSztlzd413S0UGUF7s86LXEs1/YF6lDVIGOCL4U+uRahc9
         g8GXU2YDHQlqA==
Date:   Tue, 30 Nov 2021 07:32:28 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     msizanoen1 <msizanoen@qtmlabs.xyz>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net tree
Message-ID: <20211130073228.611fa87f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gjR3KYURrv4BnpyKAAQne2C";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gjR3KYURrv4BnpyKAAQne2C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  cdef485217d3 ("ipv6: fix memory leak in fib6_rule_suppress")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/gjR3KYURrv4BnpyKAAQne2C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGlONwACgkQAVBC80lX
0GwURgf9FW2bQqgeEUzIn8a/ReQAE/MbbZEtfH9PhcplmCOmwZeg3U6Ae7PfC4GF
MVvHz7R3eSr0Amn6Vzbv5kWu3lUKe6rN56ivYyArnVe+lPdTl+xVf8XNQJFLKgTz
VCVZ4WB+ZfvX7S52bMMoKVgN6c5ZYwULQTe/rDmk8wGh784BdHj/v5VTwECjFo+a
PDK8CcQxVy2Z33Ka/AOaH3r5LtmpkQv3vIOQxHAl7IJNIIoYvV7QhG9CXynZlYS+
BWEVlJiVWScl71TPxyTDIx0nVsNOyB0pZ6o66VSFaELHiEEy2VU9//nG3DXzMATA
tVyzoSB2pxOSRgQShYMct/pP+eX4fw==
=CJv9
-----END PGP SIGNATURE-----

--Sig_/gjR3KYURrv4BnpyKAAQne2C--
