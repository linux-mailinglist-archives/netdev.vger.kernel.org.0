Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7E380046
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 20:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406829AbfHBSjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 14:39:55 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43238 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405505AbfHBSjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 14:39:55 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so30593232qto.10
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 11:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=tVWQy+nDA7BgpOlTITwN5hmtSLFhbI4YY9JeFdJrHmg=;
        b=nX7Wlz26eb2VKdzDm8ODw+faXt0CPkB+7oQt+/Fewg8G4PYOPJQKSq4qEPtrqM54qx
         Cep1rq24Y4DL5VeB1DgKtkifQ9g09+7sBnjgo88ef0L/OA9NlX6aPPHyhUxfog8lkMp9
         wyojguNmY/Q/zFeoCo/2zD3s0YYaGPKEX6MBbKzsUjPDK+nwLluCl+CVDVs0qYCutjLk
         kOpz/RwHp+OZhJaXntkH78ya2sf1x5KXQPi0QyR5QOmXzfzk/JsYR8U78fvFfXAYhrFC
         T96HlmLrUyoLXk3R3J+VeSQJYO24srhWMEbYTD0Yv/pr/sEWYQE3CTgsucllK5iXYG/m
         uLOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=tVWQy+nDA7BgpOlTITwN5hmtSLFhbI4YY9JeFdJrHmg=;
        b=Jp/AnnU8vIU1blHg2JQQF/o7R+DffTMC5k4uNN70vER249CpYPHbsW/EzHco+HOsLh
         QIKA77AsyrOJvztCvm7WQrJN6IIq7Vli8xLBdSaqaJayqaYAzIJPjus2R9rl0ssmROwA
         bE7hC0RDe9dMNAfTOpta/qhX1JXjkBVEkQGyaFt/5uu0SVi4M6H7AIlAw8FRSmIhnz0i
         TSrGsNxSgHjeZ3u0NI/XUtEhIIKc/TU7Lby8y7/NcWo64LnJNEYrJRxUGxHDmqjF++ve
         UyPS70eFB8zUr/44ruzp36CULL2RtwBzsZeV6Gv2hBp9Kd+cRQXCQg7iPA064FrX/EGx
         0TpA==
X-Gm-Message-State: APjAAAWmFP4qK9LpA+ufXeF6+O+PHav5m387F3vq/HFMvc0+9DVbTxDs
        2I5G5hBGuJXx/8Fwbunm4DxKsw==
X-Google-Smtp-Source: APXvYqwzcWaqw070rXe6ICerTPSD9I9FRYEa+tcARvMWCu3C56MIT3kWi5zy8N4dVGA6jrJpWR7k+A==
X-Received: by 2002:ac8:384c:: with SMTP id r12mr96359910qtb.153.1564771193831;
        Fri, 02 Aug 2019 11:39:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w80sm35472080qka.74.2019.08.02.11.39.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 11:39:53 -0700 (PDT)
Date:   Fri, 2 Aug 2019 11:39:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [v2,1/2] tools: bpftool: add net attach command to attach XDP
 on interface
Message-ID: <20190802113935.63be803a@cakuba.netronome.com>
In-Reply-To: <CAEKGpzhsjMuf+DtN3pDVYMxJa5o2e=-3AeWbHFiFoMoXCkgsNg@mail.gmail.com>
References: <20190801081133.13200-1-danieltimlee@gmail.com>
        <20190801081133.13200-2-danieltimlee@gmail.com>
        <20190801163638.71700f6d@cakuba.netronome.com>
        <CAEKGpzhsjMuf+DtN3pDVYMxJa5o2e=-3AeWbHFiFoMoXCkgsNg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Aug 2019 14:02:29 +0900, Daniel T. Lee wrote:
