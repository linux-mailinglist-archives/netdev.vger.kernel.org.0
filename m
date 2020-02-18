Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 027CF163351
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgBRUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:45:46 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:49769 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbgBRUpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 15:45:46 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48MXtc1GxGz9sNg;
        Wed, 19 Feb 2020 07:45:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582058744;
        bh=vcH78/WKpaQSZFfOI9MHiMt3W7LNLVfvc8SLfALOdK8=;
        h=Date:From:To:Cc:Subject:From;
        b=Q60757T88nE1c+zQg6l1Hjz7twjfcu3z7hWDFDEcRGpNauM3c1tXEMSyzrogLDj+p
         b9nzfH8U7Llhf5exdXRt0M2rJ7uayl8Wi+5Hxzoy3uzGIylaZdpLktSpG1x04cAZb+
         sfcLibVt0i69HPKlSdaM6H1oRvQIovA+QylV2PKsDBThiTE0P4A6HvFDnnq3fcVEwE
         Y0lb0JLEvh39+DLFNS6+b3IOLIJgw+Dscm0Gnq553oDKxkqfXTGacWomYDkMEixa3k
         vHkk4/jThXeG9MNTf2ZLJ9KC5hBrRaaL0dklXwjd/ve/3VDsvDPM2okGk8Tt5iHfB0
         AabV90k9ZFjeA==
Date:   Wed, 19 Feb 2020 07:45:34 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>
Subject: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20200219074534.33c21dee@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/HwP/tRR4zvaemdF0dLGNw7T";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/HwP/tRR4zvaemdF0dLGNw7T
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

In commit

  af6565adb02d ("qede: Fix race between rdma destroy workqueue and link cha=
nge event")

Fixes tag

  Fixes: cee9fbd8e2e ("qede: Add qedr framework")

has these problem(s):

  - SHA1 should be at least 12 digits long
    Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
    or later) just making sure it is not set (or set to "auto").

--=20
Cheers,
Stephen Rothwell

--Sig_/HwP/tRR4zvaemdF0dLGNw7T
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5MTO4ACgkQAVBC80lX
0GztbAf+JpmdkPPYQtOSJJUfzA2bYbQLU7BZkQc1eyfpPlSIpHiSDKTFRRCwuhqp
l4rte/+LlSdfclqWW4tcnrpPf4YaPbTNebGLMjizVfUEWvoRCXF3Pq+f5H3Bghhv
7Y0YkzHbJEbU0OYX491xL8/nDYJZX/GuYPjGHxuZnB628aOqHRo+oogi/+2feZDJ
iY2B0mpNR62rSn/f4yFkf9crATyfd+Yws4nvgH+g1x0NlQpt1VhO2Eyt6mWwtJsF
J0NvmjucPevLat+8ldAp53rFTltLiuci/mVlGhpXh5CV/bv2+/ZN10w+387sI65A
JOR+HDg5woRvBLQAtUqPzzu0IGdXHg==
=6b50
-----END PGP SIGNATURE-----

--Sig_/HwP/tRR4zvaemdF0dLGNw7T--
