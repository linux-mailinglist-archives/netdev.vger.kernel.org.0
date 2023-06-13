Return-Path: <netdev+bounces-10277-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B9372D78A
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 04:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38EA1281123
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33D6617F3;
	Tue, 13 Jun 2023 02:59:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239D47F
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:59:48 +0000 (UTC)
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3663EE;
	Mon, 12 Jun 2023 19:59:46 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4QgCvd3zkHz4xG5;
	Tue, 13 Jun 2023 12:59:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686625182;
	bh=es8zQWhr2UGYmQ6I4rN+kdE5kkY9Q5v0gYGCqZI4080=;
	h=Date:From:To:Cc:Subject:From;
	b=ZyzXmLisrTXpCxMLiYV2gGmnAskKtigmW/92PYRGks0p94daheLgF3b9J3I9R+qGb
	 q6D+gRBc+T9Ah3WijlA3YwNv1Mq38F9jFx2ywlQokVlr48GoWlyXKLXwtH/+s+yTOU
	 t2cu56objMdEPqAnzHOmeny4NtndGoDD+5tiVWZrYW6sDdWOGuxn4kF7e2/sFb8M4Q
	 ZXIcXYL4ACgd9wRmhirlZmeevYdLhjQWoFsX8y08TLWxEGXS8PsW09s6lpRQ2sHrJ4
	 Rt5LluMyXfqoSfXuhFtIPpj+3AYlc5Y1Yu/rfjKze8y0lOI7wgYBb78nRThchLGIz7
	 qgSnJ0T62REyg==
Date: Tue, 13 Jun 2023 12:59:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>
Cc: David Howells <dhowells@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Networking <netdev@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the block tree with the net-next tree
Message-ID: <20230613125939.595e50b8@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mCx3ToNKpO6AWjiAYHFUjEf";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/mCx3ToNKpO6AWjiAYHFUjEf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the block tree got a conflict in:

  fs/splice.c

between commit:

  2bfc66850952 ("splice, net: Add a splice_eof op to file-ops and socket-op=
s")

from the net-next tree and commit:

  6a3f30b8bdb2 ("splice: Make do_splice_to() generic and export it")

from the block tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/splice.c
index 67ddaac1f5c5,2420ead610a7..000000000000
--- a/fs/splice.c
+++ b/fs/splice.c
@@@ -969,23 -841,24 +937,35 @@@ static long do_splice_from(struct pipe_
  	return out->f_op->splice_write(pipe, out, ppos, len, flags);
  }
 =20
 +/*
 + * Indicate to the caller that there was a premature EOF when reading fro=
m the
 + * source and the caller didn't indicate they would be sending more data =
after
 + * this.
 + */
 +static void do_splice_eof(struct splice_desc *sd)
 +{
 +	if (sd->splice_eof)
 +		sd->splice_eof(sd);
 +}
 +
- /*
-  * Attempt to initiate a splice from a file to a pipe.
+ /**
+  * vfs_splice_read - Read data from a file and splice it into a pipe
+  * @in:		File to splice from
+  * @ppos:	Input file offset
+  * @pipe:	Pipe to splice to
+  * @len:	Number of bytes to splice
+  * @flags:	Splice modifier flags (SPLICE_F_*)
+  *
+  * Splice the requested amount of data from the input file to the pipe.  =
This
+  * is synchronous as the caller must hold the pipe lock across the entire
+  * operation.
+  *
+  * If successful, it returns the amount of data spliced, 0 if it hit the =
EOF or
+  * a hole and a negative error code otherwise.
   */
- static long do_splice_to(struct file *in, loff_t *ppos,
- 			 struct pipe_inode_info *pipe, size_t len,
- 			 unsigned int flags)
+ long vfs_splice_read(struct file *in, loff_t *ppos,
+ 		     struct pipe_inode_info *pipe, size_t len,
+ 		     unsigned int flags)
  {
  	unsigned int p_space;
  	int ret;
@@@ -1081,9 -959,9 +1070,9 @@@ ssize_t splice_direct_to_actor(struct f
  		size_t read_len;
  		loff_t pos =3D sd->pos, prev_pos =3D pos;
 =20
- 		ret =3D do_splice_to(in, &pos, pipe, len, flags);
+ 		ret =3D vfs_splice_read(in, &pos, pipe, len, flags);
  		if (unlikely(ret <=3D 0))
 -			goto out_release;
 +			goto read_failure;
 =20
  		read_len =3D ret;
  		sd->total_len =3D read_len;

--Sig_/mCx3ToNKpO6AWjiAYHFUjEf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSH25wACgkQAVBC80lX
0Gzaqgf+OENpEocAaIWONgxRVA5awJBquhhvSjVNP7OTfeJtPdzuVTf/zMYIe8rd
+aGRnBzgDBPtyjmcjO9FQyqZBt4LidHm4q0FBgGRFCNSA9g6J2j2qXjIDXfqKeS9
Kl3C3r+JthUj4N+DUgOTI+3ch2fEEkJxCtZAY/k3+IHVF5YjekJGXBnqKybTrN0n
7PuqgEWlj5GWt6SavJTrXJ9Yu3htPFJ4lYtbh0iLRU6uRU4PpGzxYHeXRDe2B8LF
spGvcHNesKLh1TlGTvdSjeICF7lItxOSS9+7XwlNA0uiosiaY9EQb7LhG4BPOSX0
O0Dsss29wIjjEA+63i7EK/876fI8IQ==
=8zyQ
-----END PGP SIGNATURE-----

--Sig_/mCx3ToNKpO6AWjiAYHFUjEf--

