Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC3F2C7A4B
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgK2Rd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2Rd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 12:33:57 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BA5C0613CF;
        Sun, 29 Nov 2020 09:33:16 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id d8so15969069lfa.1;
        Sun, 29 Nov 2020 09:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9Ivd228KRGNiM4oNPEXV7qZkA2p1Ts+zhGyYk+f14Q=;
        b=u2MYvRT0eQe0r0Wowe9wkWT+K7QQR+2NqAKvauTfrEaC1xlduUKrJmlDxadn82NKm2
         59HoTTBShi0p9cqRwuYHOewT4WDJI/o5uv6hF8e6WSDhXv9c7Qq8NPmk4C9UBLTuHuyK
         scXPFyo98AhNixof4TiTIAGgTS6I0pl3WgyH+gkj2IiZ3ygRY3r5NScWrug9frxqj6nz
         +xiJ+HVn7+qIz2+oo+1uhZtR7gsMO/WhHuck/WkSnY0YtdxMOi5hIvJrzyoU1r2ILMtS
         OJVYOkL4XFGLrM7nkeQvRpmemWT+IAole/af3QncqRfCe7tJjafohpH9HvgkfK8l3Fgj
         f3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9Ivd228KRGNiM4oNPEXV7qZkA2p1Ts+zhGyYk+f14Q=;
        b=G6TeQ6zMuzo+rn5y/vBfxMSP8gei+6UrDrdJVJoBj1yzc5I7yWL+BPbmBie7dcjc1P
         cluaLMUG7G93VvK0LRjwy2TxUEo6gOYXh3dNFkX/V6PLbeJ+1VandF2gVLj961A18AV8
         MqmQ9RmQENAwfeGtSH9o6p2Xg03/oRkAR38qy2wpRLjd+Hm4+jpKaw5dH/RErnc9nf1g
         RjOecJ2aUa6jI8CtLM1L5Vj0yVQzhEVa7USOucvmZjT8Hw3pMBLSksn2FP0JB0kTx/TK
         Uywm7ekui+jU/zhx0G8/W6Hv9gLDn7DmJt0IKg70QSIZc2EvhLmUjsJ5a5MDMyE3Yo9N
         uJxQ==
X-Gm-Message-State: AOAM532jCzXGRRQWBzH91ry5MqtMiq9ILVD/9Is2THD2VpBMQn124rP+
        wEEA4663FU3STl6UjhGjbfHYCRMGcp0eVAMUJuU=
X-Google-Smtp-Source: ABdhPJx3xjRMpnuQ78Qyi7pGaPhJWAnK7tU0l38c6yYDB/D1JMGCLLB2e63BF4sSIUjRipae8ui+mx0IZ7rTclbLcn8=
X-Received: by 2002:a19:8048:: with SMTP id b69mr6868103lfd.263.1606671195181;
 Sun, 29 Nov 2020 09:33:15 -0800 (PST)
MIME-Version: 1.0
References: <20201023033855.3894509-1-haliu@redhat.com> <20201128221635.63fdcf69@hermes.local>
In-Reply-To: <20201128221635.63fdcf69@hermes.local>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 29 Nov 2020 09:33:03 -0800
Message-ID: <CAADnVQKgBudBhB2JSgd+5ZRFqLVrHiVRMMPyksL_Q9prouZ0ig@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 0/5] iproute2: add libbpf support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 10:16 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 23 Oct 2020 11:38:50 +0800
> Hangbin Liu <haliu@redhat.com> wrote:
>
> > This series converts iproute2 to use libbpf for loading and attaching
> > BPF programs when it is available. This means that iproute2 will
> > correctly process BTF information and support the new-style BTF-defined
> > maps, while keeping compatibility with the old internal map definition
> > syntax.
> >
> > This is achieved by checking for libbpf at './configure' time, and using
> > it if available. By default the system libbpf will be used, but static
> > linking against a custom libbpf version can be achieved by passing
> > LIBBPF_DIR to configure. FORCE_LIBBPF can be set to force configure to
> > abort if no suitable libbpf is found (useful for automatic packaging
> > that wants to enforce the dependency).
> >
> > The old iproute2 bpf code is kept and will be used if no suitable libbpf
> > is available. When using libbpf, wrapper code ensures that iproute2 will
> > still understand the old map definition format, including populating
> > map-in-map and tail call maps before load.
> >
> > The examples in bpf/examples are kept, and a separate set of examples
> > are added with BTF-based map definitions for those examples where this
> > is possible (libbpf doesn't currently support declaratively populating
> > tail call maps).
>
>
> Luca wants to put this in Debian 11 (good idea), but that means:
>
> 1. It has to work with 5.10 release and kernel.
> 2. Someone has to test it.
> 3. The 5.10 is a LTS kernel release which means BPF developers have
>    to agree to supporting LTS releases.

That must be a bad joke.
You did the opposite of what we asked.
You folks are on your own.
5.10, 5.11 whatever release. When angry users come with questions
about random behavior you'll be answering them. Not us.
