Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A54428FFE4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405127AbgJPIVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 04:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405123AbgJPIVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 04:21:49 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E53C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 01:21:49 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e22so1915794ejr.4
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 01:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gEiZi7rd3SSJxLuea3zsqbWKYhT9/0fEd+OaUrny7yk=;
        b=aIRbhHfqk1vKGHGZH7OYReSBQQJmLwmDg7rla+i5yjZsClb/2mCV1Kzpu++IyycOhU
         R/WFhtw18JOJcPaJykk3x4aZtJQKNtI1F2lXDEZdCOFjV+bYQwYALYpeXZQSLLVGLNEu
         qBKRdxrbXZ7SIVzp59+6PVVkOFEo8VLxL6uU3bwemdEhDqtBkqpLhcawiRHGs3lBJ541
         ALiXLYD0S5HFWf1EawRrDAxyzb0FX+EAzL6ASD2K4Ytxu5eabs82Ulinook4X+dx/N+N
         Vk+UD/5dAbtQwECUQhUabqzBlHwTTe6eDjvQv0sNd1W1BOgEeN/vD+c51Ytz7cgIQVWZ
         IUVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gEiZi7rd3SSJxLuea3zsqbWKYhT9/0fEd+OaUrny7yk=;
        b=IC+kwaO1zLIIiRIc6l1L9GQIdlQR+3vygr75XIkmFitY2s65usgAA7Yu13CtjKnH4g
         hs4LesMaGP/FmMnunCgkb7saPi9HXEizukle8ld/nHwZvcoC5i0yyRTLTtJB3RNcW0bQ
         4cGPOOOfwUD8dG9OHFWOI16DrnZdxHusGwv22Ms+9UGD0mSxQ3W13rU5D67mbZM7pd2s
         f/7Y9hOIv/9KJdJdLsRXOjgQirPS7zHEoEBOGPYO0lPB8i0pXMtO4k4i0X4PKqEEqJFp
         kjTPdV6WiLVl6K7fNHYbfkiOx7eSktkClWJAyhW6kICdXZsR2i0VxcVcH0w97DXLuJ5m
         Uo3g==
X-Gm-Message-State: AOAM53264sI6DO7iPEYSZex6p7RomrVBLs+M6dsfOUNxfB2wF6vrvhaL
        aSHCqrYoCcbu/wY60vRmSTCo16AnqK6DnOTCnlnt8g==
X-Google-Smtp-Source: ABdhPJxJ0EMK0apijpvIDsk11bP2lUcvGUYaK+08n4ilw6CScnd+QnA1GbXN5B8u16s0u+bMEV0U6G03hZpSqSx7+Pg=
X-Received: by 2002:a17:906:f205:: with SMTP id gt5mr2524261ejb.48.1602836507861;
 Fri, 16 Oct 2020 01:21:47 -0700 (PDT)
MIME-Version: 1.0
References: <1602757888-3507-1-git-send-email-loic.poulain@linaro.org>
 <ec2a1d76-d51f-7ec5-e2c1-5ed0eaf9a537@gmail.com> <CAMZdPi93Ma4dGMNr_2JHqYJqDE6VSx6vEpRR3_Y2wbpT1QAvTA@mail.gmail.com>
 <62605ecb-3974-38a9-1f64-b08df6a72663@gmail.com>
In-Reply-To: <62605ecb-3974-38a9-1f64-b08df6a72663@gmail.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 16 Oct 2020 10:27:16 +0200
Message-ID: <CAMZdPi_RtJRQu0hA=KBZyAWLryoDZW+a=x_GoHJrUP4APVstHQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] net: Add mhi-net driver
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Thu, 15 Oct 2020 at 20:56, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/15/20 3:29 PM, Loic Poulain wrote:
> > On Thu, 15 Oct 2020 at 14:41, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 10/15/20 12:31 PM, Loic Poulain wrote:
> >>> This patch adds a new network driver implementing MHI transport for
> >>> network packets. Packets can be in any format, though QMAP (rmnet)
> >>> is the usual protocol (flow control + PDN mux).
> >>>
> >>> It support two MHI devices, IP_HW0 which is, the path to the IPA
> >>> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> >>> driven IP path (to modem CPU).
> >>>
> >>>
> >>> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> >>> +{
> >>> +     struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> >>> +     struct mhi_device *mdev = mhi_netdev->mdev;
> >>> +     int err;
> >>> +
> >>> +     skb_tx_timestamp(skb);
> >>> +
> >>> +     /* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> >>> +      * network core. Once MHI core will be thread save, migrate to
> >>> +      * NETIF_F_LLTX support.
> >>> +      */
> >>> +     err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> >>> +     if (err == -ENOMEM) {
> >>> +             netif_stop_queue(ndev);
> >>
> >> If you return NETDEV_TX_BUSY, this means this skb will be requeues,
> >> then sent again right away, and this will potentially loop forever.
> >
> > The TX queue is stopped in that case, so the net core will not loop, right?
>
> -ENOMEM suggests a memory allocation failed.
>
> What is going to restart the queue when memory is available ?

The queue is restarted as soon as new ring elements are available, in
the tx complete callback (mhi_net_ul_callback).

>
> -ENOMEM seems weird if used for queue being full.

Regarding MHI core, that means no element is available in the ring to
push the buffer, so maybe -ENOSPC would be more suitable? This change
could be done in a subsequent series since it would request to modify
MHI core and other MHI drivers.

I'm not sure this is the right way, but this 'stop-queue and return
busy' is a pattern used in various other network drivers. However, I
understand that a better solution would be to stop the queue earlier,
as soon as ring is full and prevent this abnormal situation.

>
> >
> >>
> >> Also skb_tx_timestamp() would be called multiple times.
> >
> > OK so I'm going to remove that, maybe the MHI layer should mark
> > timestamp instead.
>
> Yes, probably.
>
