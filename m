Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBDF225B0
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 03:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbfESB4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 21:56:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44601 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727037AbfESB4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 21:56:07 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4564r34PMLz9s9T;
        Sun, 19 May 2019 11:56:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1558230964;
        bh=6WnHFkBKRyJ8ZMsDGEqv1D2LTXDvuHlH8fxzICnfLhw=;
        h=Date:From:To:Cc:Subject:From;
        b=E82SdtFYtLOGTKEPDQf6EiBaBt65KDLQObZLI67has11tVMBP0oE1/Ejj9KTslrQD
         LwM+T4rYHwuOi/ctg3ODB5v8TcVPja8EH8aQDjG3utLYg1SE1TwWogA9J9RYu8HQly
         Qtv0l5fkOgr7uKxtGpEykrLVcPXQRh21tyn7RouOn9ssoY6GHDoatKIxxyh1Tgp+3T
         yd8L3CMZbeGCspzOzvNPWyja5OiAFZA7JJvqbPYMttEi55/lLjs3zvHVukka0FvZ/W
         seQEwMFnQ6eqDX7Rs/RFf6LULYdERu8wjqR7nzClqQcYYEny3o4+RgwSXyehFCjYNS
         +JSGEsYyoCNYQ==
Date:   Sun, 19 May 2019 11:55:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Junwei Hu <hujunwei4@huawei.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20190519115554.5fb4401d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/F8Ln1Iv=xRyhhRkafI0faUa"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/F8Ln1Iv=xRyhhRkafI0faUa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  532b0f7ece4c ("tipc: fix modprobe tipc failed after switch order of devic=
e registration")

Fixes tag

  Fixes: 7e27e8d6130c

has these problem(s):

  - missing subject

Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/F8Ln1Iv=xRyhhRkafI0faUa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzgt6oACgkQAVBC80lX
0Gzdjwf/ReTHS6gphp80Qg9+IifkL9yZGNbTP59/YBBJWkSQD8ElZovA57jFum1D
aBZ0CjcePFJ6qrQbUK4t0jCyviSY2yyxzeA0nTB23MENUtJJjPv55557OPtb5eiR
7sr+Nh9/59WN7smM81yZbGaG3BviZeLMKyg1XVLA3uQ+wPAZh49QPlzRk5xQzgrm
nE6woXxj8UIWBtufUEOfJjOXgaQgOVRjYd3XUxL5TMYZBWzd7Plpix2y0K0X93LV
mIxfNTofLInV8iMH9hdHNZRo1xwwhaK9ytppeXPrC4cMYOJ+f/eSBiRy/R09LJSZ
qmLE/UnfUHxZTAZU5YPztoNa0VvGMA==
=5Ani
-----END PGP SIGNATURE-----

--Sig_/F8Ln1Iv=xRyhhRkafI0faUa--