> On Fri, Aug 2, 2019 at 8:36 AM Jakub Kicinski  wrote:
> > On Thu,  1 Aug 2019 17:11:32 +0900, Daniel T. Lee wrote: =20
> > > By this commit, using `bpftool net attach`, user can attach XDP prog =
on
> > > interface. New type of enum 'net_attach_type' has been made, as state=
d at
> > > cover-letter, the meaning of 'attach' is, prog will be attached on in=
terface.
> > >
> > > BPF prog will be attached through libbpf 'bpf_set_link_xdp_fd'.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> > > Changes in v2:
> > >   - command 'load' changed to 'attach' for the consistency
> > >   - 'NET_ATTACH_TYPE_XDP_DRIVE' changed to 'NET_ATTACH_TYPE_XDP_DRIVE=
R'
> > >
> > >  tools/bpf/bpftool/net.c | 107 ++++++++++++++++++++++++++++++++++++++=
+-
> > >  1 file changed, 106 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > > index 67e99c56bc88..f3b57660b303 100644
> > > --- a/tools/bpf/bpftool/net.c
> > > +++ b/tools/bpf/bpftool/net.c
> > > @@ -55,6 +55,35 @@ struct bpf_attach_info {
> > >       __u32 flow_dissector_id;
> > >  };
> > >
> > > +enum net_attach_type {
> > > +     NET_ATTACH_TYPE_XDP,
> > > +     NET_ATTACH_TYPE_XDP_GENERIC,
> > > +     NET_ATTACH_TYPE_XDP_DRIVER,
> > > +     NET_ATTACH_TYPE_XDP_OFFLOAD,
> > > +     __MAX_NET_ATTACH_TYPE
> > > +};
> > > +
> > > +static const char * const attach_type_strings[] =3D {
> > > +     [NET_ATTACH_TYPE_XDP] =3D "xdp",
> > > +     [NET_ATTACH_TYPE_XDP_GENERIC] =3D "xdpgeneric",
> > > +     [NET_ATTACH_TYPE_XDP_DRIVER] =3D "xdpdrv",
> > > +     [NET_ATTACH_TYPE_XDP_OFFLOAD] =3D "xdpoffload",
> > > +     [__MAX_NET_ATTACH_TYPE] =3D NULL, =20
> >
> > Not sure if the terminator is necessary,
> > ARRAY_SIZE(attach_type_strings) should suffice? =20
>=20
> Yes, ARRAY_SIZE is fine though. But I was just trying to make below
> 'parse_attach_type' consistent with 'parse_attach_type' from the 'prog.c'.
> At 'prog.c', It has same terminator at 'attach_type_strings'.
>=20
> Should I change it or keep it?

Oh well, I guess there is some precedent for that :S

Quick grep for const char * const reveals we have around 7 non-NULL
terminated arrays, and 2 NULL terminated. Plus the NULL-terminated
don't align the '=3D' sign, while most do.

it's not a big deal, my preference is for not NULL terminating here,
and aligning '=3D'.

> > > +     NEXT_ARG();
> > > +     if (!REQ_ARGS(1))
> > > +             return -EINVAL; =20
> >
> > Error message needed here.
> > =20
>=20
> Actually it provides error message like:
> Error: 'xdp' needs at least 1 arguments, 0 found
>=20
> are you suggesting that any additional error message is necessary?

Ah, sorry, I missed REQ_ARGS() there!

> > > +             return -EINVAL;
> > > +     } =20
> >
> > Please require the dev keyword before the interface name.
> > That'll make it feel closer to prog load syntax. =20
>=20
> If adding the dev keyword before interface name, will it be too long to t=
ype in?

I think it's probably muscle memory for most. Plus we have excellent
bash completions.

> and also `bpftool prog` use extra keyword (such as dev) when it is
> optional keyword.
>=20
>        bpftool prog dump jited  PROG [{ file FILE | opcodes | linum }]
>        bpftool prog pin   PROG FILE
>        bpftool prog { load | loadall } OBJ  PATH \
>=20
> as you can see here, FILE uses optional keyword 'file' when the
> argument is optional.

Not sure I follow =F0=9F=A4=94

>        bpftool prog { load | loadall } OBJ  PATH \
>                          [type TYPE] [dev NAME] \
>                          [map { idx IDX | name NAME } MAP]\
>                          [pinmaps MAP_DIR]
>=20
> Yes, bpftool prog load has dev keyword with it,
>=20
> but first, like previous, the argument is optional so i think it is
> unnecessary to use optional keyword 'dev'.

The keyword should not be optional if device name is specified.
Maybe lack of coffee on my side..

> and secondly, 'bpftool net attach' isn't really related to 'bpftool prog =
load'.
>
> At previous version patch, I was using word 'load' instead of
> 'attach', since XDP program is not
> considered as 'BPF_PROG_ATTACH', so it might give a confusion. However
> by the last patch discussion,
> word 'load' has been replaced to 'attach'.
>=20
> Keeping the consistency is very important, but I was just wandering
> about making command
> similar to 'bpftool prog load' syntax.

