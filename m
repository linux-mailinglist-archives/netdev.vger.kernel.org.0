Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A681E759A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgE2Fuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgE2Fun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 01:50:43 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A913C08C5C6;
        Thu, 28 May 2020 22:50:42 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g18so1018318qtu.13;
        Thu, 28 May 2020 22:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3Gk4/XYGIC/kid5xA4UWr5Yurfg4GXkX9ju8HCOHk0=;
        b=tsPw1aZKojE7l5I6TkPKMccGLXMQZQ2HedzxFOPD49pxxBx/kfgMLW40bMRbmXSHK/
         RZf43FApOnbBTutAjUMSIac3qumQAwzMFVuv+iza3l22NpivvWLElqKyikseS1L3KfPJ
         zqHztM0E4OamC05hSH+Hh5Y4KF+cGfCufblypa/ql1PuW0RyHEJJQgHEsy4I2Zv1iGPE
         Fo2caa7xedMMdBGmqRBXrtsleXR9k2A7R2o9l/ttTefjtxy7gtOxR3gzZqp5V7xch4Fc
         QX+wBzGfPauBB09Tn/qR64ZSIwtWpie53HW8UC4XUfFHucL0NeQseZVZG/MfRw7wIMyH
         m17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3Gk4/XYGIC/kid5xA4UWr5Yurfg4GXkX9ju8HCOHk0=;
        b=YlGsAUEkIr31YTKxBQmwxRumfw2TEt8NXxIi9a872B36OtrNGwW7B8wucoPuwvZOpV
         4S5cdpKob/MpE+gcmbaTthAebAX+/uPMAoYm/ROKvVnovQh/MsFA0OM+jA+QiwAZyA9a
         3YijqXD9/l7pKvIlUKwgPbIA1bR+r6Chgd0R2DpxhQkxtm/SqRQOeE+u8TfYhEPGmPG7
         dlc9zYi4NZ6H+2DcQOcr/GfJu+MgwkhWnEiB5KI8EjyO0+mNGcHv+E6vtSxoIXz7f0L+
         LOpp6DbwUI3OXnrB4XT44CIbPdnB58TR186WE/rGnhIzkvT+6W3sz1kau7oUebebYdrl
         jRhg==
X-Gm-Message-State: AOAM533sBpm+/+oeqbEesT7rHE2RKKYEgoVTxQ7Lp6CelZYEnbCFy+5B
        OPo+Pm8OZ+H1IWsjdcFAD+L8SOgT5SHGxlF7xVg=
X-Google-Smtp-Source: ABdhPJzKgofgvtxnTmYL8qn+ggoNENomYP0krGoxLpHFMwMpmqzJPjMop+trzl/lYzgZyt4YHFKt5G6XeF+0FcwMuV4=
X-Received: by 2002:ac8:342b:: with SMTP id u40mr6967274qtb.59.1590731441275;
 Thu, 28 May 2020 22:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200528062408.547149-1-andriin@fb.com> <20200528225427.GA225299@google.com>
In-Reply-To: <20200528225427.GA225299@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 22:50:30 -0700
Message-ID: <CAEf4BzZ_g2RwOgaRL1Qa9yo-8dH4kpgNaBOWZznNxqxhJUM1aA@mail.gmail.com>
Subject: Re: [PATCH linux-rcu] docs/litmus-tests: add BPF ringbuf MPSC litmus tests
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>, parri.andrea@gmail.com,
        will@kernel.org, Peter Ziljstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>, npiggin@gmail.com,
        dhowells@redhat.com, j.alglave@ucl.ac.uk, luc.maranget@inria.fr,
        Akira Yokosawa <akiyks@gmail.com>, dlustig@nvidia.com,
        open list <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 3:54 PM Joel Fernandes <joel@joelfernandes.org> wrote:
