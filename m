Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD12523FA
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgHYXJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHYXJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:09:28 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562D5C061574;
        Tue, 25 Aug 2020 16:09:28 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bbl754848z9sTK;
        Wed, 26 Aug 2020 09:09:21 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598396962;
        bh=PT/lyVPPPlyugAJQBBONAwhxYNwsYmbBguP8Pax6C38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J1bO8Yx/hQOulgT9ISDieyLJujg9TVAqYpEGGNYtixi8BJIHQUBtv3QQqRMIaIIoT
         KWi42x9UyOdrVA4ga5+6o2sP2w3psGT1du1queIriNL/XSVVgCEc4HzM2LyTYZBvX9
         SRVJ+Y/Di1CNDymMNUAfaeV1S35cTrATiwjBqLihn4aNeH1uRY3ZOKMjfUOst7s467
         VYh02/JLZSBp+glwUGOV4RnWH6GsTQiBCJ/HLfONLgDT1jXewFi0jVoJQhrHYM2hl3
         Sy32/HytRfS0rNn1pms1CeZZMsQky+9mVcZaAOuyFXUGXc4D5EDdlOMWDf9EqG/VXC
         zJVmnRg0g6cOQ==
Date:   Wed, 26 Aug 2020 09:09:19 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the bpf-next tree
Message-ID: <20200826090919.5363a6f6@canb.auug.org.au>
In-Reply-To: <CAADnVQJ1KZ1hUGsZY0XrWcQTa6V-y7VA9YdEjxCJfHRe5mH4xw@mail.gmail.com>
References: <20200821111111.6c04acd6@canb.auug.org.au>
        <20200825112020.43ce26bb@canb.auug.org.au>
        <CAADnVQLr8dU799ZrUnrBBDCtDxPyybZwrMFs5CAOHHW5pnLHHA@mail.gmail.com>
        <20200825130445.655885f8@canb.auug.org.au>
        <CAADnVQKGf7o8gJ60m_zjh+QcmRTNH+y1ha_B2q-1ixcCSAoHaw@mail.gmail.com>
        <20200825165029.795a8428@canb.auug.org.au>
        <CAADnVQ+SZj-Q=vijGkoUkmWeA=MM2S2oaVvJ7fj6=c4S4y-LMA@mail.gmail.com>
        <20200826071046.263e0c24@canb.auug.org.au>
        <CAADnVQJ1KZ1hUGsZY0XrWcQTa6V-y7VA9YdEjxCJfHRe5mH4xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Zh2BFdtqv6yQB66h7H_fq7a";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Zh2BFdtqv6yQB66h7H_fq7a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alexei,

On Tue, 25 Aug 2020 15:34:52 -0700 Alexei Starovoitov <alexei.starovoitov@g=
mail.com> wrote:
>
> On Tue, Aug 25, 2020 at 2:10 PM Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
> >
> > Hi Alexei,
> >
> > On Tue, 25 Aug 2020 07:33:51 -0700 Alexei Starovoitov <alexei.starovoit=
ov@gmail.com> wrote: =20
> > >
> > > what do you suggest to use to make it 'manually enabled' ?
> > > All I could think of is to add:
> > > depends on !COMPILE_TEST
> > > so that allmodconfig doesn't pick it up. =20
> >
> > That is probably sufficient.  Some gcc plugins and kasan bits, etc use
> > just that. =20
>=20
> Ok. Pushed the silencing 'fix':
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?=
id=3D2532f849b5134c4c62a20e5aaca33d9fb08af528

Thanks for that.

--=20
Cheers,
Stephen Rothwell

--Sig_/Zh2BFdtqv6yQB66h7H_fq7a
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9Fmh8ACgkQAVBC80lX
0GycUAf/QpYP3TtlUVJ6SmAaJPuAUYrTh68rq3ACJ0IjFZwwiOCQp6ucfEIYa4F5
ls/OOmoh7FlL8TPBRIVOKtBG/FBmPOiX74QWh3Nu4c9niR1J0hPymwobI7vVtWGB
Sgdztx2z8HL1v1sM7F9uFNWRkQOwvyqurYijKpeRTHcoPv7na+stl0ooLYYII8gw
2lpKqE5TyPHMHGWljXfy7K2yqxPbBpQxc4d000c1zaL5EPAlF4JWw3fci3N8BoT4
bn5sMBcNg2dQMzx+CIlev8oQO4i5c7u4bTaogEsXx90YRO7pmwRm9e11ZlvRZLeU
rwPezPGPNmj20GUbBIfO0TAtHsP5Sg==
=rf9f
-----END PGP SIGNATURE-----

--Sig_/Zh2BFdtqv6yQB66h7H_fq7a--
