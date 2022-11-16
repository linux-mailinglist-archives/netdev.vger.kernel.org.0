Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C3062B351
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:35:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiKPGeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbiKPGeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:34:05 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC545214;
        Tue, 15 Nov 2022 22:34:03 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NBtYL1j9Zz4xP9;
        Wed, 16 Nov 2022 17:33:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668580438;
        bh=IcStPmiV1MBe09/lsLzruHx/CsoeJugmpVvHDZ7qmTU=;
        h=Date:From:To:Cc:Subject:From;
        b=XzOf2kbfINAtqX12sKBS8Dvdsx/QNkbpbR2OlVkjtQ1/JNDiQbbjs0igAbYBenlzj
         U8rkD+Bn1Mf5FKYrXuNKSgnSS6gaXyZrZYnXaugDz50eujOCzaF4mLk75fUyR3lgmA
         FkzYSF4v26xQDqQMUcdX3gAxeXQ7GDavZTeHbOgpw3VP4MAKLWeLvhIgbkRwORJWYi
         nGVEB07GtW92vrM+cDJvyGhd/unt6I0m2yonAOrvQOkx4xqtI1ARPvuFhNztjlWynQ
         dyQNFbSRxRH0IrvAIJ4uaRz0LaD05pnpDhdXfI4qW9RbZQPDfmEut3MYbr5WNfYxYs
         iHGqr2HPih/9Q==
Date:   Wed, 16 Nov 2022 17:33:53 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20221116173353.19c17173@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KWuY9bN2JCuIGyIxZuCfFyd";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KWuY9bN2JCuIGyIxZuCfFyd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
pseries_le_defconfig) failed like this:


Caused by commit

  d9282e48c608 ("tcp: Add listening address to SYN flood message")

CONFIG_IPV6 is not set for this build.

--=20
Cheers,
Stephen Rothwell

--Sig_/KWuY9bN2JCuIGyIxZuCfFyd
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmN0hFEACgkQAVBC80lX
0GzgvggAowlRJfGOcH+dfBs0j8gTI+j+mRL7CB1Z0rvQoM7MQQ4kEqg70RBdxhkL
dTDvCqUsf84CDNstnjw56YeGl17Sj45UzSAOvuQInZ/m/qk5RG6iYbxYAlkMOR+j
AX1cw9IeIKtk2NHljIiAqaXHF5BYuPa7NDwJ2d4ZGHzqa830Les1fGGTnwGnXmja
r2AKUi/TKszcQgNSQGXcwehfyz+zu5SZG4mFR3Oo5QXNaHuWZou7//tvRm8tymmI
He8Ymvx/C0fkjbMFBH+J6GosTX9c2lRHTw8jg3Auy0hTu6cvjEs0B9NsfncG2J7O
3g7DhrEo8/vPcsip6tLZjZeE6Ld6uQ==
=FVnb
-----END PGP SIGNATURE-----

--Sig_/KWuY9bN2JCuIGyIxZuCfFyd--
