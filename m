Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC21B45D580
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhKYHf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhKYHdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 02:33:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57260C061746
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:30:10 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id y12so21401253eda.12
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 23:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zl4Mzlpe6F0HOpdj4Sl3skBw9ImGE6T+paPOveokNjk=;
        b=YWXtv5fX1y4eCm294JLj0bq0F59e43k8xrfA+D8RZU86kDbaB5pfRYZbeSFyPZxzYR
         LybsIJqdADJ41hgsh2eyDtwd3NLKvSHLGsoB7ABUDx3z/9GEeqp9Ej+GFUTKpg5ZF3SZ
         NR7XfQ6dWdRNPh01Co5SAQWD7TBhErF1P+QO3p8RyefDkGbMgN38CKrWWQFiurIKGj1z
         puCQoAuzzOoiO40mp9Znm5XyGq9NARog8azZ7G7NAr4RF/21OSCOzw0KNB4d5J4+614n
         Gmn5iw1MdYemcO25BbR0WfPShhqdVMjxIst13NCch1XqPyQs/xMhOFiKoce+X6f5F1Bb
         4tjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zl4Mzlpe6F0HOpdj4Sl3skBw9ImGE6T+paPOveokNjk=;
        b=JIHfd9PpHn0KFxKAF16P+YnwNxm5fY6s3agugg59G7e4mUMMRKcePCxWap3FQ+OMoG
         ujimRP6+IiBubSsVxkZHEuA5yZIIX4Rn9F/0H70aBrZ96rikHZ0wK8LciKOSvH+Z+UbR
         meo8mmHWfbtp1cveb8DXjKS7uXSW6QnmcHR1FTkFalAZTj4yOGMpA3niY6fLMlU2Q42X
         eTMBSxpfqp+gExRS9VgLvFwvBaocz+et0/i+jscPmH9LyWdqjaZS3kTPrKHNCcB+Zf5n
         TVIm5AaWRX+B/HNLGIZWdXCL7xayfDiVuRpyXcjNYL00Nunl0fBHF7KNPB2RGjX6KgNO
         Zu6Q==
X-Gm-Message-State: AOAM5337VPTOEitG+0rZ/J52Xzb4hTIJY9kCI/3KwacwngNcC9ibw+hN
        X+CbliF8CErfAKsFIdunJlyVrFsU5eC/eBrJdkHYrK1P0KWmjw==
X-Google-Smtp-Source: ABdhPJzBM8rNpdV9N+LD9aHK7YZ164O+1qYFeFpmEu7o44T2ClFYtJvvmwPQBqB64Z5ABHWWS2Y3MDvr60m+vyqqybA=
X-Received: by 2002:a17:906:c301:: with SMTP id s1mr29810214ejz.409.1637825408950;
 Wed, 24 Nov 2021 23:30:08 -0800 (PST)
MIME-Version: 1.0
References: <20211125020155.6488-1-xiangxia.m.yue@gmail.com> <20211124181858.6c4668db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124181858.6c4668db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 25 Nov 2021 15:29:33 +0800
Message-ID: <CAMDZJNWWYhdCUvo1FJoAOJ-=43aK6PppNas6st4bGPXUbVuDAA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] ifb: support ethtools driver info
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 10:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 25 Nov 2021 10:01:54 +0800 xiangxia.m.yue@gmail.com wrote:
> > +#define DRV_NAME     "ifb"
> > +#define DRV_VERSION  "1.0"
>
> Let's not invent meaningless driver versions.
Ok
> > +#define TX_Q_LIMIT   32
> > +
> >  struct ifb_q_private {
> >       struct net_device       *dev;
> >       struct tasklet_struct   ifb_tasklet;
> > @@ -181,6 +185,12 @@ static int ifb_dev_init(struct net_device *dev)
> >       return 0;
> >  }
> >
> > +static void ifb_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
> > +{
> > +     strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
>
> Can we make core fill in driver name from rtnl_link_ops so we don't
> need to do it in each driver?
Good idea! v2 is sent out, please review.
https://patchwork.kernel.org/project/netdevbpf/patch/20211125072544.32578-1-xiangxia.m.yue@gmail.com/
> > +     strlcpy(info->version, DRV_VERSION, sizeof(info->version));
>
> Leave this field as is, core should fill it with the kernel release.
Ok
> > +}




--
Best regards, Tonghao
