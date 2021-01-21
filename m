Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7632FDFBE
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbhAUCt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436844AbhAUC1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:27:33 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F7FAC061575;
        Wed, 20 Jan 2021 18:26:51 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DLmVZ2Nctz9sW4;
        Thu, 21 Jan 2021 13:26:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1611196008;
        bh=adam7o31byAmsNO7PyJ+PTMYjYvnxJ3L+Eo0CAo9M+M=;
        h=Date:From:To:Cc:Subject:From;
        b=TzN/DIkCkWPSi6nhvSZKyGdEfEGkuTL+dt3TYTumpJ/E8aW+UoBqUhGSnm38vYG/g
         5wgPobZ9dnhykV6S86sdD1Nine931g4zpMdY/TZAq2dAQ01nRk3Gix4+LCC1QqlbP9
         aFHiNXGgqaz48wkAjrFlVTjjg/P8XXLw8Y8fr6tibMrbeQKyCgw1XhKtL1EsJRYxf2
         NTjyH4dkJ2s+KPZvfYVEwewVgNLsdNHu4ftwrInhfaeD/84YgOInposJ91gU+sMQJY
         MEm5141mLGIgRyeauiRxZKswGDaZw48TNSv3OgI/KnvrfPOVG8wXbTd5EBpEFuXoxi
         E/YoAzU3Ad6SQ==
Date:   Thu, 21 Jan 2021 13:26:45 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Rob Herring <robherring2@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the devicetree tree with the net-next
 tree
Message-ID: <20210121132645.0a9edc15@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/4Mltm=817k1qngRGqT7LIAG";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/4Mltm=817k1qngRGqT7LIAG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the devicetree tree got a conflict in:

  Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml

between commit:

  19d9a846d9fc ("dt-binding: net: ti: k3-am654-cpsw-nuss: update bindings f=
or am64x cpsw3g")

from the net-next tree and commit:

  0499220d6dad ("dt-bindings: Add missing array size constraints")

from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 3fae9a5f0c6a,097c5cc6c853..000000000000
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@@ -72,7 -66,8 +72,8 @@@ properties
    dma-coherent: true
 =20
    clocks:
+     maxItems: 1
 -    description: CPSW2G NUSS functional clock
 +    description: CPSWxG NUSS functional clock
 =20
    clock-names:
      items:

--Sig_/4Mltm=817k1qngRGqT7LIAG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAI5mUACgkQAVBC80lX
0GytuwgAjhKNzn/qra4GuNZvh50dYrJ+NpEzKxx1r3Dy0OWlM3yHOHW2oIHrhVni
EkIGgwybxYV44kcQKUzCDDpHG+SvFYkOI4sq4zFxHXqFkUVDdbH72X/ptc1TycPa
uRzqH+krnkrDM+KCm2plwkd6ZEbAr90kiRQWGITKJm82gweCAWCQO2TXa2yRa5ef
WM/EhuzvqCboEMk/VVhskgcCycUhVEW3PKetDLQS/GGTycgCJCwUQtVNmIeRdJJD
wsYPMghPVk9xRF8DYn8Br3YnyEYk83iTKD2bN0DBTcGJjGCbxFOhNSgVsq0TtM3+
Z8aQXG3opmWMLW04kqagsB2kE7oQxA==
=Uoaj
-----END PGP SIGNATURE-----

--Sig_/4Mltm=817k1qngRGqT7LIAG--
