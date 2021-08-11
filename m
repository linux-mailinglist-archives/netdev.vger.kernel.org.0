Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6CB3E87AC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 03:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhHKBgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 21:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhHKBf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 21:35:59 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8895BC061765;
        Tue, 10 Aug 2021 18:35:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GkspD4TgTz9sWS;
        Wed, 11 Aug 2021 11:35:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1628645733;
        bh=oLqcRhkKAlWqkAi2nMUD2QJlUlWpIKdpuMPS6Z6G9G0=;
        h=Date:From:To:Cc:Subject:From;
        b=RdesqB14I4595HORSPRmXz0aBsrDmLe2K/WqYg610cTAzNGOWFy+xoKKOWN8b4vas
         OaDD3BwMfMyAB7rBlJZojWhKV3KFeoMFTQeM2SsPcJxQdJyJOS0LvnG5udUgG8eNTS
         D6UP3OxFL6kol3znk/+wKj2GJxoDDG+dR5gRsNcMzv0hz+AyUNEJsqDUkiPQZjRRVH
         vz94FCdonkNlQ3ktuB2Psu8C7oPYywDpPI9ZImcBZbg+EN6cN3zCa15kCMINoDc1cn
         1ZbT9NwPqgeIZgHyhElhZEplOene7a19Pta7TVWYRxnnSBTdVdz0MysNrmUv1RhE8C
         MCCKNhYNoZI+A==
Date:   Wed, 11 Aug 2021 11:35:31 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20210811113531.18f8ee4d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/lMcLOHdoJF.0nDkZSpI/_SX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/lMcLOHdoJF.0nDkZSpI/_SX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  include/linux/bpf-cgroup.h
  kernel/bpf/helpers.c

between commit:

  a2baf4e8bb0f ("bpf: Fix potentially incorrect results with bpf_get_local_=
storage()")

from the net tree and commit:

  c7603cfa04e7 ("bpf: Add ambient BPF runtime context stored in current")

from the net-next tree.

The latter removed the code that the former modified.

I fixed it up (I just used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/lMcLOHdoJF.0nDkZSpI/_SX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmETKWMACgkQAVBC80lX
0Gzyfgf+KTO4rZkAA24NrU1UYOCngS691NC2QJICnvtCdwumV0b/kTlQLTLcTEGJ
nQyY0js6Djh56plEwboBEknbob80ex8keTDm6BWq1Tpu4wqH1C1EhbenWMqtra+I
pZyEUkz1wjX8JjbUSNKNZ8InOPZIRwlTGqVLZMTB/D/ewZZkHdVjlRgoOdzb1n5S
DfPZliDyIdXpdKpFUq6pkt/GoojUJkhTPiXbjH9+vSbX17ldlz4eURFaYD0a5s9+
iD03r3y17VCz/hpbvY8iUzldGRaJzJca0uBVw6iHpiaNNtD1PHC/ioz00D+AM0FX
gNqZVfvfCX6clhRcHBtdenf2LOXH2Q==
=/39c
-----END PGP SIGNATURE-----

--Sig_/lMcLOHdoJF.0nDkZSpI/_SX--
