Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D51351C5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfFDVWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:22:19 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:37812 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFDVWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:22:19 -0400
Received: by mail-qt1-f177.google.com with SMTP id y57so15622225qtk.4;
        Tue, 04 Jun 2019 14:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AED2jyah/dgR/czIjAFpE3UpTk+gK5gHIvSL+ozzoNw=;
        b=By3CrnN4bFkxTtMBRDDjEyjOYa6x1YKXjNdkajPZ6cL+lq0m5TBslUVwVKV5NVYc0/
         BupxWU1r8lXR7oUtY68XTKsA6GsSLyXZCtd8nrXoFVoy/9tRA7bVBUalOXv6V+W0pgI5
         AsCzNYLHM6s/aU+UxMRNVhIfaYm8ySuOF6gzYSLgEPK/ig6o0kjDhOH3yr6XBjjIIKZi
         k6MiFWNbPUJsmLNf+cgAruxY4J+ysMDMQr6g1RtPFOeISU4R/00TxUZbLyLd+sL7v2Nb
         n8fvt/8oMVT7w6iIIMMhCZ/n32+DoDu/Y4TZDDcCbeVZ6W3UiXopR0naO3mHf8XCYS+E
         Ozsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AED2jyah/dgR/czIjAFpE3UpTk+gK5gHIvSL+ozzoNw=;
        b=B9f24vy006P4EZf+3Hvwh+fuKfBFpOKSzYDn4lTJhki9KfQJI+Fap/lhTlMjSdmpMK
         yiLnTui1uQaLs67dNEBdI0/ifyKZKqE6UNk8E5PlyxRJhfSdplMJPm/9WAJsQJn11WuD
         b9MNPJ5Ew0ZYaYECsJVwJxiP7c/cVh/Arf9X5J8HLOUyl5p80CXsDrt4Zlc/VL+coAQ0
         FYUSLJb7uly2D3n55NWP1gCR5SB8znCaD1t/kn+lHhvgnwyl3S4/2/uyDcdH9hKMPpjX
         7SDjcthDMKL0jmaZ9+oWiCtskBtvM4fUYZ4fg9+2n1XgI4RFSzlOBj+LDU541BOqmOSP
         WbRQ==
X-Gm-Message-State: APjAAAVfLy/n/zbijCrY5kff55B85dcJ6rDOufGFxL38+/tm34Z/1qic
        qMp6pT2jR683OF8QjGY6btBDR+30ls82HtQfew4=
X-Google-Smtp-Source: APXvYqxTtwFFDXWFiWSo2jvCXTYrNW8a7N5At3K2d0GtN0oHmo8Rd/Golgbvk8XfkULlkOl0D0P/Myf8cRIekEv2DuI=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr9724690qta.93.1559683337406;
 Tue, 04 Jun 2019 14:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190531202132.379386-7-andriin@fb.com> <20190531212835.GA31612@mini-arch>
 <CAEf4Bza38VEh9NWTLEReAR_J0eqjsvH1a2T-0AeWqDZpE8YPfA@mail.gmail.com>
 <20190603163222.GA14556@mini-arch> <CAEf4BzbRXAZMXY3kG9HuRC93j5XhyA3EbWxkLrrZsG7K4abdBg@mail.gmail.com>
 <20190604010254.GB14556@mini-arch> <f2b5120c-fae7-bf72-238a-b76257b0c0e4@fb.com>
 <20190604042902.GA2014@mini-arch> <20190604134538.GB2014@mini-arch>
 <CAEf4BzZEqmnwL0MvEkM7iH3qKJ+TF7=yCKJRAAb34m4+B-1Zcg@mail.gmail.com> <20190604210710.GA17053@mini-arch>
