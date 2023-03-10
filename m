Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D82E6B32D5
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCJAiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCJAiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:38:24 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD275C9FD;
        Thu,  9 Mar 2023 16:38:23 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PXnGN0nSWz4x7v;
        Fri, 10 Mar 2023 11:38:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1678408701;
        bh=JsHc1igOc4Eb43fU6eO4BGsI5tx0g6dZVy+B67z7JMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AktlXja5BihYVa6Q0S4+ghoDQ28KLwCMJ1elTPluDEFXZfOD770+HpJ9SgkpIE6au
         7aWvAoPI//bka6Egt6OTpQK5TLd0GMGfpfzju20RF9eVhIR7rTEyvHa4WdYhtTmItK
         Fn+0s76iKL4KyoNqtfGGf2KnUDr2C/0n9dhsxVJTL0ZJFy1D9h/LfkvEu/7pYmtbbu
         nFizkky90GFBXrxATrkAt1ziQQdTjzJAbLCIhuf7SL29gx2lI7V6NTKgtW9++3w408
         IsQ87UCIkYrXZjRjTqmGlvZRXEZi92tqQbTkh8lfMwcOEzUgxx3Mxw3B1TSfIDvhAf
         GJmsMYJRiskIA==
Date:   Fri, 10 Mar 2023 11:38:18 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        David Vernet <void@manifault.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20230310113818.3f27de45@canb.auug.org.au>
In-Reply-To: <20230307095812.236eb1be@canb.auug.org.au>
References: <20230307095812.236eb1be@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Y.WdL2fUM0E+dmerrA8t=Gx";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Y.WdL2fUM0E+dmerrA8t=Gx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 7 Mar 2023 09:58:12 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>=20
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   Documentation/bpf/bpf_devel_QA.rst
>=20
> between commit:
>=20
>   b7abcd9c656b ("bpf, doc: Link to submitting-patches.rst for general pat=
ch submission info")
>=20
> from the bpf tree and commit:
>=20
>   d56b0c461d19 ("bpf, docs: Fix link to netdev-FAQ target")
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
> diff --cc Documentation/bpf/bpf_devel_QA.rst
> index b421d94dc9f2,5f5f9ccc3862..000000000000
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@@ -684,8 -684,12 +684,8 @@@ when
>  =20
>  =20
>   .. Links
> - .. _netdev-FAQ: Documentation/process/maintainer-netdev.rst
>  -.. _Documentation/process/: https://www.kernel.org/doc/html/latest/proc=
ess/
> + .. _netdev-FAQ: https://www.kernel.org/doc/html/latest/process/maintain=
er-netdev.html
>   .. _selftests:
>      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/t=
ree/tools/testing/selftests/bpf/
>  -.. _Documentation/dev-tools/kselftest.rst:
>  -   https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
>  -.. _Documentation/bpf/btf.rst: btf.rst
>  =20
>   Happy BPF hacking!

This is now a conflict between the net-next tree and Linus' tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/Y.WdL2fUM0E+dmerrA8t=Gx
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmQKe/sACgkQAVBC80lX
0GwC1wf/RXdwB6V64d2FmGNLAOXcwdNdjog6gxjgZqNWqyp/L+gw9tFRB+2bUx4q
8TT7yXos2gU3SB+IkExmgMSD5eCCzX3nDcqVstoFMnyfY7oYk7jhptIFq0zwbqrI
QADkm6PAKQyYj5FNVYdpcHrdvr2Gsz5hifcB0OPp0Oj+ohNWP1bCAJ4fNSil4BjP
Uaj/GatXItd+kPwDM1v88d8jr+yeCUV0Z14w0bhWu0dEj/hegmIy8wJ0K/vMCPQg
UdA6LEHNfe+auaPqt8nFacW8uJ/bCk/OPC+/+EcDuNFJIZAdDxAzVQmsP7kIYuv3
kFmSRJKMFxwJr+a7zCDDxLjXQJpEGQ==
=SBe0
-----END PGP SIGNATURE-----

--Sig_/Y.WdL2fUM0E+dmerrA8t=Gx--
