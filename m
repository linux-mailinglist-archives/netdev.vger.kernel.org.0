Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3C44B1AC0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 01:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346563AbiBKAwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 19:52:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346528AbiBKAwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 19:52:30 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6261E5F86;
        Thu, 10 Feb 2022 16:52:30 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Jvw7T67qHz4xdJ;
        Fri, 11 Feb 2022 11:52:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1644540742;
        bh=tM9oSUqc6GihGbZkPvqaIHIZCKY0n+fEMRawOrrTALY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tGQqH+km47OY8CFfKc5FhDlCKoJVSG5GhYpZzJiekmm46QrOtRJ4d+oi6tDM99YnS
         4N899PZ0reKalNLo/MaYKxsOlq/RZ8bBKvuFfQwZCPN56YKTlySLRvt3z7qOuJTm63
         8T/pZGsvo2Fmbn4A6U7RtLJ08MYLNMh/qAUI53lQ3rLs0BgLGYkUCSAS2vXUJpjgpQ
         yWLBwCZKNBIHUa1b+ZEauXePqRQ/SpPpkinJVn4t1dpZ3XwbOL4cQA0sUMWl8cLMq3
         aFTQvU0biu/DnLBUlBgyaB/xM71zS1/YW2x352PE5gHGKnyGOn5u6R5ctEPcOhWH33
         3FAWpvB+9moMQ==
Date:   Fri, 11 Feb 2022 11:52:20 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Networking <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree (Was:
 Re: linux-next: build failure after merge of the bpf-next tree)
Message-ID: <20220211115220.4d4746fe@canb.auug.org.au>
In-Reply-To: <20220209112135.7fec872f@canb.auug.org.au>
References: <20220209112135.7fec872f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ImzMXu3OpUzcrR/0Blb+6dX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ImzMXu3OpUzcrR/0Blb+6dX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 9 Feb 2022 11:21:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the bpf-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> kernel/bpf/core.c:830:23: error: variably modified 'bitmap' at file scope
>   830 |         unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>       |                       ^~~~~~
>=20
> Caused by commit
>=20
>   57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
>=20
> I have used the bpf-next tree from next-20220208 for today.

The net-next tree has inherited this build failure by merging the
bpf-next tree.

I have used the net-next tree from next-20220209 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/ImzMXu3OpUzcrR/0Blb+6dX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmIFs0QACgkQAVBC80lX
0GxsDQgAlns5dBAnb2XaAy4qyu4Br0sM9tPbvnXUPnEH6p9ksbrB4rJg1C0n0md2
BeM4yujg/8UMC/ohfOB0/UG04DpsiWDtqkvSBFSccGmNAltyBHELL6+fGIsa21Cw
qhwMDiQguS3pvYasZcx799MM61VsdrCSw9JaAbaM2JQrcBXzveY45USYy01dy1et
NIeeFgHKffDxtiWMs4gQoLU85snZDvhVdg1TGLZJ+GXsjF7Znr+vjlMo+/02QrJp
/jRwD8s+axiFleJe63mTvTaYGSCIhkOPtkTVz4m5sF22uIaDPphY/qg8av0I2yRu
RESHNzJjz5DyR37imUp63kETSd+GyQ==
=S9bw
-----END PGP SIGNATURE-----

--Sig_/ImzMXu3OpUzcrR/0Blb+6dX--
