Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C07737B3A7
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 03:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhELBqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 21:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhELBqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 21:46:48 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D6EC061574;
        Tue, 11 May 2021 18:45:40 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id b131so28831229ybg.5;
        Tue, 11 May 2021 18:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RY0FbXeciXf+eRiGZwpaJiiBkIF1cUE9AZQITZCXRqc=;
        b=hqsmcTeyhcB4qkRP0Ook5eInotR55pdtCp+QGsKkpEjTqe4jLjUpoX7qLLxfegbIvs
         4VBRvZVTsfOWZNDuP4Eefm6Ef7MngT82TWzcQcPIO+wMvFijt9oS/xhOwRtFHnGstSs1
         dRfWkiadpVYncRDA1TLKc5EPL3fCbmPKGePfD6Qn8Cd4ZVPb9+C28uYSJJ1NQDkPzryl
         VcKOtWWnTCg28WvdRJxSUkcXtSZNYCFEtuvlI541LH8PuREDpBrDdk/myw1K+H8USp+C
         SGoWp8vpDZdI7Hr8H0rulwOGKfwLje7UASQCqzrpTloYSkVB9qL/amrAU+5lTICaujT1
         dlnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RY0FbXeciXf+eRiGZwpaJiiBkIF1cUE9AZQITZCXRqc=;
        b=Sl7/b2Kr10LgTvrD5KvEiKoKNGQ0YqwcX9gGZWsvbzXD8emd7Ts6kelXq0ISOFY049
         gH75dpo7WSD6D5hRvRxqIgm1dm+rY62ZlXrVpl73WDN7fvA3VgsHCDjm0+YAluFnL8jV
         Ml+Ru08pW3aupXilaFO5yjs3iVBa++W8sGrnbJ7SxbxuqHY+n5QAQzKiEFdpOLDhxR5V
         noFX+bbA82r4nPWshR0FHqmQBfnWskDrraYJT1ERF0LZPCvazGr/eGgDQyMKoX16hxn1
         DEpjlH3gwTgu304ekdeF6OOgCAu/BAROeGilaD4GThbkRsDYhOAcVsrpYbGtq6EZRvKB
         eW+w==
X-Gm-Message-State: AOAM532E4TAVov7sGWK83IdvMe6a5Rd0iB4qHR5JAHMsVv04+yD19zNN
        gcFuOe0SCAb51sI5E/mj0BawShYhfQ2nLKBXzKX43hH46htuLA==
X-Google-Smtp-Source: ABdhPJxcsE174J00MC05n2r68fpE8bueRLTGQX26HZgYtE78lnMjDKuJzY3CWaeKVJVUv0VjqpYk4G5IWPREEuR0+m0=
X-Received: by 2002:a5b:3c2:: with SMTP id t2mr44069877ybp.39.1620783939211;
 Tue, 11 May 2021 18:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210511225913.2951922-1-pgwipeout@gmail.com> <YJsl7rLVI6ShqZvI@lunn.ch>
In-Reply-To: <YJsl7rLVI6ShqZvI@lunn.ch>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Tue, 11 May 2021 21:45:27 -0400
Message-ID: <CAMdYzYrbzk60=XvU4dEeb9QriKDXD1bDEbL86nD+yZjbik-E3g@mail.gmail.com>
Subject: Re: [PATCH v2] net: phy: add driver for Motorcomm yt8511 phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 8:48 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, May 11, 2021 at 06:59:13PM -0400, Peter Geis wrote:
> > Add a driver for the Motorcomm yt8511 phy that will be used in the
> > production Pine64 rk3566-quartz64 development board.
> > It supports gigabit transfer speeds, rgmii, and 125mhz clk output.
>
> Hi Peter
>
> Please can you add minimal RGMII delay support. Trying to add it later
> generally end up in backwards compatibility problems.

It should be possible, yes.
I experimented a bit with it but it just broke things.
I'm still digging through the datasheet to find what is possible for this PHY.
A lot of items should be set up via the device tree, though it seems
this is a relatively unused concept in the net phy subsystem.
As I'm relatively new to this subsystem I'm still learning as well.

>
> Do you know which one of the four RGMII modes your setup needs? Is the
> PHY adding the Rx and Tx delays? So "rgmii-id"?

By default it implements a 500ps delay internally on the txd clock and
a 1.2 ns delay on the rx clock.
The controller is the snps,dwmac-4.20a, and it implements a default
delay as well.

I'd like to eventually support as much as possible.
For instance it seems to support cable testing.
What I've done so far has been through trial and error, but I'd prefer
a more scientific approach.
I need to be able to test that functions work and would need someone
who's experienced with network phys to assist.

>
>        Andrew
