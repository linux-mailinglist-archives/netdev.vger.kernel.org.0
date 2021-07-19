Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975B53CE255
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 18:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbhGSPaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 11:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348614AbhGSPY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 11:24:56 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCE6C08EBAF;
        Mon, 19 Jul 2021 08:16:13 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p186so20451759iod.13;
        Mon, 19 Jul 2021 08:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dUp4KizKkP62bfFIACj5yluSFgs6t9ggjz821ypftuc=;
        b=jZbpjPH/YL1hwylpNEwlxY5hzP5L6oHb3pyS8NiP9moyWvagD1TomMT7TgM+zGE9ec
         ZerWRUwBwX9u6vT6kRSlqnP/a01/6Up+hZS+6kSY0apliE0qCjGXjYULO9udk5orHd0g
         px8UyQCux6xKJSLG1lmBDFIqOsfXDgzKCbfLv7xpQyMVGNNkijJq+opLQXGAylZkej44
         zN+8ncoLmiPuu6oquEJ/Yw/7J8t6ysmprvrQOuCRSHVazniaXzkcRH0F2x8J+BJVJCVy
         dvTZCIq2ZCUzIFdmAxRUJWF9WW/JL+OS/FS9X+wAMnq1I+45LHY1pNOplFkBFi6++zeS
         qBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dUp4KizKkP62bfFIACj5yluSFgs6t9ggjz821ypftuc=;
        b=cwl5Tv6ztATNGkSDSJ5cJxnaIkhOPCUbJUmvGdss7mODm5cy4uyDhL2IzRzvJCpEvh
         RyI8+1rtURWSIyoGYt1r4uD2VDT6e9NWZx2R8mMTzNDvFiB9uTHDAOi5Aa/k9KyDzd7x
         ULSsHBGTbV2pSQaxKQ/W2mwtnq9CCOd8I+Bm6H+UPoj35Ger88jxvNmV1F4BnIcQEszg
         0wV5rCla6001xxm3StBZeRTVoGaXYLGV8S3qmSzvo9ZCO9U0VYSrsNHbULGl0vcbMGEj
         6A5W76Pjo4D4HUSg4VwpHlzgpcz9CtiPNy6GFqXiHwPNLo+FctEwdnPtLKpw7O41Hsxx
         AoYA==
X-Gm-Message-State: AOAM532/mDl3PLqjGqzRZXv8dXRlQdvFGIopHb8Lp8/0pNdHpFgx+qEK
        9gQsSiMLdslLFfRMPKNZhlB6+NgB/S2k48jiBmdFOA9b
X-Google-Smtp-Source: ABdhPJyJqrjcpWe5TPapi2Eds7LS8V0tadPUoiHu7RtPGgJ3cUggLnDgcfpMvXoK517tFEhelNc8o7I/y004WnYAfsM=
X-Received: by 2002:a05:6638:14d6:: with SMTP id l22mr22055489jak.99.1626709418618;
 Mon, 19 Jul 2021 08:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210719145317.79692-1-stephan@gerhold.net>
In-Reply-To: <20210719145317.79692-1-stephan@gerhold.net>
From:   Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Date:   Mon, 19 Jul 2021 09:43:27 -0600
Message-ID: <CAOCk7NonuOKWrpr-MwdjAwF1F4jviEMf=c04vVBxQ-OmfY2b-g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        MSM <linux-arm-msm@vger.kernel.org>, dmaengine@vger.kernel.org,
        DTML <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 9:01 AM Stephan Gerhold <stephan@gerhold.net> wrote:
>
> The BAM Data Multiplexer provides access to the network data channels
> of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
> or MSM8974. This series adds a driver that allows using it.
>
> For more information about BAM-DMUX, see PATCH 4/4.
>
> Shortly said, BAM-DMUX is built using a simple protocol layer on top of
> a DMA engine (Qualcomm BAM DMA). For BAM-DMUX, the BAM DMA engine runs in
> a quite strange mode that I call "remote power collapse", where the
> modem/remote side is responsible for powering on the BAM when needed but we
> are responsible to initialize it. The BAM is power-collapsed when unneeded
> by coordinating power control via bidirectional interrupts from the
> BAM-DMUX driver.

The hardware is physically located on the modem, and tied to the modem
regulators, etc.  The modem has the ultimate "off" switch.  However,
due to the BAM architecture (which is complicated), configuration uses
cooperation on both ends.

>
> The series first adds one possible solution for handling this "remote power
> collapse" mode in the bam_dma driver, then it adds the BAM-DMUX driver to
> the WWAN subsystem. Note that the BAM-DMUX driver does not actually make
> use of the WWAN subsystem yet, since I'm not sure how to fit it in there
> yet (see PATCH 4/4).
>
> Please note that all of the changes in this patch series are based on
> a fairly complicated driver from Qualcomm [1].
> I do not have access to any documentation about "BAM-DMUX". :(

I'm pretty sure I still have the internal docs.

Are there specific things you want to know?
