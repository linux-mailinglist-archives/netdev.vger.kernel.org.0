Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC80448D5A5
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 11:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiAMKWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 05:22:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41716 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiAMKWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 05:22:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7FE561C01;
        Thu, 13 Jan 2022 10:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C80C36AEC;
        Thu, 13 Jan 2022 10:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642069324;
        bh=I7HlexZS8NRdpazkeMv6xpnWlkXR+p+1i06vB6vDCmE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lUCcNk3AdyH+eGcui2xZzXvzv8BdHmZPfojz9V4NhAC+DaoWXr/VW62BMIMClwNCY
         4fMHOp1n1OorYjC25emGA3r5WIIKpt+u143T5i3IwK94ZaUZd0YR8z6OGFv434GCGA
         6fU3tFjGB78q/GQ5G2BcDVgo8pmWXmS56O50A8DlA+fruDk6BRS1qrJgO2x7ZNXGYn
         sfyojyuEUxyXthVRi8LQ4afoTM4yXYguI123+MBZOSpp+tFb2puciGgPXqOekMJOn8
         L6wmNB7dh0F8eS3J9ynXZbCJUSZHq+APnPz2MueNQZEuP5VlEuIoriLyrD9yngDyxw
         y9NCdwrouDibA==
Date:   Thu, 13 Jan 2022 11:22:00 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>, brouer@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Message-ID: <Yd/9SPHAPH3CpSnN@lore-desk>
References: <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk>
 <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk>
 <8735lshapk.fsf@toke.dk>
 <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/9SrXxM1u7AZoJOX"
Content-Disposition: inline
In-Reply-To: <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--/9SrXxM1u7AZoJOX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20
>=20
> On 12/01/2022 23.04, Toke H=F8iland-J=F8rgensen wrote:
> > Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> >=20
> > > > On Wed, Jan 12, 2022 at 11:47 AM Alexei Starovoitov
> > > > <alexei.starovoitov@gmail.com> wrote:
> > > > >=20
> > > > > On Wed, Jan 12, 2022 at 11:21 AM Andrii Nakryiko
> > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > >=20
> > > > > > On Wed, Jan 12, 2022 at 11:17 AM Alexei Starovoitov
> > > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > >=20
> > > > > > > On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
> > > > > > > <andrii.nakryiko@gmail.com> wrote:
> > > > > > > >=20
> > > > > > > > On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@=
kernel.org> wrote:
> > > > > > > > >=20
> > > > > > > > > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenz=
o@kernel.org> wrote:
> > > > > > > > > > >=20
> > > > > > > > > > > Introduce support for the following SEC entries for X=
DP multi-buff
> > > > > > > > > > > property:
> > > > > > > > > > > - SEC("xdp_mb/")
> > > > > > > > > > > - SEC("xdp_devmap_mb/")
> > > > > > > > > > > - SEC("xdp_cpumap_mb/")
> > > > > > > > > >=20
> > > > > > > > > > Libbpf seemed to went with .<suffix> rule (e.g., fentry=
=2Es for
> > > > > > > > > > sleepable, seems like we'll have kprobe.multi or  somet=
hing along
> > > > > > > > > > those lines as well), so let's stay consistent and call=
 this "xdp_mb",
> > > > > > > > > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really a=
ll that
> > > > > > > > > > recognizable? would ".multibuf" be too verbose?). Also,=
 why the "/"
