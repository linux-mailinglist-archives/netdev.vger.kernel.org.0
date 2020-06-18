Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0A61FFEE4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 01:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgFRXsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 19:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgFRXsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 19:48:45 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FEFC06174E;
        Thu, 18 Jun 2020 16:48:45 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a45so3851787pje.1;
        Thu, 18 Jun 2020 16:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=cGgzomHsmMiibZOiFHQpzS69L8geW6hLr8jvWa1/zL4=;
        b=Nyre89On0UQFyud2sdz3I8zVgfKWaFWlfzPdQnduM1IDmK/B5cfLxvdr/JPFV5BOmm
         doqFBHyhkSRQYPFmWq8YV1n3nIFjvur9G2UZG5YoHbgTkGP6f6VBf34BhZia49qw/Yw6
         P8o6LVYJKcuehf1fY5MOAmlrVzgjMxLTGbOw3alE4jEgDiXrX/3f3/dGVDcrXXat1ZtN
         ad1TePP0SNBWpannwphaR4ayqTwgaBdgdhssgB+PmMsj69azty42hKyvTWMe1wENI3k5
         HWQ8i4btjRijLEskes6Mo0/xq1wJ6XpcskiuAPqMC+1M7gTq+srgy90HLT6zRpxhuqBb
         vITg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=cGgzomHsmMiibZOiFHQpzS69L8geW6hLr8jvWa1/zL4=;
        b=DX2PwWANgfIMwkq0kcddNmRofrY2UbuW2lldB8N5ZoHiIYzZumSsP3bgLqzFfJE9f9
         GfcmPd/Aeiwwch0QDRNaShEk0PoOJ/cBQkoQWfUh7qTO9inPLOyH2OuITCtoVycFlInm
         sAdGeB5A/UjNVSQ/wLBV6i5EY60dUQBxyRGtFNMxH0rSKN9rlYTj04ZTxzBuPJwDspK7
         hVkTwetebNXxBVkstIU3dg3avIy7+9yNlNy9K6k+H491tApe54jfGAS9GpKlH1bi32iq
         Zd0GCz1cOSfNoJ7x6LDewcsSKqwv8EwEZJZc4MuxBVBTOpkByyCvdWlZTi/DSWJ1DyE6
         dQuQ==
X-Gm-Message-State: AOAM533RGQmqLjWhpJZzFvMOFAPbkkW+kDWUkTzagmeYe6W4BDVLPjkJ
        xuinJNdlNMKt4/ekm8oH2eU=
X-Google-Smtp-Source: ABdhPJwKsBbbczybQnXu6vEp+IQaN9iI0Xr0prO0FSo4n1aUbeQ8fqoSd+qWsQ/M4NahWFrFAsI2yQ==
X-Received: by 2002:a17:902:a585:: with SMTP id az5mr5648730plb.207.1592524124685;
        Thu, 18 Jun 2020 16:48:44 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id nl11sm7633653pjb.0.2020.06.18.16.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 16:48:43 -0700 (PDT)
Date:   Thu, 18 Jun 2020 16:48:36 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Christoph Hellwig <hch@lst.de>
Message-ID: <5eebfd54ec54f_27ce2adb0816a5b876@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzYNFddhDxLAkOC+q_ZWAet42aHybDiJT9odrzF8n5BBig@mail.gmail.com>
References: <20200616050432.1902042-1-andriin@fb.com>
 <20200616050432.1902042-2-andriin@fb.com>
 <5eebbbef8f904_6d292ad5e7a285b883@john-XPS-13-9370.notmuch>
 <CAEf4BzYNFddhDxLAkOC+q_ZWAet42aHybDiJT9odrzF8n5BBig@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, Jun 18, 2020 at 12:09 PM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > Add selftest that validates variable-length data reading and concatentation