>
> Hello Andrii,
> This is quite exciting. Some comments below:
>
> On Wed, May 27, 2020 at 11:24:08PM -0700, Andrii Nakryiko wrote:
> [...]
> > diff --git a/Documentation/litmus-tests/bpf-rb/bpf-rb+1p1c+bounded.litmus b/Documentation/litmus-tests/bpf-rb/bpf-rb+1p1c+bounded.litmus
> > new file mode 100644
> > index 000000000000..558f054fb0b4
> > --- /dev/null
> > +++ b/Documentation/litmus-tests/bpf-rb/bpf-rb+1p1c+bounded.litmus
> > @@ -0,0 +1,91 @@
> > +C bpf-rb+1p1c+bounded
> > +
> > +(*
> > + * Result: Always
> > + *
> > + * This litmus test validates BPF ring buffer implementation under the
> > + * following assumptions:
> > + * - 1 producer;
> > + * - 1 consumer;
> > + * - ring buffer has capacity for only 1 record.
> > + *
> > + * Expectations:
> > + * - 1 record pushed into ring buffer;
> > + * - 0 or 1 element is consumed.
> > + * - no failures.
> > + *)
> > +
> > +{
> > +     atomic_t dropped;
> > +}
> > +
> > +P0(int *lenFail, int *len1, int *cx, int *px)
> > +{
> > +     int *rLenPtr;
> > +     int rLen;
> > +     int rPx;
> > +     int rCx;
> > +     int rFail;
> > +
> > +     rFail = 0;
> > +
> > +     rCx = smp_load_acquire(cx);
> > +     rPx = smp_load_acquire(px);
>
> Is it possible for you to put some more comments around which ACQUIRE is
> paired with which RELEASE? And, in general more comments around the reason
> for a certain memory barrier and what pairs with what. In the kernel sources,
> the barriers needs a comment anyway.
>
> > +     if (rCx < rPx) {
> > +             if (rCx == 0) {
> > +                     rLenPtr = len1;
> > +             } else {
> > +                     rLenPtr = lenFail;
> > +                     rFail = 1;
> > +             }
> > +
> > +             rLen = smp_load_acquire(rLenPtr);
> > +             if (rLen == 0) {
> > +                     rFail = 1;
> > +             } else if (rLen == 1) {
> > +                     rCx = rCx + 1;
> > +                     smp_store_release(cx, rCx);
> > +             }
> > +     }
> > +}
> > +
> > +P1(int *lenFail, int *len1, spinlock_t *rb_lock, int *px, int *cx, atomic_t *dropped)
> > +{
> > +     int rPx;
> > +     int rCx;
> > +     int rFail;
> > +     int *rLenPtr;
> > +
> > +     rFail = 0;
> > +
> > +     rCx = smp_load_acquire(cx);
> > +     spin_lock(rb_lock);
> > +
> > +     rPx = *px;
> > +     if (rPx - rCx >= 1) {
> > +             atomic_inc(dropped);
>
> Why does 'dropped' need to be atomic if you are always incrementing under a
> lock?

It doesn't, strictly speaking, but making it atomic in litmus test was
just more convenient, especially that I initially also had a lock-less
variant of this algorithm.

>
> > +             spin_unlock(rb_lock);
> > +     } else {
> > +             if (rPx == 0) {
> > +                     rLenPtr = len1;
> > +             } else {
> > +                     rLenPtr = lenFail;
> > +                     rFail = 1;
> > +             }
> > +
> > +             *rLenPtr = -1;
>
> Clarify please the need to set the length intermittently to -1. Thanks.

This corresponds to setting a "busy bit" in kernel implementation.
These litmus tests are supposed to be correlated with in-kernel
implementation, I'm not sure I want to maintain extra 4 copies of
comments here and in kernel code. Especially for 2-producer cases,
there are 2 identical P1 and P2, which is unfortunate, but I haven't
figured out how to have a re-usable pieces of code with litmus tests
:)

>
> > +             smp_store_release(px, rPx + 1);
> > +
> > +             spin_unlock(rb_lock);
> > +
> > +             smp_store_release(rLenPtr, 1);
> > +     }
> > +}
> > +
> > +exists (
> > +     0:rFail=0 /\ 1:rFail=0
> > +     /\
> > +     (
> > +             (dropped=0 /\ px=1 /\ len1=1 /\ (cx=0 \/ cx=1))
> > +     )
> > +)
> > diff --git a/Documentation/litmus-tests/bpf-rb/bpf-rb+1p1c+unbound.litmus b/Documentation/litmus-tests/bpf-rb/bpf-rb+1p1c+unbound.litmus
> > new file mode 100644
> > index 000000000000..7ab5d0e6e49f
> > --- /dev/null
> > +++ b/Documentation/litmus-tests/bpf-rb/bpf-rb+1p1c+unbound.litmus
>
> I wish there was a way to pass args to litmus tests, then perhaps it would
> have been possible to condense some of these tests. :-)

It wouldn't help much, actually, because litmus tests can't have
arrays. See all those "if selectors" between len1 and len2, I had to
do explicitly.

