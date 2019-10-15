Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 441E5D8473
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390235AbfJOX2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:28:01 -0400
Received: from ozlabs.org ([203.11.71.1]:53323 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388009AbfJOX2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 19:28:00 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46tBRx4smMz9sPJ;
        Wed, 16 Oct 2019 10:27:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1571182078;
        bh=G80iYNZ+w7OwrZvrZ0J+yxERwvHUoMHMkoRk5dYyW7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=snJV5CChUB77EcaqFOnEpbDDcF8IzCfjhIDo/A3jcNRxJLFmo0TfVNciLt8iqL1I3
         QktWoGfbFsF0tLd00YKxbh9eeWazfKmDh4T6vATWdNpMj/VyOV3fQTj2vMOh6FxJAw
         YylKep4uG5TYpCFUhyfV/nLNFtLg4PK4IX5kIyZv4uNmYM6R1MzYHBwFekw1GAoXD+
         AoyFWM5JkI7GW8uu+8LSD015pOi9ouJkvAOll86pGZFC2OfIN61qzRvGa5ZAgJevFq
         0rNTFq590UhPFTsbICQHLVDU/nd01LmbhxY6VPn/vzbs+5OY5UlBu8E+gLizsM6U4b
         Aq8xM38rjOi9A==
Date:   Wed, 16 Oct 2019 10:27:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20191016102751.02c30ed0@canb.auug.org.au>
In-Reply-To: <20191008094840.1553ff38@canb.auug.org.au>
References: <20191008094840.1553ff38@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Lom=PRLybBS7MXrH_xQq8ep";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Lom=PRLybBS7MXrH_xQq8ep
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

This is now a conflict between the net and net-next trees.

On Tue, 8 Oct 2019 09:48:40 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   tools/lib/bpf/Makefile
>=20
> between commit:
>=20
>   1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")
>=20
> from the bpf tree and commit:
>=20
>   a9eb048d5615 ("libbpf: Add cscope and tags targets to Makefile")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc tools/lib/bpf/Makefile
> index 56ce6292071b,10b77644a17c..000000000000
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@@ -143,7 -133,9 +143,9 @@@ LIB_TARGET	:=3D $(addprefix $(OUTPUT),$(L
>   LIB_FILE	:=3D $(addprefix $(OUTPUT),$(LIB_FILE))
>   PC_FILE		:=3D $(addprefix $(OUTPUT),$(PC_FILE))
>  =20
> + TAGS_PROG :=3D $(if $(shell which etags 2>/dev/null),etags,ctags)
> +=20
>  -GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN) | \
>  +GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN_SHARED) | \
>   			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
>   			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
>   			   sort -u | wc -l)

--=20
Cheers,
Stephen Rothwell

--Sig_/Lom=PRLybBS7MXrH_xQq8ep
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2mVfcACgkQAVBC80lX
0Gz1ogf+PuhLQyiM/Fcr7XdWrOaOmdPHxVJzy2wejPRc1csiaa7LMxYuV470n38O
xUXHSchUrvOEEwJM3+VLMH+sCsMAnFnxTn2uNYNZIGlajLHJHiM8fAScHxve1eMV
4iKtOcuZVrbULbbeFteDUJ554N7NcsHMntBf9lA6iEju3HdRQLmOsPuLKayuT9qD
an2Av+3LO6k3nOZgR0RwMDO8xxQPf4Dpjle+Kx5RJktWcM7GP2zVhy1wHaKTKWKX
xSfx028lD+e6nXRN0QsYUE3yYEPXVuQodRj0fvRREAOmXuUnCHASpkNuwj31amtO
ZsWt+80J291g0Cj8LS9XPC84HpafZg==
=2xFl
-----END PGP SIGNATURE-----

--Sig_/Lom=PRLybBS7MXrH_xQq8ep--
