Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DEF27DF28
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 06:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725765AbgI3EHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 00:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgI3EHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 00:07:22 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3FAC061755;
        Tue, 29 Sep 2020 21:07:21 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C1N4h32B4z9sS8;
        Wed, 30 Sep 2020 14:07:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601438837;
        bh=NDvKx2m8FPj+G+l2Zwz8LrjqP4/PZi2OytndnhSYMoU=;
        h=Date:From:To:Cc:Subject:From;
        b=E5enepypdsG7fFF98lToN7to3c71QT+mKH5TdL74kJSxsX+WYknOB0pSwkYqbMGFw
         V88YxeNWRxyBtXEvOx7rDL59dzhI6uXGRChjUIyFufajqmAh7yBfPKKalQ2H1LFULA
         td+/5/IHLc5V3qWoBIfPL0DebwU2al8sP9/o0dOOcg9p4HHOuTjkaxDCArjLsD2xYc
         D5T3U500JmyjQh47wf1F7vS9hhwWkgXrkUtbo0oEL0bb336aPo627+usUbAH0+XXhF
         PgUaefav22bq6UbIYsMR7anPVvnxuuP/9zt6hJIvRHn1jBeFWiyfDMZqf0IAQtcQny
         oze+NzVpLWNmg==
Date:   Wed, 30 Sep 2020 14:07:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20200930140715.68af921b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/zXI4ITNXdmg6bHRqZA/rPoA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zXI4ITNXdmg6bHRqZA/rPoA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/lib/bpf/btf.c

between commit:

  1245008122d7 ("libbpf: Fix native endian assumption when parsing BTF")

from the bpf tree and commit:

  3289959b97ca ("libbpf: Support BTF loading and raw data output in both en=
dianness")

from the bpf-next tree.

I fixed it up (I used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/zXI4ITNXdmg6bHRqZA/rPoA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl90BHMACgkQAVBC80lX
0GzCdAf/RM50Zx8iRKRR+BVzRuGw/RSmA4W6TtiBufcI5YdYHjQgL1la3O3347lb
dKf4tZoCqcXCbIxq61tSkFvYBxOB3AmX3IGXgC9NlxNyFarXwUbcLFHjueZ9WzEi
rKyhfKWDLMh8TxGpKZREkyy4WurkvSJyeVp7OMV/YxPxmJ/gNlrbEc2b1k+LbIzp
LTZK2XY4phYuhw/plr8eqphwU6CcDTbNjF+j5yQf/K296y5A3WhjTMf+pZNOf2Dp
UzAHpvauy0hjIlSAcxXfHkSTfyuLeKID4W3NL8m1suiTuRs7Vkgc4HrJT1xqh7u4
90mC5dGd/PT8q8T9JcxDw3KahZwMag==
=pT5I
-----END PGP SIGNATURE-----

--Sig_/zXI4ITNXdmg6bHRqZA/rPoA--
