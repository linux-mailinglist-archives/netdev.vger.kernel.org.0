Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2931D43FE
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 05:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgEODTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 23:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727856AbgEODTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 23:19:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B63C061A0C;
        Thu, 14 May 2020 20:19:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49NYXf04FMz9sT8;
        Fri, 15 May 2020 13:18:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1589512738;
        bh=t5TmQpn3DiV31DFC2sE1M61YrXj0NQ20tFn+T2BJ4dU=;
        h=Date:From:To:Cc:Subject:From;
        b=r0FQL82H/5R6YfS7Q6aJVyRbY0jIJk9mbTFCMj3Vl0c8a/uQDHeOglezQcm2HvDmK
         Lwm72/cjC5yiYkMbEsfPNZx73i/MBMnT0OtRcnt+dRyVF2wyDfPClcrJG0zznygFVZ
         +lZB2Bhq76WYonCxqPL1P6ojSli6GFQh8+qWH/7GbxPdnDRnv/E74A4S6upClpEX68
         NDiXZPp9lZQtxM3eFik5QX4VUlJtG006avuq8/edznoj5kNRpNNPkJZjxZ4U1Bwl3C
         Tz4Dbp8pj8edama0/G35eMoM9LtXtZPbCuqlhRHQaSDRZcw57vVtaGwPTaZymjlGeh
         lGrPXBdnn0oKQ==
Date:   Fri, 15 May 2020 13:18:53 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20200515131853.06375989@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KiZE6h07nxf.M9k.R+KNNA2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KiZE6h07nxf.M9k.R+KNNA2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  kernel/bpf/verifier.c

between commit:

  e92888c72fbd ("bpf: Enforce returning 0 for fentry/fexit progs")

from the bpf tree and commit:

  15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")

from the bpf-next tree.

I fixed it up (I just used the latter version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/KiZE6h07nxf.M9k.R+KNNA2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6+Ch0ACgkQAVBC80lX
0GwMCgf/ePk6dVQIX2ko7nhfY5wNlC0MXFnGhnEv/9Hmzgw2QnKpngT02+83FhFK
cJcDIMSNg5ex4WdypOcbrge+NlGgdHte/wOClLxMQIOuRaDsVkQG1CfkIpPguIxe
oLDmwuSWi2bSh94hfae9gAcO/IpquSb2J7LOeyJprszsPzJnP0xlnbs38nW3+OcB
w/3Ewa6FWhlrlhzyiI664tBERYHUo28dpFa0sSCAVafmbu9cqQ7j8NJB2/X/czKu
A5OBv+dyYztfESS6vn6heP1ppc1JSN88QMWQB+Qq+k4rtxC38RWE/LHlCbirvXrv
6ZfRAjVH0z13SLMRDUdguN8acN2DQg==
=HsuW
-----END PGP SIGNATURE-----

--Sig_/KiZE6h07nxf.M9k.R+KNNA2--
