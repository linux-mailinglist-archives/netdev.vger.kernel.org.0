Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4BF1EB33C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 04:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgFBCKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 22:10:05 -0400
Received: from ozlabs.org ([203.11.71.1]:45755 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgFBCKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 22:10:04 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49bb8m3VQQz9sSJ;
        Tue,  2 Jun 2020 12:09:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1591063802;
        bh=UbkV9G9ILzKj+CtGZ3U1KshR8wI9CyyIQiV1XZ+mZf4=;
        h=Date:From:To:Cc:Subject:From;
        b=A9LA87Wwp082F6EjV8hCHU/FUQ5f8KQL8L2oxu6eUchftAfXc93JHu7xbgnpRkmOX
         DTerZvTUwoRevqwMBCvRuMz5isBiGb0AoNkHWEc0sLZ1Vy7pNlbTUfCqINU4zNxAAP
         E7wt/itGwuA9vlmAiH8cNsG6JtVOGtYCa/YT0LV4OzXd4bbfeFMHxBPdueHiCiMtef
         L8uJKbqaNvwoxQt8JoPn2LpHsTREcMi3/eXx9Q7Eu8CDJYHTXyllLFwq4M1CvT45tP
         dOoJ0p0TqK+R+SGGyym5fpY0m9FIjhxBXwA38BQ4Ateu2oPhC9YhZgtYhr2HZVvVo+
         ttPYuOMCG4AWg==
Date:   Tue, 2 Jun 2020 12:09:57 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Mike Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: linux-next: manual merge of the net-next tree with the clk tree
Message-ID: <20200602120957.1351bda0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/g61fbTKRciyXS8ZoanT/Y9u";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/g61fbTKRciyXS8ZoanT/Y9u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt

between commit:

  7b9e111a5216 ("dt-bindings: clock: mediatek: document clk bindings for Me=
diatek MT6765 SoC")

from the clk tree and commit:

  9f9d1e63dc55 ("dt-bindings: convert the binding document for mediatek PER=
ICFG to yaml")

from the net-next tree.

I fixed it up (I deleted the file and added the following patch) and
can carry the fix as necessary. This is now fixed as far as linux-next
is concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 2 Jun 2020 12:07:03 +1000
Subject: [PATCH] dt-bindings: fix up for "dt-bindings: clock: mediatek:
 document clk bindings for Mediatek MT6765 SoC"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 .../devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml       | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericf=
g.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.ya=
ml
index 55209a2baedc..e271c4682ebc 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
@@ -20,6 +20,7 @@ properties:
         - enum:
           - mediatek,mt2701-pericfg
           - mediatek,mt2712-pericfg
+          - mediatek,mt6765-pericfg
           - mediatek,mt7622-pericfg
           - mediatek,mt7629-pericfg
           - mediatek,mt8135-pericfg
--=20
2.26.2

--=20
Cheers,
Stephen Rothwell

--Sig_/g61fbTKRciyXS8ZoanT/Y9u
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl7VtPUACgkQAVBC80lX
0GyCPAf/a0heoXStijEoy4LeqoH0NA4ksFIEbHYF0H49575Eky3/rbYDONVBoXKs
NBuhFc9Bz4ALnsUvtrXCUNcZyRZ9vbXXyIYTOGjrMrCu3B5NL0ABQbLqOaoiT+62
N8ZjSxcqzLenZiBXNI7IDzZ7OUVE+hrY/vvPfEZSbPXYsF4BdXWxTPs9v6Al8OD/
tayVnp2imySZ/y1/YYrowuLbHfayoHw+vI5X+taJIS7O0Y/Mjluz5iykF9/Vb0ms
rnt5HJKUii33AlK5Z9LFPywGxV1u3zotW3e/mvwm0sCSJ0DRLyleoP9wrdLj9qmz
AbDqTAot2Ye3yVHkdSb42rVx1JLg9w==
=+qKe
-----END PGP SIGNATURE-----

--Sig_/g61fbTKRciyXS8ZoanT/Y9u--
