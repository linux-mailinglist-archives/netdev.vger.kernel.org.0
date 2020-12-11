Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDF92D72E0
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437403AbgLKJez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390353AbgLKJe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:34:29 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC988C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 01:33:42 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id ga15so11420540ejb.4
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 01:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s3rr1yeDbuDZjvp0l6lLC3rgx12DIQsMtcefFu3nv7I=;
        b=GTnnNE16sKjivuxq//ccroEVqjcEhNhqLLASsZtG3qcuN9VtX4xxB+BtBbSr3Hpxxr
         hwY5FroR6JpeljSxdgOOXmNVXL/jYlZaIsTyKUNNzEAmAWLZfQooVZQrJ7PMzM+oWG7S
         KOZl3Qz7/5PGbaN4+221ScIH+oev3maMespADiF8wy56Vpe0K8Q/LmRNuEUc10HcVIpt
         k2zZmP8iwJOdxnu9siDSF90VMMg5HheNYLh9RsF1NRIgWbpqJZJpwNk8xxTK65dyyH5d
         re+jtV2tvNNv8bsHPuG6OqGL+4Q7PBrsddcaGPg49I8N1/14GHrAcuVeE58j7eu/PCqi
         EvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s3rr1yeDbuDZjvp0l6lLC3rgx12DIQsMtcefFu3nv7I=;
        b=HZj+Q1QHZO8GD2l1h1NnE4i0Rc3Mm3qbIIZEHC2obQ1U1tciJciezqLhl6LS5i43Dc
         yH6i8/jWUu/0YkZ33vKSUSw7fSNdcHgSg/ERx459Esz3eXO4WzARknKH5mEWvju3hl9H
         T+U4/Mo1T3OBtmMAk2xX2wFPYUINZghvzzMnX1omUWiahgwswvktEyXYloQ6qnos8uKJ
         +jqS8k36f37zHdk0I+fZrv5gdjWdshw3RwpsmWYjFVcnmne93byLX0Dp1DCzJZ28CHMu
         EYieG4DmhH0ZNL+OCU5yHxcbzy6ypBnx+QxkHzKuk8ct/KbsvMLL3INyH6Mw+EH7/Myd
         Zn9A==
X-Gm-Message-State: AOAM5306sanusvy39ld+fBSd2LywkibZJQM2HqGhXbZRp3WHKUGQuxFg
        Q77JBzu7STN4/VugYGPO3hPxvakEzGRl5Os1msF52w==
X-Google-Smtp-Source: ABdhPJz1HchAi6Cg2DoTAPpMv4Bs5UimtvRmB6tGwGVzgCfkQIQlgvy92Jn5eQht+lD18znIxNSN8TizCI9THagc+Ps=
X-Received: by 2002:a17:906:8151:: with SMTP id z17mr10261170ejw.48.1607679221641;
 Fri, 11 Dec 2020 01:33:41 -0800 (PST)
MIME-Version: 1.0
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
 <1607598951-2340-2-git-send-email-loic.poulain@linaro.org> <20201211053800.GC4222@work>
In-Reply-To: <20201211053800.GC4222@work>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 11 Dec 2020 10:40:13 +0100
Message-ID: <CAMZdPi_9=CPXTNCDV=eLEg-2A0o-S1LkHr=hmED=z=CNe8u2iw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] net: mhi: Get RX queue size from MHI core
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mani,

On Fri, 11 Dec 2020 at 06:38, Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> On Thu, Dec 10, 2020 at 12:15:50PM +0100, Loic Poulain wrote:
> > The RX queue size can be determined at runtime by retrieving the
> > number of available transfer descriptors.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > ---
> >  v2: Fixed commit message typo
> >
> >  drivers/net/mhi_net.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
[...]
> > -
> >       INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
> >       u64_stats_init(&mhi_netdev->stats.rx_syncp);
> >       u64_stats_init(&mhi_netdev->stats.tx_syncp);
> > @@ -268,6 +265,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
> >       if (err)
> >               goto out_err;
> >
> > +     /* Number of transfer descriptors determines size of the queue */
> > +     mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
> > +
>
> This value is not static right? You might need to fetch the count in
> mhi_net_rx_refill_work().

It is, actually here driver is just looking for the total queue size,
which is the number of descriptors at init time. This total queue size
is used later to determine the level of MHI queue occupancy rate.

Regards,
Loic
