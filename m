Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE2F83DD5
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 01:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbfHFXas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 19:30:48 -0400
Received: from ozlabs.org ([203.11.71.1]:48983 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfHFXar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 19:30:47 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4639qS61rBz9sBF;
        Wed,  7 Aug 2019 09:30:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1565134244;
        bh=APD0Xj8POeQN32pet+v6/GF2149kJ9ghQPB0FuUWBkg=;
        h=Date:From:To:Cc:Subject:From;
        b=UqjhZFxP0UDRgBeKupXYvUOIg9E+vdkBVqux+c6jNfYbNTDY3yJZBDINuAk52hcDi
         6rrfqbXTBoFHkUOox/LRmmz+WLJB58GlApEo1nScFdmFtwfWa99Nm9+7d/iL/p6tYo
         7W6H5BmMi0IX7rnQpiW+YnvAtC76za0Lo0+aSpaZFz/8E4ehe7xG7tStWXkAllgHEX
         4DRa+ZdugGuiOU7H4rb5OgKOAdaxxuOtHlzHLb9kveZheJY9E+XjJviRNurD7/MW4x
         6HFeEUHPdFdj6ibOXUzeeLQmMDHWqteEcdRDFgUqymzsNHRmHwDPqp6brmNhT40cZo
         S1/imaQVf5hQA==
Date:   Wed, 7 Aug 2019 09:30:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yifeng Sun <pkusunyifeng@gmail.com>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20190807093037.65ac614e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DW/fZ2_35iFfbVHoi7N1nDf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/DW/fZ2_35iFfbVHoi7N1nDf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  aa733660dbd8 ("openvswitch: Print error when ovs_execute_actions() fails")

is missing a Signed-off-by from its author.

--=20
Cheers,
Stephen Rothwell

--Sig_/DW/fZ2_35iFfbVHoi7N1nDf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1KDZ0ACgkQAVBC80lX
0GziCQgAkssM2BUps+5KtP9aXRfOKQ64fWWZQ7dc2p1KAisbH/bsFDGAabL9s4Lq
KKgB8teOGv4npZtbbPxIV0KdsLkxNAfE8tP3TZVYSVqck7Ldy2lU/wEb6bgSNEF6
7h2D4PoIvkY39+N9jIOuTpp8Ykra2kup8dwhD2+YILsBlblZjRC9mD2VLFq4TQwD
WU/q8UEGWZ++2DxLOtSIIKCVrh/WJZKuDhhPHuCjYN50qcjiyGZJGbW0ZWzirujY
5moMDimPjXc934ju5gMm5OK933GVKY60s2b+d0Fc+0jrZFyyipf1zLYdTtIVBDUq
yVpwP/RAW33cPT7Nhwt956cjw2WUIg==
=g7M2
-----END PGP SIGNATURE-----

--Sig_/DW/fZ2_35iFfbVHoi7N1nDf--
