Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859EB5AFDCD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiIGHpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIGHpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:45:45 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2037FFAC;
        Wed,  7 Sep 2022 00:45:42 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MMvSM48Bmz4wgr;
        Wed,  7 Sep 2022 17:45:39 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1662536741;
        bh=bhsJcQEgyb5vhXPUdvUG6IM1FjPRH71usf9pZQ22R1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cYRv60Mn0VD9/sCRd9f51WWo2eCrDCXr4Bzs0uDkG19XgmBhgzXAvmFA1Snjc2s+X
         0bpBYSJ//f6SITYk+MhxISXGg/B0muwWFUbuBJQPE8Nwei7j+JNdpgArKGL+89TXLm
         pPm0hF6l9GRDS0MTstX6c1YOEz5kj3XKKQXQZTthbl0PmpJZDDuPRe2aQrC5DJUxZW
         4NYauY4Apix4awRLXlM4FkAkew2C0fT1c73vdBhBmXL6f0zh2jr3vCsNLg4TWnYDLc
         4pBx0nRaXQb2HYytzoPAGqek89313v0+w0LrRQP+Idu48OWA4YYIyd5Tqm2ipBA2Ie
         GJkcm0Gk9A8dQ==
Date:   Wed, 7 Sep 2022 17:45:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Marco Elver <elver@google.com>
Subject: Re: linux-next: build failure after merge of the slab tree
Message-ID: <20220907174535.4852e7da@canb.auug.org.au>
In-Reply-To: <CAADnVQKJORAcV75CHE1yG6_+c8qnoOj6gf=zJG9vnWwR5+4SqQ@mail.gmail.com>
References: <20220906165131.59f395a9@canb.auug.org.au>
        <dab10759-c059-2254-116b-8360bc240e57@suse.cz>
        <CAADnVQJTDdA=vpQhrbAbX7oEQ=uaPXwAmjMzpW4Nk2Xi9f2JLA@mail.gmail.com>
        <CAADnVQKJORAcV75CHE1yG6_+c8qnoOj6gf=zJG9vnWwR5+4SqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/IMql38jc4ngYXPwtr.DpjJM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/IMql38jc4ngYXPwtr.DpjJM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 6 Sep 2022 20:05:44 -0700 Alexei Starovoitov <alexei.starovoitov@gm=
ail.com> wrote:
>
> On Tue, Sep 6, 2022 at 11:37 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Sep 6, 2022 at 12:53 AM Vlastimil Babka <vbabka@suse.cz> wrote:=
 =20
> > >
> > > On 9/6/22 08:51, Stephen Rothwell wrote: =20
> > > > Hi all, =20
> > >
> > > Hi,
> > > =20
> > > > After merging the slab tree, today's linux-next build (powerpc
> > > > ppc64_defconfig) failed like this:
> > > >
> > > > kernel/bpf/memalloc.c: In function 'bpf_mem_free':
> > > > kernel/bpf/memalloc.c:613:33: error: implicit declaration of functi=
on '__ksize'; did you mean 'ksize'? [-Werror=3Dimplicit-function-declaratio=
n]
> > > >    613 |         idx =3D bpf_mem_cache_idx(__ksize(ptr - LLIST_NODE=
_SZ));
> > > >        |                                 ^~~~~~~
> > > >        |                                 ksize =20
> > >
> > > Could you use ksize() here? I'm guessing you picked __ksize() because
> > > kasan_unpoison_element() in mm/mempool.c did, but that's to avoid
> > > kasan_unpoison_range() in ksize() as this caller does it differently.
> > > AFAICS your function doesn't handle kasan differently, so ksize() sho=
uld
> > > be fine. =20
> >
> > Ok. Will change to use ksize(). =20
>=20
> Just pushed the following commit to address the issue:
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?=
id=3D1e660f7ebe0ff6ac65ee0000280392d878630a67
>=20
> It will get to net-next soon.

I replaced my revert with that patch for today (and will discard that
when it arrives via some other tree).

--=20
Cheers,
Stephen Rothwell

--Sig_/IMql38jc4ngYXPwtr.DpjJM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMYTB8ACgkQAVBC80lX
0GyK6Qf/QTHmLJ5Q68YznFmFD9sOrzRpxcX1pruMX5LvK7xzTn3NoGEmaFSNPT1i
2ikd8XlTRk8YIbW+k80qPoHHWJy7hfmYEEwznigEOPfgq1a/HfmUbhc4tYjRffTD
KBwk2urFFvs59tjKt2PgH0aS2Jr7Ze/1LaY1eYnJ9mS6+wY8b6OeBarl+0qbuAop
Ia4q0N6/Z1Nf1NrAAo+7llUdda26Ly30iJCrS9prkOfvWYy6k/B6ehgbFwDg5sV5
1gfz3aZokZXvb5XAKVmwnQHJPq094gZ7qr59OjIkNLKQ1ZkD6pOddWzCmcuqrhQY
mOoX0BJ/H/c5ez5x43XtgYgMwZrTYQ==
=tqs4
-----END PGP SIGNATURE-----

--Sig_/IMql38jc4ngYXPwtr.DpjJM--
