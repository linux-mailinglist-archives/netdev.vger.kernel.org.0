Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F14F110C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbfKFI3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:29:23 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40743 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbfKFI3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:29:23 -0500
Received: by mail-ed1-f66.google.com with SMTP id p59so18578387edp.7;
        Wed, 06 Nov 2019 00:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qtpUEILOEaUCVfXdaJ71r8lA3F3BG6Ju5XNHryG150Q=;
        b=WLeOSuWD368qfl5KCFcaGk7RN1KvVMq3NkhXwU+yB/udBXKobup3ROz5chDKNj0vU2
         AuX3P/vbgO925avVpyVWenjo7MjUZllDWgkj1OETAQjuPbp/MkMIFHfglEhG/ri59q+p
         Y23GdBk8Rkha6xT0fz0LJhtECu08JKxfb+HWzEYkxQbLw3t0W3kb+vfoKBuHMFlUkR9P
         hbjhdjDhaAGGqzJkJDXtcVkgRv3Pyc33GQGrQFvYk/3Ssst0tbmas7CEMUFtV81tdKFJ
         g2hZbeXvw6sUZADqJrPD8jEAyDnYd50+4W8AmpyX6vYio/qDoVb3AKv67sUbpepfIOOG
         PGZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qtpUEILOEaUCVfXdaJ71r8lA3F3BG6Ju5XNHryG150Q=;
        b=mhtVZK18gz7p8LwXBG4icF5u3sLDYseaWSm3RI81GZ/DYlIVJx0hLygLA2dtP0QaBW
         viXbeFRHdyLBYueMu34p4oSr2Re284kz4nPm7yuFUcm7RgQdy87vHg+pv9gYvJf1OWw8
         4/3Hm9gNfiJTpuN0LUMrRn98JVP8HMDmL0bCZEqJR5r5rX/1thH7amPMGq/6w/RtNZc3
         QJUDaumxaTGqQqFepnlerP0rVqJonYlivM5jg5OGCnhniFQk1afbyHcT8I94Ds2+ExvO
         yz9dwIEaLPnclrESOeUJm8BDDO73+so6pE9ZbR5bDuqzdKOjGjmTYk4T81UVmQelfH3N
         iJuw==
X-Gm-Message-State: APjAAAWK8IOrSFaqi3GhZfKVH5y8unz4Vn5aNzILrby5FYnxKPWvRK0H
        t8ub4AoIqf+uYqS9vQDX0htItsistoOYcYYxXA8=
X-Google-Smtp-Source: APXvYqywQGZeix5+hyJFd179p4wCPYJqsd1zl+Oy2ya+e0sEg5kPmrlpmtXOALPZmXk7kRVsin2h9Cj6z6+8t6bhIUQ=
X-Received: by 2002:aa7:d4d8:: with SMTP id t24mr1330124edr.40.1573028961733;
 Wed, 06 Nov 2019 00:29:21 -0800 (PST)
MIME-Version: 1.0
References: <20191106080128.23284-1-hslester96@gmail.com> <VI1PR0402MB3600F14956A82EF8D7B53CC4FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3600F14956A82EF8D7B53CC4FF790@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Wed, 6 Nov 2019 16:29:10 +0800
Message-ID: <CANhBUQ1wZU92K=XTRCNU5HhOzZ761+S83zyjqOdZKpyQVuXrCw@mail.gmail.com>
Subject: Re: [EXT] [PATCH] net: fec: add a check for CONFIG_PM to avoid clock
 count mis-match
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 4:13 PM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: Chuhong Yuan <hslester96@gmail.com> Sent: Wednesday, November 6, 2019 4:01 PM
> > If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
> > automatically to disable clks.
> > Therefore, remove only needs to disable clks when CONFIG_PM is disabled.
> > Add this check to avoid clock count mis-match caused by double-disable.
> >
> > This patch depends on patch
> > ("net: fec: add missed clk_disable_unprepare in remove").
> >
> Please add Fixes tag here.
>

The previous patch has not been merged to linux, so I do not know
which commit ID
should be used.

> Andy
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> > ---
> >  drivers/net/ethernet/freescale/fec_main.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/freescale/fec_main.c
> > b/drivers/net/ethernet/freescale/fec_main.c
> > index a9c386b63581..696550f4972f 100644
> > --- a/drivers/net/ethernet/freescale/fec_main.c
> > +++ b/drivers/net/ethernet/freescale/fec_main.c
> > @@ -3645,8 +3645,10 @@ fec_drv_remove(struct platform_device *pdev)
> >                 regulator_disable(fep->reg_phy);
> >         pm_runtime_put(&pdev->dev);
> >         pm_runtime_disable(&pdev->dev);
> > +#ifndef CONFIG_PM
> >         clk_disable_unprepare(fep->clk_ahb);
> >         clk_disable_unprepare(fep->clk_ipg);
> > +#endif
> >         if (of_phy_is_fixed_link(np))
> >                 of_phy_deregister_fixed_link(np);
> >         of_node_put(fep->phy_node);
> > --
> > 2.23.0
>
