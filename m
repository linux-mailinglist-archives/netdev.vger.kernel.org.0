Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9CC32D390
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbhCDMu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233488AbhCDMux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 07:50:53 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12563C06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 04:50:13 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id t16so7566406ott.3
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 04:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JdmCgqxTyfY5I9xDaY/BPP2iZJNza/9ewn2ak7RkY8c=;
        b=IRqibLQDdwElfOKotXOyk6Xm69sPl8sxQuqV9clOuFIxG9QXGOKdMTyqASjrHoAlc5
         XbAzsS49oadxgoJZy1EUjRNB1HpeOMOPzkrh0336mMM4eax9oQyhJxO2OOK2e1LMMHxV
         yH+o8/uUl2nRK/2lJS8ur7FNb0oPpl+ZtRZYP+si94EBqxYY5jLvvM4QRyPQ5JaWY/lS
         QpulFo5IaziPPl5MSdGCUdqvZDGubjyrymWtl4cZQJ6Eh/4ZPJGUhJh4K55c5Xr1LfWR
         AcCy6zPrb8C1Uq9tk1XIqOAbpbZZyyCiacXm3xPaWFcTMngYTQjwzsXF7xIiyRqACxjD
         A7vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JdmCgqxTyfY5I9xDaY/BPP2iZJNza/9ewn2ak7RkY8c=;
        b=HfAxof5ufg0PusPZ8G6HezHLDhMOfDxOWckiMOxMw51eyLsfBW9fE5/XLUfTDRYV+L
         SbGPS1Ei08gRagd6Swb0KCpYdDugfm6rrVZWnrAilorNV6jFTHQyvw6I1zN6yrSJlCjs
         GUMeXBqjb8X0xoX80ZMWZX1yu67CEALqLb1ao5rjtv0utMJ3x9mMTD+zmom6muXUnXWY
         1HQTrIvej5wSYUZSAQE4WuR2BXMiHMP5JYS8Wd5rJvTF/zjZYZvmYx5xu6aAWt7uy90l
         4z4yBGZz4OcSGKU3Dvw+W+cCAgsj9oGFsQofjIKcMteZWQFd920DxH6Wl7tndIdt20pk
         FNaw==
X-Gm-Message-State: AOAM533VMR3sOBvze04i9Ejc6kHi7z1RFv569NCY3/XeLOO8QusfLWgr
        NALY7NB5InY+4QBacUvm2gCtz0dQ1CMkmFsINDY=
X-Google-Smtp-Source: ABdhPJzbhicuu49yichXDV8SMjyqQgf9w6HbwCQwnIXpL+ttX6kIA914/CgbcAIy4idZZ7+voPTafSCOvktvmmlDhkY=
X-Received: by 2002:a9d:6e17:: with SMTP id e23mr3389238otr.38.1614862212533;
 Thu, 04 Mar 2021 04:50:12 -0800 (PST)
MIME-Version: 1.0
References: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
 <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Zbynek Michl <zbynek.michl@gmail.com>
Date:   Thu, 4 Mar 2021 13:50:01 +0100
Message-ID: <CAJH0kmyTgLp4rJGL1EYo4hQ_qcd3t3JQS-s-e9FY8ERTPrmwqQ@mail.gmail.com>
Subject: Re: [regression] Kernel panic on resume from sleep
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks good so far, but need to wait some more time as the issue was irregular.

Do you have any explanation why the calls disorder caused the panic
just occasionally?

Also, the same (wrong) order I can see in the 3.16 kernel code, but it
has worked fine with this kernel in all cases. So what is different in
5.10?

Thanks
Zbynek

On Wed, Mar 3, 2021 at 2:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 1 Mar 2021 23:11:05 +0100 Zbynek Michl wrote:
> > Hello,
> >
> > Can anybody help me with the following kernel issue?
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=983595
> >
> > Do I understand it correctly that the kernel crashes due to the bug in
> > the alx driver?
>
> Order of calls on resume looks suspicious, can you give this a try?
>
> diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
> index 9b7f1af5f574..9e02f8864593 100644
> --- a/drivers/net/ethernet/atheros/alx/main.c
> +++ b/drivers/net/ethernet/atheros/alx/main.c
> @@ -1894,13 +1894,16 @@ static int alx_resume(struct device *dev)
>
>         if (!netif_running(alx->dev))
>                 return 0;
> -       netif_device_attach(alx->dev);
>
>         rtnl_lock();
>         err = __alx_open(alx, true);
>         rtnl_unlock();
> +       if (err)
> +               return err;
>
> -       return err;
> +       netif_device_attach(alx->dev);
> +
> +       return 0;
>  }
>
>  static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
