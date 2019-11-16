Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114C4FEC8B
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 15:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfKPOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 09:00:35 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39121 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727551AbfKPOAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 09:00:35 -0500
Received: by mail-ed1-f67.google.com with SMTP id l25so9802117edt.6;
        Sat, 16 Nov 2019 06:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vg6OMNguE37yRu0lZWDv0k0PCtncGHdIM9h+B2HKyM0=;
        b=hM7nbd5gGgND0V7S1OiJOui/OwV0wmHX9tSl/bTxGNE7cP8pbplWyA0REo22B/wq4R
         tGLDzmpndHJ2i2WBe2nt+ObWvTgRjMVUkfbghIQHlVHtMasiQFqOAu6HwyG1DSPMuDBB
         ODU2sInhuDbf63eETl+wljibS4V3NR6f1aPtm0h+PPNBMxtV8d9tupKD1SODlsd9f7pS
         BWVcqT/Ee2WwGYP82RF1qKA3riDKux5hbgZwqDxFu/pew2ep809Y5oQGx9Cx5TrFhGMH
         UaEj8vZjva6d0sElsNieq8b82U1HG5g0wckLy6LsJM5q+EbPgz9y4+y0UuaDH8kp/8kR
         dLtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vg6OMNguE37yRu0lZWDv0k0PCtncGHdIM9h+B2HKyM0=;
        b=X/MrQBtV8WfCsVwOISw+V4YOr7SQhBQvP3Qy3DWeuqoaqO8cL4Ezxmg4E6Df7ZD/RW
         WqhNrSHGlDrZ4Uwe3tBxs77m3NgOLb6NbnjCtAAIzniJkSE7PdOpzG+0EVsVnpSo2m2w
         6tpR5r+eSjfrYEk+ZvkkTFQ+sBH3qUaAcSqTCiOow9IeUgywoM31ccob6FxKTrmZxthM
         AxQeEaILViCHJLB7J6pRyq/HqwcSbLPCf0umtcs1nCWnU47vKiZ+RSDPnjpMFUlcJWs3
         xt7mUqQgxF3if3jffvotBbjuFL43sbb1iTiD+reeSEFF+smi0r0b62yxKPEZEM3Eu8K5
         24lA==
X-Gm-Message-State: APjAAAUDYmHMc8vOg7GJDR+jWiE3HiMeEFtxcJmefVkgQVckVoLLD5+H
        hjfRAOEk9yRaUfpkiqFz590tGgCdeQcWnZlW377GAEsL
X-Google-Smtp-Source: APXvYqxj3xRFkMYxP+BopeZ8IgN78tBvhLNLSsp0WDlo7FxOG5yBwZDICwp9PI+Z2EhY9uaorCeokmEjFFgZIv24D4Q=
X-Received: by 2002:a17:906:a388:: with SMTP id k8mr9654605ejz.223.1573912833541;
 Sat, 16 Nov 2019 06:00:33 -0800 (PST)
MIME-Version: 1.0
References: <20191112112830.27561-1-hslester96@gmail.com> <20191115.121050.591805779332799354.davem@davemloft.net>
 <VI1PR0402MB3600CE74E0EC86AC97F25026FF730@VI1PR0402MB3600.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3600CE74E0EC86AC97F25026FF730@VI1PR0402MB3600.eurprd04.prod.outlook.com>
From:   Chuhong Yuan <hslester96@gmail.com>
Date:   Sat, 16 Nov 2019 22:00:21 +0800
Message-ID: <CANhBUQ1VZMV4MKqs95mJnZPLeDnhAgjgLTSaqL_pY08GGzM-mQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net v2] net: fec: add a check for CONFIG_PM to
 avoid clock count mis-match
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 2:57 PM Andy Duan <fugang.duan@nxp.com> wrote:
>
> From: David Miller <davem@davemloft.net> Sent: Saturday, November 16, 2019 4:11 AM
> > From: Chuhong Yuan <hslester96@gmail.com>
> > Date: Tue, 12 Nov 2019 19:28:30 +0800
> >
> > > If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
> > > automatically to disable clks.
> > > Therefore, remove only needs to disable clks when CONFIG_PM is disabled.
> > > Add this check to avoid clock count mis-match caused by double-disable.
> > >
> > > Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in
> > > remove")
> > > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> >
> > Your explanation in your reply to my feedback still doesn't explain the
> > situation to me.
> >
> > For every clock enable done during probe, there must be a matching clock
> > disable during remove.
> >
> > Period.
> >
> > There is no CONFIG_PM guarding the clock enables during probe in this driver,
> > therefore there should be no reason to require CONFIG_PM guards to the
> > clock disables during the remove method,
> >
> > You have to explain clearly, and in detail, why my logic and analysis of this
> > situation is not correct.
> >
> > And when you do so, you will need to add those important details to the
> > commit message of this change and submit a v3.
> >
> > Thank you.
>
> I agree with David. Below fixes is more reasonable.
> Chuhong, if there has no voice about below fixes, you can submit v3 later.
>

I get confused that how does this work to solve the CONFIG_PM problem.
And why do we need to adjust the position of the latter four functions?
I need to explain them in the commit message.

> @@ -3636,6 +3636,11 @@ fec_drv_remove(struct platform_device *pdev)
>         struct net_device *ndev = platform_get_drvdata(pdev);
>         struct fec_enet_private *fep = netdev_priv(ndev);
>         struct device_node *np = pdev->dev.of_node;
> +       int ret;
> +
> +       ret = pm_runtime_get_sync(&pdev->dev);
> +       if (ret < 0)
> +               return ret;
>
>         cancel_work_sync(&fep->tx_timeout_work);
>         fec_ptp_stop(pdev);
> @@ -3643,15 +3648,17 @@ fec_drv_remove(struct platform_device *pdev)
>         fec_enet_mii_remove(fep);
>         if (fep->reg_phy)
>                 regulator_disable(fep->reg_phy);
> -       pm_runtime_put(&pdev->dev);
> -       pm_runtime_disable(&pdev->dev);
> -       clk_disable_unprepare(fep->clk_ahb);
> -       clk_disable_unprepare(fep->clk_ipg);
> +
>         if (of_phy_is_fixed_link(np))
>                 of_phy_deregister_fixed_link(np);
>         of_node_put(fep->phy_node);
>         free_netdev(ndev);
>
> +       clk_disable_unprepare(fep->clk_ahb);
> +       clk_disable_unprepare(fep->clk_ipg);
> +       pm_runtime_put_noidle(&pdev->dev);
> +       pm_runtime_disable(&pdev->dev);
> +
>         return 0;
>  }
>
> Regards,
> Fugang Duan
