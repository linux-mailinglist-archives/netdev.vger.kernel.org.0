Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3265411FBD9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 00:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfLOX0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 18:26:37 -0500
Received: from ozlabs.org ([203.11.71.1]:47195 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbfLOX0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 18:26:36 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47bgX90rwRz9sP3;
        Mon, 16 Dec 2019 10:26:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576452394;
        bh=Q836Q0gCA+hPUmVyyMXcLvrPYwmVS9fKCYz2xOUkNIo=;
        h=Date:From:To:Cc:Subject:From;
        b=t6TW0QsGlj9X0To9d7MhPfN4dUVvuhEaiyjNfUKggYUH3ou8feREhg5aqN4iVPedf
         DYjouezdEL3scujyyv6jxPdVZ4yRw9wWag7XtnGS58Xn07bdpgapQV9TZJ9D8uZcrE
         zvxYXc23Va1P8qKh0wfesNXfhB6HygSBfWPpuGUH/y+SHr+1euKdr/NLPg2eVGtKyL
         ib0CBy7PVtAnURbJz+SBzocCauji3cHJ+ExD3/TGDQ0J79m2RP+kio0e9D6JQUEldm
         Y02EN93yODXwSbMnrC/xzdSvrXFasIz3kKNt1HNhDtpsEjPG5f9r9K5kktkZDNfcQv
         gvdnVW/RKghaw==
Date:   Mon, 16 Dec 2019 10:26:32 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: linux-next: manual merge of the bpf-next tree with Linus' tree
Message-ID: <20191216102632.3e2ee576@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/h5aalMVYZp0e+ZTIWKmVXei";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/h5aalMVYZp0e+ZTIWKmVXei
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  net/bpf/test_run.c

between commit:

  c593642c8be0 ("treewide: Use sizeof_field() macro")

from Linus' tree and commits:

  b590cb5f802d ("bpf: Switch to offsetofend in BPF_PROG_TEST_RUN")
  850a88cc4096 ("bpf: Expose __sk_buff wire_len/gso_segs to BPF_PROG_TEST_R=
UN")

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

--Sig_/h5aalMVYZp0e+ZTIWKmVXei
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl32wSgACgkQAVBC80lX
0GzvVwf/YTxou35hG5DHK0UkLIVIsFUy3MWOxubZ6nUZQpWaznHIh1XElTOoiGdH
ZYjchIGCdcBACEgbuDyYnkZht+pnYV7gFH6je2J34o3mDlkqcS1EARbcLW+WT7RU
lBaks4BzgNaFpzLmOwi1MD+vge7f48dEulEsZ2sNI42yQRBVjguJ99qnx/R6OE//
yUb/C5B/c467deIEE9rJV4MKuyi68fvU9ziT99NyG5P8eNq9rZLriPNwpEgNh9d7
m0Op2i2bRCVQ1fu1fSCBw3x5U4sP6TOIpscLmOWLPg2eG7ZpC/xdzws8v2MUEftT
CgnZthxH4t4qX9nhAdoRcShYRrtXaQ==
=8EAE
-----END PGP SIGNATURE-----

--Sig_/h5aalMVYZp0e+ZTIWKmVXei--
