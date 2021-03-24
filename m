Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA80346F0B
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbhCXBtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbhCXBtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:49:18 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A105BC061765;
        Tue, 23 Mar 2021 18:49:18 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so348024pjv.1;
        Tue, 23 Mar 2021 18:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Kcc6sYOncKNza4pyjGfSR1hgCICN528qKEruGPFUaW0=;
        b=i/K/lP2EMNf5mL/ks+jU5qNCAiaM+A4q5Dbzv8tWCoJNfyhniaLAG+lOI7DnGGOst8
         E/cXZbjoQkNuMSz8fGShcDE5oyVMUfE/nxZ8uhcjhI+qwA5u2x9UUFXqzoEc3XclHswI
         8eK8ukUX4NXRS+uvPtt7q91dDlMMo9U73FrLrIYDygxtdwgS2zOmzZxk4TQkqADUNQgA
         AHMBAeG5P1uzR57lXRyXfoC8Yv09xGfjylKRafhs3/H8K1oHng2zTNoNbm+rvv/KYsao
         Bnkwmgd6KGMgpVatkM/uCyQo52FUYJaarkVNahNbVv4+Gu2cqUSSYJ/RhT2UxDhVtNxh
         Jg0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Kcc6sYOncKNza4pyjGfSR1hgCICN528qKEruGPFUaW0=;
        b=okc/WnaoRRP7URWrL5jIDwcCF+dXJYvE5KQxt2+a4S3Y5bHqPlEGwipm2EbrY6bxGk
         FK/KeMJizIffHaja6hrAQwiWILIFg7Hh39jLyW7rtHgCTBtbxV9T3zdjbI03EMSWrBXv
         krP3EtUgjDK43kNkcWdnMv1TlwRnl2EgkuTznAHi5z6BizWYU8YwKq/TY+6SbDPc2ExZ
         Z7jy/hDw9kBMNMgRCO8ryGrW7AOehjGPuWOByH7YWkvlKti+M4OqfcOFU8GqYSgmg0NJ
         6lg1NDcoGC/NE2F7BA+qUatzX1F1nv7sv4fQdEBccNMRuV+hIH0YrOwIkLUEB9vKepiz
         vWFA==
X-Gm-Message-State: AOAM531uNhO3RK5dU/JKnNTxhk+Qy3ZRiWEoLj608MpxxNtL/TMk5hvl
        8uiOrwUb/lnZWmD8JJleWECn8QaMTiUgVaqxOeM=
X-Google-Smtp-Source: ABdhPJwSaV2t0JL7d34dMYVjA5vhuv0+uustAjzX/a1J/kIDwNGzbXYxD8SD9PUz9jzxjHc6LckTWoVTeiQmegxvwes=
X-Received: by 2002:a17:90a:7061:: with SMTP id f88mr937998pjk.56.1616550557213;
 Tue, 23 Mar 2021 18:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
 <87eegddhsj.fsf@toke.dk> <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
 <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com> <CAM_iQpVvR1eUQxgihWrZ==X=xQjaaeH_qkehvU0Y2R6i9eM-Qw@mail.gmail.com>
 <9d045462-051e-0cde-24d0-349dd397e2b7@huawei.com>
In-Reply-To: <9d045462-051e-0cde-24d0-349dd397e2b7@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 23 Mar 2021 18:49:06 -0700
Message-ID: <CAM_iQpVgARDaUd3jdvSA11j=Q_K6KvcKfn7DQavGYXUWmvLZtw@mail.gmail.com>
Subject: Re: [Linuxarm] Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS
 for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 5:55 PM Yunsheng Lin <linyunsheng@huawei.com> wrote=
:
>
> On 2021/3/20 2:15, Cong Wang wrote:
> > On Thu, Mar 18, 2021 at 12:33 AM Yunsheng Lin <linyunsheng@huawei.com> =
wrote:
> >>
> >> On 2021/3/17 21:45, Jason A. Donenfeld wrote:
> >>> On 3/17/21, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> >>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
> >>>>
> >>>>> On Mon, Mar 15, 2021 at 2:07 PM Jakub Kicinski <kuba@kernel.org> wr=
ote:
> >>>>>>
> >>>>>> I thought pfifo was supposed to be "lockless" and this change
> >>>>>> re-introduces a lock between producer and consumer, no?
> >>>>>
> >>>>> It has never been truly lockless, it uses two spinlocks in the ring
> >>>>> buffer
> >>>>> implementation, and it introduced a q->seqlock recently, with this =
patch
> >>>>> now we have priv->lock, 4 locks in total. So our "lockless" qdisc e=
nds
> >>>>> up having more locks than others. ;) I don't think we are going to =
a
> >>>>> right direction...
> >>>>
> >>>> Just a thought, have you guys considered adopting the lockless MSPC =
ring
> >>>> buffer recently introduced into Wireguard in commit:
> >>>>
> >>>> 8b5553ace83c ("wireguard: queueing: get rid of per-peer ring buffers=
")
> >>>>
> >>>> Jason indicated he was willing to work on generalising it into a
> >>>> reusable library if there was a use case for it. I haven't quite tho=
ugh
> >>>> through the details of whether this would be such a use case, but
> >>>> figured I'd at least mention it :)
> >>>
> >>> That offer definitely still stands. Generalization sounds like a lot =
of fun.
> >>>
> >>> Keep in mind though that it's an eventually consistent queue, not an
> >>> immediately consistent one, so that might not match all use cases. It
> >>> works with wg because we always trigger the reader thread anew when i=
t
> >>> finishes, but that doesn't apply to everyone's queueing setup.
> >>
> >> Thanks for mentioning this.
> >>
> >> "multi-producer, single-consumer" seems to match the lockless qdisc's
> >> paradigm too, for now concurrent enqueuing/dequeuing to the pfifo_fast=
's
> >> queues() is not allowed, it is protected by producer_lock or consumer_=
lock.
> >>
> >> So it would be good to has lockless concurrent enqueuing, while dequeu=
ing
> >> can be protected by qdisc_lock() or q->seqlock, which meets the "multi=
-producer,
> >> single-consumer" paradigm.
> >
> > I don't think so. Usually we have one queue for each CPU so we can expe=
ct
> > each CPU has a lockless qdisc assigned, but we can not assume this in
> > the code, so we still have to deal with multiple CPU's sharing a lockle=
ss qdisc,
> > and we usually enqueue and dequeue in process context, so it means we c=
ould
> > have multiple producers and multiple consumers.
>
> For lockless qdisc, dequeuing is always within the qdisc_run_begin() and
> qdisc_run_end(), so multiple consumers is protected with each other by
> q->seqlock .

So are you saying you will never go lockless for lockless qdisc? I thought
you really want to go lockless with Jason's proposal of MPMC ring buffer
code.

>
> For enqueuing, multiple consumers is protected by producer_lock, see
> pfifo_fast_enqueue() -> skb_array_produce() -> ptr_ring_produce().

I think you seriously misunderstand how we classify MPMC or MPSC,
it is not about how we lock them, it is about whether we truly have
a single or multiple consumers regardless of locks used, because the
goal is to go lockless.

> I am not sure if lockless MSPC can work with the process context, but
> even if not, the enqueuing is also protected by rcu_read_lock_bh(),
> which provides some kind of atomicity, so that producer_lock can be
> reomved when lockless MSPC is used.


Not sure if I can even understand what you are saying here, Jason's
code only disables preemption with busy wait, I can't see why it can
not be used in the process context.

Thanks.
