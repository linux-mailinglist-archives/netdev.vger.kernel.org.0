Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F84571767
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiGLKdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGLKdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:33:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E875AD86E;
        Tue, 12 Jul 2022 03:33:12 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w185so7127545pfb.4;
        Tue, 12 Jul 2022 03:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aO8MXDqI1flCF+r/zqqcEovuCz4Cs9WHj03DFcw76/I=;
        b=Bqu5TROC0ydUHRsU5mSBn+p5IBF75vmKHTtRBUnAIfCq+OCHhUzW/CYI00qfJ6K5NZ
         BK1FSFaFgeCmKX1o5i1w5MMIFDbl7VlNt6UMXy2BwbKxs9DugP/IDgtG+tKGDvtoxQEq
         mD0pQsZlMFrMd/F1/NW1dRTLRk0qxuuXd33xoBWx2kUKWmvHYJoUC6Wp2YXLWBLSRTvT
         lPZNhkodYndRJLmOrceSJQiIqhoDiswoICzLzV3i7Pavo2ItKykomXEBXRiJl/bgVg7E
         q1wRg53wkjvqqyz2LVrZxNDaOeuHD8PrQPNQe1gVHetdetbJSfdrylCnQQl+8ohlvrRu
         lzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aO8MXDqI1flCF+r/zqqcEovuCz4Cs9WHj03DFcw76/I=;
        b=CRlS4EJ/uEJNlv0nCuSUk0ZS/QBHIKcWaOZKr4WFPBaoNngI7Z9u87rgj4RTCilmSy
         mqrAwFSZVkGaT5+m2vIixXuSY31NqtqxJ5Qk44V8Cnz4893kI69n1TuRCIKFirLMKyzS
         r5dtcNhqNVP/R22AAcOeEpI20r2X6q+JxvlLASehP0DZ13MNxMI+dwjTiPbzDU6zQaNY
         Np28Ex6TPV3CqJfEbuU/lRLtxpomwizfSwVXy902SDE7OdcMyW/0UGyCRTpBeQPqxthX
         UeEeJbbsAZL8D9rbleFL6FaqVaYmMFESBtN01LpGnDyMA4mbjz+cTnUge3Uh3hTdLtSb
         dhOQ==
X-Gm-Message-State: AJIora+vWnASfPRvgTh58eavFbV8GhVXLCbxvSZVuS+nQTr2r8JvpdzL
        xTHjClvGDfVo/pY8VDlK/FMm6/yG5Y6meL+zzIc=
X-Google-Smtp-Source: AGRyM1tmac8rb4MYGko3hfY9js/lcnrsM4VpkvV4+nO+v7mxhG8eNeCx0a2uJNqV+HP3WK7RWDTG7L03Q6SEToSU2oI=
X-Received: by 2002:a63:5a49:0:b0:40d:e7a0:3cb with SMTP id
 k9-20020a635a49000000b0040de7a003cbmr19628872pgm.69.1657621991623; Tue, 12
 Jul 2022 03:33:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <87iloja8ly.fsf@toke.dk>
 <20220704154440.7567-1-alexandr.lobakin@intel.com> <87a69o94wz.fsf@toke.dk>
 <20220705154120.22497-1-alexandr.lobakin@intel.com> <87pmij75r1.fsf@toke.dk>
 <20220706135023.1464979-1-alexandr.lobakin@intel.com> <87edyxaks0.fsf@toke.dk>
In-Reply-To: <87edyxaks0.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 12 Jul 2022 12:33:00 +0200
Message-ID: <CAJ8uoz1XVqVCpkKo18qbkh6jq_Lejk24OwEWCB9cWhokYLEBDQ@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 1:25 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
>
> > From: Toke H??iland-J??rgensen <toke@redhat.com>
> > Date: Tue, 05 Jul 2022 20:51:14 +0200
> >
> >> Alexander Lobakin <alexandr.lobakin@intel.com> writes:
> >>
> >> [... snipping a bit of context here ...]
> >>
> >> >> >> Yeah, I'd agree this kind of configuration is something that can=
 be
> >> >> >> added later, and also it's sort of orthogonal to the consumption=
 of the
