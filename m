Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6CC69FDC8
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjBVVjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbjBVVjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:39:36 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C99A2DE55;
        Wed, 22 Feb 2023 13:39:35 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PMV114MNxz4x1h;
        Thu, 23 Feb 2023 08:39:33 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1677101974;
        bh=OTUn1q3utxkbFQDCyursLifFDedmceapAyJzXwEbnLU=;
        h=Date:From:To:Cc:Subject:From;
        b=A62xzaC2+uD5F0WxjO+TNPQBri0O5n6nVap5Ma34ZCJs3huF4iCMbKtpY8XTVcUOq
         jq1utDwKNAdZUoS1JvS2FjZfTbqoAajcNXS2HKvl53depDpb7QL7jQiUm5gdVyJv8O
         AR8Xab7axrA+WrArB0eDSgd4Oe4MCdRGvkYH7Z8pLiJUW+em44pRktnf8IqGc8WhgC
         394B8Ffpz48ToxUdzod5LH32pz4aZa/bnp5Wi9+wvX0UbccE6rdHhBpDFqhetZ4wYj
         nSYQdwmVJdBa7CBP+Q9UqwTYT6rFw2+Ulq8kaDm442c4w1au4wgL0Yiq2JdhurnZlH
         15q8tT2Ugnu7A==
Date:   Thu, 23 Feb 2023 08:39:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        Huacai Chen <chenhuacai@loongson.cn>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patch in the bpf tree
Message-ID: <20230223083932.0272906f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JRqgbQ4N4E7IJLAyr_RT5Yc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JRqgbQ4N4E7IJLAyr_RT5Yc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commit is also in Linus Torvalds' tree as a different commit
(but the same patch):

  345d24a91c79 ("bpf: Include missing nospec.h to avoid build error.")

This is commit

  f3dd0c53370e ("bpf: add missing header file include")

in Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/JRqgbQ4N4E7IJLAyr_RT5Yc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmP2i5QACgkQAVBC80lX
0GyVbQf9GzToz130+z/mogNO8jvshZIPr1m1BqLrk25SdiGfdkXVOS9QCIv3btgh
3p+F0rwt+WeZR81LZS4KtrHH8zasxlzgbp92jEUpYJiv8JNhUky0diJAWd3hl8FC
Qe/ThlqR7/6t6Jps2vGP2pG5QX0X8wRNwyLC+DhdXBadye19vwGd7yOsyiD11Ifo
/hV/RyNvUsSIjVfOS/BF8NYtizmLLtwP0f5GkVtxJA6l+OParihxov7BwjhC7Uzv
bsLH4V90GnoNg5yQTK2HQtraPr2cfVbXDLuCLbORbx3BqOTrAwZntqFgSPPUJlFf
knBoDUqs5mnqi2HlmT7FpIoF+iHcSQ==
=0a4c
-----END PGP SIGNATURE-----

--Sig_/JRqgbQ4N4E7IJLAyr_RT5Yc--
