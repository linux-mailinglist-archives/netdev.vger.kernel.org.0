Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2BC48CB15
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356304AbiALSfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:35:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40630 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356305AbiALSfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:35:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C313E619CC;
        Wed, 12 Jan 2022 18:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03FAC36AEA;
        Wed, 12 Jan 2022 18:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642012529;
        bh=HmRQnAXT4lWFBNnsRBtAgzm9nwINgaKqdSCXYPXFbTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eFu0RivdJr9GxENhMgdd5N3ECs2qMhsgdZjWrfTzrC+ful7VV01i4fGFus5IZxd1o
         U5ploRcJpQAVOL+h+2qPBbEUPY+EpPp+1U9LYT2GMOPaZd1Eo1scmXHcbY2tZb4/V8
         GXRV1Chqn0EyJ1Uf8UFb26PR6Po/85glmLXdulPeoC9+E38g9IiVJaqxCac8+3Cymy
         qooJe9N9G+RE88GSP0P0VYaCiHDQCBktPi66TFOl47G6qNh+EJLSF+PfJkHbk4Mq1x
         AgNdlj7vyaXKd0vHYIzehSlQJ1W+s8ucsUKfy1wucCytVcANUXPD3Hs9hmY0o/fg0r
         UCPiQlNB32dzg==
Date:   Wed, 12 Jan 2022 19:35:25 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Message-ID: <Yd8fbUT0pDUu87J+@lore-desk>
References: <cover.1641641663.git.lorenzo@kernel.org>
 <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk>
 <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="zsCcsW07E/CGmOVq"
Content-Disposition: inline
In-Reply-To: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zsCcsW07E/CGmOVq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wr=
ote:
> >
> > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> =
wrote:
> > > >
> > > > Introduce support for the following SEC entries for XDP multi-buff
> > > > property:
> > > > - SEC("xdp_mb/")
> > > > - SEC("xdp_devmap_mb/")
> > > > - SEC("xdp_cpumap_mb/")
> > >
> > > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> > > sleepable, seems like we'll have kprobe.multi or  something along
> > > those lines as well), so let's stay consistent and call this "xdp_mb",
> > > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> > > recognizable? would ".multibuf" be too verbose?). Also, why the "/"
> > > part? Also it shouldn't be "sloppy" either. Neither expected attach
> > > type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
> > > at most it should be SEC_XDP_MB, probably.
> >
> > ack, I fine with it. Something like:
> >
> >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BT=
F | SEC_SLEEPABLE, attach_lsm),
> >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_AT=
TACH_BTF, attach_iter),
> >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
> >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACH=
ABLE),
> > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
> >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACH=
ABLE),
> > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
>=20
> yep, but please use SEC_NONE instead of zero

ack, I will fix it.

>=20
> >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OP=
T | SEC_SLOPPY_PFX),
> >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_S=
LOPPY_PFX),
> >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPP=
Y_PFX),
> >
> > >
> > > >
> > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 8 ++++++++
> > > >  1 file changed, 8 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index 7f10dd501a52..c93f6afef96c 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > > >         SEC_SLEEPABLE =3D 8,
> > > >         /* allow non-strict prefix matching */
> > > >         SEC_SLOPPY_PFX =3D 16,
> > > > +       /* BPF program support XDP multi-buff */
> > > > +       SEC_XDP_MB =3D 32,
> > > >  };
> > > >
> > > >  struct bpf_sec_def {
> > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_pro=
gram *prog,
> > > >         if (def & SEC_SLEEPABLE)
> > > >                 opts->prog_flags |=3D BPF_F_SLEEPABLE;
> > > >
> > > > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP && (def & SEC_XDP_M=
B))
> > > > +               opts->prog_flags |=3D BPF_F_XDP_MB;
> > >
> > > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> > > enough to warrant a flag.
> >
> > ack, something like:
> >
> > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP &&
> > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > +               opts->prog_flags |=3D BPF_F_XDP_MB;
>=20
> yep, can also simplify it a bit with strstr(prog->sec_name,
> ".multibuf") instead of three strcmp

ack, I will fix it.

Regards,
Lorenzo

>=20
> >
> > Regards,
> > Lorenzo
> >
> > >
> > > > +
> > > >         if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
> > > >              prog->type =3D=3D BPF_PROG_TYPE_LSM ||
> > > >              prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_=
btf_id) {
> > > > @@ -8600,8 +8605,11 @@ static const struct bpf_sec_def section_defs=
[] =3D {
> > > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTAC=
H_BTF | SEC_SLEEPABLE, attach_lsm),
> > > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SE=
C_ATTACH_BTF, attach_iter),
> > > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > > +       SEC_DEF("xdp_devmap_mb/",       XDP, BPF_XDP_DEVMAP, SEC_AT=
TACHABLE | SEC_XDP_MB),
> > > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_AT=
TACHABLE),
> > > > +       SEC_DEF("xdp_cpumap_mb/",       XDP, BPF_XDP_CPUMAP, SEC_AT=
TACHABLE | SEC_XDP_MB),
> > > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_AT=
TACHABLE),
> > > > +       SEC_DEF("xdp_mb/",              XDP, BPF_XDP, SEC_ATTACHABL=
E_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
> > > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABL=
E_OPT | SEC_SLOPPY_PFX),
> > > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | S=
EC_SLOPPY_PFX),
> > > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_S=
LOPPY_PFX),
> > > > --
> > > > 2.33.1
> > > >

--zsCcsW07E/CGmOVq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYd8fbQAKCRA6cBh0uS2t
rDCpAP9ZZ++hmwSd7MRWdj+Aa3wW0FQ/eytkJb8mlIKpycd64wD/ZFNQ3D8fT8if
D8vGDbISLpr1dDnARwHMisN0eBf8zgY=
=IauF
-----END PGP SIGNATURE-----

--zsCcsW07E/CGmOVq--