> >> >> >> metadata itself.
> >> >> >>
> >> >> >> Also, tying this configuration into the loading of an XDP progra=
m is a
> >> >> >> terrible interface: these are hardware configuration options, le=
t's just
> >> >> >> put them into ethtool or 'ip link' like any other piece of devic=
e
> >> >> >> configuration.
> >> >> >
> >> >> > I don't believe it fits there, especially Ethtool. Ethtool is for
> >> >> > hardware configuration, XDP/AF_XDP is 95% software stuff (apart f=
rom
> >> >> > offload bits which is purely NFP's for now).
> >> >>
> >> >> But XDP-hints is about consuming hardware features. When you're
> >> >> configuring which metadata items you want, you're saying "please pr=
ovide
> >> >> me with these (hardware) features". So ethtool is an excellent plac=
e to
> >> >> do that :)
> >> >
> >> > With Ethtool you configure the hardware, e.g. it won't strip VLAN
> >> > tags if you disable rx-cvlan-stripping. With configuring metadata
> >> > you only tell what you want to see there, don't you?
> >>
> >> Ah, I think we may be getting closer to identifying the disconnect
> >> between our way of thinking about this!
> >>
> >> In my mind, there's no separate "configuration of the metadata" step.
> >> You simply tell the hardware what features you want (say, "enable
> >> timestamps and VLAN offload"), and the driver will then provide the
> >> information related to these features in the metadata area
> >> unconditionally. All XDP hints is about, then, is a way for the driver
> >> to inform the rest of the system how that information is actually laid
> >> out in the metadata area.
> >>
> >> Having a separate configuration knob to tell the driver "please lay ou=
t
> >> these particular bits of metadata this way" seems like a totally
> >> unnecessary (and quite complicated) feature to have when we can just l=
et
> >> the driver decide and use CO-RE to consume it?
> >
> > Magnus (he's currently on vacation) told me it would be useful for
> > AF_XDP to enable/disable particular metadata, at least from perf
> > perspective. Let's say, just fetching of one "checksum ok" bit in
> > the driver is faster than walking through all the descriptor words
> > and driver logics (i.e. there's several hundred locs in ice which
> > just parse descriptor data and build an skb or metadata from it).
> > But if we would just enable/disable corresponding features through
> > Ethtool, that would hurt XDP_PASS. Maybe it's a bad example, but
> > what if I want to have only RSS hash in the metadata (and don't
> > want to spend cycles on parsing the rest), but at the same time
> > still want skb path to have checksum status to not die at CPU
> > checksum calculation?
>
> Hmm, so this feels a little like a driver-specific optimisation? I.e.,
> my guess is that not all drivers have a measurable overhead for pulling
> out the metadata. Also, once the XDP metadata bits are in place, we can
> move in the direction of building SKBs from the same source, so I'm not
> sure it's a good idea to assume that the XDP metadata is separate from
> what the stack consumes...
>
> In any case, if such an optimisation does turn out to be useful, we can
> add it later (backed by rigorous benchmarks, of course), so I think we
> can still start with the simple case and iterate from there?

Just to check if my intuition was correct or not I ran some benchmarks
around this. I ported Jesper's patch set to the zero-copy driver of
i40e, which was really simple thanks to Jesper's refactoring. One line
of code added to the data path of the zc driver and making
i40e_process_xdp_hints() a global function so it can be reached from
the zc driver. I also moved the prefetch Jesper added to after the
check if xdp_hints are available since it really degrades performance
in the xdp_hints off case.

First number is the throughput change with hints on, and the second
number is with hints off. All are compared to the performance without
Jesper's patch set applied. The application is xdpsock -r (which used
to be part of the samples/bpf directory).

Copy mode with all hints: -21% / -2%
Zero-copy mode with all hints: -29% / -9%

Copy mode rx timestamp only (the rest removed with an #if 0): -11%
Zero-copy mode rx timestamp only: -20%

So, if you only want rx timestamp, but can only enable every hint or
nothing, then you get a 10% performance degradation with copy mode and
9% with zero-copy mode compared to if you were able just to enable rx
timestamp alone. With these rough numbers (a real implementation would
not have an #if 0) I would say it matters, but that does not mean we
should not start simple and just have a big switch to start with. But
as we add hints (to the same btfid), this will just get worse.

Here are some other numbers I got, in case someone is interested. They
are XDP numbers from xdp_rxq_info in samples/bpf.

hints on / hints off
XDP_DROP: -18% / -1.5%
XDP_TX: -10% / -2.5%

> >> >> > I follow that way:
> >> >> >
> >> >> > 1) you pick a program you want to attach;
> >> >> > 2) usually they are written for special needs and usecases;
> >> >> > 3) so most likely that program will be tied with metadata/driver/=
etc
> >> >> >    in some way;
> >> >> > 4) so you want to enable Hints of a particular format primarily f=
or
> >> >> >    this program and usecase, same with threshold and everything
> >> >> >    else.
> >> >> >
> >> >> > Pls explain how you see it, I might be wrong for sure.
> >> >>
> >> >> As above: XDP hints is about giving XDP programs (and AF_XDP consum=
ers)
> >> >> access to metadata that is not currently available. Tying the lifet=
ime
> >> >> of that hardware configuration (i.e., which information to provide)=
 to
