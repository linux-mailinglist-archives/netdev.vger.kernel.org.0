Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E2856135F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 09:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbiF3Hj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 03:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiF3Hj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 03:39:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837933334B;
        Thu, 30 Jun 2022 00:39:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 73-20020a17090a0fcf00b001eaee69f600so1964159pjz.1;
        Thu, 30 Jun 2022 00:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EJyT7JUyVRG07CmRqYATiVRu3C+foKjVhjORnf17DTg=;
        b=nAIydJpbrF/sgjoGNHwlEc8GBxDR2mbzzZE5VC0MYNDzULkNTg7dQWQe4pT+og/Nyg
         JoKjIXRvF84wY76GPd/xf+wJbfuGQ7+Bqu2zXnoS3oVRqA8FWuL0q37okgqJNH7FAS2f
         P6e4zFf3Dyv38uauiAtRfNg5lNhRYOriX7tVD9ldH3ZUBaxL2qp9Wf+V9yTqFvlNk3vL
         07cnSiAvR/x8N5pdsl1jon4I812agpB4LRGzKhLuWkBBclkzmzn4xGLS1W/0Nf7GoJJI
         LJed4n1ZS3rOQkIuVFdt+5hWD5ba3YHksYekhQPeUJqNPS/DuSDGA7mLWI23yeXzdlpr
         y1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EJyT7JUyVRG07CmRqYATiVRu3C+foKjVhjORnf17DTg=;
        b=VpshHglLo21U2nmprjucxoGEXmcZg9VpeYP7YLMfdC51uQrrRzYYLNkSAH+Vmm6U4Z
         vyQP6bgncOgh3WQT5401qjEw0DWP53153Xe16lLR78DxEWMMNQZzh62+8jR8wG5dwfuK
         Gm+jrIjm8pm2UGlTtIS00JGPnQpfMQkLPsLT8Y1QFVLZ2GaodTgNnnQ27tvcT4kZcaY1
         J6h+4zjcuG3SRccI87CqgzoIvQGiBsCabFFsynqh9fvvLaEPncZ8MUHxgibnH5evvmJI
         O9CLbTZio5FcoD4e6/CZ69kbWUUw1X6/82LMz+kLxvbjZGcBpQAx0ArGvNyPUHLv5tZE
         ws4w==
X-Gm-Message-State: AJIora/Kh5wr/+HzhHq02wXcj1XcvQiKY2D0GwzK7mj5o1G/i7u0PGuS
        DgLBNScZUb0B/juEQ1KE8RCL6rGdpR1AUfGaPHWD8Wicc5d4x8Kt
X-Google-Smtp-Source: AGRyM1smXJkpDmv7tDg9/tNiZb3Gar6+RHRs2UJOn4upIpxO7Pv4yKxO3epjk+EAuYoL0WzJ0vTsMJrdkj9R0APY/EI=
X-Received: by 2002:a17:902:d701:b0:16a:2206:9ba8 with SMTP id
 w1-20020a170902d70100b0016a22069ba8mr13192207ply.168.1656574794826; Thu, 30
 Jun 2022 00:39:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
 <62bbedf07f44a_2181420830@john.notmuch> <CAC1LvL0kTesx8bpL3GWe2Q60uT2WthO5dHX7h7bd-UOGOne_Zg@mail.gmail.com>
