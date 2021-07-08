Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1190B3C1B9C
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 00:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhGHW6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 18:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhGHW6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 18:58:42 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107C7C061574;
        Thu,  8 Jul 2021 15:55:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GLWqJ3R6Qz9sXN;
        Fri,  9 Jul 2021 08:55:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1625784956;
        bh=Exe/NnWf8lBaMwnH0fPa+CcmaR93UKYDClybA6cuv4U=;
        h=Date:From:To:Cc:Subject:From;
        b=X4hdiOmaWActI+USu4vgMBDM4OtHmr/vjkm9nwuDxsEYavF7bp63+k+q+WJMLqmOj
         qQ4rdzrhKda6unaZprFVIE5h5fYMjghpL5TngrcZwyTxDeByfjPlSsuT5owPLBFnPB
         EevsQmGMgX5/U1wQ0mhhWoVLr3cULVVzH2UBjWGPVgApd+1V+WYrP2MrDJxTbrPdly
         niYQkW0mJXGCNNsxg3n45FNnnemXtCXmt3Quri2bCJZymrUoJDHA9T7c8KU8s3ab3j
         H2awryVkYcVyGUinSLNl2j6OJFbIiGkUK03gJDZqB2NANrYy3MPpmsFmnG0fP1Tc8X
         9MxG6OBFErikA==
Date:   Fri, 9 Jul 2021 08:55:55 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build warning after merge of the bpf tree
Message-ID: <20210709085555.291350c0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ProQ4XOgdqYnGASqodNvrDN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ProQ4XOgdqYnGASqodNvrDN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

kernel/bpf/verifier.c: In function 'jit_subprogs':
kernel/bpf/verifier.c:12055:18: warning: unused variable 'map_ptr' [-Wunuse=
d-variable]
12055 |  struct bpf_map *map_ptr;
      |                  ^~~~~~~

Introduced by commit

  7e0f5bf7eb62 ("bpf: Track subprog poke correctly, fix use-after-free")

--=20
Cheers,
Stephen Rothwell

--Sig_/ProQ4XOgdqYnGASqodNvrDN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDngnsACgkQAVBC80lX
0GwahAf+JwsPxXRu8UJbyVZ3esrnNQoUVSILSz/iu02JJ5Pb7slSGzDJ/ZtRsaCp
aJ1kZcZoaiXrSgCYZtEWtq+PkX8E7Va/C73WNqtelmkHCDl7u0Q7Cs1pqX0fOuKW
Qi+4g3KC9sM7oOm1NEZq7WRqZ71b5Ez3E8dlPF/DgHf8GtcjFv5HKxF/XYPWCrQO
C/uDK0adpfAeYjJXBAxxYinuG+eEvqIePnOz62Kg8LFt6jT4gXyZuUS+OoLOfFH5
Rmf47Y30UgRfJqFgF39G8uAQyw3bjOLKEoG9EmW6U9nKrhl2enyfDU/a1pxcZEgb
Q8lTZM3g0LqK8TV+kbaw1Vb7FQxqeQ==
=6njV
-----END PGP SIGNATURE-----

--Sig_/ProQ4XOgdqYnGASqodNvrDN--
