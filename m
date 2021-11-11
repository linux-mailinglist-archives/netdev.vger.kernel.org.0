Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC70744DB4B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbhKKRyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhKKRyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 12:54:24 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61687C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:51:34 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id x15so27297721edv.1
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 09:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mPO8fHybtftQS6GQjnKEKx2XYyWGVl7seTcjqXTdlDQ=;
        b=O0ofJiB8oWr7MgQ4UXkxRgrco24zEqCtJxu/YDEYNCYTqNaG8Mm7Goh73rLqhuz9eo
         fLtQidODte45aTNY8mzS9YRbHZp7NEUrYwR5CqmdR13u9ztg+XliP5ymXSrqtu0HpIgL
         0npwWwAsTD+BTCqjZq6OietIKcXW5rRUb87Os=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mPO8fHybtftQS6GQjnKEKx2XYyWGVl7seTcjqXTdlDQ=;
        b=w8N+688AHIU+h3pQeu7SNzV2NKrvfIinUE80zYKHGJBR5tKvrxiWoRQRsmeZe5XxaU
         nqahXKtKVTIBH7r3bv5TyAXbDF4NzEjeDvtr4SJEdFxot4u6JsJhIdwKnfdydPHGd7qy
         fMU0in0LIlNegpAQJYvbpl4PBWE8GVBETtVoPD5Ob+7QQs8ZYgqQZ2UkI3gDKGdtKF2R
         h+uEQNvw8102I65+s4l8pL15ChS8AuZCyXTxTSI8/EE68k+OpnJ2g2UbPkW5/FoLJ6NV
         +TrTgwG50hru1+PRbJHh89KEV934V21R1i1QVFVcJPTiuftVpRSU9PSf8+Q4GXFS0rkp
         GMtg==
X-Gm-Message-State: AOAM532N3jLIfOtxP7QkGHv2k4uhclp1pdb0KOFdXok7ZA9llch7+Mwx
        ZoNMV0bRBqlAh6rml/QQuWjnxk0vNLS56pUVqVcplGmOT2F64IjSOIU=
X-Google-Smtp-Source: ABdhPJzJV8PY3mHzQZy+v8AIZ1QyCoERmBlLuqHBR1+CkjmTIXsy0BPMIwLhypmrlsdNt9kVCJ3PB6DNxi7wstm3eXQ=
X-Received: by 2002:a50:e608:: with SMTP id y8mr11916743edm.39.1636653092948;
 Thu, 11 Nov 2021 09:51:32 -0800 (PST)
MIME-Version: 1.0
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com> <20211111094837.55937988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111094837.55937988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date:   Thu, 11 Nov 2021 20:51:20 +0300
Message-ID: <CAJqdLrrY9zfk_i3fUhCORY33xpFPX8k4ZKWkVsL2D8sPMnNEZw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jakub,

Thanks for your attention to the patch. Sure, I will do it.

Please, let me know, what do you think about RTNH_F_OFFLOAD,
RTNH_F_TRAP flags? Don't we need to prohibit it too?

Alex

On Thu, Nov 11, 2021 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Nov 2021 19:02:40 +0300 Alexander Mikhalitsyn wrote:
> > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > index 5888492a5257..c15e591e5d25 100644
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -417,6 +417,9 @@ struct rtnexthop {
> >  #define RTNH_COMPARE_MASK    (RTNH_F_DEAD | RTNH_F_LINKDOWN | \
> >                                RTNH_F_OFFLOAD | RTNH_F_TRAP)
> >
> > +/* these flags can't be set by the userspace */
> > +#define RTNH_F_REJECT_MASK   (RTNH_F_DEAD | RTNH_F_LINKDOWN)
>
> You should probably drop the _F_ since RTNH_COMPARE_MASK above
> does not have it.
