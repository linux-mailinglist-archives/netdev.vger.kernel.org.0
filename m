Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD01E54D9
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 06:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725779AbgE1EAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 00:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725298AbgE1EAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 00:00:52 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0473C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 21:00:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id 9so7808790ilg.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 21:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UZ3/4qMMYCF6mUst5HAlHNrC/7lKbhk64SY5SN7lcMw=;
        b=Nst3wsRFQvXKwVXjJK6Po6kRwbgF/ryD15qz2Hk9qCSXPTWQ8ARboTSUJkL4Hj1B8t
         U2GGBLKqwNHTG+jK0u4i8pfnksBvyCRSp7qAWpAXwh6v6wYgesiGJyqfcW3L17iFzaN6
         KWigw1IzQYErfe7BcWXtLV+HOD2AJ2sjSDVilWeu4yM2twb7xUNVh3s7NbXnp0ERVANw
         uu5fRYaDABi/svrgdEvqQlT8fFloDRHlqMhRtszdUADjmyxnohSxX86Y9iZG6XQVtvei
         sXOFr06Ga81Ej7fPNSXwWt02tkhWlsXhpKwiNFGwtmTCABBZLM/Qo8De+7n8JsXz/1y1
         KmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UZ3/4qMMYCF6mUst5HAlHNrC/7lKbhk64SY5SN7lcMw=;
        b=N9qG826ooGU/XJEb6cLF9/U8w91qRwdhMxP0ehsqYhAbQAfFxt4UYePW2QUo4UUe3f
         EyCvzG1zjOs4eSoQsxcmOzDWAmlESyHL3LkDzrDfuDzCm+/FJ1amdTuSOX58uiT22aiy
         CCkxzB7/EAn6DfG1zdR7B+z5/fiKumTo+LAcX14a9GvqgOGFKgJ6LlLN4wsfJ4J8Bgvu
         aaQ3DpOof1OKORahRToSjRbJHqW8mr5I9hP2d9CavpExemqrxzh9WLMjmXlHFBQ/nXwZ
         kJysPzkYGasrAcJxVgE7onfsrvTERcuKzFFlkl32mtPBYvvvP/Ik3+UfDI6Di60nlQDh
         sxkg==
X-Gm-Message-State: AOAM532cKZZmljNZCpyu0McCw8+uQHefBw/+RRxkX+N422WdmLkMUG95
        9xTqb1vRRVcOl6nGZJpTUsg8eqy1z3lYz3Fo9w1bjVjS
X-Google-Smtp-Source: ABdhPJwz55fiFPJucWCd5q4j2B5OjVO3mDh8ojGY1R4UVMU/JDO05mn7WHpMVgFyaHriQeGxRV1izZtr3x2H61PzOyI=
X-Received: by 2002:a92:984e:: with SMTP id l75mr1278266ili.22.1590638451881;
 Wed, 27 May 2020 21:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <877dwxvgzk.fsf@mellanox.com>
In-Reply-To: <877dwxvgzk.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 27 May 2020 21:00:39 -0700
Message-ID: <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
To:     Petr Machata <petrm@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 2:56 AM Petr Machata <petrm@mellanox.com> wrote:
>
>
> Cong Wang <xiyou.wangcong@gmail.com> writes:
>
> > On Tue, May 26, 2020 at 10:11 AM Petr Machata <petrm@mellanox.com> wrote:
> >>
> >> The Spectrum hardware allows execution of one of several actions as a
> >> result of queue management events: tail-dropping, early-dropping, marking a
> >> packet, or passing a configured latency threshold or buffer size. Such
> >> packets can be mirrored, trapped, or sampled.
> >>
> >> Modeling the action to be taken as simply a TC action is very attractive,
> >> but it is not obvious where to put these actions. At least with ECN marking
> >> one could imagine a tree of qdiscs and classifiers that effectively
> >> accomplishes this task, albeit in an impractically complex manner. But
> >> there is just no way to match on dropped-ness of a packet, let alone
> >> dropped-ness due to a particular reason.
> >>
> >> To allow configuring user-defined actions as a result of inner workings of
> >> a qdisc, this patch set introduces a concept of qevents. Those are attach
> >> points for TC blocks, where filters can be put that are executed as the
> >> packet hits well-defined points in the qdisc algorithms. The attached
> >> blocks can be shared, in a manner similar to clsact ingress and egress
> >> blocks, arbitrary classifiers with arbitrary actions can be put on them,
> >> etc.
> >
> > This concept does not fit well into qdisc, essentially you still want to
> > install filters (and actions) somewhere on qdisc, but currently all filters
> > are executed at enqueue, basically you want to execute them at other
> > pre-defined locations too, for example early drop.
> >
> > So, perhaps adding a "position" in tc filter is better? Something like:
> >
> > tc qdisc add dev x root handle 1: ... # same as before
> > tc filter add dev x parent 1:0 position early_drop matchall action....
>
> Position would just be a chain index.

Why? By position, I mean a place where we _execute_ tc filters on
a qdisc, currently there is only "enqueue". I don't see how this is
close to a chain which is basically a group of filters.


>
> > And obviously default position must be "enqueue". Makes sense?
>
> Chain 0.
>
> So if I understand the proposal correctly: a qdisc has a classification
> block (cl_ops->tcf_block). Qevents then reference a chain on that
> classification block.

No, I am suggesting to replace your qevents with position, because
as I said it does not fit well there.

>
> If the above is correct, I disagree that this is a better model. RED
> does not need to classify anything, modelling this as a classification
> block is wrong. It should be another block. (Also shareable, because as
> an operator you likely want to treat all, say, early drops the same, and
> therefore to add just one rule for all 128 or so of your qdiscs.)

You can still choose not to classify anything by using matchall. No
one is saying you have to do classification.

If you want to jump to a block, you can just use a goto action like
normal. So your above example can be replaced with:

# tc qdisc add dev eth0 root handle 1: \
        red limit 500K avpkt 1K

# tc filter add dev eth0 parent 1:0 position early_drop matchall \
   action goto chain 10

# tc chain add dev eth0 index 10 ...

See the difference?

Thanks.
