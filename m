Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88A8415381
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 00:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbhIVWfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 18:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhIVWfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 18:35:03 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F7FC061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 15:33:32 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w11so2709321plz.13
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 15:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=ueUIVWZtuVo7JRyI3K5iP8YUgY0UI0+lod+jGWGoO6s=;
        b=N32bLN0ZOv/wt/PZun7Aik5LyQ8S1yQvhKsbGq1gzz7gPjs86h0G0dblK03HOfQWso
         EUC9ee67V3BqvTTnHfnhJ2ga1BupGo7jMWlqMy6oFOHyl3WrPPAvv3i27yZMmjcfUtik
         jzI3iZ08YjsmzcAbEytXy8Vtngo3/DAZNLbIMdW7mp0fIcgxfnrGNcyW5wxcT8mtOEX/
         iUvTJjtuhXOVzfMhlz9u0Ev0PKihDF8RIEiYdpJWjaueQ4DYjqqVv04+L6FdA5BvKohN
         X7bwdnc0CcfJLF6bQMvTFxz6FmUt+HHvTsU+cU8xoXY6GPgiUDpIorXu8NjoHkiSALCE
         B4qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=ueUIVWZtuVo7JRyI3K5iP8YUgY0UI0+lod+jGWGoO6s=;
        b=uleZ6+ZP8jiK7u2loXrqsiK32ScECeiU0tOY4nxBhyAAMk9rGGCJFSqQFfTUTeBNer
         d5/Tr7zfU1dXOrm3X7AbxBZdqj2l2+aj+EPPzctn5qCCoZ6lkDUMIoP2fvLD/3M8l5ru
         KEiVNPBnrsVAyis51h+RIaHOWiGnViUO7Z6AWpPkp/8DsrbHUHvkfCLeR5uUH5t93Afb
         b5aR1pOgW21vYXrlYssgV2Q64VvhWBOpFj5QAI1w7wkrZKT7BTLOj5TePA9k3QH9DfPl
         9HcVnaAnjwzI09RN1UvH3FEAw+S7cZZAGjuzG5HswqSivDMKNHbR1UcQbeO66WgzlYkP
         RaZA==
X-Gm-Message-State: AOAM533tTfI+qj5eyoF4izseZu2jRXzJb09dbRh9nyS3krXbzvyQS/Xy
        67fM049xlX0Q7FW/FKiw3X5sq3QkgmKBIKMf5j0=
X-Google-Smtp-Source: ABdhPJwNEPaUfSTq0SSs2rCAufaYMOFEnPH+TzRtEr2eZEYzkVOee6lDvZJ5DO8QJ5n1LDFkDITyV5ZD55y3mUVUz/8=
X-Received: by 2002:a17:90b:1b0b:: with SMTP id nu11mr14036730pjb.74.1632350012239;
 Wed, 22 Sep 2021 15:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <CADZJnBbMmE-zktRyq-gZWPuEOHRLyuQRmheqKP1_HWuHRymK0g@mail.gmail.com>
 <YUuFfuowmumndWkI@lunn.ch>
In-Reply-To: <YUuFfuowmumndWkI@lunn.ch>
From:   John Smith <4eur0pe2006@gmail.com>
Date:   Wed, 22 Sep 2021 15:33:21 -0700
Message-ID: <CADZJnBaLPu=qhozN7gyof+vGGynVO=7cGfS05fEBbEj9Nmj67Q@mail.gmail.com>
Subject: Re: stmmac: Disappointing or normal DMA performance?
To:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 12:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Sep 22, 2021 at 01:48:36AM -0700, John Smith wrote:
> > I have a one-way 300Mbs traffic RGMII arriving at a stmmac version
> > 3.7, in the form of 30000 1280-byte frames per second, evenly spread.
> >
> > In NAPI poll mode, at each DMA interrupt, I get around 10 frames. More
> > precisely:
> >
> > In stmmac_rx of stmmac_main.c:
> >
> > static int stmmac_rx(struct stmmac_priv *priv, int limit) {
> > ...
> > while (count < limit)
> >
> > count is around 10 when NAPI limit/weight is 64. It means that I get
> > 3000 DMA IRQs per second for my 30000 packets.
>
> I assume it exists the loop here:
>
>                 /* check if managed by the DMA otherwise go ahead */
>                 if (unlikely(status & dma_own))
>                         break;
>
> Calling stmmac_display_ring() every interrupt is too expensive, but
> maybe do it every 1000. Extend the dump so it includes des0. You can
> then check there really are 10 packets ready to be received, not more?
>
> I suppose another interesting thing to try. Get the driver to do
> nothing every other RX interrupt. Do you get the same number of frames
> per second, but now 20 per stmmac_rx()? That will tell you if it is
> some sort of hardware limit or not. I guess then check that interrupt
> disable/enable is actually being performed, is it swapping between
> interrupt driven and polling?
>
>           Andrew

Yes, the stmmac_rx returns at the dman_own test after 10 frames for
each interrupt.

I tried to override that line but obviously, it leads to crashes.

The problem is that the hardware watchdog with its maximum value 0xff,
returns after 326us generating the interrupt. I think that it's
triggered when the internal rx fifo in the hardware block is full.

If I understand well, your suggestion is to live with the interrupt
but not do the heavy lifting in each callback, instead call stmmac_rx
every 10 or 100 DMA callback. I have tried a simple hack but it
doesn't seem to work. Perhaps I misunderstood the suggestion. I'm not
sure it's going to work because the DMA buffer needs to be emptied and
blanked at each interrupt otherwise data is going to be lost or the
driver is going to be unhappy.

Also, if I send frames of 1280x3, I get 1/3 interrupts so it really
seems to be a FIFO depth limitation.

Thank you for helping! I think that only the ST team knows the
hardware limitation and they would have some ideas of a workaround for
this specific case but they don't reply...

John
