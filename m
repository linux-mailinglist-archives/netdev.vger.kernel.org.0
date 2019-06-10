Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 367523BBE2
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbfFJShe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:37:34 -0400
Received: from ozlabs.org ([203.11.71.1]:43457 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387500AbfFJShe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 14:37:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45N21Q5Lkqz9sBp;
        Tue, 11 Jun 2019 04:37:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1560191852;
        bh=tyRH81QZ/gsIDJcqGVSsCOmInqosEBxW8vFciGK1or8=;
        h=Date:From:To:Cc:Subject:From;
        b=r5drR4KjryR9IFH0ovwWVYQNX3vLb6U9QvKpTfeispz7+E+4bwJjK860RonPvV9yv
         n3AnxM47dN37CoMS+fNjmt/uonGjbnQiKjv3eSZ1Hcp6YCSf5b+NqSGWZ6GSvpwV3r
         vGuLFN8vP9VdT7IWC+cXIwNo2eS3EdKApD3/hlJR6+Ki2LoCuMxWdnY6/3oPeGWxzB
         3pWiG5GpzuiA5AAKOusLdtcSSd8C6rqd2nU75WZK9dYQ1Hg0i7vsyr2W21Rb1GKVXH
         4QXxGjHctUZgqXXwAX4xlQJeUjHFwEhQeNTLdllY7xbTXpsD6mDxYU4cJbNXxqO9xm
         3Yd4eAtTmBNag==
Date:   Tue, 11 Jun 2019 04:37:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Dahl <ada@thorsis.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190611043722.54fb0099@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gzw/5FfKffZHbXx6xgzXs_="; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gzw/5FfKffZHbXx6xgzXs_=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  0ed89d777dd6 ("can: usb: Kconfig: Remove duplicate menu entry")

Fixes tag

  Fixes: ffbdd9172ee2f53020f763574b4cdad8d9760a4f

has these problem(s):

  - missing subject

--=20
Cheers,
Stephen Rothwell

--Sig_/gzw/5FfKffZHbXx6xgzXs_=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlz+o2IACgkQAVBC80lX
0GysQgf8DK/UXPAcRct4iFO5E0pt9iPWy5+BB0NC/8CDqr9L30x4WcZf2rsqm0r3
46RBVamnlgzepeENM18u6KErLPF53EWdt32n28BxGup+gcEuir7QVb4pFPr/foNg
Vf2W/gN6lYibSyf5wEcHoq5/h0r8kjx2CjyS6a9uulvmxLJ7JSJFQ1LUUfQxP8FH
GYQU8c9VY4c4Yk30RSf/IBigpgI3fvXfPYgiigcKV3D6RPQyXgqDg0vokVEfYXSz
vZyYB+XrPzdCspV1glmEIHvc8UWOvK+VWT3bv0BPOwMyWjEANO+4ryqg0elmymTg
8KUEpH86/6HT09Ibm07BjWsAfmAoQA==
=YM4m
-----END PGP SIGNATURE-----

--Sig_/gzw/5FfKffZHbXx6xgzXs_=--
