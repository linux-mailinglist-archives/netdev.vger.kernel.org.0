Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818922BA3F7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 08:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgKTHxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 02:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgKTHxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 02:53:54 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9554BC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 23:53:54 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id l36so7958271ota.4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 23:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zyKLKzuFuFUGJB+TFB/rwYaF3iL8XCXOZFvVC5kwyvw=;
        b=ru5tiOO25/1q9AjIvriFhRXdEb47pc9+2selgB1PwmAcCT5cpM/d9yC8Kj2FApwctZ
         XXzgiulmG0vXbTeo5Pq5bfakhw69i91c1FtfPAPOeyysZTWlk/dNwVQTSBR6M+HXlGIX
         PcGWeSBBEgnbfKWGQ3yPcMFbloeqIaTI5uWVrBFKuvXQk7vxdOuXFtjKgvpXVib9eggH
         IGDhqxi4P7pvVgyZIftfUw2MTrFwZxlt01v+RZueBejOoIlm9Fk3d96X6zcXXzFWGhJ8
         aw6qYpOTWyfX03kqJL98ApPuMvgfp1V8hkX+Rf3yL6B9oH+23DcTfWdDlI0dcQJpEwr/
         TzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zyKLKzuFuFUGJB+TFB/rwYaF3iL8XCXOZFvVC5kwyvw=;
        b=LY0fwKTvmN92epfjwuLejC1XI1SKPYHhIC7uoMh9YLOtpRNRRnZTXLwuXeSR5kWYUl
         nTdJuIC6nyvDjm8YduHa/bMfaT0TTZ3ZHkZErA1Vr9bVRWooJUIEJTGT17yWvn0/pgDT
         xwUXwS6jKs6th8Y/ttv9SqxkOQsRmlOy7zCs7jj/lVLyQ9VkZFbC2WHjxHJxY7e1vO1w
         bO49FJbFctrFXsCd5NNn52rdJBzw5BEf7tmlnCX4bAh6tnXfZiGTV+EsiqS6c9KcBQuH
         tq1Ml1o4T0Jqvrbwno0VYOBR1qQZ8GcPUiUK1+3mbwOo7/jLDuoS802rydXJCykowuo3
         upaw==
X-Gm-Message-State: AOAM530agIY3kzjzL/h7d5yaOKYbIy0iywOqvPzYEj5C3SE69nwlOzRv
        BclrWOw5/+AL/TvCvuGDWxPN2XBxjhl8QDbPt24=
X-Google-Smtp-Source: ABdhPJwJp4FV+TSXBP63vXTJsHfC7J2Trfx2q4XVUq/J1U6idSsSFi8cdWMNJWagszw78zXPIE8w/cjpJkOIm9ammRk=
X-Received: by 2002:a9d:7392:: with SMTP id j18mr13194630otk.288.1605858833991;
 Thu, 19 Nov 2020 23:53:53 -0800 (PST)
MIME-Version: 1.0
References: <CAMeyCbh8vSCnr-9-odi0kg3E8BGCiETOL-jJ650qYQdsY0wxeA@mail.gmail.com>
 <CAMeyCbjuj2Q2riK2yzKXRfCa_mKToqe0uPXKxrjd6zJQWaXxog@mail.gmail.com>
 <3f069322-f22a-a2e8-1498-0a979e02b595@gmail.com> <739b43c5c77448c0ab9e8efadd33dbfb@AcuMS.aculab.com>
 <CAMeyCbj4aVRtVQfzKmHvhUkzh08PqNs2DHS1nobbx0nR4LoXbg@mail.gmail.com>
 <CAMeyCbjOzJw7e3+e-AwnCzRpYWYT5OjFSH=+eEsZcEBrJ4BCYg@mail.gmail.com>
 <AM8PR04MB7315635D8FFC131B04B25E00FFE50@AM8PR04MB7315.eurprd04.prod.outlook.com>
 <CAMeyCbiuFAtqpUTtrPx3Afp_Hc41nZTzq0US7vg5HXwPp6SdFQ@mail.gmail.com> <AM8PR04MB7315A098BBB4AF823009382FFFE40@AM8PR04MB7315.eurprd04.prod.outlook.com>
In-Reply-To: <AM8PR04MB7315A098BBB4AF823009382FFFE40@AM8PR04MB7315.eurprd04.prod.outlook.com>
From:   Kegl Rohit <keglrohit@gmail.com>
Date:   Fri, 20 Nov 2020 08:53:43 +0100
Message-ID: <CAMeyCbgAFsySM5Jb-rnbR3tV3vVMDRa+DDdwAiCmbRj15gexzQ@mail.gmail.com>
Subject: Re: [EXT] Re: Fwd: net: fec: rx descriptor ring out of order
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 8:48 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Kegl Rohit <keglrohit@gmail.com> Sent: Sunday, November 15, 2020 1:37 AM
> > On Sat, Nov 14, 2020 at 2:58 AM Andy Duan <fugang.duan@nxp.com> wrote:
> > >
> > > From: Kegl Rohit <keglrohit@gmail.com> Sent: Friday, November 13, 2020
> > > 8:21 PM
> > > > On Fri, Nov 13, 2020 at 8:33 AM Kegl Rohit <keglrohit@gmail.com> wrote:
> > > > >
> > > > > > What are the addresses of the ring entries?
> > > > > > I bet there is something wrong with the cache coherency and/or
> > > > > > flushing.
> > > > > >
> > > > > > So the MAC hardware has done the write but (somewhere) it isn't
> > > > > > visible to the cpu for ages.
> > > > >
> > > > > CMA memory is disabled in our kernel config.
> > > > > So the descriptors allocated with dma_alloc_coherent() won't be CMA
> > memory.
> > > > > Could this cause a different caching/flushing behaviour?
> > > >
> > > > Yes, after tests I think it is caused by the disabled CMA.
> > > >
> > > > @Andy
> > > > I could find this mail and the attached "i.MX6 dma memory bufferable
> > > > issue.pptx" in the archive
> > > > https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fma
> > > > rc.info
> > > > %2F%3Fl%3Dlinux-netdev%26m%3D140135147823760&amp;data=04%7C
> > 01
> > > > %7Cfugang.duan%40nxp.com%7C121e73ec66684a125e2a08d887cea578%
> > 7C
> > > >
> > 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637408668924362983
> > > > %7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIi
> > LCJ
> > > >
> > BTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=e7Cm24Ay1Ay52UKtzT
> > > > BiX9KlhuublndP30vnwxAaugM%3D&amp;reserved=0
> > > > Was this issue solved in some kernel versions later on?
> > > > Is CMA still necessary with a 5.4 Kernel?
> > >
> > > Yes, CMA is required. Otherwise it requires one patch for L2 cache.
> >
> > Where can I find the patch / is the patch already mainline?
> No, the patch is not in mainline. CMA can fix the issue.
>
> The original patch is: set shared override bit in PL310 AUX_CTRL register
>
> > Is it some development patch or already well tested?
> > Or would you recommend enabling CMA instead?
> > Are other components affected apart from the already mentioned peripherals
> > (ENET, Audio, USB) in the attachment?
> Yes,  recommend CMA that can fix the cache issue for all components.

Ok, thanks. One more Question: The kernel's default CMA size is 16MB,
is this enough for a headless system without usage of the IPU?
