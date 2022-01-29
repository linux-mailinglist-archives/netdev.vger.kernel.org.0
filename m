Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0A04A314D
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352974AbiA2SIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 13:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353017AbiA2SIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 13:08:06 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB95C0613F4
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 10:07:54 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id y15so18161803lfa.9
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 10:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1Om2Uz/QZK9qzhsKj5n8yy4r02Q5XmTjvMohS21fYI=;
        b=NRoJshM+AUSPbVTTWzQ02n6Sal4uftgo0+CzfKYmWyX82aH3IUScXi96WROEilsIyy
         9uU4ySz0WyJo/19os/e99QHuaqHIrYaApp73dZgeKY+kX3q2Zy5V9reV9qK5xTRHLV5g
         Adj6v4apwYUBq677x/xREXBVyikFJiFWS6r/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1Om2Uz/QZK9qzhsKj5n8yy4r02Q5XmTjvMohS21fYI=;
        b=WbnGuCi3bPgpB66S4LHT2fVW3boU9rRkJ56DDW+Ly0fTc6EIh5WGEhVzE8ogpCICgd
         xrgDptDQ4uxCj4EF6V/4Rg34QIDwMe57lPvGqY00scos45cfppEIK/2aFMUOHVF8aB/G
         XZUp8Ypj3OFG4eNGu3ZAhhUAjocylDkbvWqri5DI+r6ZAW3m3yHnxMEzQrWQknL78XGB
         730R2Vgmo9SCbZsKfMaYjpX7g9sd0yjS1ZzLSquCuSZJmQfYsfjZS2YJRB19BUzqC2bN
         nzLuyO0gFWzUsIrN6EAn7mYMXftn4EM6VyOldgWI69vFHdlGz9ncQ1aCO8US8iHu+lBZ
         Z8Vw==
X-Gm-Message-State: AOAM532w7HnXM/dgT2CoT/q09Bg4WUubl6/DII+/OplNPr2BrHemRTCM
        hWhiswSoTWCR5QOIHlEsWxvVYz71O3v4toNWF4vL5Q==
X-Google-Smtp-Source: ABdhPJxq8v9k8NcuJuerGB+O4OIqIMMb0HQBqfJoC5kxmZ84Ny8ZcykdmP2n6D+1owkLNvFLREguXvxQVX1BuhDvDTE=
X-Received: by 2002:a05:6512:441:: with SMTP id y1mr9594895lfk.315.1643479672465;
 Sat, 29 Jan 2022 10:07:52 -0800 (PST)
MIME-Version: 1.0
References: <1643237300-44904-1-git-send-email-jdamato@fastly.com>
 <YfJhIpBGW6suBwkY@hades> <CALALjgyosP7GeMZgiQ3c=TXP=wBJeOC4GYV3PtKY544JbQ72Hg@mail.gmail.com>
 <YfVKDxenS5IWxCLX@hades>
In-Reply-To: <YfVKDxenS5IWxCLX@hades>
From:   Joe Damato <jdamato@fastly.com>
Date:   Sat, 29 Jan 2022 10:07:41 -0800
Message-ID: <CALALjgzX+=rRTokT_k8grt38fJXUa+=Ed+KCkHz=BhkEquDF0w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] net: page_pool: Add page_pool stat counters
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 6:07 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> Hi Joe!
>
> On Thu, Jan 27, 2022 at 03:55:03PM -0800, Joe Damato wrote:
> > On Thu, Jan 27, 2022 at 1:08 AM Ilias Apalodimas
> > <ilias.apalodimas@linaro.org> wrote:
> > >
> > > Hi Joe,
> > >
> > > On Wed, Jan 26, 2022 at 02:48:14PM -0800, Joe Damato wrote:
> > > > Greetings:
> > > >
> > > > This series adds some stat counters for the page_pool allocation path which
> > > > help to track:
> > > >
> > > >       - fast path allocations
> > > >       - slow path order-0 allocations
> > > >       - slow path high order allocations
> > > >       - refills which failed due to an empty ptr ring, forcing a slow
> > > >         path allocation
> > > >       - allocations fulfilled via successful refill
> > > >       - pages which cannot be added to the cache because of numa mismatch
> > > >         (i.e. waived)
> > > >
> > >
> > > Thanks for the patch.  Stats are something that's indeed missing from the
> > > API.  The patch  should work for Rx based allocations (which is what you
> > > currently cover),  since the RX side is usually protected by NAPI.  However
> > > we've added a few features recently,  which we would like to have stats on.
> >
> > Thanks for taking a look at the patch.
> >
>
> yw
>
> > > commit 6a5bcd84e886("page_pool: Allow drivers to hint on SKB recycling"),
> > > introduces recycling capabilities on the API.  I think it would be far more
> > > interesting to be able to extend the statistics to recycled/non-recycled
> > > packets as well in the future.
> >
> > I agree. Tracking recycling events would be both helpful and
> > interesting, indeed.
> >
> > > But the recycling is asynchronous and we
> > > can't add locks just for the sake of accurate statistics.
> >
> > Agreed.
> >
> > > Can we instead
> > > convert that to a per-cpu structure for producers?
> >
> > If my understanding of your proposal is accurate, moving the stats
> > structure to a per-cpu structure (instead of per-pool) would add
> > ambiguity as to the performance of a specific driver's page pool. In
> > exchange for the ambiguity, though, we'd get stats for additional
> > events, which could be interesting.
>
> I was mostly thinking per pool using with 'struct percpu_counter' or
> allocate __percpu variables,  but I haven't really checked if that's doable or
> which of those is better suited for our case.

I wrote up a v2 last night that allocates and exports a
page_pool_stats structure per cpu (but not per pool). The data can be
accessed by users in the file /proc/net/page_pool_stats. The approach
is similar to the way softnet_stat is implemented.

The main advantage with this approach is that no driver modifications
are needed and no additional APIs are exposed that will need to be
maintained. Adding new stats in the future would be much simpler with
this approach. I've also moved all the code behind a kernel config
flag so users can opt-in to get these stats.

I'll send the v2 shortly.

Thanks,
Joe