In-Reply-To: <20190604210710.GA17053@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 Jun 2019 14:22:06 -0700
Message-ID: <CAEf4Bzb7EnfRHHq+rfcQJ7Wg7kmko_T3t6O12OuWb1mkAkRJaQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 6/8] libbpf: allow specifying map definitions
 using BTF
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 4, 2019 at 2:07 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/04, Andrii Nakryiko wrote:
> > On Tue, Jun 4, 2019 at 6:45 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 06/03, Stanislav Fomichev wrote:
> > > > > BTF is mandatory for _any_ new feature.
> > > > If something is easy to support without asking everyone to upgrade to
> > > > a bleeding edge llvm, why not do it?
> > > > So much for backwards compatibility and flexibility.
> > > >
> > > > > It's for introspection and debuggability in the first place.
> > > > > Good debugging is not optional.
> > > > Once llvm 8+ is everywhere, sure, but we are not there yet (I'm talking
> > > > about upstream LTS distros like ubuntu/redhat).
> > > But putting this aside, one thing that I didn't see addressed in the
> > > cover letter is: what is the main motivation for the series?
> > > Is it to support iproute2 map definitions (so cilium can switch to libbpf)?
> >
> > In general, the motivation is to arrive at a way to support
> > declaratively defining maps in such a way, that:
> > - captures type information (for debuggability/introspection) in
> > coherent and hard-to-screw-up way;
> > - allows to support missing useful features w/ good syntax (e.g.,
> > natural map-in-map case vs current completely manual non-declarative
> > way for libbpf);
>
> [..]
> > - ultimately allow iproute2 to use libbpf as unified loader (and thus
> > the need to support its existing features, like
> > BPF_MAP_TYPE_PROG_ARRAY initialization, pinning, map-in-map);
> So prog_array tail call info would be encoded in the magic struct instead of
> a __section_tail(whatever) macros that iproute2 is using? Does it

Yes. It will be C-style array initialization (where value is address
of a function, corresponding to a BPF program).

> mean that the programs that target iproute2 would have to be rewritten?
> Or we don't have a goal to provide source-level compatibility?

As outlined in separate email I sent out yesterday, my goal was making
sure we have very easy transition path not changing the semantics
(field renaming for common case, functionally-equivalent, but
different syntax for tail call prog array initialization, etc). Let's
see what folks working on Cilium think about this.


>
> In general, supporting iproute2 seems like the most compelling
> reason to use BTF given current state of llvm+btf adoption.
> BPF_ANNOTATE_KV_PAIR and map-in-map syntax while ugly, is not the major
> paint point (imho); but I agree, with BTF both of those things
> look much better.
>
> That's why I was trying to understand whether we can start with using
> BTF to support _existing_ iproute2 format and then, once it's working,
> generalize it (and kill bpf_map_def or make it a subset of generic BTF).
> That way we are not implementing another way to support pinning/tail
> calls, but enabling iproute2 to use libbpf.

We currently don't have a good way (except for programmatic API) to do
either tail call or map-in-map declaratively in libbpf, so the hope is
this approach will allow us to address that lack, and preferrably in a
bit more intuitive way, than iproute2 support today. Given it's simple
to convert iproute2 approach to BTF-based one, I'd vote for not
back-porting that logic into libbpf, if possible.

>
> But feel free to ignore all my nonsense above; I don't really have any
> major concerns with the new generic format rather than discoverability
> (the docs might help) and a mandate that everyone switches to it immediately.

No, thanks for feedback! For documentation, I think we might want to
add description to https://docs.cilium.io/en/v1.4/bpf/ (though
timing-wise it would be better to do after iproute2 starts using
libbpf, so a bit of a chicken-and-egg problem). If you have better
suggestions where to put it, let me know.

>
> > The only missing feature that can be supported reasonably with
> > bpf_map_def is pinning (as it's just another int field), but all the
> > other use cases requires awkward approach of matching arbitrary IDs,
> > which feels like a bad way forward.
> >
> >
> > > If that's the case, maybe explicitly focus on that? Once we have
> > > proof-of-concept working for iproute2 mode, we can extend it to everything.
