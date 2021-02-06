Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB75311AE7
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 05:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhBFEbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 23:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhBFE3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 23:29:22 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8CDC06174A;
        Fri,  5 Feb 2021 20:28:42 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id n7so9742217oic.11;
        Fri, 05 Feb 2021 20:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/kO59WxTah5Jbk4aAvw+fhwnlddy41PK6vTRHRR5apo=;
        b=DOO91uFtkqVXVObxoWJJSgT/Y4MSY4JiBIbGhQrfH7tLn+RZpFrvlU6w2yLBPCqzI+
         HVCuQ7yRC3jini3a4HooKPHH3CJd0HvMX0lb/Ux6bBeS2rQa1cZv69+pjonwl5FLsUeE
         cGdIaoNdSJqYZsDTnvl0Xgl9enTojc6n9yAMLaMr+xyUsvrOgdkaW9/ZPNo4koRi9seQ
         mXW0N1xrOwo0vAvO/y+Q8jGD/bRsKxaiSm+ri2Tt/hoS0dOjWACYIerVmfCTeQ2VkGMU
         seySVvR+4tWN76v8BjaRXkJYd1ft5p0r29mKPvYs154DsjOGMy/Buk7s/2rbgPjsdNuu
         /qYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/kO59WxTah5Jbk4aAvw+fhwnlddy41PK6vTRHRR5apo=;
        b=ONvWb3VqPmOoMBfVzcfoG2S0fyv8mhVr97WOnq9KuqAdnsRXxxFcmHkpA6hXPreOYg
         4A0SyGxfR8D4vcWZYDwhwISqLr+UlfechbJgABYo/YeaBzfLcVovaadJvSa1FixA9OAT
         8TOUdto/JhbCnvxBqdQb0CvoO+EsS5JuuhjeEHdX6amT8blWZmXTGcYPN7XnjYnbMF41
         NF3rVS4we41aJTCC7VIdk5pvuP4F63wwQm+SHHskDJYrPV8WECrWwwH+wFPJfYfQNEPW
         H/NxpiXgLEqY4uopsYJrIlduCz202mij7DlGh2j8o5WfcwLLUc9S4zGBpJuZ1/dc6NFP
         4wlg==
X-Gm-Message-State: AOAM530VVgX+31DR2m6HOLfA9bvupQd3x7KEHV+gugcsqzlMdbr48x/U
        CaedsEHTJQnmjM1taxzMHuKsPMqqvgc0JqwLujA=
X-Google-Smtp-Source: ABdhPJzF0tXPDHPihGXR2OVqzrk74p0HCp/axMqC1HaF9ECuIsHwWKvYprJ2lzUfbSwJqKoNPQkm1MrkMddL33eeZBc=
X-Received: by 2002:aca:e108:: with SMTP id y8mr2744280oig.114.1612585721575;
 Fri, 05 Feb 2021 20:28:41 -0800 (PST)
MIME-Version: 1.0
References: <20210206000146.616465-1-enbyamy@gmail.com> <c1eae547-aa14-8307-cb81-b585a13bbd3d@infradead.org>
In-Reply-To: <c1eae547-aa14-8307-cb81-b585a13bbd3d@infradead.org>
From:   Amy Parker <enbyamy@gmail.com>
Date:   Fri, 5 Feb 2021 20:28:30 -0800
Message-ID: <CAE1WUT5XKgi10sMaCUFqENUffgUzCF-jrAJE9z=wKkW=yP_9mw@mail.gmail.com>
Subject: Re: [PATCH 0/3] drivers/net/ethernet/amd: Follow style guide
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, rppt@kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 7:16 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 2/5/21 4:01 PM, Amy Parker wrote:
> > This patchset updates atarilance.c and sun3lance.c to follow the kernel
> > style guide. Each patch tackles a different issue in the style guide.
> >
> >    -Amy IP
> >
> > Amy Parker (3):
> >   drivers/net/ethernet/amd: Correct spacing around C keywords
> >   drivers/net/ethernet/amd: Fix bracket matching and line levels
> >   drivers/net/ethernet/amd: Break apart one-lined expressions
> >
> >  drivers/net/ethernet/amd/atarilance.c | 64 ++++++++++++++-------------
> >  drivers/net/ethernet/amd/sun3lance.c  | 64 +++++++++++++++------------
> >  2 files changed, 69 insertions(+), 59 deletions(-)
> >
>
> Hi Amy,
>
> For each patch, can you confirm that the before & after binary files
> are the same?  or if they are not the same, explain why not?
>
> Just something that I have done in the past...
>
> thanks.

At least when I tried - yes. These are just stylistic changes.
Currently using gcc version 10.2.1.

   -Amy IP
