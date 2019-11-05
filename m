Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9A5F0187
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 16:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389764AbfKEPeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 10:34:17 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36350 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389399AbfKEPeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 10:34:17 -0500
Received: by mail-ed1-f67.google.com with SMTP id f7so13396274edq.3;
        Tue, 05 Nov 2019 07:34:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LzBXMbjyJbNfeN/Oz46Qs901eRdjY4SI2lRlMDYZdo=;
        b=vcdJ/JW/Yrn0n3G3bBU5K/2myQ4vrKqmrpaAPJboRHpbA8lamPSmoE7g3Ac/zgIOjO
         u4+6qvN7MT0onfnkOn9SMx4mfowdt/vB/Vf/09z2qO4S+oRv6HIm169XckUD1evEdNPj
         kO6HC8qnB05u2RaSUFeUqW5S+KLp9MDeDP+Aj37Hk7BUZ9vOmMUZPQimFC0qglo8CNbX
         Od96fD396R3qyj+QzSBsegU72IovXYHE9hE1B8BLGzwV+nSzYwg/76q2twdSNWw3dbxc
         IltJ6XWjF15KYcXmy4zFfAX0awEZzIJREd2T/TXz6gj1KXBvH4f2KRBanRngvPe7PF5D
         VS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LzBXMbjyJbNfeN/Oz46Qs901eRdjY4SI2lRlMDYZdo=;
        b=KAGpEKmTre1OlTS7JU5tdajit9qm/xRYDklxjQ7827uYcG16uUk+WIId9AkJOQMX7n
         p7JwrfeF9PIsM83d9dBiRVSzULOZzPnYj0K2WN7qD+DGZA4No91OYih2wcvBwZEL/rpa
         hMc+/Ffc2WGT2WHG8P9/QyezUF3N5IQvRWCHaIEGRq9S2zpWzL2rwC8gmy+5AFgX6SOq
         l+kH/JPxgzySHOZNk9Htd236r9NYFjo9UZ4KhRAagM+YqF9K+GohThvtDFFpGEEQIm98
         GHZUtfsyB+sM9jZzBDFbvjXmEz4bo9VxlcQfMXFm6HYCtl5jGfD6q/EThd85twO8o9im
         6kPA==
X-Gm-Message-State: APjAAAXyYwvM6VKFVu3XRvJJ7+bYv1CzcHNmU2Nog6JpFa6tcHD1tZb0
        tIwJP0Wvul4JdX+7vPN9MvUhMDJdT17Jx3g4aL4=
X-Google-Smtp-Source: APXvYqyAJep6ni7Uh6iDPEjqxWG2butQWdZImrDsNHnXCxzNemkwzCrGq+m4iCObM3QeTYSqACE88qIWH6767jahiuU=
X-Received: by 2002:aa7:db09:: with SMTP id t9mr13381738eds.171.1572968055605;
 Tue, 05 Nov 2019 07:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20191104155000.8993-1-hslester96@gmail.com> <VI1PR0402MB36006B7BEAA7F4BCB9278598FF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB36006B7BEAA7F4BCB9278598FF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Tue, 5 Nov 2019 23:34:05 +0800
Message-ID: <CANhBUQ26kCOGJvQn2Hg9HTyZPZi5ZOcOhAsfBCUvJhU-TSM_7w@mail.gmail.com>
Subject: Re: [EXT] [PATCH] net: fec: add missed clk_disable_unprepare in remove
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 9:26 AM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Chuhong Yuan <hslester96@gmail.com> Sent: Monday, November 4, 2019 11:50 PM
> > This driver forgets to disable and unprepare clks when remove.
> > Add calls to clk_disable_unprepare to fix it.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>
> If runtime is enabled, the patch will introduce clock count mis-match.
> Probe->
>     Enable clk_ipg, clk_ahb clocks
>     ...
>     In the end, runtime auto suspend callback disable clk_ipg, clk_ahb clocks.
>
> You should check CONFIG_PM is enabled or not in your platform, if not,
> it can disable these two clocks by checking CONFIG_PM.
>

Thanks for your hint!
But I am still not very clear about the mechanism.
In my opinion, it means that if CONFIG_PM is disabled, runtime_suspend will
be called automatically to disable clks.
Therefore, #ifdef CONFIG_PM check should be added before disabling
clks in remove.
I am not sure whether this understanding is right or not?

Regards,
Chuhong

> Regards,
> Andy
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index 22c01b224baa..a9c386b63581 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3645,6 +3645,8 @@ fec_drv_remove(struct platform_device *pdev)
> >                 regulator_disable(fep->reg_phy);
> >         pm_runtime_put(&pdev->dev);
> >         pm_runtime_disable(&pdev->dev);
> > +       clk_disable_unprepare(fep->clk_ahb);
> > +       clk_disable_unprepare(fep->clk_ipg);
> >         if (of_phy_is_fixed_link(np))
> >                 of_phy_deregister_fixed_link(np);
> >         of_node_put(fep->phy_node);
> > --
> > 2.23.0
>
