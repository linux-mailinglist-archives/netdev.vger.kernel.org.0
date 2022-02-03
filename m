Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34D14A8C74
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbiBCTbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiBCTbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:31:18 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB184C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:31:17 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id u14so8059921lfo.11
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JQqVvqVikqEO1u7yqbqjC6RgUCpLWxsgy/Hi4ZFDcP8=;
        b=ryyZPTHC8KPsy4GpKJtFfIDG+fsHlgBpdrak9l822nb9HFY7NAdbCwTN1lwWmSyVuX
         hp07BSWBU7o6WcKkgLiLtxPXatKxLjdztqZUNsEA7oPeuhn1iKBk+kFKa5GYknW2A1u1
         /0hGrUCxQCcww3WFHMDopiWy+aDl/DKisgNd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQqVvqVikqEO1u7yqbqjC6RgUCpLWxsgy/Hi4ZFDcP8=;
        b=Iojq3hObtd8+9oyHCS64yNyrgMdU8rkaOVj1LbXtnO8CJxrE7gmI2diuIzO1eO1U3p
         1w3YgFfOWx0lkZcaOJMkUbTE+zuuhRSV8sUATQA1fiRf+Fa0UvmymGGAF5oEeUS/XTbM
         Ds/QpT8GT5k6TsOLDHugPp2FSst5vzgyD97gIHEp75wmorqwxJxuk2N4WBjKpnOPZL41
         YljzG+hnuUbxLhjngzTb8egTZAtfYBYxgv7ODue0MtZUH0/U5SpPS8HBVl8xBBWLxOZS
         gyQ+r4AX3upIL2N1qko2ype6ucr4jzCDuUGEeOBwCgIeylHSqx4LHsv74l2jD0EBJRv1
         i4dQ==
X-Gm-Message-State: AOAM533hZmEYzW24x1VHJI5CelzT4CkTTzCNkMgNEiItrXBQxMXyhvvQ
        U6esQTWRtJLTym4yFuhPRQGLt+E0HSgsrC3K8AYjkc6XMy1V8A==
X-Google-Smtp-Source: ABdhPJwHh8bAPg+UfpaWyNIvdOTov1DXLA7F/sl6AJaUjNfwTZ5RL0Zg5X5pGK/K/sI4L5J5H/tLQANcWWX+S2Dy3/w=
X-Received: by 2002:a05:6512:304e:: with SMTP id b14mr28423904lfb.154.1643916676089;
 Thu, 03 Feb 2022 11:31:16 -0800 (PST)
MIME-Version: 1.0
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com>
 <bb50fffb-afa8-b258-5382-fe56294cd7b0@redhat.com> <CALALjgyF8X3Y7CqmxWbDH2R+Pgn=6=Vs7sUCuzSEH=BxLYR7Tg@mail.gmail.com>
 <f5206993-c967-eec2-4679-6054f954c271@gmail.com>
In-Reply-To: <f5206993-c967-eec2-4679-6054f954c271@gmail.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Thu, 3 Feb 2022 11:31:04 -0800
Message-ID: <CALALjgwMnisAeNzwtGmNGzqAuWZGGtBpT2NWX1TcYZaPFvAixw@mail.gmail.com>
Subject: Re: [net-next v3 00/10] page_pool: Add page_pool stat counters
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        Saeed Mahameed <saeed@kernel.org>, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:21 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>
>
>
> On 2/2/2022 7:30 PM, Joe Damato wrote:
> > On Wed, Feb 2, 2022 at 6:31 AM Jesper Dangaard Brouer
> > <jbrouer@redhat.com> wrote:
> >>
> >>
> >> Adding Cc. Tariq and Saeed, as they wanted page_pool stats in the past.
> >>
> >> On 02/02/2022 02.12, Joe Damato wrote:
> >>> Greetings:
> >>>
> >>> Sending a v3 as I noted some issues with the procfs code in patch 10 I
> >>> submit in v2 (thanks, kernel test robot) and fixing the placement of the
> >>> refill stat increment in patch 8.
> >>
> >> Could you explain why a single global stats (/proc/net/page_pool_stat)
> >> for all page_pool instances for all RX-queues makes sense?
> >>
> >> I think this argument/explanation belongs in the cover letter.
> >
> > I included an explanation in the v2 cover letter where those changes
> > occurred, but you are right: I should have also included it in the v3
> > cover letter.
> >
> > My thought process was this:
> >
> > - Stats now have to be enabled by an explicit kernel config option, so
> > the user has to know what they are doing
> > - Advanced users can move softirqs to CPUs as they wish and they could
> > isolate a particular set of RX-queues on a set of CPUs this way
> > - The result is that there is no need to expose anything to the
> > drivers and no modifications to drivers are necessary once the single
> > kernel config option is enabled and softirq affinity is configured
> >
> > I had assumed by not exposing new APIs / page pool internals and by
> > not requiring drivers to make any changes, I would have a better shot
> > of getting my patches accepted.
> >
> > It sounds like both you and Ilias strongly prefer per-pool-per-cpu
> > stats, so I can make that change in the v4.
> >
> >> What are you using this for?
> >
> > I currently graph NIC driver stats from a number of different vendors
> > to help better understand the performance of those NICs under my
> > company's production workload.
> >
> > For example, on i40e, I submit changes to the upstream driver [1] and
> > am graphing those stats to better understand memory reuse rate. We
> > have seen some issues around mm allocation contention in production
> > workloads with certain NICs and system architectures.
> >
> > My findings with mlx5 have indicated that the proprietary page reuse
> > algorithm in the driver, with our workload, does not provide much
> > memory re-use, and causes pressure against the kernel's page
> > allocator.  The page pool should help remedy this, but without stats I
> > don't have a clear way to measure the effect.
> >
> > So in short: I'd like to gather and graph stats about the page pool
> > API to determine how much impact the page pool API has on page reuse
> > for mlx5 in our workload.
> >
> Hi Joe, Jesper, Ilias, and all,
>
> We plan to totally remove the in-driver page-cache and fully rely on
> page-pool for the allocations and dma mapping. This did not happen until
> now as the page pool did not support elevated page refcount (multiple
> frags per-page) and stats.
>
> I'm happy to see that these are getting attention! Thanks for investing
> time and effort to push these tasks forward!
>
> >> And do Tariq and Saeeds agree with this single global stats approach?
> >
> > I don't know; I hope they'll chime in.
> >
>
> I agree with Jesper and Ilias. Global per-cpu pool stats are very
> limited. There is not much we can do with the super-position of several
> page-pools. IMO, these stats can be of real value only when each cpu has
> a single pool. Otherwise, the summed stats of two or more pools won't
> help much in observability, or debug.

OK thanks Tariq -- that makes sense to me.

I can propose a v4 that converts the stats to per-pool-per-cpu and
re-run the benchmarks, with the modification Jesper suggested to make
them run a bit longer.

I'm still thinking through what the best API design is for accessing
stats from the drivers, but I'll propose something and see what you
all think in the v4.

Thanks,
Joe