> > > > > > > > > > part? Also it shouldn't be "sloppy" either. Neither exp=
ected attach
> > > > > > > > > > type should be optional.  Also not sure SEC_ATTACHABLE =
is needed. So
> > > > > > > > > > at most it should be SEC_XDP_MB, probably.
> > > > > > > > >=20
> > > > > > > > > ack, I fine with it. Something like:
> > > > > > > > >=20
> > > > > > > > >          SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC=
, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > > > > > > > >          SEC_DEF("iter/",                TRACING, BPF_TRA=
CE_ITER, SEC_ATTACH_BTF, attach_iter),
> > > > > > > > >          SEC_DEF("syscall",              SYSCALL, 0, SEC_=
SLEEPABLE),
> > > > > > > > > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVM=
AP, 0),
> > > > > > > > >          SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEV=
MAP, SEC_ATTACHABLE),
> > > > > > > > > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUM=
AP, 0),
> > > > > > > > >          SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPU=
MAP, SEC_ATTACHABLE),
> > > > > > > > > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
> > > > > > > >=20
> > > > > > > > yep, but please use SEC_NONE instead of zero
> > > > > > > >=20
> > > > > > > > >          SEC_DEF("xdp",                  XDP, BPF_XDP, SE=
C_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> > > > > > > > >          SEC_DEF("perf_event",           PERF_EVENT, 0, S=
EC_NONE | SEC_SLOPPY_PFX),
> > > > > > > > >          SEC_DEF("lwt_in",               LWT_IN, 0, SEC_N=
ONE | SEC_SLOPPY_PFX),
> > > > > > > > >=20
> > > > > > > > > >=20
> > > > > > > > > > >=20
> > > > > > > > > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > > > > > > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > > > > > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > > > > > > > ---
> > > > > > > > > > >   tools/lib/bpf/libbpf.c | 8 ++++++++
> > > > > > > > > > >   1 file changed, 8 insertions(+)
> > > > > > > > > > >=20
> > > > > > > > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/l=
ibbpf.c
> > > > > > > > > > > index 7f10dd501a52..c93f6afef96c 100644
> > > > > > > > > > > --- a/tools/lib/bpf/libbpf.c
> > > > > > > > > > > +++ b/tools/lib/bpf/libbpf.c
> > > > > > > > > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > > > > > > > > > >          SEC_SLEEPABLE =3D 8,
> > > > > > > > > > >          /* allow non-strict prefix matching */
> > > > > > > > > > >          SEC_SLOPPY_PFX =3D 16,
> > > > > > > > > > > +       /* BPF program support XDP multi-buff */
> > > > > > > > > > > +       SEC_XDP_MB =3D 32,
> > > > > > > > > > >   };
> > > > > > > > > > >=20
> > > > > > > > > > >   struct bpf_sec_def {
> > > > > > > > > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(=
struct bpf_program *prog,
> > > > > > > > > > >          if (def & SEC_SLEEPABLE)
> > > > > > > > > > >                  opts->prog_flags |=3D BPF_F_SLEEPABL=
E;
> > > > > > > > > > >=20
> > > > > > > > > > > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP && (d=
ef & SEC_XDP_MB))
> > > > > > > > > > > +               opts->prog_flags |=3D BPF_F_XDP_MB;
> > > > > > > > > >=20
> > > > > > > > > > I'd say you don't even need SEC_XDP_MB flag at all, you=
 can just check
> > > > > > > > > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb"=
 or
> > > > > > > > > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't se=
em generic
> > > > > > > > > > enough to warrant a flag.
> > > > > > > > >=20
> > > > > > > > > ack, something like:
> > > > > > > > >=20
> > > > > > > > > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP &&
> > > > > > > > > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf=
") ||
> > > > > > > > > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf=
") ||
> > > > > > > > > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > > > > > > > > +               opts->prog_flags |=3D BPF_F_XDP_MB;
> > > > > > > >=20
> > > > > > > > yep, can also simplify it a bit with strstr(prog->sec_name,
> > > > > > > > ".multibuf") instead of three strcmp
> > > > > > >=20
> > > > > > > Maybe ".mb" ?
> > > > > > > ".multibuf" is too verbose.
> > > > > > > We're fine with ".s" for sleepable :)
> > > > > >=20
> > > > > >=20
> > > > > > I had reservations about "mb" because the first and strong asso=
ciation
> > > > > > is "megabyte", not "multibuf". And it's not like anyone would h=
ave
> > > > > > tens of those programs in a single file so that ".multibuf" bec=
omes
> > > > > > way too verbose. But I don't feel too strongly about this, if t=
he
> > > > > > consensus is on ".mb".
> > > > >=20
> > > > > The rest of the patches are using _mb everywhere.
> > > > > I would keep libbpf consistent.
> > > >=20
> > > > Should the rest of the patches maybe use "multibuf" instead of "mb"=
? I've been
> > > > following this patch series closely and excitedly, and I keep havin=
g to remind
> > > > myself that "mb" is "multibuff" and not "megabyte". If I'm having t=
o correct
> > > > myself while following the patch series, I'm wondering if future co=
nfusion is
> > > > inevitable?
> > > >=20
> > > > But, is it enough confusion to be worth updating many other patches=
? I'm not
> > > > sure.
> > > >=20
> > > > I agree consistency is more important than the specific term we're =
consistent
> > > > on.
> > >=20
> > > I would prefer to keep the "_mb" postfix, but naming is hard and I am
> > > polarized :)
> >=20
> > I would lean towards keeping _mb as well, but if it does have to be
> > changed why not _mbuf? At least that's not quite as verbose :)
>=20
> I dislike the "mb" abbreviation as I forget it stands for multi-buffer.
> I like the "mbuf" suggestion, even-though it conflicts with (Free)BSD mbu=
fs
> (which is their SKB).

If we all agree, I can go over the series and substitute mb postfix with mb=
uf.
Any objections?

>=20
> I prefer/support the .<suffix> idea from Andrii.
> Which would then be ".mbuf" for my taste.

ack, I have already implemented it, we need to define just the naming
convention now.

Regards,
Lorenzo

>=20
> --Jesper
> p.s. I like the bikeshed red, meaning I don't feel too strongly about thi=
s.
>=20

--/9SrXxM1u7AZoJOX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYd/9SAAKCRA6cBh0uS2t
rL02AQCp9KeOu3lnbwwOyjMDOOBWCJLlwougl4pl1veqTEaR1wD+PoBKboPMi2uz
+x6q9fSX+kcXzvH4knjk4jiU+RqKYQA=
=H6Op
-----END PGP SIGNATURE-----

--/9SrXxM1u7AZoJOX--
