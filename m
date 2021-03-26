Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55118349E89
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 02:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCZBSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 21:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhCZBSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 21:18:15 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26043C06174A;
        Thu, 25 Mar 2021 18:18:15 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F63xt3nQfz9sVt;
        Fri, 26 Mar 2021 12:18:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616721492;
        bh=phZFSTiTd0aRNE6wEyesxTgghlCmSudlO8cvlqd38hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OivewrUlARIeV7Ycjvf2fowC7Kr80wiRcRxSQdY+Q4vfsS5i+GKMU098BNS88hqoC
         6jwNWN/JSJvpYnGd+cz4DljClaTgJRbAZMFV4hiCagpEB+JvrItaSuMoZ23f/4+Nby
         wmYJFW428u2kueN+/RRHkMuIijwpXLNi7n8bY0QBsvNN8NIPjxX96rSc1m3NpJSH/b
         xPjD5q4SlkfkRLat8/hSdgh5VkF+p9k1X26ykwyUnufwBBKR3wtzXMlCuWDmL1LGJY
         TUQHqqEQEtZNiqaSwKQ8mHYNkqv0Ge+F3gmK2NG6VXwUarsGJLO4EWhKsBdvtcAw9a
         CKZeda2zDHzzw==
Date:   Fri, 26 Mar 2021 12:18:08 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20210326121808.2da7ac74@canb.auug.org.au>
In-Reply-To: <20210312120014.62ced6dd@canb.auug.org.au>
References: <20210311114723.352e12f8@canb.auug.org.au>
        <bad04c3d-c80e-16c1-0f5a-4d4556555a81@intel.com>
        <20210312120014.62ced6dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/d8v2PmVjnHhlGf3y3+hGsVt";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/d8v2PmVjnHhlGf3y3+hGsVt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 12 Mar 2021 12:00:14 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> [Cc'ing a few (maybe) interested parties]
>=20
> On Thu, 11 Mar 2021 07:47:03 +0100 Bj=C3=B6rn T=C3=B6pel <bjorn.topel@int=
el.com> wrote:
> >
> > On 2021-03-11 01:47, Stephen Rothwell wrote: =20
> > >=20
> > > After merging the bpf-next tree, today's linux-next build (perf) fail=
ed
> > > like this:
> > >=20
> > > make[3]: *** No rule to make target 'libbpf_util.h', needed by '/home=
/sfr/next/perf/staticobjs/xsk.o'.  Stop. =20
> >=20
> > It's an incremental build issue, as pointed out here [1], that is
> > resolved by cleaning the build. =20
>=20
> Does this mean there is a deficiency in the dependencies in our build sys=
tem?
>=20
> > [1] https://lore.kernel.org/bpf/CAEf4BzYPDF87At4=3D_gsndxof84OiqyJxgAHL=
7_jvpuntovUQ8w@mail.gmail.com/
> >  =20
> > > Caused by commit
> > >=20
> > >    7e8bbe24cb8b ("libbpf: xsk: Move barriers from libbpf_util.h to xs=
k.h")
> > >=20
> > > I have used the bpf tree from next-20210310 for today. =20
>=20
> I have set my system to remove the object directory before building
> after merging the bpf-next tree for now.

I now get this build failure after I merge the net-next tree :-(

--=20
Cheers,
Stephen Rothwell

--Sig_/d8v2PmVjnHhlGf3y3+hGsVt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBdNlEACgkQAVBC80lX
0Gwx9Af+Pqj2r9q2x6e0mYcrknKbqhUt431nnKOFK5iscYRXk/GgNFBWSJkRNX6n
KetyaIqcoBFWEyHX+WyaR/G1wu/WKpDPloDr56Tml9Ef9szNepom4mpQsfpCLYIU
CNnMcfIR+jK1hiK1z6Gkz+/rrMEqynfLBBiCc8R6iBzempLF+eBQKVNvrk1hj32I
73qSTQa0Fv24lAeSC2BrPj+Rox14RyVsFXn/fCtjarQyT9vj+ih1M9Xk30QVmTnP
2I0+VXCceqJ1qlItRj+3MjCJuw8Ekcg5/pH7sPbm/9cxNJ6gsXV1AA76b86+Nri1
wJ5xcQ0CgJcwDK70RIAzHaaw8fPQyA==
=OP4w
-----END PGP SIGNATURE-----

--Sig_/d8v2PmVjnHhlGf3y3+hGsVt--
