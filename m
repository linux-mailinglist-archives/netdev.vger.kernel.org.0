Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B84493772
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 10:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352237AbiASJik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 04:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbiASJij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 04:38:39 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B670EC061574;
        Wed, 19 Jan 2022 01:38:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12D19CE1C4E;
        Wed, 19 Jan 2022 09:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7F6C004E1;
        Wed, 19 Jan 2022 09:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642585115;
        bh=CKV+zi0KNehjLbHnOq5EedfhWZUHE0jo/uA0PO8/TPc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ShEy5xL3VN0F4Mn/n2MrSwD6L0/GyVf8sOxZcvhQCa3K03IxIlAP+JdHmvTR7VaAH
         UcADT+pVHDPERF3deFxKKBUqxh6zbC5RyVKiQcm55nNhbq0eFe96/MAAuNC0mQ6JBe
         Xxjc9jbfqGqPVo9xL2zYdbpSbvUPHM3DyCvQS95vTRloxraFV3UXzPIypB9W9MROxT
         RPloCMbzh6fBkicK83KQDq4KE9TlVVJJHzC7Ucb1ppg2v9Paei5j+5J04PECp7JdCV
         EkG/tCubpxHdWc29xmuJjjyvwUepNyBJ2D4k9xaq2766UXbCXzQONMFqWI4FhrCc7J
         8+UADT/8cleZw==
Date:   Wed, 19 Jan 2022 10:38:31 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v22 bpf-next 18/23] libbpf: Add SEC name for xdp
 multi-frags programs
Message-ID: <YefcFzFSWJHf6kks@lore-desk>
References: <cover.1642439548.git.lorenzo@kernel.org>
 <c2bdc436abe8e27a46aa8ba13f75d24f119e18a4.1642439548.git.lorenzo@kernel.org>
 <20220118201449.sjqzif5qkpbu5tqx@ast-mbp.dhcp.thefacebook.com>
 <Yec/qu7idEImzqxc@lore-desk>
 <CAADnVQJgKVQ8vNfiazTcNbZVFTb2x=7G1WUda7O+LHM8Hs=KCw@mail.gmail.com>
 <CAEf4BzYHyCz5QNwuuKnRRrqCTcP0c0Q6fdi0N5_Yp8yNXvxReQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qJ9cHp6/IZe/+g7y"
Content-Disposition: inline
In-Reply-To: <CAEf4BzYHyCz5QNwuuKnRRrqCTcP0c0Q6fdi0N5_Yp8yNXvxReQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qJ9cHp6/IZe/+g7y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Jan 18, 2022 at 2:33 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jan 18, 2022 at 2:31 PM Lorenzo Bianconi <lorenzo@kernel.org> w=
rote:
> > >
> > > > On Mon, Jan 17, 2022 at 06:28:30PM +0100, Lorenzo Bianconi wrote:
> > > > > Introduce support for the following SEC entries for XDP multi-fra=
gs
> > > > > property:
> > > > > - SEC("xdp.frags")
> > > > > - SEC("xdp.frags/devmap")
> > > > > - SEC("xdp.frags/cpumap")
> > > > >
> > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > ---
> > > > >  tools/lib/bpf/libbpf.c | 6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > >
> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > > index fdb3536afa7d..611e81357fb6 100644
> > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > @@ -6562,6 +6562,9 @@ static int libbpf_preload_prog(struct bpf_p=
rogram *prog,
> > > > >     if (def & SEC_SLEEPABLE)
> > > > >             opts->prog_flags |=3D BPF_F_SLEEPABLE;
> > > > >
> > > > > +   if (prog->type =3D=3D BPF_PROG_TYPE_XDP && strstr(prog->sec_n=
ame, ".frags"))
> > > > > +           opts->prog_flags |=3D BPF_F_XDP_HAS_FRAGS;
> > > >
> > > > That's a bit sloppy.
> > > > Could you handle it similar to SEC_SLEEPABLE?
> > > >
> > > > > +
> > > > >     if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
> > > > >          prog->type =3D=3D BPF_PROG_TYPE_LSM ||
> > > > >          prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_bt=
f_id) {
> > > > > @@ -8600,8 +8603,11 @@ static const struct bpf_sec_def section_de=
fs[] =3D {
> > > > >     SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_=
BTF | SEC_SLEEPABLE, attach_lsm),
> > > > >     SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_=
ATTACH_BTF, attach_iter),
> > > > >     SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > > > +   SEC_DEF("xdp.frags/devmap",     XDP, BPF_XDP_DEVMAP, SEC_NONE=
),
> > > > >     SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTA=
CHABLE),
> > > > > +   SEC_DEF("xdp.frags/cpumap",     XDP, BPF_XDP_CPUMAP, SEC_NONE=
),
> > > > >     SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTA=
CHABLE),
> > > > > +   SEC_DEF("xdp.frags",            XDP, BPF_XDP, SEC_NONE),
> > > >
> > > > It would be SEC_FRAGS here instead of SEC_NONE.
> > >
> > > ack, I dropped SEC_FRAGS (SEC_XDP_MB before) from sec_def_flags becau=
se Andrii asked to remove
> > > it but I am fine to add it back. Agree?
> >
> > Andrii,
> > what was the motivation?
> > imo that's cleaner than strstr.
>=20
> Given it was XDP-specific (as opposed to sleepable flag that applies
> more widely), it felt cleaner ([0]) to handle that as a special case
> in libbpf_preload_prog. But I didn't feel that strongly about that
> back then and still don't, so if you think SEC_FRAGS is better, I'm
> fine with it. I'd make it SEC_XDP_FRAGS to make it more obvious it's
> still XDP-specific (there are no plans to extend it to non-XDP,
> right?).

I do not think so and anyway it is an internal flag so we can change it in =
the
future if necessary, right?

Regards,
Lorenzo

>=20
> But whichever way, it's internal implementation detail and pretty
> small one at that, so I don't care much.
>=20
>   [0] https://lore.kernel.org/bpf/CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6=
sJEUxDSy1zZw@mail.gmail.com/

--qJ9cHp6/IZe/+g7y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYefcFwAKCRA6cBh0uS2t
rCaJAQDwcLRcUG+CeWc8ko/YatfpFVuR8yPcPu04ezEEMny2gwD+PBvHRm9bD/Wf
MkG1QX7rrbFM6Cw7sQkdAze8NKp0rgU=
=p33r
-----END PGP SIGNATURE-----

--qJ9cHp6/IZe/+g7y--
