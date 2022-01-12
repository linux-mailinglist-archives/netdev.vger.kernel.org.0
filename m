Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63FA48CAD0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356132AbiALSSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:18:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58518 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349910AbiALSSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:18:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 017D9619BF;
        Wed, 12 Jan 2022 18:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE24AC36AE5;
        Wed, 12 Jan 2022 18:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642011480;
        bh=0H1CLt+VvEHrz668MInHgFSL7XgsFZ5ZGc1z5o89IT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fejQXkxCbbVke3tZeXwEdGCkeKgldUhJjMSFyQ/DXyOR2XMAi9b5gGpNLGnkrv+1f
         IFX2x8HCFRwgL7xmzVnlE0NsERisWbSjH+pGZBj74qv6IcK+B7KjefNVfBkASmONyk
         IjG5reByBZqx2y4POlrC7D2sCGtsZeMRiW4PT7ZrXDEGMhB/1gbNAqK9Msw9d5gOu3
         cTqZRvYrTPcnloPSX1yWPpQg4x3J2RUTIZO+6Z1VO3oY6lynlisUSapv5qaX8Vw+zX
         4clONkLlt1LPN6tHbxkI1pwjYeUZ3WjydVUwtNAaY6D12Q4PW1BFn/zIO/FRXKjkCM
         TpY+mFdFLuB7g==
Date:   Wed, 12 Jan 2022 19:17:56 +0100
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
Message-ID: <Yd8bVIcA18KIH6+I@lore-desk>
References: <cover.1641641663.git.lorenzo@kernel.org>
 <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="PE2xfSOW+rT6gZi6"
Content-Disposition: inline
In-Reply-To: <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PE2xfSOW+rT6gZi6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrot=
e:
> >
> > Introduce support for the following SEC entries for XDP multi-buff
> > property:
> > - SEC("xdp_mb/")
> > - SEC("xdp_devmap_mb/")
> > - SEC("xdp_cpumap_mb/")
>=20
> Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> sleepable, seems like we'll have kprobe.multi or  something along
> those lines as well), so let's stay consistent and call this "xdp_mb",
> "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> recognizable? would ".multibuf" be too verbose?). Also, why the "/"
> part? Also it shouldn't be "sloppy" either. Neither expected attach
> type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
> at most it should be SEC_XDP_MB, probably.

ack, I fine with it. Something like:

 	SEC_DEF("lsm.s/",		LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, atta=
ch_lsm),
 	SEC_DEF("iter/",		TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
+	SEC_DEF("xdp_devmap.multibuf",	XDP, BPF_XDP_DEVMAP, 0),
 	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
+	SEC_DEF("xdp_cpumap.multibuf",	XDP, BPF_XDP_CPUMAP, 0),
 	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
+	SEC_DEF("xdp.multibuf",		XDP, BPF_XDP, 0),
 	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),

>=20
> >
> > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  tools/lib/bpf/libbpf.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 7f10dd501a52..c93f6afef96c 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -235,6 +235,8 @@ enum sec_def_flags {
> >         SEC_SLEEPABLE =3D 8,
> >         /* allow non-strict prefix matching */
> >         SEC_SLOPPY_PFX =3D 16,
> > +       /* BPF program support XDP multi-buff */
> > +       SEC_XDP_MB =3D 32,
> >  };
> >
> >  struct bpf_sec_def {
> > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program=
 *prog,
> >         if (def & SEC_SLEEPABLE)
> >                 opts->prog_flags |=3D BPF_F_SLEEPABLE;
> >
> > +       if (prog->type =3D=3D BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> > +               opts->prog_flags |=3D BPF_F_XDP_MB;
>=20
> I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> enough to warrant a flag.

ack, something like:

+	if (prog->type =3D=3D BPF_PROG_TYPE_XDP &&
+	    (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
+	     !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
+	     !strcmp(prog->sec_name, "xdp.multibuf")))
+		opts->prog_flags |=3D BPF_F_XDP_MB;

Regards,
Lorenzo

>=20
> > +
> >         if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
> >              prog->type =3D=3D BPF_PROG_TYPE_LSM ||
> >              prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_btf_=
id) {
> > @@ -8600,8 +8605,11 @@ static const struct bpf_sec_def section_defs[] =
=3D {
> >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BT=
F | SEC_SLEEPABLE, attach_lsm),
> >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_AT=
TACH_BTF, attach_iter),
> >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > +       SEC_DEF("xdp_devmap_mb/",       XDP, BPF_XDP_DEVMAP, SEC_ATTACH=
ABLE | SEC_XDP_MB),
> >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACH=
ABLE),
> > +       SEC_DEF("xdp_cpumap_mb/",       XDP, BPF_XDP_CPUMAP, SEC_ATTACH=
ABLE | SEC_XDP_MB),
> >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACH=
ABLE),
> > +       SEC_DEF("xdp_mb/",              XDP, BPF_XDP, SEC_ATTACHABLE_OP=
T | SEC_SLOPPY_PFX | SEC_XDP_MB),
> >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OP=
T | SEC_SLOPPY_PFX),
> >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_S=
LOPPY_PFX),
> >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPP=
Y_PFX),
> > --
> > 2.33.1
> >

--PE2xfSOW+rT6gZi6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYd8bUwAKCRA6cBh0uS2t
rHT7AQD3onYae8E3PhJBeBaGxkhzTBs22TBaYlJSvJ7dQALCIgD9HtStnzng+xiX
Gp9RFPg8IKvaAicW9mpSlE9YIGOWZAE=
=WAcO
-----END PGP SIGNATURE-----

--PE2xfSOW+rT6gZi6--
