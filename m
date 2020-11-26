Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789542C4E2C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 06:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgKZFOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 00:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgKZFOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 00:14:42 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6174CC0613D4
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 21:14:42 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t37so707834pga.7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 21:14:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+mO7kKOcX864rYxK+E8x7m2LZ3qPCgNQ1vMVCeSRc9U=;
        b=Nc1cjkjCTdM1Tp3jaJlgkyJzrGjWhvOzH2hUKosYTmoRbGG0jSEcEPFY0xnViYJtGy
         qrK8W/NZPWnjplkpwZ4lsyCyTIDFPBrgi+NiRW8ZfbvfRIjH63idAJD1SIs5dqXE4X/f
         HaW8SUPfR7viWzlf27f0UJtWSYvSuTbH/LX/mPClTg/H4qD52e5TuYo2s5rqv96CP8/1
         0G3SbKc3C8uH1ak94KSxqTzEWbXUzMja3Cz4dhixjhgGsZ4LlXwb9x3I7SWikdWdOEZr
         D+Mu/eMO6IZDI2qsBR9f06gI4/Ypv+5x7h4njdcX8o9wWQ+8c0JKj/rx4E4+4HLhkK70
         VafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+mO7kKOcX864rYxK+E8x7m2LZ3qPCgNQ1vMVCeSRc9U=;
        b=fK47P2U9hqcXByw7C5ohKRcIarTcsjwLcdOZ4io1yrAqNiZG0qS7NBUs3XfhlfxEw8
         oYBf60b7HBZ2CyqHW92FKIw5JxYL+L3MqIoQfZnFAl9QMFlKEtcja0f4WxtG30TXbNUz
         OxlQ+u4i93FmIWH+ywOBRBMItEXR07zbDavjzvYq1jkXCpWN3rQ2wwtaIHIYGY/GqhYQ
         3rKCDuWTYNNuBUFjZcHjZaPjb0gKLnbG1zn27rMM3lVppbrxcfWAhov5N39xhJPiq+v4
         Kr63I8zSP2/KMa5UQxY0qVTTnzlc2D2pA0CmOtiLAoqG1uQoFH74rVBDuGfvgC5AZLXk
         fBow==
X-Gm-Message-State: AOAM533lnxEYrUz1oCxCfSj5GIN1SF9beM5/kmT2Hqd1mHcXMFWatGIU
        OPEfpaSBtB2R7XpQkQ8KPgPOp8byoP6RV2U755I=
X-Google-Smtp-Source: ABdhPJz6mPjJZAX7Sm6GQP+hRB9tuN+J0m+U9qXkgR3aF0kk2yx45uwf9ZpBsu+6VDylGvuyOHKC2POhpgizIVfcZyw=
X-Received: by 2002:a17:90a:de81:: with SMTP id n1mr1647286pjv.52.1606367681808;
 Wed, 25 Nov 2020 21:14:41 -0800 (PST)
MIME-Version: 1.0
References: <1606276883-6825-1-git-send-email-wenxu@ucloud.cn>
 <1606276883-6825-4-git-send-email-wenxu@ucloud.cn> <20201125200407.GB449907@localhost.localdomain>
In-Reply-To: <20201125200407.GB449907@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 25 Nov 2020 21:14:30 -0800
Message-ID: <CAM_iQpUmQt-264XNjaXaU4EbDmM3ub=8r-LKwMbF7dFgi99DRw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 3/3] net/sched: sch_frag: add generic packet
 fragment support.
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     wenxu <wenxu@ucloud.cn>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 12:04 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Wed, Nov 25, 2020 at 12:01:23PM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> >
> > Currently kernel tc subsystem can do conntrack in cat_ct. But when several
>                                                typo ^^^
>
> > fragment packets go through the act_ct, function tcf_ct_handle_fragments
> > will defrag the packets to a big one. But the last action will redirect
> > mirred to a device which maybe lead the reassembly big packet over the mtu
> > of target device.
> >
> > This patch add support for a xmit hook to mirred, that gets executed before
> > xmiting the packet. Then, when act_ct gets loaded, it configs that hook.
> > The frag xmit hook maybe reused by other modules.
>
> (I'm back from PTO)
>
> This paragraph was kept from previous version and now although it can
> match the current implementation, it's a somewhat forced
> understanding. So what about:
> """
> This patch adds support for a xmit hook to mirred, that gets executed
> before xmiting the packet. Then, when act_ct gets loaded, it enables
> such hook.
> The hook may also be enabled by other modules.
> """
>
> Rationale is to not give room for the understanding that the hook is
> configurable (i.e., replaceable with something else), to cope with v4
> changes.
>
> >
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> > v2: make act_frag just buildin for tc core but not a module
> >     return an error code from tcf_fragment
> >     depends on INET for ip_do_fragment
> > v3: put the whole sch_frag.c under CONFIG_INET
>
> I was reading on past discussions that led to this and I miss one
> point of discussion. Cong had mentioned that as this is a must have
> for act_ct, that we should get rid of user visible Kconfigs for it
> (which makes sense).  v3 then removed the Kconfig entirely.
> My question then is: shouldn't it have an *invisible* Kconfig instead?
> As is, sch_frag will be always enabled, regardless of having act_ct
> enabled or not.
>
> I don't think it's worth tiying this to act_ct itself, as I think
> other actions can do defrag later on or so. So I'm thinking act_ct
> could select this other Kconfig, that depends on INET, and use it to
> enable/disable building this code.

Yeah, I think compiler is able to compile out unused code with LTO, so
probably not a big deal here.

Thanks.