> >> >> the lifetime of an XDP program is not a good interface: for one thi=
ng,
> >> >> how will it handle multiple programs? What about when XDP is not us=
ed at
> >> >
> >> > Multiple progs is stuff I didn't cover, but will do later (as you
> >> > all say to me, "let's start with something simple" :)). Aaaand
> >> > multiple XDP progs (I'm not talking about attaching progs in
> >> > differeng modes) is not a kernel feature, rather a libpf feature,
> >> > so I believe it should be handled there later...
> >>
> >> Right, but even if we don't *implement* it straight away we still need
> >> to take it into consideration in the design. And expecting libxdp to
> >> arbitrate between different XDP programs' metadata formats sounds like=
 a
> >> royal PITA :)
> >>
> >> >> all but you still want to configure the same features?
> >> >
> >> > What's the point of configuring metadata when there are no progs
> >> > attached? To configure it once and not on every prog attach? I'm
> >> > not saying I don't like it, just want to clarify.
> >>
> >> See above: you turn on the features because you want the stack to
> >> consume them.
> >>
> >> > Maybe I need opinions from some more people, just to have an
> >> > overview of how most of folks see it and would like to configure
> >> > it. 'Cause I heard from at least one of the consumers that
> >> > libpf API is a perfect place for Hints to him :)
> >>
> >> Well, as a program author who wants to consume hints, you'd use
> >> lib{bpf,xdp} APIs to do so (probably in the form of suitable CO-RE
> >> macros)...
> >>
> >> >> In addition, in every other case where we do dynamic data access (w=
ith
> >> >> CO-RE) the BPF program is a consumer that modifies itself to access=
 the
> >> >> data provided by the kernel. I get that this is harder to achieve f=
or
> >> >> AF_XDP, but then let's solve that instead of making a totally
> >> >> inconsistent interface for XDP.
> >> >
> >> > I also see CO-RE more fitting and convenient way to use them, but
> >> > didn't manage to solve two things:
> >> >
> >> > 1) AF_XDP programs, so what to do with them? Prepare patches for
> >> >    LLVM to make it able to do CO-RE on AF_XDP program load? Or
> >> >    just hardcode them for particular usecases and NICs? What about
> >> >    "general-purpose" programs?
> >>
> >> You provide a library to read the fields. Jesper actually already
> >> implemented this, did you look at his code?
> >>
> >> https://github.com/xdp-project/bpf-examples/tree/master/AF_XDP-interac=
tion
> >>
> >> It basically builds a lookup table at load-time using BTF information
> >> from the kernel, keyed on BTF ID and field name, resolving them into
> >> offsets. It's not quite the zero-overhead of CO-RE, but it's fairly
> >> close and can be improved upon (CO-RE for userspace being one way of
> >> doing that).
> >
> > Aaaah, sorry, I completely missed that. I thought of something
> > similar as well, but then thought "variable field offsets, that
> > would annihilate optimization and performance", and our Xsk team
> > is super concerned about performance hits when using Hints.
> >
> >>
> >> >    And if hardcode, what's the point then to do Generic Hints at
> >> >    all? Then all it needs is making driver building some meta in
> >> >    front of frames via on-off button and that's it? Why BTF ID in
> >> >    the meta then if consumers will access meta hardcoded (via CO-RE
> >> >    or literally hardcoded, doesn't matter)?
> >>
> >> You're quite right, we could probably implement all the access to
> >> existing (fixed) metadata without using any BTF at all - just define a
> >> common struct and some flags to designate which fields are set. In my
> >> mind, there are a couple of reasons for going the BTF route instead:
> >>
> >> - We can leverage CO-RE to get close to optimal efficiency in field
> >>   access.
> >>
> >> and, more importantly:
> >>
> >> - It's infinitely extensible. With the infrastructure in place to make
> >>   it really easy to consume metadata described by BTF, we lower the ba=
r
> >>   for future innovation in hardware offloads. Both for just adding new
> >>   fixed-function stuff to hardware, but especially for fully
> >>   programmable hardware.
> >
> > Agree :) That libxdp lookup translator fixed lots of stuff in my
> > mind.
>
> Great! Looks like we're slowly converging towards a shared
> understanding, then! :)
>
> >> > 2) In-kernel metadata consumers? Also do CO-RE? Otherwise, with no
> >> >    generic metadata structure they won't be able to benefit from
> >> >    Hints. But I guess we still need to provide kernel with meta?
> >> >    Or no?
> >>
> >> In the short term, I think the "generic structure" approach is fine fo=
r
> >> leveraging this in the stack. Both your and Jesper's series include
> >> this, and I think that's totally fine. Longer term, if it turns out to
> >> be useful to have something more dynamic for the stack consumption as
> >> well, we could extend it to be CO-RE based as well (most likely by
> >> having the stack load a "translator" BPF program or something along
> >> those lines).
> >
> > Oh, that translator prog sounds nice BTW!
>
> Yeah, it's only a rough idea Jesper and I discussed at some point, but I
> think it could have potential (see also point above re: making XDP hints
> *the* source of metadata for the whole stack; wouldn't it be nice if
> drivers didn't have to deal with the intricacies of assembling SKBs?).
>
> -Toke
>
