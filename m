Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 380C7DBA59
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 01:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441803AbfJQX5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 19:57:02 -0400
Received: from ozlabs.org ([203.11.71.1]:48947 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbfJQX5B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 19:57:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46vR0V3b79z9sPV;
        Fri, 18 Oct 2019 10:56:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571356618;
        bh=K13U+AUFHnw6L6dQYDvLcinbUAJeMsLlIuOy4kBBer4=;
        h=Date:From:To:Cc:Subject:From;
        b=WqZCRkRhp4/4inRmp5XtNf0tPg2jyec1xXylhSZRn9Wsne5SxbSgl/Nb4LXBx0JaH
         Z+Zh6TF+8FF8t9VRCqeCFWobHD3WbNq+zyfZkGJfJKlBI577JsOJKoY9Mp3UPQ6Od/
         B3p60GrUGlgINtu3mkun9L5CvytijQQ4/QZ/vUgJ5UBwZ/GfyJMk8A8ywouB2Pk3uo
         wxMggGCi+CPQe6NXYbdTU1SioRl+LzD5oGuQ35IC0lXU8UOgIy/4pXe6B9kHtNse73
         rYs2vyNuLcm0w5mufm3n6PY4d8gkka1KBl/SU2H9jpohSGcIurx2jXIt46ioY2urc8
         rcfH+UT2sX38Q==
Date:   Fri, 18 Oct 2019 10:56:57 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20191018105657.4584ec67@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/RzygGg_XqUDEQwGIY_nGvDE";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/RzygGg_XqUDEQwGIY_nGvDE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bpf-next tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

WARNING: 2 bad relocations
c000000001998a48 R_PPC64_ADDR64    _binary__btf_vmlinux_bin_start
c000000001998a50 R_PPC64_ADDR64    _binary__btf_vmlinux_bin_end

Introduced by commit

  8580ac9404f6 ("bpf: Process in-kernel BTF")

--=20
Cheers,
Stephen Rothwell

--Sig_/RzygGg_XqUDEQwGIY_nGvDE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2o/8kACgkQAVBC80lX
0Gwzvwf/eU6rk1Dlj9jbIO6m14+31QNvZjmfiYayLy62FobBqj7lD6s86RJ5XdrM
kOTNRDsf/bC5mVwZKVS3daTojZX3xXl0RHe1JCV5fzagL1Mxfmlw613dyRqGBSXp
Vz7ToIV63qXfPmqPxf19LbQhwtDOFprKi1fPV+TyKJRyp/DFiNI2b+Lm+KkBt9R6
VTFai3eBNCWjJCnZmYfQ6w/B0yX1Hkn/DQ1I+OBm4lYOjEjLhf7NCliEAYSEOiM0
9JiHhQ2iOcHhRm++ykqMvPSGTHuC7+mxglYfrFI0SsjrWrowIo9Wy8bc44V2LKnL
vKxuVTQNsm8SW1FS9fRFbt9xs4dYJg==
=Ajn9
-----END PGP SIGNATURE-----

--Sig_/RzygGg_XqUDEQwGIY_nGvDE--