In-Reply-To: <CAC1LvL0kTesx8bpL3GWe2Q60uT2WthO5dHX7h7bd-UOGOne_Zg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Jun 2022 09:39:43 +0200
Message-ID: <CAJ8uoz1UxxGYvjpYDaHM2o=DqOpGubsSL-G24c3Wt3eY7qvRTA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH RFC bpf-next 00/52] bpf, xdp: introduce
 and use Generic Hints/metadata
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
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
        Toke Hoiland-Jorgensen <toke@redhat.com>,
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 7:57 PM Zvi Effron <zeffron@riotgames.com> wrote:
>
> On Tue, Jun 28, 2022 at 11:15 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Alexander Lobakin wrote:
> > > This RFC is to give the whole picture. It will most likely be split
> > > onto several series, maybe even merge cycles. See the "table of
> > > contents" below.
> >
> > Even for RFC its a bit much. Probably improve the summary
> > message here as well I'm still not clear on the overall
> > architecture so not sure I want to dig into patches.
> >
> > >
> > > The series adds ability to pass different frame
> > > details/parameters/parameters used by most of NICs and the kernel
> > > stack (in skbs), not essential, but highly wanted, such as:
> > >
> > > * checksum value, status (Rx) or command (Tx);
> > > * hash value and type/level (Rx);
> > > * queue number (Rx);
> > > * timestamps;
> > > * and so on.
> > >
> > > As XDP structures used to represent frames are as small as possible
> > > and must stay like that, it is done by using the already existing
> > > concept of metadata, i.e. some space right before a frame where BPF
> > > programs can put arbitrary data.
> >
> > OK so you stick attributes in the metadata. You can do this without
> > touching anything but your driver today. Why not push a patch to
> > ice to start doing this? People could start using it today and put
> > it in some feature flag.
> >
> > I get everyone wants some grand theory around this but again one
> > patch would do it and your customers could start using it. Show
> > a benchmark with 20% speedup or whatever with small XDP prog
> > update and you win.
> >
> > >
> > > Now, a NIC driver, or even a SmartNIC itself, can put those params
> > > there in a well-defined format. The format is fixed, but can be of
> > > several different types represented by structures, which definitions
> > > are available to the kernel, BPF programs and the userland.
> >
> > I don't think in general the format needs to be fixed.
> >
> > > It is fixed due to it being almost a UAPI, and the exact format can
> > > be determined by reading the last 10 bytes of metadata. They contain
> > > a 2-byte magic ID to not confuse it with a non-compatible meta and
> > > a 8-byte combined BTF ID + type ID: the ID of the BTF where this
> > > structure is defined and the ID of that definition inside that BTF.
> > > Users can obtain BTF IDs by structure types using helpers available
> > > in the kernel, BPF (written by the CO-RE/verifier) and the userland
> > > (libbpf -> kernel call) and then rely on those ID when reading data
> > > to make sure whether they support it and what to do with it.
> > > Why separate magic and ID? The idea is to make different formats
> > > always contain the basic/"generic" structure embedded at the end.
> > > This way we can still benefit in purely generic consumers (like
> > > cpumap) while providing some "extra" data to those who support it.
> >
> > I don't follow this. If you have a struct in your driver name it
> > something obvious, ice_xdp_metadata. If I understand things
> > correctly just dump the BTF for the driver, extract the
> > struct and done you can use CO-RE reads. For the 'fixed' case
> > this looks easy. And I don't think you even need a patch for this.
> >
> > >
> > > The enablement of this feature is controlled on attaching/replacing
> > > XDP program on an interface with two new parameters: that combined
> > > BTF+type ID and metadata threshold.
> > > The threshold specifies the minimum frame size which a driver (or
> > > NIC) should start composing metadata from. It is introduced instead
> > > of just false/true flag due to that often it's not worth it to spend
> > > cycles to fetch all that data for such small frames: let's say, it
> > > can be even faster to just calculate checksums for them on CPU
> > > rather than touch non-coherent DMA zone. Simple XDP_DROP case loses
> > > 15 Mpps on 64 byte frames with enabled metadata, threshold can help
> > > mitigate that.
> >
> > I would put this in the bonus category. Can you do the simple thing
> > above without these extra bits and then add them later. Just
> > pick some overly conservative threshold to start with.
> >
> > >
> > > The RFC can be divided into 8 parts:
> >
> > I'm missing something why not do the simplest bit of work and
> > get this running in ice with a few smallish driver updates
> > so we can all see it. No need for so many patches.
> >
> > >
> > > 01-04: BTF ID hacking: here Larysa provides BPF programs with not
> > > only type ID, but the ID of the BTF as well by using the
> > > unused upper 32 bits.
> > > 05-10: this provides in-kernel mechanisms for taking ID and
> > > threshold from the userspace and passing it to the drivers.
> > > 11-18: provides libbpf API to be able to specify those params from
> > > the userspace, plus some small selftest to verify that both
> > > the kernel and the userspace parts work.
> > > 19-29: here the actual structure is defined, then the in-kernel
> > > helpers and finally here comes the first consumer: function
> > > used to convert &xdp_frame to &sk_buff now will be trying
> > > to parse metadata. The affected users are cpumap and veth.
> > > 30-36: here I try to benefit from the metadata in cpumap even more
> > > by switching it to GRO. Now that we have checksums from NIC
> > > available... but even with no meta it gives some fair
> > > improvements.
> > > 37-43: enabling building generic metadata on Generic/skb path. Since
> > > skbs already have all those fields, it's not a problem to do
> > > this in here, plus allows to benefit from it on interfaces
> > > not supporting meta yet.
> > > 44-47: ice driver part, including enabling prog hot-swap;
> > > 48-52: adds a complex selftest to verify everything works. Can be
> > > used as a sample as well, showing how to work with metadata
> > > in BPF programs and how to configure it from the userspace.
> > >
> > > Please refer to the actual commit messages where some precise
> > > implementation details might be explained.
> > > Nearly 20 of 52 are various cleanups and prereqs, as usually.
> > >
> > > Perf figures were taken on cpumap redirect from the ice interface
> > > (driver-side XDP), redirecting the traffic within the same node.
> > >
> > > Frame size / 64/42 128/20 256/8 512/4 1024/2 1532/1
> > > thread num
> >
> > You'll have to remind me whats the production use case for
> > cpu_map on a modern nic or even smart nic? Why are you not
> > just using a hardware queues and redirecting to the right
> > queues in hardware to start with?
> >
> > Also my understanding is if you do XDP_PASS up the stack
> > the skb is built with all the normal good stuff from hw
> > descriptor. Sorry going to need some extra context here
> > to understand.
> >
> > Could you do a benchmark for AF_XDP I thought this was
> > the troublesome use case where the user space ring lost
> > the hardware info e.g. timestamps and checksum values.
> >
> > >
> > > meta off 30022 31350 21993 12144 6374 3610
> > > meta on 33059 28502 21503 12146 6380 3610
> > > GRO meta off 30020 31822 21970 12145 6384 3610
> > > GRO meta on 34736 28848 21566 12144 6381 3610
> > >
> > > Yes, redirect between the nodes plays awfully with the metadata
> > > composed by the driver:
> >
> > Many production use case use XDP exactly for this. If it
> > slows this basic use case down its going to be very hard
> > to use in many environments. Likely it wont be used.
> >
> > >
> > > meta off 21449 18078 16897 11820 6383 3610
> > > meta on 16956 19004 14337 8228 5683 2822
> > > GRO meta off 22539 19129 16304 11659 6381 3592
> > > GRO meta on 17047 20366 15435 8878 5600 2753
> >
> > Do you have hardware that can write the data into the
> > metadata region so you don't do it in software? Seems
> > like it should be doable without much trouble and would
> > make this more viable.
> >
> > >
> > > Questions still open:
> > >
> > > * the actual generic structure: it must have all the fields used
> > > oftenly and by the majority of NICs. It can always be expanded
> > > later on (note that the structure grows to the left), but the
> > > less often UAPI is modified, the better (less compat pain);
> >
> > I don't believe a generic structure is needed.
> >
> > > * ability to specify the exact fields to fill by the driver, e.g.
> > > flags bitmap passed from the userspace. In theory it can be more
> > > optimal to not spend cycles on data we don't need, but at the
> > > same time increases the complexity of the whole concept (e.g. it
> > > will be more problematic to unify drivers' routines for collecting
> > > data from descriptors to metadata and to skbs);
> > > * there was an idea to be able to specify from the userspace the
> > > desired cacheline offset, so that [the wanted fields of] metadata
> > > and the packet headers would lay in the same CL. Can't be
> > > implemented in Generic/skb XDP and ice has some troubles with it
> > > too;
> > > * lacks AF_XDP/XSk perf numbers and different other scenarios in
> > > general, is the current implementation optimal for them?
> >
> > AF_XDP is the primary use case from my understanding.
> >
>
> AF_XDP is a use case, and might be the primary, but we work with pure XDP and
> have been waiting for the ability to take advantage of the hardware checksums
> for years. It would be a very large performance boost for us (in theory) as
> we're currently having to verify the checksums ourselves in software, and
> recompute them on modifications (since we can't use hardware TX checksums).

Yes, there are plenty of people out there that want that boost both
for XDP and AF_XDP, me included. So this work is important.

> Also, if I understand correctly, if the functionality is available to pure XDP,
> AF_XDP could benefit from it by having the XDP program that redirects to AF_XDP
> copy it into metadata where AF_XDP can find it because of the user defined
> contract between the XDP program and the userspace program? (Not as efficient,
> obviously, and duplicative, but would work, I think.)

Correct, AF_XDP can benefit from this directly. The metadata is
already put before the packet, so in zero-copy mode it will be
available to user-space at no extra cost. In copy mode though, it has
to be copied out together with the packet data. But that code is
already there since you can use the metadata section today for
communicating information between XDP and user-space via AF_XDP.


> > > * metadata threshold and everything else present in this
> > > implementation.
> >
> > I really think your asking questions that are two or three
> > jumps away. Why not do the simplest bit first and kick
> > the driver with an on/off switch into this mode. But
> > I don't understand this cpumap use case so maybe explain
> > that first.
> >
> > And sorry didn't even look at your 50+ patches. Figure lets
> > get agreement on the goal first.
> >
> > .John
