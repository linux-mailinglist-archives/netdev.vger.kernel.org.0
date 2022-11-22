Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA176634928
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbiKVVYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiKVVYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:24:16 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88147CBB3;
        Tue, 22 Nov 2022 13:24:12 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NGy1l09gGz4xN5;
        Wed, 23 Nov 2022 08:24:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1669152251;
        bh=sbRuO2aFOs+wXOry96RCRNP5VBQqIMMgw80/mKrVywo=;
        h=Date:From:To:Cc:Subject:From;
        b=qrRu75Uyzu+ZNbGm0UAzl+PTpGKfjb/HrW+Dt8x+XuD1uDsTMy3IyrP0LoQLUPrIP
         tV/Zaxo9bZ2zeD/4F1vixjwjKRE0YtCBBGvkwVhBHi21wx6pewGB+d7jssIVczh6FW
         1DTYu18agjwNlXkHNlUVyS9kwQiWF+p+7Y5Zy7RdoJI6Lgqz9VQp5zjRHn8fjFzY5h
         wzEsco4oiyWiXcTr3a0r78tgiX/LF1NY51qTbjd28EvGg2KwKHrQvapBruWg1HirVm
         DudNwNfEt6Os4jXbKTNVYczJl/N6R7o/GsFF+nueeKsGq9eJji89CmeXMiP8ieeDev
         GOyoVGfupYUlw==
Date:   Wed, 23 Nov 2022 08:24:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the bpf-next tree
Message-ID: <20221123082409.51f63598@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/BDiR4qN_2FHzqABGC/b4gPx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/BDiR4qN_2FHzqABGC/b4gPx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  6caf7a275b42 ("Revert "selftests/bpf: Temporarily disable linked list tes=
ts"")

is missing a Signed-off-by from its author and committer.

Reverts are commits too.

--=20
Cheers,
Stephen Rothwell

--Sig_/BDiR4qN_2FHzqABGC/b4gPx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmN9PfkACgkQAVBC80lX
0GwcVwf6At5YSPn+GZla7NgKUtrbBVczmtiQbZrBFSDJUjQDVUcTtZQe68o0oYoU
RGwQsevkZwHoVBX2kP8shl6QbX//IqqRIp8+hrxQNrZ4uDKTpWJnZ228pGTjoetQ
mrKIe66hnMIW6coT/ZxiXRiVzVXUkldtBkmt9cJeV9Bf3kalU5gPfJkrnC16LVeH
WWcJ8nGUMsxJ5V1kI6LCr/NsAdxFd/qYdM+Gox7G/wemGZ75pl7qN5/f/56BPW0y
MTeZ0ADcF5TOGB7LJWtk6AZ/ObXpso8wFRTzd4VpZ3p3PKRZtBbNarcv7+DTmfbG
2vIXiZnNaD4hhGTnC5gHaKATSktFEw==
=tZbP
-----END PGP SIGNATURE-----

--Sig_/BDiR4qN_2FHzqABGC/b4gPx--
