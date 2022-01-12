Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229A748CAE9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356183AbiALSYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356166AbiALSYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:24:17 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F93CC061748;
        Wed, 12 Jan 2022 10:24:17 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id v1so4865711ioj.10;
        Wed, 12 Jan 2022 10:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xFSrcJFcLbWaS9g4H0h+8wluxp6gHrT+Bua0ZmBYWB4=;
        b=JsoeVbxRRL7KvvWrpKt0xE6a8sjb9BJ1HefDkriX/BmSB/UDj7NQNsMxZf1ePDBUm7
         M6HZPmY3TFrXtOTnarffUqk1aIDtb5fWtoNxMU+TTM+d83hGoVGl07Cf++g4OlFrZq+4
         Z0x4ctbQYXjP2F3yCTW2lIGj881zStumUUdwfcvHJ1IWilkUiu//L0k11HDHh5Lkg24m
         DIpRpJc4KqCzmmn1+HLJYbCwOqFj9BLCB/5mv7p2dufyFm5A+Of4hNSafia5zjwbcF4/
         LilFIIZ0bSSzRSPu04ZY3Y+whtX6OylASIAMpkM+DrJg8nvvRitI/R/bT3j66fXokE8H
         vDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xFSrcJFcLbWaS9g4H0h+8wluxp6gHrT+Bua0ZmBYWB4=;
        b=r0Po4roEksFnhmQnJ8vS4L1ky9tWw2+PhoeY2Cnkieg1oE3sAJi0suxD9zu8gZhP0s
         qJT/8FBkdCdSSz9RJipGMW5wzq9tr4LMI1EQIdKxlxWUcmXJ8PSch31FcRrcZF4WAnAA
         mtex3Ar+o4JJUj0dEIz2oQtS0DOE7Lx8knxrFBwBqI3AUlxcA2iwYbXG2Gq6fTtjuQ8A
         rQQ7lgBiCbkNhYM82AOqzduNytPhHLKRDsW5KtuaxgZzuDaObhSQrs5w39Dn96emV8Ig
         s0oHxT13otLs1E9sd1pbtzoBxzGVOemCWB29ol7ZY4w9yWufvr42LpjvApl0630o664X
         oUYA==
X-Gm-Message-State: AOAM533Vvz4CgrICFmzYXrai0e8rA6S9GlprW/e5XfPv1wfxGbyEZ5Sl
        lw8zdT+bSnFSL90ps7EmjLMt7x4M2yMvq8o3wbSSYzC9
X-Google-Smtp-Source: ABdhPJw1DB97XndZyC84WGpQVMtI+qMw+HdDizPsD/vZMVScBMeX7yvWc/LjNZQU2a9bXUrQwCdTyhD8yAJ4hEqobzw=
X-Received: by 2002:a05:6638:410a:: with SMTP id ay10mr496664jab.237.1642011856466;
 Wed, 12 Jan 2022 10:24:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com> <Yd8bVIcA18KIH6+I@lore-desk>
In-Reply-To: <Yd8bVIcA18KIH6+I@lore-desk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Jan 2022 10:24:05 -0800
Message-ID: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Lorenzo Bianconi <lorenzo@kernel.org>
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > Introduce support for the following SEC entries for XDP multi-buff
> > > property:
> > > - SEC("xdp_mb/")
> > > - SEC("xdp_devmap_mb/")
> > > - SEC("xdp_cpumap_mb/")
> >
> > Libbpf seemed to went with .<suffix> rule (e.g., fentry.s for
> > sleepable, seems like we'll have kprobe.multi or  something along
> > those lines as well), so let's stay consistent and call this "xdp_mb",
> > "xdp_devmap.mb", "xdp_cpumap.mb" (btw, is "mb" really all that
> > recognizable? would ".multibuf" be too verbose?). Also, why the "/"
> > part? Also it shouldn't be "sloppy" either. Neither expected attach
> > type should be optional.  Also not sure SEC_ATTACHABLE is needed. So
> > at most it should be SEC_XDP_MB, probably.
>
> ack, I fine with it. Something like:
>
>         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
>         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
>         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
>         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
>         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),

yep, but please use SEC_NONE instead of zero

>         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
>         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
>         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
>
> >
> > >
> > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > >
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index 7f10dd501a52..c93f6afef96c 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -235,6 +235,8 @@ enum sec_def_flags {
> > >         SEC_SLEEPABLE = 8,
> > >         /* allow non-strict prefix matching */
> > >         SEC_SLOPPY_PFX = 16,
> > > +       /* BPF program support XDP multi-buff */
> > > +       SEC_XDP_MB = 32,
> > >  };
> > >
> > >  struct bpf_sec_def {
> > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > >         if (def & SEC_SLEEPABLE)
> > >                 opts->prog_flags |= BPF_F_SLEEPABLE;
> > >
> > > +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> > > +               opts->prog_flags |= BPF_F_XDP_MB;
> >
> > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> > enough to warrant a flag.
>
> ack, something like:
>
> +       if (prog->type == BPF_PROG_TYPE_XDP &&
> +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> +            !strcmp(prog->sec_name, "xdp.multibuf")))
> +               opts->prog_flags |= BPF_F_XDP_MB;

yep, can also simplify it a bit with strstr(prog->sec_name,
".multibuf") instead of three strcmp

>
> Regards,
> Lorenzo
>
> >
> > > +
> > >         if ((prog->type == BPF_PROG_TYPE_TRACING ||
> > >              prog->type == BPF_PROG_TYPE_LSM ||
> > >              prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> > > @@ -8600,8 +8605,11 @@ static const struct bpf_sec_def section_defs[] = {
> > >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> > >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > +       SEC_DEF("xdp_devmap_mb/",       XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE | SEC_XDP_MB),
> > >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > > +       SEC_DEF("xdp_cpumap_mb/",       XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE | SEC_XDP_MB),
> > >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > > +       SEC_DEF("xdp_mb/",              XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
> > >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> > >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
> > > --
> > > 2.33.1
> > >
