Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7989B1FB42B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgFPOXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgFPOXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:23:39 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E606FC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:23:38 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e12so14408028eds.2
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 07:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TkCGZfrbkt372b+CAPYKwOpuDv2+GsCex7jgtMmV/XQ=;
        b=AfvmmE0eqvRdurFiuiA2kgoLowea0sfy7blPSWtRo3zFSU+IAKbYhzzRrZgYE0j6Lq
         zMvOnPGD2jrtWACPPodHw0USz+jSPjCd1CQRc7Pa/MbozgaG2j5LFeqW7P7roWbuSx6s
         uXo/LMhil+jTADxJKdbwoUfVcEnA8a5uhMB+wZ6OA5H3nA4kReSmD03EXliA/w+tKQ8m
         75Kg5qp/CHT/BOdsvucZ9yc6tAatX+CVkYiRazwLX2/DBfVYb4sYh65ak6TG8HMWaOzu
         B/wQ9lLHI1RPsdcYwmTa0WbJPoqbX/IvZKAUqeAtBTB1AgEtvYne7xWh/52nIc3gynWt
         IHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TkCGZfrbkt372b+CAPYKwOpuDv2+GsCex7jgtMmV/XQ=;
        b=fCviCxt8UdvU7ISpfWpztd20j72VdHqmHwhnmsp9VGBUPtSX6OWCD4RWD7n4doUQBR
         k33RvS9qkfY9c1PinmFJn1rzXADDK7916zovA78d+bflSuGEldoxbpPWZCOSuYLaKRHj
         9xMmJrhJZNgDtIsJAVlIHzTcqPDvnKBS70ke168O4+c5kXTBr4eFzzpyTY6W/XukZxgu
         xScxqsGv22iTQG6Ez2eZRAT+mJz+91c1ZbzkM15KS8LbySNYnDVhIgnNfXLaBPVwdaPu
         kpSl9a1H/XhnP1S1dvA2kPT6+LVscYGaC/W8YjVaG2/cNdVbRNE37tBxKBjX4iKC5d9c
         W52w==
X-Gm-Message-State: AOAM530+dfoaiAuRB4pY7ZseArqpzfw3Z7D7l7pZ8vyAUvXFTyxeKUwM
        E1+TdEt6rxcghfmbLuOOg42SUPUG7n05XhEYA8Q=
X-Google-Smtp-Source: ABdhPJxN4eBC8mXLMuNvEMcg+XNUJM63Uj3+E5t6/iJXiGuK0gS1m/haIBd2mYCPCYz5Id1/B+r48IVE7C9lHAdh8I0=
X-Received: by 2002:a05:6402:362:: with SMTP id s2mr2833466edw.337.1592317417494;
 Tue, 16 Jun 2020 07:23:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592247564.git.dcaratti@redhat.com> <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
 <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
 <fd20899c60d96695060ecb782421133829f09bc2.camel@redhat.com>
 <CA+h21hrCScMMA9cm0fhF+eLRWda403pX=t3PKRoBhkE8rrR-rw@mail.gmail.com> <429bc64106ac69c8291f4466ddbaa2b48b8e16c4.camel@redhat.com>
In-Reply-To: <429bc64106ac69c8291f4466ddbaa2b48b8e16c4.camel@redhat.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 17:23:26 +0300
Message-ID: <CA+h21hpL+7tuEX7_NCNo7NdgZ1OYqjQ03=DHuZ3aOOKh6Z4tsw@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 15:43, Davide Caratti <dcaratti@redhat.com> wrote:
>
> On Tue, 2020-06-16 at 13:38 +0300, Vladimir Oltean wrote:
> > Hi Davide,
> >
> > On Tue, 16 Jun 2020 at 13:13, Davide Caratti <dcaratti@redhat.com> wrote:
> > > hello Vladimir,
> > >
> > > thanks a lot for reviewing this.
> > >
> > > On Tue, 2020-06-16 at 00:55 +0300, Vladimir Oltean wrote:
>
> [...]
>
> > > > What if you split the "replace" functionality of gate_setup_timer into
> > > > a separate gate_cancel_timer function, which you could call earlier
> > > > (before taking the spin lock)?
> > >
> > > I think it would introduce the following 2 problems:
> > >
> > > problem #1) a race condition, see below:
>
> [...]
>
> > > > @@ -433,6 +448,11 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
> > > > >         if (goto_ch)
> > > > >                 tcf_chain_put_by_act(goto_ch);
> > > > >  release_idr:
> > > > > +       /* action is not in: hitimer can be inited without taking tcf_lock */
> > > > > +       if (ret == ACT_P_CREATED)
> > > > > +               gate_setup_timer(gact, gact->param.tcfg_basetime,
> > > > > +                                gact->tk_offset, gact->param.tcfg_clockid,
> > > > > +                                true);
> > >
> > > please note, here I felt the need to add a comment, because when ret ==
> > > ACT_P_CREATED the action is not inserted in any list, so there is no
> > > concurrent writer of gact-> members for that action.
> > >
> >
> > Then please rephrase the comment. I had read it and it still wasn't
> > clear at all for me what you were talking about.
>
> something like:
>
> /* action is not yet inserted in any list: it's safe to init hitimer
>  * without taking tcf_lock.
>  */
>
> would be ok?
>

Yes, better.

> [...]
>
> > I wonder, could you call tcf_gate_cleanup instead of just canceling the
> > hrtimer?
>
> not with the current tcf_gate_cleanup() [1] and parse_gate_list() [2],
> because it would introduce another bug: 'p->entries' gets cleared on
> action overwrite after being successfully created here:
>
> 395         if (tb[TCA_GATE_ENTRY_LIST]) {
> 396                 err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
> 397                 if (err < 0)
> 398                         goto chain_put;
> 399         }
>
>
> like mentioned earlier, 'hitimer' can not be canceled/re-initialized easily when
> tcf_gate_init() still has a possible error path. And in my understanding
> 'p->entries' must be consistent when the timer is initialized.
>
> IMO, the correct way to handle 'entries' is to:
>
> - populate the list on a local variable, before taking the spinlock and
> allocating the IDR
>
> - assign to p->entries after validation is successful (with the spinlock
> taken). Same as what was done with 'cycletime' in patch 1/2, but with the
> variable initialized (btw, thanks for catching this), and free the old
> list in case of action replace
>
> - release the newly allocated list in the error path of tcf_gate_init()
>
> (but again, this would be a fix for 'entries' - not for 'hitimer', so I
> plan to work on it as a separate patch, that fits better 'net-next' rather
> than 'net').
>

Targeting net-next would mean that the net tree would still keep
appending to p->entries upon action replacement, instead of just
replacing p->entries?

> --
> davide
>
> [1] https://elixir.bootlin.com/linux/v5.8-rc1/source/net/sched/act_gate.c#L450
> [2] https://elixir.bootlin.com/linux/v5.8-rc1/source/net/sched/act_gate.c#L235
>

Thanks,
-Vladimir
