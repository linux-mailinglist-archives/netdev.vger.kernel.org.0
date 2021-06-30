Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2D93B809C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 12:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhF3KKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 06:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbhF3KKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 06:10:52 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26204C061756;
        Wed, 30 Jun 2021 03:08:23 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id i4so4101627ybe.2;
        Wed, 30 Jun 2021 03:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=315GgWjphcSz4gPu0C1m0uStExLIy8BjxmSHxJbMz+A=;
        b=ZnDBa1cXuz8dugVH3GM27VJNdOaUpFHAt1ec71DlEUe9Fs5vHDkM5qK4wDJWt5dEap
         tfS8FvGyEXeO4G//gvgDi63Y6FjfNrmutpus4X4YHBWTi16pQ3oplLhkqRFKMGke2beZ
         EIiGrP9u2oQ0WtMwWycf3SemKo3/LbUCoyarSTdragiWtNo6Zj6CbArMe62GncasWQqi
         Qpv0pE1YIOWnosj6Isn6xYYy6X3KNuDZvlOLSQc20rpRoKolqCZAasyntyewtKKsEd3Y
         pCm2lZ4W0WE9BGCnmchzO5Qpr8q1Oly+VhP4YQUq95lHQxLWtt7BBqtXGPbFUr3EUsxc
         xMLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=315GgWjphcSz4gPu0C1m0uStExLIy8BjxmSHxJbMz+A=;
        b=V83wiMX7D6/7uM/cHO2yCBE5opJ5U4mKI0KV721eO1IdcgBcAYNrgtDgWCWWYz5Ywh
         bj6gcQ2RUV1AEFaurry3GON7LIvDb7eSfnfUpGglOsTzFt5Q/9QXlv40NmLfVczmswNS
         7aSsSskFWS9TMBKWnWq7/ebYsM/FvfL7PvzuBw7oGj6feP+HvTapB659/Q32Eqd+Sz0t
         I4wghSYQzb4+uKQUtOJFMrEhdTl1fKsL2ltOK3jjgLnXsAzA9OgoxjzeyoIb1+sKCsOu
         SOGP1al8NZAc41ZTxmbVQEJJOJmkA+6oCT5oqD+lqFsVQ+4+MdaSiUs3wvgYhMBi8lGg
         NlUA==
X-Gm-Message-State: AOAM532UPjhJS9rFvxAChM8VwuxZh8tV53DL1OsTdBhCIFu4QFOxWDlV
        MJAK7afjW+lZAL9g7ZrZsp38W/Zzac6+P8J1v7o=
X-Google-Smtp-Source: ABdhPJyP06aeOdXsv7HZlWAV/uAGgwFMb31hNT4oKTPcE3/6jCBK8xYLq6eH5qRRwa9FQ5luL0ArmsAZMBy1GN1Ctdo=
X-Received: by 2002:a25:1455:: with SMTP id 82mr44281547ybu.403.1625047701821;
 Wed, 30 Jun 2021 03:08:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210624022518.57875-1-alexei.starovoitov@gmail.com>
 <20210624022518.57875-2-alexei.starovoitov@gmail.com> <fd30895e-475f-c78a-d367-2abdf835c9ef@fb.com>
 <20210629014607.fz5tkewb6n3u6pvr@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaPPDEUvsx51mEpp_vJoXVwJQrLu5QnL4pSnL9YAPXevw@mail.gmail.com> <CAADnVQ+erEuHj_0cy16DBFSu_Otj-+60EZN__9W=vogeNQuBOg@mail.gmail.com>
In-Reply-To: <CAADnVQ+erEuHj_0cy16DBFSu_Otj-+60EZN__9W=vogeNQuBOg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 30 Jun 2021 13:08:08 +0300
Message-ID: <CAEf4BzbpF7S2861ueTHC7u4avzFZU7vXkujNX+bLewd4hN5trw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/8] bpf: Introduce bpf timers.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 4:28 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 28, 2021 at 11:34 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > Have you considered alternatively to implement something like
> > bpf_ringbuf_query() for BPF ringbuf that will allow to query various
> > things about the timer (e.g., whether it is active or not, and, of
> > course, remaining expiry time). That will be more general, easier to
> > extend, and will cover this use case:
> >
> > long exp = bpf_timer_query(&t->timer, BPF_TIMER_EXPIRY);
> > bpf_timer_start(&t->timer, new_callback, exp);
>
> yes, but...
> hrtimer_get_remaining + timer_start to that value is racy
> and not accurate.

yes, but even though we specify expiration in nanosecond precision, no
one should expect that precision w.r.t. when callback is actually
fired. So fetching current expiration, adding new one, and re-setting
it shouldn't be a problem in practice, IMO.

I just think the most common case is to set a timer once, so ideally
usability is optimized for that (so taken to extreme it would be just
bpf_timer_start without any bpf_timer_init, but we've already
discussed this, no need to do that again here). Needing bpf_timer_init
+ bpf_timer_set_callbcack + bpf_timer_start for a common case feels
suboptimal usability-wise.

There is also a new race with bpf_timer_set_callback +
bpf_timer_start. Callback can fire inbetween those two operations, so
we could get new callback at old expiration or old callback with new
expiration. To do full update reliably, you'd need to explicitly
bpf_timer_cancel() first, at which point separate
bpf_timer_set_callback() doesn't help at all.

> hrtimer_get_expires_ns + timer_start(MODE_ABS)
> would be accurate, but that's an unnecessary complication.
> To live replace old bpf prog with new one
> bpf_for_each_map_elem() { bpf_timer_set_callback(new_prog); }
> is much faster, since timers don't need to be dequeue, enqueue.
> No need to worry about hrtimer machinery internal changes, etc.
> bpf prog being replaced shouldn't be affecting the rest of the system.

That's a good property, but if it was done as a
bpf_timer_set_callback() in addition to current
bpf_timer_start(callback_fn) it would still allow to have a simple
typical use.

Another usability consideration. With mandatory
bpf_timer_set_callback(), bpf_timer_start() will need to return some
error code if the callback wasn't set yet, right? I'm afraid that in
practice it will be the situation similar to bpf_trace_printk() where
people expect that it always succeeds and will never check the return
code. It's obviously debuggable, but a friction point nevertheless.

>
> > This will keep common timer scenarios to just two steps, init + start,
> > but won't prevent more complicated ones. Things like extending
> > expiration by one second relative that what was remaining will be
> > possible as well.
>
> Extending expiration would be more accurate with hrtimer_forward_now().
>
> All of the above points are minor compared to the verifier advantage.
> bpf_timer_set_callback() typically won't be called from the callback.
> So verifier's insn_procssed will be drastically lower.
> The combinatorial explosion of states even for this small
> selftests/bpf/progs/timer.c is significant.
> With bpf_timer_set_callback() is done outside of callback the verifier
> behavior will be predictable.
> To some degree patches 4-6 could have been delayed, but since the
> the algo is understood and it's working, I'm going to keep them.
> It's nice to have that flexibility, but the less pressure on the
> verifier the better.

I haven't had time to understand those new patches yet, sorry, so not
sure where the state explosion is coming from. I'll get to it for real
next week. But improving verifier internals can be done transparently,
while changing/fixing BPF UAPI is much harder and more disruptive.