In case of TC the device argument is optional. You may specify it, or
you can refer to TC blocks instead. So for that reason alone I think
it'll be much cleaner to require dev before the interface name.

> > > +     return 0;
> > > +}
> > > +
> > > +static int do_attach_detach_xdp(int *progfd, enum net_attach_type *a=
ttach_type,
> > > +                             int *ifindex)
> > > +{
> > > +     __u32 flags;
> > > +     int err;
> > > +
> > > +     flags =3D XDP_FLAGS_UPDATE_IF_NOEXIST; =20
> >
> > Please add this as an option so that user can decide whether overwrite
> > is allowed or not. =20
>=20
> Adding force flag to bpftool seems necessary.
> I will add an optional argument for this.

Right, I was wondering if we want to call it force, though? force is
sort of a reuse of iproute2 concept. But it's kind of hard to come up
with names.

Just to be sure - I mean something like:

bpftool net attach xdp id xyz dev ethN noreplace

Rather than:

bpftool -f net attach xdp id xyz dev ethN

> > > +     if (*attach_type =3D=3D NET_ATTACH_TYPE_XDP_GENERIC)
> > > +             flags |=3D XDP_FLAGS_SKB_MODE;
> > > +     if (*attach_type =3D=3D NET_ATTACH_TYPE_XDP_DRIVER)
> > > +             flags |=3D XDP_FLAGS_DRV_MODE;
> > > +     if (*attach_type =3D=3D NET_ATTACH_TYPE_XDP_OFFLOAD)
> > > +             flags |=3D XDP_FLAGS_HW_MODE;
> > > +
> > > +     err =3D bpf_set_link_xdp_fd(*ifindex, *progfd, flags);
> > > +
> > > +     return err; =20
> >
> > no need for the err variable here. =20
>=20
> My apologies, but I'm not sure why err variable isn't needed at here.
> AFAIK, 'bpf_set_link_xdp_fd' from libbpf returns the netlink_recv result,
> and in order to propagate error, err variable is necessary, I guess?

	return bpf_set_link_xdp_fd(*ifindex, *progfd, flags);

Is what I meant.

> > > +}
> > > +
> > > +static int do_attach(int argc, char **argv)
> > > +{
> > > +     enum net_attach_type attach_type;
> > > +     int err, progfd, ifindex;
> > > +
> > > +     err =3D parse_attach_args(argc, argv, &progfd, &attach_type, &i=
findex);
> > > +     if (err)
> > > +             return err; =20
> >
> > Probably not the best idea to move this out into a helper. =20
>=20
> Again, just trying to make consistent with 'prog.c'.
>=20
> But clearly it has differences with do_attach/detach from 'prog.c'.
> From it, it uses the same parse logic 'parse_attach_detach_args' since
> the two command 'bpftool prog attach/detach' uses the same argument forma=
t.
>=20
> However, in here, 'bpftool net' attach and detach requires different numb=
er of
> argument, so function for parse argument has been defined separately.
> The situation is little bit different, but keeping argument parse logic a=
s an
> helper, I think it's better in terms of consistency.

Well they won't share the same arguments if you add the keyword for
controlling IF_NOEXIST :(

> About the moving parse logic to a helper, I was trying to keep command
> entry (do_attach)
> as simple as possible. Parse all the argument in command entry will
> make function longer
> and might make harder to understand what it does.
>=20
> And I'm not pretty sure that argument parse logic will stays the same
> after other attachment
> type comes in. What I mean is, the argument count or type might be
> added and to fulfill
> all that specific cases, the code might grow larger.
>=20
> So for the consistency, simplicity and extensibility, I prefer to keep
> it as a helper.
>=20
> > > +     if (is_prefix("xdp", attach_type_strings[attach_type]))
> > > +             err =3D do_attach_detach_xdp(&progfd, &attach_type, &if=
index); =20
> >
> > Hm. We either need an error to be reported if it's not xdp or since we
> > only accept XDP now perhaps the if() is superfluous? =20
>=20
> Well, if the attach_type isn't xdp, the error will be occurred from
> the argument parse,
> Will it be necessary to reinforce with error logic to make it more secure?

Hm. it should already be fine, no? For non-xdp parse_attach_type() will
return __MAX_NET_ATTACH_TYPE, then parsing returns EINVAL and we exit.
Not sure I follow.
