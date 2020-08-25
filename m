Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA613250E21
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgHYBUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:20:25 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:36021 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgHYBUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 21:20:25 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BbB4j2jnnz9sR4;
        Tue, 25 Aug 2020 11:20:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598318422;
        bh=orACE8XNdpPQLCVIZOOLkMoBz3O9kQEbyhusfiLC9xc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EKJtguj1OCroNAGgeZScq2ozqizEFYE7f0IEdeZQlzkkgzNnEGPNxq3o3VfPcpfxT
         KccJgBn0Hc5wavGjzPrMQ2gb/jscycu7EmGypFhou9sWDLF8erVI36b8q0MxCdw8Ke
         86TZJAyUgTDvkG9lXIRBs/TLRvmuZi7w5W+e//b16kKlpeMkaWGFjUHF1jjdJ8sAdH
         iQdP2GGdSWJdbu4R5ha7kwZKBVNXRpeu+p8indD5JMbIfeN3SNHTJXLUl4UqnuHFKk
         UJZheIKDNIsZ5RQfSbJj1Q7dTr7Ll+NJaX/Bqu1vFxjpDt5ZjPsYyf94kRcGtpr9p9
         A/QgZy3/zdDww==
Date:   Tue, 25 Aug 2020 11:20:20 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200825112020.43ce26bb@canb.auug.org.au>
In-Reply-To: <20200821111111.6c04acd6@canb.auug.org.au>
References: <20200821111111.6c04acd6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/uEGnJE3mnFVYeu_NbTaCo41";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/uEGnJE3mnFVYeu_NbTaCo41
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 21 Aug 2020 11:11:11 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi all,
>=20
> After merging the bpf-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> Auto-detecting system features:
> ...                        libelf: [ =1B[31mOFF=1B[m ]
> ...                          zlib: [ =1B[31mOFF=1B[m ]
> ...                           bpf: [ =1B[32mon=1B[m  ]
>=20
> No libelf found
> make[5]: *** [Makefile:284: elfdep] Error 1
>=20
> Caused by commit
>=20
>   d71fa5c9763c ("bpf: Add kernel module with user mode driver that popula=
tes bpffs.")
>=20
> [For a start, can we please *not* add this verbose feature detection
> output to the nrormal build?]
>=20
> This is a PowerPC hosted cross build.
>=20
> I have marked BPF_PRELOAD as BROKEN for now.

Still getting this failure ...

--=20
Cheers,
Stephen Rothwell

--Sig_/uEGnJE3mnFVYeu_NbTaCo41
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9EZ1QACgkQAVBC80lX
0GwyJgf/bj4gNDDE+5OrWbGr507qbRKe2x2YNr+32yK902+Cj9i7wVVZ6cMfF4S9
2B8w8rMfgMDgFZlS5f1WMTj4jYPbiVGGkfI8sCBzRqEyI32GVEH+Sslgcpb/Mn37
bSexlHPlqsLejK2Ti/EKRLyQm89yOSsSMslET7B/D5thxOwFNn+QD3c9ftine3sf
jrvke0EnRKWU6L1wX8J+ANcr3meHnS4XPe3mGDVttOGkf1LCW3KzxoptVD8VAmiY
LtKKBBibv6Rcsc5cRL08g5UDr/kcd7OaTwTvaB4duul4cV/Osupr3NDJeZdqUTk5
1Z7j7xtW2DZmX4oRjeLDeN7pExIy9w==
=FP6q
-----END PGP SIGNATURE-----

--Sig_/uEGnJE3mnFVYeu_NbTaCo41--
