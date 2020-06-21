Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BE5202A0F
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 12:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgFUKbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 06:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729732AbgFUKbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 06:31:00 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FC4C061794;
        Sun, 21 Jun 2020 03:31:00 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c16so1146958ioi.9;
        Sun, 21 Jun 2020 03:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LsMCxRhdCW91CmwifYJvdAgyVM3T+RUgnr+kb3EmnFs=;
        b=SU1pgQI52ABIdOpJdSBMfxpi17aWi2VVmCyCts8803J66mBP10FI+0zBPbX/6OU63+
         SxrTicKKv36NpESSKXTBZVRyMOyVbag3Hx72KXQhkXAW7XXKIQxOkbCsALJGUrR52cVv
         A1HaEUHXGVUNZ2221m3ZwzwM/wTzVLBqO7mHVJ9ASXIBmIQM71hfXunqMzOoB8/QNZIV
         cJDIJwikKyD8JPzIpjjpFPsqjG8U1GgmzdH+PJE16NrpmgGMLn5Nm7NGcCeUIYxcj/oS
         9xvLFkCtbS2gq8BM7pxVT9oYe1Lj2sANQjBnCSpx4XcaQ8tzZoVCwpYHmKFO/YkiEHic
         SOXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LsMCxRhdCW91CmwifYJvdAgyVM3T+RUgnr+kb3EmnFs=;
        b=kgw2X9uRh2G+d4mVLFtsgmK+DR6co/w9b2SiR/ofIkD1Y2exaFb4zJR3e/y5iZHZdT
         GdA42rXp1CD2COIpreL/XdkO6prCti4J4Rz/WEvlFcIr13Zyw5Xf4kCzt+rtssZKfP0C
         0pkKY1tCdDHUTi1T+mMrorlm5/XI19EeJBdsaE8UD1RWNE0nynCd8hL9dTYvPmHfNzFd
         0WoOKESKqPAvO+r9Br+1Kswx6T/l5JagvaBUoxOfbqgZaD5GqKNqpLVHOdtpsXFiPmnR
         yYvQSmCxZ4ZXbKmgCLHYHM5RoNzmsw9MrcuB8axaN9eEJbJEnRqqMmqV0S+03g8YJuv3
         wlcg==
X-Gm-Message-State: AOAM532OGM45g7eD6LCfsT76JspUGjog940Nj366CFdpv/Jzo+orbDSR
        dzE4/mrluPJRU8I3T5/OefI4FmdW2FGxjqnQlB4=
X-Google-Smtp-Source: ABdhPJwACX5THWhrfzFfUizf/8poXPvY+ktvbys5e+P0F6hUT0iHojEazcInM0IIsXlZ409X9IGqEHsDbhC1fbtMLQ8=
X-Received: by 2002:a05:6638:d05:: with SMTP id q5mr12005630jaj.2.1592735458655;
 Sun, 21 Jun 2020 03:30:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200618190807.GA20699@nautica> <20200620201456.14304-1-alexander.kapshuk@gmail.com>
 <20200621084512.GA720@nautica>
In-Reply-To: <20200621084512.GA720@nautica>
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date:   Sun, 21 Jun 2020 13:30:20 +0300
Message-ID: <CAJ1xhMWe6qN9RcpmTkJVRkCs+5F=_JtdwsYuFfM7ZckwEkubhA@mail.gmail.com>
Subject: Re: [PATCH] net/9p: Validate current->sighand in client.c
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     lucho@ionkov.net, ericvh@gmail.com, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 11:45 AM Dominique Martinet
<asmadeus@codewreck.org> wrote:
>
> Alexander Kapshuk wrote on Sat, Jun 20, 2020:
> > Use (un)lock_task_sighand instead of spin_lock_irqsave and
> > spin_unlock_irqrestore to ensure current->sighand is a valid pointer as
> > suggested in the email referenced below.
>
> Thanks for v2! Patch itself looks good to me.
>
> I always add another `Link:` tag to the last version of the patch at the
> time of applying, so the message might be a bit confusing.
> Feel free to keep the link to the previous discussion but I'd rather
> just repeat a bit more of what we discussed (e.g. fix rcu not being
> dereferenced cleanly by using the task helpers as suggested) rather than
> just link to the thread
>
> Sorry for nitpicking but I think commit messages are important and it's
> better if they're understandable out of context, even if you give a link
> for further details for curious readers, it helps being able to just
> skim through git log.
>
>
> Either way I'll include the patch in my test run today or tomorrow, had
> promised it for a while...
>
> Cheers,
> --
> Dominique

Hi Dominique,

Thanks for your feedback.
Shall I simply resend the v2 patch with the commit message reworded as
you suggested, or should I make it a v3 patch instead?

One other thing I wanted to clarify is I got a message from kernel
test robot <lkp@intel.com>,
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/TMTLPYU6A522JH2VCN3PNZVAP6EE5MDF/,
saying that on parisc my patch resulted in __lock_task_sighand being
undefined during modpost'ing.
I've noticed similar messages about other people's patches on the
linux-kernel mailing list with the responses stating that the issue
was at the compilation site rather than with the patch itself.
As far as I understand, that is the case with my patch also. So no
further action on that is required of me, is it?
Thanks.
