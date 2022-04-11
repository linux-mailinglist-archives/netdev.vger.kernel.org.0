Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33C24FB2F4
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 06:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244699AbiDKEiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 00:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241098AbiDKEib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 00:38:31 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3350625E8C;
        Sun, 10 Apr 2022 21:36:05 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4KcGJM5pvnz4xQq;
        Mon, 11 Apr 2022 14:36:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1649651764;
        bh=YoxPSRCfaNi8+d6J43vTyxCyG6mcuvx7SvTGzsQcrPs=;
        h=Date:From:To:Cc:Subject:From;
        b=rtAJR2Y8Xib6wW66AhjROymGWOJv3SwA29HOmP6yq/tkO4onZphvPMMMws4XyOP8h
         UHQr7vHyYGDLkILSumAZxZZxnkk2QFkO+oWH8hGFlBXxRZuoKfYjCKefw4VKx6q2+/
         0h2DcZTAWkzy2J6F9DABCDQ0zBLHCzcWyZvXrwVzFPzmV4+Nq/WR4+3GxqYSKRFMCP
         QtHDu84JuGwEMruP+6eROucnj7LrHyiM8Ouz6Jsi98CckXqyEJP+lEM7O0s+2dnMwG
         JrvzCF+zZJZnS5LfDeGNQ4M+LV7TYv1APeqH2Y0TYfHr6POq6+itjBwNGY2aNKfedx
         kY0yeR9vwvh8A==
Date:   Mon, 11 Apr 2022 14:36:02 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warnings after merge of the net tree
Message-ID: <20220411143602.24aa559b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UuNFG+i=/HTjAVRJ9jwzvpL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/UuNFG+i=/HTjAVRJ9jwzvpL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (htmldocs) produced
these warnings:

Documentation/driver-api/infrastructure:35: drivers/base/dd.c:280: WARNING:=
 Unexpected indentation.
Documentation/driver-api/infrastructure:35: drivers/base/dd.c:281: WARNING:=
 Block quote ends without a blank line; unexpected unindent.

Introduced by commit

  c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic=
")

Exposed by commit

  74befa447e68 ("net: mdio: don't defer probe forever if PHY IRQ provider i=
s missing")

--=20
Cheers,
Stephen Rothwell

--Sig_/UuNFG+i=/HTjAVRJ9jwzvpL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmJTsDIACgkQAVBC80lX
0Gwd/gf/V81l2NZLvWXXf/P8QkLznXhiabQ5aLmcrFVGDXj5ezYqxY8+8yPnRsCa
uKSO/KnxdzimhxJHCQX0yS3mK0Jvcluwdp3psvvN9bAUc6jYa4bBuoKOIsBimXGJ
ag9Or0w3MDb3R2C4MQZw0PRiD8AkCYituZaKr4QOKwrtD52ilywAZWYXu/eDjirg
qHmrLjzN2/nfFQcB5R1d4YO3Vg+K4VCS8+g/RMldGm87VzSBEa0s6DoSMOeGM5Lk
N10cA1f1IIPrpbET+QROdvSmJvA4//VPJyeZkF8sRFkkTurXWhwnoI2sgoblmv1W
O8L+yv7ueBZKhxxtxDW2ucXYdFFIyw==
=QCY1
-----END PGP SIGNATURE-----

--Sig_/UuNFG+i=/HTjAVRJ9jwzvpL--
