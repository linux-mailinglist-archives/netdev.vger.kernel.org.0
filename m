Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71C5C447A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbfJAXkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 19:40:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40042 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbfJAXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 19:40:14 -0400
Received: by mail-qt1-f196.google.com with SMTP id f7so23961405qtq.7;
        Tue, 01 Oct 2019 16:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4iWsKGD7fsUJ9YtyIOs2+QL6Yq8bELNEjKiSIN4eSlA=;
        b=CnHHruK/YZVjBlhgStCLTCxuW5pxZ5djreHGgWBadtQKtHnduR27rHKGHWZrJaF6yB
         pGo+pLFYFQyyOhdDiwm5be0jBv0xTSmsfkrhDal2wxu6Pi20s1pwUwrXErD1aLdfgZTt
         h0VtJPyZMYHbYuNrmvuAePNamM6BHMQwit2vKdWVcmITodnUTyp5f3vUYKnfaVNG6PUx
         11HrphuRTQJK1vfa6tO4Aznrqf70mwK7Rx8KmrN+36GQGUW/GYaAoKxqtYnvtA+PCCb6
         45WM646TpPfNHMB59GMI2AWdMwmP4YL7v5Np0UqP1HrYqvKE0SvxOImsoOT8OUxX44+Z
         WPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4iWsKGD7fsUJ9YtyIOs2+QL6Yq8bELNEjKiSIN4eSlA=;
        b=W1dG0rp6Bjg/RKt5UkWsnNIRLsbGmcwImS8CGLwVFpDYRhkaFLT9oqItAacFsnACCd
         7yRadqkhI4+MxvAsVofHJV20Vaz6ODzb9iIZ9EsrR5fmUFDjRiDWTanVRBtJ2Fid7zM3
         yG06pFc5zwp5c3oFKRtIHsWSL9BnYnqhaPbE6mTvtPglRpOGawoE0Fl7xBOCt+SIzxg4
         JfHqT8z1p8s4b2PCzf8NGqUBuW947xjlEiFoMoDnTisDF5ykpq3FZHcHJv8kl1W1Ds6r
         035VVShOE+4lM3PJSw7td/BjWLH7cL5rGfJ7eUAyCO6j6VTm3IEm/JTb+CjEpk4sRnZm
         fC7g==
X-Gm-Message-State: APjAAAVO0mxcCshCnhv3DBhn3exxcswcpcfg39ZIc0FG+C035vvzBBbP
        HEMLzgyuFKHUoxYYqeBikzN5mndcXd3B3Lz1ANk=
X-Google-Smtp-Source: APXvYqwEaKlrTJTH1kKdrvft30BjYY9d2A7p37FDU9FnzrVhwyNgYEqv7kPnPBRqy/jP7xHua5Y8C9N5Gzriprbwj5U=
X-Received: by 2002:ac8:1417:: with SMTP id k23mr1025336qtj.93.1569973212025;
 Tue, 01 Oct 2019 16:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190930185855.4115372-1-andriin@fb.com> <20190930185855.4115372-3-andriin@fb.com>
 <20191001224535.GB10044@pc-63.home> <CAEf4BzZQ=NNK42yOu7_H+yuqZ_1npBxDaTuQwsrmJoQUiMfd7A@mail.gmail.com>
In-Reply-To: <CAEf4BzZQ=NNK42yOu7_H+yuqZ_1npBxDaTuQwsrmJoQUiMfd7A@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 16:40:01 -0700
Message-ID: <CAEf4BzZ-OoJxdk3RkB6JyYiNGMcO9Odgtq12Z3j8iu2cmq0F7g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 4:31 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 1, 2019 at 3:45 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On Mon, Sep 30, 2019 at 11:58:51AM -0700, Andrii Nakryiko wrote:
> > > Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure they
> > > are installed along the other libbpf headers.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > [...]

[...]

> >
> > As mentioned earlier, the whole helper function description below
> > should get a big cleanup in here when moved into libbpf API.
>
> Right, I just recalled that today, sorry I didn't do it for this version.
>
> There were two things you mentioned on that thread that you wanted to clean up:
> 1. using __u32 instead int and stuff like that
> 2. using macro to hide some of the ugliness of (void *) = BPF_FUNC_xxx
>
> So with 1) I'm concerned that we can't just assume that __u32 is
> always going to be defined. Also we need bpf_helpers.h to be usable
> both with including system headers, as well as auto-generated
> vmlinux.h. In first case, I don't think we can assume that typedef is
> always defined, in latter case we can't really define it on our own.
> So I think we should just keep it as int, unsigned long long, etc.
> Thoughts?
>
> For 2), I'm doing that right now, but it's not that much cleaner, let's see.
>
> Am I missing something else?

Ok, so this doesn't work with just

#define BPF_FUNC(NAME, ...) (*NAME)(__VA_ARGS__)
__attribute__((unused)) = (void *) BPF_FUNC_##NAME

because helper is called bpf_map_update_elem(), but enum value is
BPF_FUNC_map_update_elem (without bpf_ prefix). So one way to do this
would be to have bpf_ prepended to function name by macro:

static int BPF_FUNC(map_update_elem, ....);

But this is super confusing, because this definition becomes basically
un-greppable. I think we should just keep it as is, or go all the way
in for super-verbose

static int BPF_FUNC(BPF_FUNC_map_update_elem, bpf_map_elem, ...);

I hate both, honestly.

>
> >
> > > +static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
> > > +     (void *) BPF_FUNC_map_lookup_elem;
> > > +static int (*bpf_map_update_elem)(void *map, const void *key, const void *value,
> > > +                               unsigned long long flags) =
> > [...]
> > > +

[...]

> > > --
> > > 2.17.1
> > >
