Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93DF317E768
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbgCISnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:43:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34626 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbgCISnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:43:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id z15so12583989wrl.1
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 11:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8XtaVbFU1vysQJVWrzugNCIKJ6cHKyzWu9LZ5IvRCfk=;
        b=bOd0jfTwX2VyPqrdtSfBhD3BIfT815ilin2W2tTt6S4iB7p0fnIXIeiLA0d20CmIMX
         +P14v+dBs+iUIKf+CdKMfcj9in+WTNDLZF288gx3KOattW9S0zyyyojacQ7XXUKCMibN
         jyNvZB4TBEos+r5Gf4y8v4i2QOI1bWSBTwqJXrCAWEDouxWOQmMpNxBBDa9hk+RJFl2g
         F/JRHNIrRCsC6LEI/fYy0MVmXeBBxEuy2vVgdDYX6b7FmRHTNBJhMp+yMfNOhYMgXxwm
         LLqu4/GAemFVeksDRAnjJhdDDTs8bzs8H2uwpU+gIrdxAPOGG1VCPnXBBv8LP1XlqHHk
         W9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8XtaVbFU1vysQJVWrzugNCIKJ6cHKyzWu9LZ5IvRCfk=;
        b=uF4z9WMtGNpHErl7/rNPB1A5Ei1niUXv2yblUGEJfiKNUkKWpAR7rm3Htx7N+dpJZD
         2EHjLG/lXqwRNUu1ilE1IGpiFnuogrcpyiodEKSRjn0JmpH5ROWYgbDt3vNWtZBtPNsD
         8YUaDOzPact95tj7loDWJiBZ5J7iP394EiAdaLDpyFIBYRN+zIWOFEzOBGa2skeTwJ2Q
         ESb5XYHQNf7c4X43Jnz6S2exY388gdVy7hsgoycZzs1dyaB7TZOahRcyD3znQOWk7e8E
         mFsGrD79rGsKu5wqHeHpsgjy5DBtvwKiLqh0AzMTZJk7/GLff/b2nDI0Hu+fK8iz59ks
         EIAw==
X-Gm-Message-State: ANhLgQ0bp8exU/GXdH5BIapalRIB3rsYqL4GLlGaOP3k/n+06pPe+hmR
        0tC8d8jm3+CrmpqVX7Eu9ToQRuM+oDe5g/t88cP7Vk/2
X-Google-Smtp-Source: ADFU+vuumjGpfaytEnqnXEaiD/sBRAi2s/H+Zq2FGsD8W5X2SiEAQZPlzeoY+Ff16pYtVv2Wsid31+BUE+2uRAJtwF0=
X-Received: by 2002:adf:fb01:: with SMTP id c1mr15365618wrr.357.1583779383982;
 Mon, 09 Mar 2020 11:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200305162540.4363-1-lesliemonis@gmail.com> <37e346e2-beb6-5fcd-6b24-9cb1f001f273@gmail.com>
 <773f285c-f9f2-2253-6878-215a11ea2e67@gmail.com> <e1ad29bb-7766-7c9d-3191-47a5e866e07e@gmail.com>
In-Reply-To: <e1ad29bb-7766-7c9d-3191-47a5e866e07e@gmail.com>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Tue, 10 Mar 2020 00:12:27 +0530
Message-ID: <CAHv+uoE_Q37jCY3=_k_hEoiOrD0Mm67qEd-ALO-E9QjQRkSxBA@mail.gmail.com>
Subject: Re: [PATCH iproute2-next] tc: pie: change maximum integer value of tc_pie_xstats->prob
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 11:24 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> On 3/9/20 10:48 AM, Eric Dumazet wrote:
> >
> > This means that iproute2 is incompatible with old kernels.
> >
> > commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows") was wrong,
> > it should not have changed user ABI.
> >
> > The rule is : iproute2 v-X should work with linux-<whatever-version>
> >

I'm apologize. I wasn't aware of this rule.

> > Since pie MAX_PROB was implicitly in the user ABI, it can not be changed,
> > at least from user point of view.
> >

You're right. It shouldn't have affected user space.
But I'm afraid the value of MAX_PROB in the kernel did change in v5.1.
commit 3f7ae5f3dc52 ("net: sched: pie: add more cases to auto-tune
alpha and beta")
introduced that change. I'm not sure what to do about this. How can I fix it?

>
> So this kernel patch might be needed :
>
> diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
> index f52442d39bf57a7cf7af2595638a277e9c1ecf60..c65077f0c0f39832ee97f4e89f25639306b19281 100644
> --- a/net/sched/sch_pie.c
> +++ b/net/sched/sch_pie.c
> @@ -493,7 +493,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
>  {
>         struct pie_sched_data *q = qdisc_priv(sch);
>         struct tc_pie_xstats st = {
> -               .prob           = q->vars.prob,
> +               .prob           = q->vars.prob << BITS_PER_BYTE,
>                 .delay          = ((u32)PSCHED_TICKS2NS(q->vars.qdelay)) /
>                                    NSEC_PER_USEC,
>                 .packets_in     = q->stats.packets_in,

Thanks. This is a much better solution.
Should I go ahead and submit this to net-next?
I guess the applied patch (topic of this thread) has to be reverted.
