Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903C747F408
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 18:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhLYRSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Dec 2021 12:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhLYRSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Dec 2021 12:18:16 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15C9C061401;
        Sat, 25 Dec 2021 09:18:16 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id d10so34478176ybn.0;
        Sat, 25 Dec 2021 09:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cwNlOJL6+nTpPQ0bQe4LhDmUn6tSXE052qJuMPuWowI=;
        b=Hi/rsuhGnO97sjZH7Lwv/9kXCCCOhcRLuk3JE6I0sQMyoZWgQGaqupQTYJr3gEH6qa
         gMaqjoGzEkgTkrCTfJbn8YN6dkwSx6oQH/Nv1yCqN6EfT8BH4zpH0fRDWBf1706rXEw2
         9HP6tHo0d10x0bxFIgFC+qOkvTzwEkI/vyveN6DAxMb1v5fO84LG+0zD7OibcyXo+0EA
         B/Gu7xv6/1pFLLMHz+4bqLPFGkbVArUIUoh//iL0ESaRxdYJVergJ8kml7bJhKPbmzY8
         Grr7Yt3N+8lsaoncJ38ZFWMTKAPLpQTkj28TIzoXxLe5qGPJaqS8OY+a6G5gX5hC2+xJ
         ZqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cwNlOJL6+nTpPQ0bQe4LhDmUn6tSXE052qJuMPuWowI=;
        b=6kqUwUXdeibVstArMYJAVM0C54+dX7Qr09UOQ7lkvhFyPz2T0/cAjAT9gnM55urCGX
         N7S02GY26A3If79jrKqDWb3lazNy+aAVmw96/BEQbbJKYsBvIYvMhUeL37h02Mh2+5x9
         Yih3sGL7HFtSaWOwiqyV2IjWodJRQFYSH5M0lj9+YCNmrpuBUfrN+ATD10VOUEY3Ewff
         Ab1Bt8WA63KM95TJmHuy31qW/hAyNFEPN5WZxZs0bkMgSjUtvF547Fme7lzduvp88EUP
         2BcmBB9MP2zCUZJ00aQ60oSSZ7/eCAx9P2p8XGs51eQdmRAqis+wh5csGhyzJIELsMKp
         qI8w==
X-Gm-Message-State: AOAM530WjCWnYezbJkWXd+GLgwfYAE7BW/oG1Bd9ZsoF82eYzvfZLsst
        WzgKc3S1W/88ui6GqZzm0OhlXcsmHEpH9agqIac=
X-Google-Smtp-Source: ABdhPJxdJr5GL3Hd+8jIEnSRoCdZb/BNzFvqysSW+BSC3SGwNEIHJxOVinXGVjVqxrL0Bsc+bMgKlJ0xEbQkzrol3dA=
X-Received: by 2002:a25:c586:: with SMTP id v128mr3131214ybe.186.1640452695879;
 Sat, 25 Dec 2021 09:18:15 -0800 (PST)
MIME-Version: 1.0
References: <20211224192626.15843-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211224192626.15843-9-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAHp75Vd60ftgzvWqz+r5YcptimDwURmwOucOBw-WqdHega6NqA@mail.gmail.com>
In-Reply-To: <CAHp75Vd60ftgzvWqz+r5YcptimDwURmwOucOBw-WqdHega6NqA@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 25 Dec 2021 17:17:50 +0000
Message-ID: <CA+V-a8tuc02C85T5rWg16qW+1jY7=a3Q-kBiuuDahVfyX7hQcw@mail.gmail.com>
Subject: Re: [PATCH 8/8] net: ethernet: ti: davinci_emac: Use
 platform_get_irq() to get the interrupt
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

Thank you for the review.

On Sat, Dec 25, 2021 at 4:59 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Sat, Dec 25, 2021 at 4:06 AM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> >
> > platform_get_resource(pdev, IORESOURCE_IRQ, ..) relies on static
> > allocation of IRQ resources in DT core code, this causes an issue
> > when using hierarchical interrupt domains using "interrupts" property
> > in the node as this bypasses the hierarchical setup and messes up the
> > irq chaining.
> >
> > In preparation for removal of static setup of IRQ resource from DT core
> > code use platform_get_irq() for DT users only.
> >
> > While at it propagate error code in case request_irq() fails instead of
> > returning -EBUSY.
>
>
> > +       if (dev_of_node(&priv->pdev->dev)) {
>
> Why?! What's wrong with using the same approach in all cases?
>
The earlier code looped the resource from start to end and then
requested the resources. So I believed the the IORESOURCE_IRQ was
sending the range of interrupts. But now looking at the mach-davinci
folder I can confirm its just send an single IRQ resource. So this
check can be dropped and same approach can be used for OF and non OF
users.

> > +               while ((ret = platform_get_irq_optional(priv->pdev, res_num)) != -ENXIO) {
>
> This is wrong.
>
> You need to check better as I pointed several times against your patches.
>
Right, Ill have a look.

Cheers,
Prabhakar
> > +                       if (ret < 0)
> > +                               goto rollback;
> >
> > +                       ret = request_irq(ret, emac_irq, 0, ndev->name, ndev);
> > +                       if (ret) {
> > +                               dev_err(emac_dev, "DaVinci EMAC: request_irq() failed\n");
> >                                 goto rollback;
> >                         }
> > +                       res_num++;
> >                 }
> > -               res_num++;
> > +       } else {
> > +               while ((res = platform_get_resource(priv->pdev, IORESOURCE_IRQ, res_num))) {
> > +                       for (irq_num = res->start; irq_num <= res->end; irq_num++) {
> > +                               ret = request_irq(irq_num, emac_irq, 0, ndev->name, ndev);
> > +                               if (ret) {
> > +                                       dev_err(emac_dev, "DaVinci EMAC: request_irq() failed\n");
> > +                                       goto rollback;
> > +                               }
> > +                       }
> > +                       res_num++;
> > +               }
> > +               /* prepare counters for rollback in case of an error */
> > +               res_num--;
> > +               irq_num--;
> >         }
>
> --
> With Best Regards,
> Andy Shevchenko
