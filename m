Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0D9948CBBB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356594AbiALTRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344247AbiALTRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 14:17:09 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389CFC06173F;
        Wed, 12 Jan 2022 11:17:09 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i6so5653858pla.0;
        Wed, 12 Jan 2022 11:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mq5NPm6S7NqcUF5CrIvIYfcx+ESfElA0nRRkS7FISzE=;
        b=YyqZ+0Qfe8TCePqG9z1PvpQNXBaVMDbhjylILc7g1IcGoQ2rwTGh38XkVJpPG3gZU+
         M4h0aJt3oYOe1D6MUxvnAntSyLzQhbY3DQCKwb5kqMUJstlAQOyA1Nudb0vgq3nwTXnN
         hdiIbvBX6UNs2TsNy+I45+38I0y8ir5DG/l5fLyJ7ifxv3cGW6KeVwUUtQFPy70haDlS
         Zwza2vztlK2+wDVyKl6hDT4eT4faiwMcG4lS5QInaM9Ni150pJjxojIvZvh+Yg6zE1FB
         QWxfSsmBYDYXijsgY4jM6/4ER/YZIHOtn1U2jvgaL633mlWE6GUnC1v7UCqaPC8KGUO0
         BtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mq5NPm6S7NqcUF5CrIvIYfcx+ESfElA0nRRkS7FISzE=;
        b=HDf/boS2vMKrplI9w7ZdQ+VUxCNeFPRrby24vTMlToZnAm8YfJ1QZRELLl/MYKTekB
         KoAMfIVwG1i59kqkBtiXVQGazHdbkJYyN9xm2R2LSEB5xKTgBxro/6wx5x2j/3wIh9Le
         pp9Ip1UsXoSooB/+hK0sja+P56wG7Sa/5rzbN0Xt7xJX1eFfuU4Kdbu5TTRxr5Za+Kkq
         EZPin6tJy34YxDbnTfVWkxpQu+daDYTDnS+5Mze57/KAiHq8mKXXV3NBbZIodfRmvDIN
         WJeVzG067Av7FLYPrfRx/Lzwg1DXiznMr19hW7UvkCwV3lEwOemV1OEhU7pVdcqE3vEB
         EAMQ==
X-Gm-Message-State: AOAM533Blt39stE5OsJ5rCcus3arpn9xYeN56N5zMGTZxUIwbRox2Vlu
        +m3xlBFMk7ohaC0hnny3chMToN9hjZgJhSdkbeWfvY+8
X-Google-Smtp-Source: ABdhPJz3r/foRSic7o2V33P/3zvPkUe8g8sD/+BXXK6WelMO6XSHU/mtLFGjwnJKMKDxwt61uqub+PkZV0Tbccyrg+Q=
X-Received: by 2002:a17:90b:34f:: with SMTP id fh15mr10451680pjb.122.1642015028697;
 Wed, 12 Jan 2022 11:17:08 -0800 (PST)
MIME-Version: 1.0
References: <cover.1641641663.git.lorenzo@kernel.org> <f9103d787144983524ba331273718e422a63a767.1641641663.git.lorenzo@kernel.org>
 <CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com>
 <Yd8bVIcA18KIH6+I@lore-desk> <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
In-Reply-To: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jan 2022 11:16:57 -0800
Message-ID: <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb programs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
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

On Wed, Jan 12, 2022 at 10:24 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jan 12, 2022 at 10:18 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > > On Sun, Jan 9, 2022 at 7:05 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
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
> >         SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> >         SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> >         SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > +       SEC_DEF("xdp_devmap.multibuf",  XDP, BPF_XDP_DEVMAP, 0),
> >         SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > +       SEC_DEF("xdp_cpumap.multibuf",  XDP, BPF_XDP_CPUMAP, 0),
> >         SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > +       SEC_DEF("xdp.multibuf",         XDP, BPF_XDP, 0),
>
> yep, but please use SEC_NONE instead of zero
>
> >         SEC_DEF("xdp",                  XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
> >         SEC_DEF("perf_event",           PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
> >         SEC_DEF("lwt_in",               LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
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
> > > >         SEC_SLEEPABLE = 8,
> > > >         /* allow non-strict prefix matching */
> > > >         SEC_SLOPPY_PFX = 16,
> > > > +       /* BPF program support XDP multi-buff */
> > > > +       SEC_XDP_MB = 32,
> > > >  };
> > > >
> > > >  struct bpf_sec_def {
> > > > @@ -6562,6 +6564,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > > >         if (def & SEC_SLEEPABLE)
> > > >                 opts->prog_flags |= BPF_F_SLEEPABLE;
> > > >
> > > > +       if (prog->type == BPF_PROG_TYPE_XDP && (def & SEC_XDP_MB))
> > > > +               opts->prog_flags |= BPF_F_XDP_MB;
> > >
> > > I'd say you don't even need SEC_XDP_MB flag at all, you can just check
> > > that prog->sec_name is one of "xdp.mb", "xdp_devmap.mb" or
> > > "xdp_cpumap.mb" and add the flag. SEC_XDP_MB doesn't seem generic
> > > enough to warrant a flag.
> >
> > ack, something like:
> >
> > +       if (prog->type == BPF_PROG_TYPE_XDP &&
> > +           (!strcmp(prog->sec_name, "xdp_devmap.multibuf") ||
> > +            !strcmp(prog->sec_name, "xdp_cpumap.multibuf") ||
> > +            !strcmp(prog->sec_name, "xdp.multibuf")))
> > +               opts->prog_flags |= BPF_F_XDP_MB;
>
> yep, can also simplify it a bit with strstr(prog->sec_name,
> ".multibuf") instead of three strcmp

Maybe ".mb" ?
".multibuf" is too verbose.
We're fine with ".s" for sleepable :)
