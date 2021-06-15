Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5B03A768D
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 07:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhFOFnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 01:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOFnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 01:43:10 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C297EC061574;
        Mon, 14 Jun 2021 22:41:06 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id i13so1653871lfc.7;
        Mon, 14 Jun 2021 22:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C09yVGLDueA5DuTyNVcSJ7fOg+Ues+QqBlKK+G9Lpvo=;
        b=kqGqk9t4jSjjxBOJd6U7Jwy/FEhcEABozIaOq4PWD0qw1LPoQ9kSIF4oanyhw+4nkB
         ImQeC2xRb7x45v6XsMq3tNFKSJoCUcquqWXNJlLwnNS9FTS0qIWictpCPNNpaFuHZ3R/
         wneJBkLPWC+TuYh5AxEwbOwggUHeQseihZdMb3BRkbyJkeJ3dp1DLQOxkefDmsRGAHn2
         C9kOyYtzV3C6uiRmzTyjwFYldsCGhLki2yglSehtECRgpU2TJVlbjyGZtZPcP1NZFIOf
         cl5qK/OGRccnEACLk/5lZ5hxSDcnevbfp9C9gWCqJ2jMzOjfTuHeVc66i6qim+Ov6cZa
         Dm6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C09yVGLDueA5DuTyNVcSJ7fOg+Ues+QqBlKK+G9Lpvo=;
        b=BLmZtjEPsJyDWLlAVvKcLMJSqE2rKqmCOXDir/FOzE9P5t+dAROXFG0nmdOC2PCbe0
         T9Wf9n3TPxOSt8vh3Kwfbg+wKapn1hy4ALrAK6LX5rg+Ku3E7qJ5cciLZ/VD5QXpQYXn
         9xt59mbn4vJvXVREaqg+YUlV2++6gYUL9ir62aRb8zr6p4CrBq1pgWvuiFNFqW/H5kY8
         /Kpl2gGGy/e/6c6gHtRdkcsp3oNufRHdCOro+ez+4KTsaPSEryu1ZJvjeJrxS+XnxOtI
         P2sT7YzFRbP51ZmwOkeqW3olyq0IyojJNqTCM5B5ou3SqayWmEUVYdHmYplvutnXLxZA
         k3mw==
X-Gm-Message-State: AOAM531LNr6GFgb/Su2BKYA+jZRd0UBeTdQkfnB2z+N6m5E8uWgGB2aN
        cXhNpI9ZJ5j1Ww9mvvGW/eO3BptDt4GNDUcHMWY=
X-Google-Smtp-Source: ABdhPJxtLPEC0ikOwg/AgPZDDbv12/wGWGshxj1FNyX8oc6KDoi3GTesu4TIOPNQqoBd9dpTs2yla3i6WAqpt1VV0DI=
X-Received: by 2002:a05:6512:3f9a:: with SMTP id x26mr15273253lfa.75.1623735665023;
 Mon, 14 Jun 2021 22:41:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <9b23b2c6-28b2-3ab3-4e8b-1fa0c926c4d2@fb.com>
 <CAADnVQLS=Jx9=znx6XAtrRoY08bTQHTipXQwvnPNo0SRSJsK0Q@mail.gmail.com> <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZ159NfuGJo0ig9i=7eGNgvQkq8TnZi09XHSZST17A0zQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Jun 2021 22:40:53 -0700
Message-ID: <CAADnVQJ3CQ=WnsantyEy6GB58rdsd7q=aJv93WPsZZJmXdJGzQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 10:31 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jun 14, 2021 at 8:29 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Mon, Jun 14, 2021 at 9:51 AM Yonghong Song <yhs@fb.com> wrote:
> > > > +     ret = BPF_CAST_CALL(t->callback_fn)((u64)(long)map,
> > > > +                                         (u64)(long)key,
> > > > +                                         (u64)(long)t->value, 0, 0);
> > > > +     WARN_ON(ret != 0); /* Next patch disallows 1 in the verifier */
> > >
> > > I didn't find that next patch disallows callback return value 1 in the
> > > verifier. If we indeed disallows return value 1 in the verifier. We
> > > don't need WARN_ON here. Did I miss anything?
> >
> > Ohh. I forgot to address this bit in the verifier. Will fix.
> >
> > > > +     if (!hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer))
> > > > +             /* If the timer wasn't active or callback already executing
> > > > +              * bump the prog refcnt to keep it alive until
> > > > +              * callback is invoked (again).
> > > > +              */
> > > > +             bpf_prog_inc(t->prog);
> > >
> > > I am not 100% sure. But could we have race condition here?
> > >     cpu 1: running bpf_timer_start() helper call
> > >     cpu 2: doing hrtimer work (calling callback etc.)
> > >
> > > Is it possible that
> > >    !hrtimer_active(&t->timer) || hrtimer_callback_running(&t->timer)
> > > may be true and then right before bpf_prog_inc(t->prog), it becomes
> > > true? If hrtimer_callback_running() is called, it is possible that
> > > callback function could have dropped the reference count for t->prog,
> > > so we could already go into the body of the function
> > > __bpf_prog_put()?
> >
> > you're correct. Indeed there is a race.
> > Circular dependency is a never ending headache.
> > That's the same design mistake as with tail_calls.
> > It felt that this case would be simpler than tail_calls and a bpf program
> > pinning itself with bpf_prog_inc can be made to work... nope.
> > I'll get rid of this and switch to something 'obviously correct'.
> > Probably a link list with a lock to keep a set of init-ed timers and
> > auto-cancel them on prog refcnt going to zero.
> > To do 'bpf daemon' the prog would need to be pinned.
>
> Hm.. wouldn't this eliminate that race:
>
> switch (hrtimer_try_to_cancel(&t->timer))
> {
> case 0:
>     /* nothing was queued */
>     bpf_prog_inc(t->prog);
>     break;
> case 1:
>     /* already have refcnt and it won't be bpf_prog_put by callback */
>     break;
> case -1:
>     /* callback is running and will bpf_prog_put, so we need to take
> another refcnt */
>     bpf_prog_inc(t->prog);
>     break;
> }
> hrtimer_start(&t->timer, ns_to_ktime(nsecs), HRTIMER_MODE_REL_SOFT);
>
> So instead of guessing (racily) whether there is a queued callback or
> not, try to cancel just in case there is. Then rely on the nice
> guarantees that hrtimer cancellation API provides.

I haven't thought it through yet, but the above approach could
indeed solve this particular race. Unfortunately there are other races.
There is an issue with bpf_timer_init. Since it doesn't take refcnt
another program might do lookup and bpf_timer_start
while the first prog got to refcnt=0 and got freed.
Adding refcnt to bpf_timer_init() makes the prog self pinned
and no callback might ever be executed (if there were no bpf_timer_start),
so that will cause a high chance of bpf prog stuck in the kernel.
There could be ref+uref schemes similar to tail_calls to address all that,
but it gets ugly quickly.
imo all these issues and races is a sign that such self pinning
shouldn't be allowed.
