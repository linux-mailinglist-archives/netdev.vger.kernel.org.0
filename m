Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCFA611C440
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 04:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfLLDlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 22:41:50 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:35133 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727882AbfLLDlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 22:41:50 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 47YKNQ6p0Nz9sSQ;
        Thu, 12 Dec 2019 14:41:42 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1576122106;
        bh=qNe+Q/0e/+XGLzL9L0UcJVLDaBn2jLogw36ETox1VAg=;
        h=Date:From:To:Cc:Subject:From;
        b=dnu12qocJMzXWYPB9VglDV1fzeST+kv4DG2SjmO0uO0BWUXuB8PyLijF3lUFdH9Ly
         d4g4E41jA/sczThluJawDZlpuV3dVxLq3OcByJcFLKxvfhg/oN5ZIVP5Nj5A2Z0UT7
         GRhORy7tM5yVGyNZON8VE/WFp4wxdJq74jdVfczrW9RqpknHY5JTAHKP3YY15U/Zqs
         uPmyCp6Mwr5xqXaX2jBjUQbpugw9B2KssILxZk2zZxOizXQh9OHJoMvkgZy48cbisy
         W5Gba2XT4gJjshk5vL5gm77/Jn9lLGNHdRJd4dP0kNR2fBK+Wr0Nu0w1DFMv2KIJDJ
         V76xkMs79/yXw==
Date:   Thu, 12 Dec 2019 14:41:41 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kees Cook <keescook@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
Subject: linux-next: manual merge of the kspp tree with the bpf-next tree
Message-ID: <20191212144141.62a303cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/CDuDp1dY65J4_qh1hIpJPMW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/CDuDp1dY65J4_qh1hIpJPMW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kspp tree got a conflict in:

  net/bpf/test_run.c

between commit:

  b590cb5f802d ("bpf: Switch to offsetofend in BPF_PROG_TEST_RUN")

from the bpf-next tree and commit:

  c593642c8be0 ("treewide: Use sizeof_field() macro")

from the kspp tree.

I fixed it up (I just used the former version) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

--Sig_/CDuDp1dY65J4_qh1hIpJPMW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl3xtvUACgkQAVBC80lX
0Gy5pQf9EDmaBbrtUKq4iQKL3KWPYk1mq6qW+ZrvzwDMG6pZMBgOpV3nWNxM8q99
BqEFQpFmhdd7Oqp73udyXcFvOkePbWniAJzYOMqrQJGwT8VLpBw/AUqDZO7KmlVH
zQ8aYxacx7GONv9dbFL+NDpkdtgawB2zlhsEuL7koRlyC9s7dtjHktcmyTSDsy2t
rWXzU+/40HNbqKU1suHSoRN3LycL9QUFjXS8B+rBNtkuVfa0LDqnPNEkhn4ctBuk
FZfGrcmbbsoZNFd4hXApjFwkZk3bgwcBXOUPE/2mfCOBK7OL7+ibRMg6Ywi413mW
IKO3+t2qz8TwIJYj8gj3T+vR7vZn0w==
=t6+P
-----END PGP SIGNATURE-----

--Sig_/CDuDp1dY65J4_qh1hIpJPMW--
