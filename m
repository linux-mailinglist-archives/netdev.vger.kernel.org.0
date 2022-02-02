Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518964A76DA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 18:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbiBBRaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 12:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiBBRaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 12:30:17 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7257EC061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 09:30:17 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id i34so556139lfv.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 09:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bWP0zmwGXXF0D2jQgGgQQYBg1XgA4WJG6Z73I2F4e0o=;
        b=MFiDGK33s5fNaI42fjwdJFTs+8uCwJqj2ldo0lW1RxYffAOoD05MkvjL0MTEugvbV4
         NgLAWsLFwveaAPPJTBxW/5Sv/lkKTxsVfvZP8H32Btz93ddka2c2+k2Kw5lXaXIscZNf
         4hcqIQBuUqfdpEpxT/nm0MGV0kj37h/FWwlJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWP0zmwGXXF0D2jQgGgQQYBg1XgA4WJG6Z73I2F4e0o=;
        b=3MHrFu5wfx/wPb1ZpwXpMHXoZjWFsNkOHxnAF/pd5snu8CHE8kG9Rgyvoazs+Ry1Ec
         oFu+uTWAlIndolDKhDEi/kTFhx1nTTiIObVrVJCMY/U5A+vbhefMffyX12nalFnPWnym
         BHJV5mu2rs5T6OuLRVAfVafplR0ccsz5gRiOPbBKLSwbyy9fCR9O5bpt7rqaZrxXodSv
         cOB4cRNH+92uipdOvJrVJcSkdQGUmW6aMeKdiEwRufUaDxhGrCfjpOzsnUnYWhym7agW
         HvIV5FRb5fIf8sjZSbXqomrwBUgtylomoAALhxJCj0o0EESDI108wxTMhfiBlY86z0KZ
         vbSQ==
X-Gm-Message-State: AOAM530t4ej/pdA/hP1Zbg/c937FvXBmUz65HFBRMvYwtcI1UMRLRc75
        M2Xq6SEG22BYbaRVG8WeNPmi6tLrr6VPqx2bDBP0Hw==
X-Google-Smtp-Source: ABdhPJwA8f6uhCH7AwUA4Kp6xQNLu5bX6dbDMGIdOCbGdJu/XvGApyOgfLTg5SFidWnrGkGAt3KME8PjI6bEYTK8yXs=
X-Received: by 2002:a05:6512:b96:: with SMTP id b22mr9681057lfv.540.1643823015668;
 Wed, 02 Feb 2022 09:30:15 -0800 (PST)
MIME-Version: 1.0
References: <1643764336-63864-1-git-send-email-jdamato@fastly.com> <bb50fffb-afa8-b258-5382-fe56294cd7b0@redhat.com>
In-Reply-To: <bb50fffb-afa8-b258-5382-fe56294cd7b0@redhat.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Wed, 2 Feb 2022 09:30:04 -0800
Message-ID: <CALALjgyF8X3Y7CqmxWbDH2R+Pgn=6=Vs7sUCuzSEH=BxLYR7Tg@mail.gmail.com>
Subject: Re: [net-next v3 00/10] page_pool: Add page_pool stat counters
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 6:31 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> Adding Cc. Tariq and Saeed, as they wanted page_pool stats in the past.
>
> On 02/02/2022 02.12, Joe Damato wrote:
> > Greetings:
> >
> > Sending a v3 as I noted some issues with the procfs code in patch 10 I
> > submit in v2 (thanks, kernel test robot) and fixing the placement of the
> > refill stat increment in patch 8.
>
> Could you explain why a single global stats (/proc/net/page_pool_stat)
> for all page_pool instances for all RX-queues makes sense?
>
> I think this argument/explanation belongs in the cover letter.

I included an explanation in the v2 cover letter where those changes
occurred, but you are right: I should have also included it in the v3
cover letter.

My thought process was this:

- Stats now have to be enabled by an explicit kernel config option, so
the user has to know what they are doing
- Advanced users can move softirqs to CPUs as they wish and they could
isolate a particular set of RX-queues on a set of CPUs this way
- The result is that there is no need to expose anything to the
drivers and no modifications to drivers are necessary once the single
kernel config option is enabled and softirq affinity is configured

I had assumed by not exposing new APIs / page pool internals and by
not requiring drivers to make any changes, I would have a better shot
of getting my patches accepted.

It sounds like both you and Ilias strongly prefer per-pool-per-cpu
stats, so I can make that change in the v4.

> What are you using this for?

I currently graph NIC driver stats from a number of different vendors
to help better understand the performance of those NICs under my
company's production workload.

For example, on i40e, I submit changes to the upstream driver [1] and
am graphing those stats to better understand memory reuse rate. We
have seen some issues around mm allocation contention in production
workloads with certain NICs and system architectures.

My findings with mlx5 have indicated that the proprietary page reuse
algorithm in the driver, with our workload, does not provide much
memory re-use, and causes pressure against the kernel's page
allocator.  The page pool should help remedy this, but without stats I
don't have a clear way to measure the effect.

So in short: I'd like to gather and graph stats about the page pool
API to determine how much impact the page pool API has on page reuse
for mlx5 in our workload.

> And do Tariq and Saeeds agree with this single global stats approach?

I don't know; I hope they'll chime in.

As I mentioned above, I don't really mind which approach is preferred
by you all. I had assumed that something with fewer external APIs
would be more likely to be accepted, and so I made that change in v2.

> > I only modified the placement of the refill stat, but decided to re-run the
> > benchmarks used in the v2 [1], and the results are:
>
> I appreciate that you are running the benchmarks.

Sure, no worries. As you mentioned in the other thread, perhaps some
settings need to be adjusted to show more relevant data on faster
systems.

When I work on the v4, I will take a look at the benchmarks and
explain any modifications made to them or their options when
presenting the test results.

> > Test system:

[...]

Thanks,
Joe

[1]: https://patchwork.ozlabs.org/project/intel-wired-lan/cover/1639769719-81285-1-git-send-email-jdamato@fastly.com/