> > > with one big shared data array. This is a common pattern in production use for
> > > monitoring and tracing applications, that potentially can read a lot of data,
> > > but usually reads much less. Such pattern allows to determine precisely what
> > > amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> > >
> > > This is the first BPF selftest that at all looks at and tests
> > > bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
> > > testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
> > > 0 on success, instead of amount of bytes successfully read.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> >
> > [...]
> >
> > > +/* .data */
> > > +int payload2_len1 = -1;
> > > +int payload2_len2 = -1;
> > > +int total2 = -1;
> > > +char payload2[MAX_LEN + MAX_LEN] = { 1 };
> > > +
> > > +SEC("raw_tp/sys_enter")
> > > +int handler64(void *regs)
> > > +{
> > > +     int pid = bpf_get_current_pid_tgid() >> 32;
> > > +     void *payload = payload1;
> > > +     u64 len;
> > > +
> > > +     /* ignore irrelevant invocations */
> > > +     if (test_pid != pid || !capture)
> > > +             return 0;
> > > +
> > > +     len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> > > +     if (len <= MAX_LEN) {
> >
> > Took me a bit grok this. You are relying on the fact that in errors,
> > such as a page fault, will encode to a large u64 value and so you
> > verifier is happy. But most of my programs actually want to distinguish
> > between legitimate errors on the probe vs buffer overrun cases.
> 
> What buffer overrun? bpf_probe_read_str() family cannot return higher
> value than MAX_LEN. If you want to detect truncated strings, then you
> can attempt reading MAX_LEN + 1 and then check that the return result
> is MAX_LEN exactly. But still, that would be something like:
> u64 len;
> 
> len = bpf_probe_read_str(payload, MAX_LEN + 1, &buf);
> if (len > MAX_LEN)
>   return -1;
> if (len == MAX_LEN) {
>   /* truncated */
> } else {
>   /* full string */
> }

+1

> 
> >
> > Can we make these tests do explicit check for errors. For example,
> >
> >   if (len < 0) goto abort;
> >
> > But this also breaks your types here. This is what I was trying to
> > point out in the 1/2 patch thread. Wanted to make the point here as
> > well in case it wasn't clear. Not sure I did the best job explaining.
> >
> 
> I can write *a correct* C code in a lot of ways such that it will not
> pass verifier verification, not sure what that will prove, though.
> 
> Have you tried using the pattern with two ifs with no-ALU32? Does it work?

Ran our CI on both mcpu=v2 and mcpu=v3 and the pattern with multiple
ifs exists in those tests. They both passed so everything seems OK.
In the real progs though things are a bit more complicated I didn't
check the exact generate code. Some how I missed the case below.
I put a compiler barrier in a few spots so I think this is blocking
the optimization below causing no-alu32 failures. I'll remove the
barriers after I wrap a few things reviews.. my own bug fixes ;) and
see if I can trigger the case below.

> 
> Also you are cheating in your example (in patch #1 thread). You are
> exiting on the first error and do not attempt to read any more data
> after that. In practice, you want to get as much info as possible,
> even if some of string reads fail (e.g., because argv might not be
> paged in, but env is, or vice versa). So you'll end up doing this:

Sure.

> 
> len = bpf_probe_read_str(...);
> if (len >= 0 && len <= MAX_LEN) {
>     payload += len;
> }
> ...
> 
> ... and of course it spectacularly fails in no-ALU32.
> 
> To be completely fair, this is a result of Clang optimization and
> Yonghong is trying to deal with it as we speak. Switching int to long
> for helpers doesn't help it either. But there are better code patterns
> (unsigned len + single if check) that do work with both ALU32 and
> no-ALU32.

Great.

> 
> And I just double-checked, this pattern keeps working for ALU32 with
> both int and long types, so maybe there are unnecessary bit shifts,
> but at least code is still verifiable.
> 
> So my point stands. int -> long helps in some cases and doesn't hurt
> in others, so I argue that it's a good thing to do :)

Convinced me as well. I Acked the other patch thanks.
