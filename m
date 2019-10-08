Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DCACF137
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 05:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfJHDVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 23:21:51 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46415 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729772AbfJHDVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 23:21:51 -0400
Received: by mail-ot1-f68.google.com with SMTP id 89so12838819oth.13
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 20:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ImABIl3ZwV5K1Z+VbdjptqXHViepAwOUeT513TQ6wXA=;
        b=SCHXC8HQ8ke0PaCcDNURCqOEtbsTzPfWD6idtQP9wgSSYx7jjV/voxjBJd4S6y0t/1
         dmkDdaBPPqxbOhDDy+FghXSXAQRgEWB1HisNoVdxGaK4AgnjKHl1oBWvRB5viW+X2EQj
         bfO2E3vSgXZcf8X2O/nUyAFBaULnHWC4c+3aPtJozFgx3IGudpnclLgndxXorMEAYKPk
         pWdSitGc+Ccv0BPBTEOKnTvN/iMTErugm5GoN1/luPKSHbo/j9xl5n6LpBS8yc7b1msy
         UOSzGD/1KkoidRLIZEoU5o0/fiVFxP1k6mm7FtKHyNmS2kDbcZIcvFMur5rZxszO5e7q
         BUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ImABIl3ZwV5K1Z+VbdjptqXHViepAwOUeT513TQ6wXA=;
        b=MAcVD1z2Cdy5UpZ86n8oZcuYgPK5dkLmEwhV+KQeTpyrhAfF9ex8njytKA+AUe0yO9
         25KQNzCJ4M6gVNEmnZyISajyd139gyPJsqHlLynbQxjHfjYFxibvawGfAMW/oEXyTx7p
         qyarpfczdSHPiWMGiKc543RgYf5kayIvzVrcjYqJekYCZoYQOdqbAkdCfhHKeIi9BqyB
         IxEYO4VWlKUPtT6Eu6B6csEzMH0zQRCHVe6RTx1IxVOXFT8e05Htr5eAeMdXWCG/0NC+
         AzKkGs9kLWwIE8uKmkVHv7PJQLpO+ctHER93VoXZcNjfBEQ35+dq03jxVP+nWSpgh3bI
         MYdw==
X-Gm-Message-State: APjAAAVT5v2JyOCjkvvEtnK0eJ5x/IqQupDU95FmynLcygGFGTSqPcmE
        0W1Bc+WOkfoxkNKAnPovsfyRpC9i62ArPvzShoV+Kw==
X-Google-Smtp-Source: APXvYqzJ3BjXb8yo2j6NWI+7t/H9sqZCXiO6lC5hvY0bXgo6j3VCs5RhQ39Ah5jSYAMUOlpmIkySqV28bUoMgKiN5PA=
X-Received: by 2002:a9d:1b21:: with SMTP id l30mr22906077otl.336.1570504910157;
 Mon, 07 Oct 2019 20:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
 <1569777006-7435-8-git-send-email-xiangxia.m.yue@gmail.com> <CAOrHB_COPWe2TERGPb_KS6W=Vt6vXzAmKKEUrdbf9q_gatJa8A@mail.gmail.com>
In-Reply-To: <CAOrHB_COPWe2TERGPb_KS6W=Vt6vXzAmKKEUrdbf9q_gatJa8A@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 8 Oct 2019 11:21:51 +0800
Message-ID: <CAMDZJNVZCmfSoJURTzzWdQAKuYWr4g=BPAoA5jnd7cyrej6kZg@mail.gmail.com>
Subject: Re: [PATCH net-next 7/9] net: openvswitch: add likely in flow_lookup
To:     Pravin Shelar <pshelar@ovn.org>
Cc:     Greg Rose <gvrose8192@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 10:07 AM Pravin Shelar <pshelar@ovn.org> wrote:
>
> On Sun, Sep 29, 2019 at 7:09 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > The most case *index < ma->max, we add likely for performance.
> >
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  net/openvswitch/flow_table.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
> > index c8e79c1..c21fd52 100644
> > --- a/net/openvswitch/flow_table.c
> > +++ b/net/openvswitch/flow_table.c
> > @@ -526,7 +526,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
> >         struct sw_flow_mask *mask;
> >         int i;
> >
> > -       if (*index < ma->max) {
> > +       if (likely(*index < ma->max)) {
>
> After changes from patch 5, ma->count is the limit for mask array. so
> why not use ma->count here.
because we will check the mask is valid, so use the ma->count and
ma->max are ok.
but i will use the ma->count in v2.
>
> >                 mask = rcu_dereference_ovsl(ma->masks[*index]);
> >                 if (mask) {
> >                         flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
> > --
> > 1.8.3.1
> >
