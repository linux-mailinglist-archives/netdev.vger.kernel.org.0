Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B175280C90
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 06:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbgJBEAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 00:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJBEAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 00:00:02 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9CEC0613D0;
        Thu,  1 Oct 2020 21:00:01 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C2bqK3gk4z9s1t;
        Fri,  2 Oct 2020 13:59:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601611198;
        bh=MWGm16ObZv5Om+NnqvHvi3R/IGq58782HpBajEWeTgc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HbRJL0L/RclbBP/gg9FXYF5MKHvHl5c0urXfWk1aqza7v4xf2Fw9dE/H3td5lLWM+
         c8w0+p9r96H1x9/ZKDGyNwQBVMwAYMITttq0sMPmvvL0Ap73/WZA02U2F9mtaMkJkB
         Um1oad01wZ8pB5DCQSCE5uo8vhJ15d8OsBuWiXosel/+mVyJISs5EITlTgn7VRfLkN
         X9RdRd3BKBV2WCprDaRG+TU+62mDikWqlpNEQQ4h+/6g6ngj5OK1nP1AK5T0h73qYI
         fzrQ1RDIZBfVvs2T87E3KucAiIe+mURz1VZNe0kw/Rwba8aHuYMiivnQdcGSjRLBJe
         erizMX0/8TRfw==
Date:   Fri, 2 Oct 2020 13:59:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20201002135956.2941cf47@canb.auug.org.au>
In-Reply-To: <20200930140715.68af921b@canb.auug.org.au>
References: <20200930140715.68af921b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GZvrsGRAPNdDOH0TXW9w0.z";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/GZvrsGRAPNdDOH0TXW9w0.z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 30 Sep 2020 14:07:15 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   tools/lib/bpf/btf.c
>=20
> between commit:
>=20
>   1245008122d7 ("libbpf: Fix native endian assumption when parsing BTF")
>=20
> from the bpf tree and commit:
>=20
>   3289959b97ca ("libbpf: Support BTF loading and raw data output in both =
endianness")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (I used the latter version) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.

This is now a conflict between the net-next and net trees.
--=20
Cheers,
Stephen Rothwell

--Sig_/GZvrsGRAPNdDOH0TXW9w0.z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl92pbwACgkQAVBC80lX
0GxOLgf+IN3XwKtBfY64pu8233iR1IxkUX90ia8A3NZPYpKOxDKIrCfkNGPzNT+f
KTHH+BCCBqZy5U57GooI8SkleBliOORIdUtK2ETDw/v+ifciVlbUVKSZJ9Jf1d0a
9gWQFW2SB3xEcVP9Wt5TClBxctAJLzuggGnRI9Dp+qRxz20Pa5/Zwux+DmQCjd5e
hqSrh0+XIg91P+gO9Kf8x3y99VnSsPtzY+BJ/Yi5eh4Y/xxr4IQ91fiCNK9I4gB8
sbgMEtmlYye8RMm12CQN1dfiZuI8LKwZZUQIrQVfMiHxja52BHQGlaK1eJuhWqak
L2QjdMif5nlDoZb9ofTxqIfY/T7BpQ==
=RiyK
-----END PGP SIGNATURE-----

--Sig_/GZvrsGRAPNdDOH0TXW9w0.z--
