Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A7A28EFFC
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 12:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgJOKUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 06:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgJOKUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 06:20:16 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362A6C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:20:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id ce10so2821102ejc.5
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 03:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h8VwUpwBBTh1Rt5wZETtbVn2OaoNXb3XoyRsN7+Y0Go=;
        b=OUinwxwmMVvHZNml5LaB5PTPpU9i/RuDDwuzA61t8sa5dwIEidyVF5r0y+c92yC7XG
         cdj7xvaeqCjhVzsrsZAGUceg/sZZyyWdN4vIs7bzOES1xH3d3GZb9JuqitYgrXvM7m/p
         RJIAvbnfWIAAzo4wGGeS6qeOK8wiM8+j365oxnSJQXbH7WBJJ0eAcTeEtyOMLyEA/sAw
         /wy/wDs6ueLWwtk9GdlXcG2VT2rYUzdYcLs9Tw4Bi1rsfaBMcdcRq0QJfmqB4eu/z5qz
         oABNBu8ZvkApKzH/coefXH/ngxzc8opNH3YE6bRdy03/3ZFaguRutlbZ1W1nBdyhQvi+
         8UEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h8VwUpwBBTh1Rt5wZETtbVn2OaoNXb3XoyRsN7+Y0Go=;
        b=W03i/FTVnxX9JQK/2j9eJoFzwr1Km47bIpPgzIfGr7YBGifJeXTumTALcd0xk+iHMh
         EcqBdag1hHnms66TXdrd2rtYuvNeiKfGH+riTw8plnnywdF9ieyZ+XYnmhQTvRr5LUSp
         F46coLR+EgKSyhIh69mN3ZwpGrFKjJaPc6YyyYTZBvb47OCaZ2FSzxcjBHT2EpKQ9HYU
         Uiyasm143bCFd+jCl2ZxMP5uUUeB9YxUO3RfZTGgalg3/1dLXh6gXyqDLDC6aQwQn1Tz
         N+uDFxr69V2J7WfY+nDTOhAUKjhVd4NZd5zhCxULy+9RM3r1sf0YMf2MjWp6tCQPnb38
         GHzw==
X-Gm-Message-State: AOAM531Dm4sVMET9L2byRbc+evncwYs348DxA1KHvnhWaT6SifRtTqUI
        jZsFFFDdp7dFKlcHfXBZFwyxk0XBMo/clgsY/RES7A==
X-Google-Smtp-Source: ABdhPJx5+mUYrRfq/cJ5vkeB4PPpgw3U7SUSOp+iKzMy158tSj/eykJP7DB8v/ac6bkyUbqxNvjJYamh4Wd/GTvEJUA=
X-Received: by 2002:a17:906:1f53:: with SMTP id d19mr3537700ejk.255.1602757214763;
 Thu, 15 Oct 2020 03:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <1602676437-9829-1-git-send-email-loic.poulain@linaro.org> <b7fd004c-2293-a08c-51eb-40eecbdd4a9c@gmail.com>
In-Reply-To: <b7fd004c-2293-a08c-51eb-40eecbdd4a9c@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 15 Oct 2020 12:25:44 +0200
Message-ID: <CAMZdPi_2Fp8rRmgUCZcXo+1JScx_4bCWPt64ePtn2hRBYP5Q8Q@mail.gmail.com>
Subject: Re: [PATCH v3] net: Add mhi-net driver
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 at 09:25, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/14/20 1:53 PM, Loic Poulain wrote:
> > This patch adds a new network driver implementing MHI transport for
> > network packets. Packets can be in any format, though QMAP (rmnet)
> > is the usual protocol (flow control + PDN mux).
> >
>
> ...
>
> > +static void mhi_net_rx_refill_work(struct work_struct *work)
> > +{
> > +     struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> > +                                                   rx_refill.work);
> > +     struct net_device *ndev = mhi_netdev->ndev;
> > +     struct mhi_device *mdev = mhi_netdev->mdev;
> > +     struct sk_buff *skb;
> > +     int err;
> > +
> > +     do {
> > +             skb = netdev_alloc_skb(ndev, READ_ONCE(ndev->mtu));
> > +             if (unlikely(!skb))
> > +                     break;
>
> It is a bit strange you use READ_ONCE(ndev->mtu) here, but later
> re-read ndev->mtu
>
> It seems you need to store the READ_ONCE() in a temporary variable,
>
>                 unsigned int mtu = READ_ONCE(ndev->mtu);
>

Indeed, thanks.

> > +
> > +             err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, ndev->mtu,
> > +                                 MHI_EOT);
>
>                  s/ndev->mtu/mtu/
>
>
> > +             if (err) {
> > +                     if (unlikely(err != -ENOMEM))
> > +                             net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> > +                                                 ndev->name, err);
> > +                     kfree_skb(skb);
> > +                     break;
> > +             }
> > +
> > +             atomic_inc(&mhi_netdev->stats.rx_queued);
>
> This is an unbound loop in the kernel ?
>
> Please add a :
>
>                 cond_resched();
>
> Before anyone gets hurt.

Will do, thanks.

>
>
> > +     } while (1);
> > +
> > +     /* If we're still starved of rx buffers, reschedule latter */
> > +     if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> > +             schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> > +}
> > +
> >
>
>
