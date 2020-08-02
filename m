Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DBB2359C1
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgHBSWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgHBSWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 14:22:19 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA67C06174A;
        Sun,  2 Aug 2020 11:22:19 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 2so19005784ybr.13;
        Sun, 02 Aug 2020 11:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMcZ/FJCRgWMeQ3B6JmHPmpaPT+Ci09KvDW8PEAoGbY=;
        b=Y7RP5xhbFhNb98xTK7vodbuLKeW59HE3DAeaQPP44TWSmigPYsJWi3/Rii0XlyR7JB
         a8aCSV6OljRugpbqb2tSMTqWWrM2RUS5b2WOJgFRQr9j3FsTH26AEcXqUAdzluKvWuW+
         4LLdOIPeVkQneBjvOaQTo62Hp56ghzCIvr7df3jZ3vE19z/iL+9VcaDnOkZSyiQyk/WM
         0HG6ZDbsvqTazosbyK4hKOzrXQzdCkhXe1BKk+s4lxhAUnqaZCcvoUOzSJAH8jpODNcI
         WAA81dF7B+SIkkrcZwvoIUilFq4gy7V2U5+7EDdX1cTEzlCGg+QZSW7tn8eJ79nRypXZ
         XUPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMcZ/FJCRgWMeQ3B6JmHPmpaPT+Ci09KvDW8PEAoGbY=;
        b=qurxFovjsK+rdcvAmyz5sf0Xcqb5LRHWUUh4XadzuCx4gr2lHSgRtvIYJPMqd180qP
         pB2+z5IHxHfxJbg2miscQ2zVQYtAx/1GVEpcgH1lZoOo4aI+qPmp+aFa+BJ6Td+w4QbT
         GHKP28L0cTPws6tjIjrVnaB6//BJAzPbkHOlbU8OyFWHxywCH/3PAQjrqzolx9NWfxUL
         WuBIym/pE/TA7bE9uxGKmA2wusJT6dKmJI87P/sl3BYf+m0JfFPqopqYuFhevw2UrXBf
         gqjbaVP2dfoSUqSxwcww50o9/IuuDFMyUg5RmDUPclAxVymWUkvndOyhhFLGBZOIoSQ9
         iUww==
X-Gm-Message-State: AOAM531/pe3Y2XYJdPp3n2h8dCLKTL2M3WHnmkr+1kAK9+DylfGTqaxg
        da+KG7oHsraWvGX6o2lw6aJsxP/6QfI6zNOZ836HFA==
X-Google-Smtp-Source: ABdhPJyd4wvsRblGO1x7tY8Kn23saHg2oagzpOI50jrotPlsch0bQfzpf8cQv5kkehMqbMSIWhlh6wyyj3/4xPMTvx8=
X-Received: by 2002:a25:2ad3:: with SMTP id q202mr19978126ybq.27.1596392538164;
 Sun, 02 Aug 2020 11:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200731024244.872574-1-andriin@fb.com> <20200802161106.GA127459@krava>
In-Reply-To: <20200802161106.GA127459@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 2 Aug 2020 11:22:07 -0700
Message-ID: <CAEf4Bzb=LBGsORPCh90=PF=WL+rdOKiBf8yDfJNwd8p2AKUK1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools build: propagate build failures from tools/build/Makefile.build
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 2, 2020 at 9:11 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Jul 30, 2020 at 07:42:44PM -0700, Andrii Nakryiko wrote:
> > The '&&' command seems to have a bad effect when $(cmd_$(1)) exits with
> > non-zero effect: the command failure is masked (despite `set -e`) and all but
> > the first command of $(dep-cmd) is executed (successfully, as they are mostly
> > printfs), thus overall returning 0 in the end.
>
> nice, thanks for digging into this,
> any idea why is the failure masked?

Two things.

1. In make, assume you have command f = a in one function and g = b; c
in another. If you write f && g, you end up with (a && b); c, right?

2. Try this shell script:

set -ex
false && true
true

It will return success. It won't execute the first true command, as
expected, but won't terminate the shell as you'd expect from set -e.

So basically, having a "logical operator" in a sequence of commands
negates the effect of `set -e`. Intuitively I'd expect that from ||,
but seems like && does that as well. if [] has similar effect -- any
failing command in an if check doesn't trigger an early termination of
a script.

>
> Acked-by: Jiri Olsa <jolsa@redhat.com>
>
> jirka
>
> >
> > This means in practice that despite compilation errors, tools's build Makefile
> > will return success. We see this very reliably with libbpf's Makefile, which
> > doesn't get compilation error propagated properly. This in turns causes issues
> > with selftests build, as well as bpftool and other projects that rely on
> > building libbpf.
> >
> > The fix is simple: don't use &&. Given `set -e`, we don't need to chain
> > commands with &&. The shell will exit on first failure, giving desired
> > behavior and propagating error properly.
> >
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Fixes: 275e2d95591e ("tools build: Move dependency copy into function")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >
> > I'm sending this against bpf-next tree, given libbpf is affected enough for me
> > to debug this fun problem that no one seemed to notice (or care, at least) in
> > almost 5 years. If there is a better kernel tree, please let me know.
> >
> >  tools/build/Build.include | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/build/Build.include b/tools/build/Build.include
> > index 9ec01f4454f9..585486e40995 100644
> > --- a/tools/build/Build.include
> > +++ b/tools/build/Build.include
> > @@ -74,7 +74,8 @@ dep-cmd = $(if $(wildcard $(fixdep)),
> >  #                   dependencies in the cmd file
> >  if_changed_dep = $(if $(strip $(any-prereq) $(arg-check)),         \
> >                    @set -e;                                         \
> > -                  $(echo-cmd) $(cmd_$(1)) && $(dep-cmd))
> > +                  $(echo-cmd) $(cmd_$(1));                         \
> > +                  $(dep-cmd))
> >
> >  # if_changed      - execute command if any prerequisite is newer than
> >  #                   target, or command line has changed
> > --
> > 2.24.1
> >
>
