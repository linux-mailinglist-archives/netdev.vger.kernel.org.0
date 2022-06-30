Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1300561E11
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 16:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbiF3Oe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 10:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiF3Oej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 10:34:39 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4DD677EE;
        Thu, 30 Jun 2022 07:20:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id e132so3062334pgc.5;
        Thu, 30 Jun 2022 07:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoOONB+6KTZ21PhWkviaVKZOS2lsC8jyZZGjusxKNh4=;
        b=I+iZ8i/D9epTvcx4pI6w8Gu0S7GXlt288tFF5mTuhax7rgWHyuM0WMLermz+fhgIfT
         daxT/ECuysrwbjuj36f8fekDNkex23H9nEzzjhNPZohNlXJLLwo+91JEDHvvndTLyX9D
         fWNSOGyBDmOy8cwm0KRFoM7ga5dHuHuBYV/pEn7co6v1RRqmVIqpRFsy4zmAcgiM2Ubw
         WaE1KUEDaUbwvmA8xfWPG5ryXhVWgfEOtb7cp+pp1oNCoH5FDeJFOhgctxcYIq1rGIAn
         /rfShey01ewSi8R+RpIRJs06PkZBjqm/9eIMgIYXqP/RWBlE6RSQEARj1UHWhsDF7Jn/
         D76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZoOONB+6KTZ21PhWkviaVKZOS2lsC8jyZZGjusxKNh4=;
        b=vMyqV3sSCp8gwnxX+J49M3f32fs5eXCorM7aHfBcDoenBTimFMEqsXCxl6ke6YWOrh
         rvGP0Wssm/bCsZf7Hooj3ThRsBeUsW+6ZeZg4o8O0JY+GEZc+hN7yMrB+8bGzmP8C1zR
         RkaaH16xZMid3DJmTQKZwCV7FOnGmX1SxigKCYTujSsFVatqJBKfJEeimOE16gb+Megw
         wQ/eOi+noIU90A6KsnkRFXjVjYLM8FnB5K3022gYVavBmOYs4Bgcp1A6xshZJ8pXgo0e
         eL/rVfvYU00yIz1tR+uac8GX2epjEJ8bNOmp7WC6R3S9nahXAOKBXD0FEoLqTeBY+DKL
         M3CA==
X-Gm-Message-State: AJIora+51nSjYj4JVJoitDFASJsejgEnO24+snBsEfZAsZt7ySrbEzYu
        3Y/yVkNNHCTGdIj9N+OiUaLThENjMxOfoBc3JQU=
X-Google-Smtp-Source: AGRyM1ukpqNyJHnjXREZdnq7pTqkcOAhbVW7upHxfkpLBRdKhsNzSlMk6xhkG/xT8wBuQajEgx04hDVn5nnWwauz5Bc=
X-Received: by 2002:aa7:999a:0:b0:525:6023:8c03 with SMTP id
 k26-20020aa7999a000000b0052560238c03mr16042113pfh.86.1656598835031; Thu, 30
 Jun 2022 07:20:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220630093717.8664-1-magnus.karlsson@gmail.com> <fa929729-6122-195f-aa4b-e5d3fedb1887@redhat.com>
In-Reply-To: <fa929729-6122-195f-aa4b-e5d3fedb1887@redhat.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Jun 2022 16:20:24 +0200
Message-ID: <CAJ8uoz2KmpVf7nkJXUsHhmOtS2Td+rMOX8-PRqzz9QxJB-tZ3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>
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

On Thu, Jun 30, 2022 at 3:44 PM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 30/06/2022 11.37, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Remove the AF_XDP samples from samples/bpf as they are dependent on
> > the AF_XDP support in libbpf. This support has now been removed in the
> > 1.0 release, so these samples cannot be compiled anymore. Please start
> > to use libxdp instead. It is backwards compatible with the AF_XDP
> > support that was offered in libbpf. New samples can be found in the
> > various xdp-project repositories connected to libxdp and by googling.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> Will you (or Maciej) be submitting these samples to XDP-tools[1] which
> is the current home for libxdp or maybe BPF-examples[2] ?
>
>   [1] https://github.com/xdp-project/xdp-tools
>   [2] https://github.com/xdp-project/bpf-examples
>
> I know Toke is ready to take over maintaining these, but we will
> appreciate someone to open a PR with this code...
>
> > ---
> >   MAINTAINERS                     |    2 -
> >   samples/bpf/Makefile            |    9 -
> >   samples/bpf/xdpsock.h           |   19 -
> >   samples/bpf/xdpsock_ctrl_proc.c |  190 ---
> >   samples/bpf/xdpsock_kern.c      |   24 -
> >   samples/bpf/xdpsock_user.c      | 2019 -------------------------------
> >   samples/bpf/xsk_fwd.c           | 1085 -----------------
>
> The code in samples/bpf/xsk_fwd.c is interesting, because it contains a
> buffer memory manager, something I've seen people struggle with getting
> right and performant (at the same time).

I can push xsk_fwd to BPF-examples. Though I do think that xdpsock has
become way too big to serve as a sample. It slowly turned into a catch
all demonstrating every single feature of AF_XDP. We need a minimal
example and then likely other samples for other features that should
be demoed. So I suggest that xdpsock dies here and we start over with
something minimal and use xsk_fwd for the forwarding and mempool
example.

Toke, I think you told me at Recipes in Paris that someone from RedHat
was working on an example. Did I remember correctly?

> You can get my ACK if someone commits to port this to [1] or [2], or a
> 3rd place that have someone what will maintain this in the future.
>
> --Jesper
>
