Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110EA468E5E
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 01:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241813AbhLFArU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 19:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241666AbhLFArT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 19:47:19 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61EBC061751;
        Sun,  5 Dec 2021 16:43:51 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J6l6Z0FqKz4xbP;
        Mon,  6 Dec 2021 11:43:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638751430;
        bh=mh7UQq5BFmbugNuJ8CAIyPjc6Mldd88Z8dgvmYqRSH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MWvkHdz8j/2HgnRpDTlcCIouZ+ISOXbk8yCCFPZD6F4STz/cxhSrJ6foe51rcy6lF
         WBCM0wta4LTvl/9IGrGVA9pGx5M+GNoe8fcm4d7i55CYjJcnEgnb6DNbj49wWJrkBT
         w52aL+mMBnz1k4i4WbHX5VBtN+JHU3GTekmKL+Iwrv1DqpvI4Xy2dHWrRdo5gqHEdK
         8LGpmqnWjYkf9xuz53Vjac9yiZr8iBhf2egff+3cotOIIbeW5O0pyyZuhmJI7KshC3
         c4zUwdlN/ItKZ1H6qYMTB1X2hrhd43M6zi+QeFrHryBbe8TCLwxciPDgv1mTJ3WyhB
         7vrqfMErP4WMQ==
Date:   Mon, 6 Dec 2021 11:43:48 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
Message-ID: <20211206114348.37971224@canb.auug.org.au>
In-Reply-To: <20211206105530.0cd0a147@canb.auug.org.au>
References: <20211206105530.0cd0a147@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/1aVpgcOsn3X2Refpd7mQpLc";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/1aVpgcOsn3X2Refpd7mQpLc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 6 Dec 2021 10:55:30 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> kernel/bpf/btf.c:6588:13: warning: 'purge_cand_cache' defined but not use=
d [-Wunused-function]
>  6588 | static void purge_cand_cache(struct btf *btf)
>       |             ^~~~~~~~~~~~~~~~
>=20
> Introduced by commit
>=20
>   1e89106da253 ("bpf: Add bpf_core_add_cands() and wire it into bpf_core_=
apply_relo_insn().")

And this is a build failure for my x86_64 allmodconfig build.  So I
have used the bpf-next tree from next-20211202 again.

--=20
Cheers,
Stephen Rothwell

--Sig_/1aVpgcOsn3X2Refpd7mQpLc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGtXMQACgkQAVBC80lX
0GxqSgf/SXInRIafSMXvSIxJhRtGsB01r9WAhTewDfiEsapJ4tXkPwGilO5iob8l
VRw9ksNOTasZjddMhySHO7InY0p9mWY4G5HLEpIbtzM51XK2NSWNM8w2YE0qdbo8
KWMCbdEilDYY40H85QvsxZI+GXI5HPVt3S42o7lUl23grI4JFO0qo9yhrjLuFOG0
pIWBpOsrxVeY9kYnNg0xEK3Tp0zNE9T9uZqgB1mDKJYHvJuDdgO6ocGqz0VJo+IU
wvyK79Tv6pujShdQmPOeS5hD8etgx3E42uRRaTyYYk9fYD7GA2TZNJPAUwusuwXp
MyZ0PQj4UdH9WXWrmksrtVfygHq37w==
=RVBZ
-----END PGP SIGNATURE-----

--Sig_/1aVpgcOsn3X2Refpd7mQpLc--