>
> > diff --git a/Documentation/litmus-tests/bpf-rb/bpf-rb+2p1c+bounded.litmus b/Documentation/litmus-tests/bpf-rb/bpf-rb+2p1c+bounded.litmus
> > new file mode 100644
> > index 000000000000..83f80328c92b
> > --- /dev/null
> > +++ b/Documentation/litmus-tests/bpf-rb/bpf-rb+2p1c+bounded.litmus
> [...]
> > +P0(int *lenFail, int *len1, int *cx, int *px)
> > +{
> > +     int *rLenPtr;
> > +     int rLen;
> > +     int rPx;
> > +     int rCx;
> > +     int rFail;
> > +
> > +     rFail = 0;
> > +
> > +     rCx = smp_load_acquire(cx);
> > +     rPx = smp_load_acquire(px);
> > +     if (rCx < rPx) {
> > +             if (rCx == 0) {
> > +                     rLenPtr = len1;
> > +             } else if (rCx == 1) {
> > +                     rLenPtr = len1;
> > +             } else {
> > +                     rLenPtr = lenFail;
> > +                     rFail = 1;
> > +             }
> > +
> > +             rLen = smp_load_acquire(rLenPtr);
> > +             if (rLen == 0) {
> > +                     rFail = 1;
> > +             } else if (rLen == 1) {
> > +                     rCx = rCx + 1;
> > +                     smp_store_release(cx, rCx);
> > +             }
> > +     }
> > +
> > +     rPx = smp_load_acquire(px);
> > +     if (rCx < rPx) {
> > +             if (rCx == 0) {
> > +                     rLenPtr = len1;
> > +             } else if (rCx == 1) {
> > +                     rLenPtr = len1;
> > +             } else {
> > +                     rLenPtr = lenFail;
> > +                     rFail = 1;
> > +             }
> > +
> > +             rLen = smp_load_acquire(rLenPtr);
> > +             if (rLen == 0) {
> > +                     rFail = 1;
> > +             } else if (rLen == 1) {
> > +                     rCx = rCx + 1;
> > +                     smp_store_release(cx, rCx);
> > +             }
> > +     }
> > +}
> > +
> > +P1(int *lenFail, int *len1, spinlock_t *rb_lock, int *px, int *cx, atomic_t *dropped)
> > +{
> > +     int rPx;
> > +     int rCx;
> > +     int rFail;
> > +     int *rLenPtr;
> > +
> > +     rFail = 0;
> > +     rLenPtr = lenFail;
> > +
> > +     rCx = smp_load_acquire(cx);
> > +     spin_lock(rb_lock);
> > +
> > +     rPx = *px;
> > +     if (rPx - rCx >= 1) {
> > +             atomic_inc(dropped);
> > +             spin_unlock(rb_lock);
> > +     } else {
> > +             if (rPx == 0) {
> > +                     rLenPtr = len1;
> > +             } else if (rPx == 1) {
> > +                     rLenPtr = len1;
> > +             } else {
> > +                     rLenPtr = lenFail;
> > +                     rFail = 1;
> > +             }
> > +
> > +             *rLenPtr = -1;
> > +             smp_store_release(px, rPx + 1);
> > +
> > +             spin_unlock(rb_lock);
> > +
> > +             smp_store_release(rLenPtr, 1);
>
> I ran a test replacing the last 2 statements above with the following and it
> still works:
>
>                 spin_unlock(rb_lock);
>                 WRITE_ONCE(*rLenPtr, 1);
>
> Wouldn't you expect the test to catch an issue? The spin_unlock is already a
> RELEASE barrier.

Well, apparently it's not an issue and WRITE_ONCE would work as well
:) My original version actually used WRITE_ONCE here. See [0] and
discussion in [1] after which I removed all the WRITE_ONCE/READ_ONCE
in favor of store_release/load_acquire for consistency.

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200513192532.4058934-3-andriin@fb.com/
  [1] https://patchwork.ozlabs.org/project/netdev/patch/20200513192532.4058934-2-andriin@fb.com/

>
> Suggestion: It is hard to review the patch because it is huge, it would be
> good to split this up into 4 patches for each of the tests. But upto you :)

Those 4 files are partial copies of each other, not sure splitting
them actually would be easier. If anyone else thinks the same, though,
I'll happily split.

>
> thanks,
>
>  - Joel
>
> [...]
>
