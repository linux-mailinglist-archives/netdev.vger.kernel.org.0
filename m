Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75573280C6C
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 05:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbgJBDCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 23:02:46 -0400
Received: from ozlabs.org ([203.11.71.1]:33575 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgJBDCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 23:02:46 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C2ZYC59Bbz9sSn;
        Fri,  2 Oct 2020 13:02:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601607762;
        bh=j53jquxv8eIAVcycClyih3HfZma6HX/HBe3EZidk8Vs=;
        h=Date:From:To:Cc:Subject:From;
        b=HDtakTJPdDRTtFG+PENzQYZTKweVWPbsyJpb3IFvuXGx6Xt8bkCRVEJ8XHnZJiOlB
         LK9qxo4WSfVGFmWfB+v7vVqAjCKpftnRrLPDVREc/bpIm1KDZPwa5iNMInSadrBBkl
         WL2ixftGxEQt5wp2Apcr62UI47Syhf+814XGI31zJkNjwzdj2vPSaCTR6GaWpy2RVq
         8MXFkWLop3HfzmBdKr2Rva4XOHmnIbXg8NJyRUSQBQyfoFeZACrxi2lZunMkVS64F2
         F7Hr6x2PwiiXzUJBcIJbdCkOGdQFcYzQiq2AV/3xSKQFp/9uAHf6Vyj/6b7gAEnfc6
         fcsn8eCvGhXHg==
Date:   Fri, 2 Oct 2020 13:02:37 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marian-Cristian Rotariu 
        <marian-cristian.rotariu.rb@bp.renesas.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20201002130237.42fe476e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1DvaFRiXCr4m2OmR.rD6n_Y";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1DvaFRiXCr4m2OmR.rD6n_Y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  Documentation/devicetree/bindings/net/renesas,ravb.txt

between commit:

  307eea32b202 ("dt-bindings: net: renesas,ravb: Add support for r8a774e1 S=
oC")

from the net tree and commit:

  d7adf6331189 ("dt-bindings: net: renesas,etheravb: Convert to json-schema=
")

from the net-next tree.

I fixed it up (I deleted the file and added the following patch) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 2 Oct 2020 12:57:33 +1000
Subject: [PATCH] fix up for "dt-bindings: net: renesas,ravb: Add support fo=
r r8a774e1 SoC"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/=
Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index e13653051b23..244befb6402a 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -31,6 +31,7 @@ properties:
               - renesas,etheravb-r8a774a1     # RZ/G2M
               - renesas,etheravb-r8a774b1     # RZ/G2N
               - renesas,etheravb-r8a774c0     # RZ/G2E
+              - renesas,etheravb-r8a774e1     # RZ/G2H
               - renesas,etheravb-r8a7795      # R-Car H3
               - renesas,etheravb-r8a7796      # R-Car M3-W
               - renesas,etheravb-r8a77961     # R-Car M3-W+
--=20
2.28.0

--=20
Cheers,
Stephen Rothwell

--Sig_/1DvaFRiXCr4m2OmR.rD6n_Y
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl92mE0ACgkQAVBC80lX
0GyFkwgAk5IVGtAIGvgu9lD2+ANmo3Acy5T7ifjEcWfo3lxiJEoTeCEU61fwX2kM
RwfBBOscw5WrWZFAwo9KMxZX0Uf57fwCyYXm5y0ppRa8IZBhE9S7EL75sbmbvBcl
VTQZ8ryTOcYh+d+mOnyJzo0bT9lthZMYH9FSM3W9HcRNB4FxA1NvrOFM3EOzxnCX
Sq5IcmRpxODzw7JvMBUY0axMqje4vF+szYv81tNIryWKtvAvxKjkwIf+61GgDYYQ
htOAgWPFd+daht924kwG6QUUTsba05rfBwa1/uC1cNYOkkgmWo4ySoAa2WtADq1E
30uzNIKW9CQkbHBG++L6Lic9zJHBBg==
=U9tM
-----END PGP SIGNATURE-----

--Sig_/1DvaFRiXCr4m2OmR.rD6n_Y--
