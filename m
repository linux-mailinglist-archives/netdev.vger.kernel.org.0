Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986722C8C7B
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388057AbgK3SRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388040AbgK3SRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:17:17 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAEDC0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:16:30 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id l5so17444942edq.11
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2AKXanvK88R+UrndJ2+lfJo0jOvZRiWePigHL5MOrpQ=;
        b=t+oYd2k8L4bXGdr4bOORSo2JgpR5uXWDVrx56F+4FY0EeuamLMDp1YW6JIH5sInuGT
         rTtQHZ+qSZjUS9YTu5LGYXDH/CwUXJuHgVdcM1yCQto3Ahh9igxg3+ITRIiOgHGpDCJj
         c59bFtLaWRLYYh2JDbgappg+NEZjyEZGr+/z2fboCh3SXTBDnK6syDMRhDLA8npvxTfS
         V3oMTCVXoi9kMmsNTD82DGqL12LHuXk0zgHJYWHzPXC9vdYyBpb1Y95Bzz0QCC4YZax1
         A98oOIB+j1krv9rUn5NtvQXBe9iCccCHcTRWMmQJ+ekRgUtEBsEgOqN+oz2dVRGzJb46
         R34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2AKXanvK88R+UrndJ2+lfJo0jOvZRiWePigHL5MOrpQ=;
        b=YRdjxobgZ3X6Lq2M4XztsRSPv9zPORYznJGQ22e+qeFHHEvL3qGR0K+YLMuHJYP8dH
         rmjdDy5drZRpCPa3rNk/d8Se/7ra4ZQJXichjNtaIyhsqr69WdRuoTEt7SJQGLVxIGYL
         3y2JbvaT6T4YXKLELZEfmgYE6kiICxVRoWf2pSdw3SCFUgKZMegki0K3YBegViaQYVLz
         7dZWtPzoyusGmXcxTmvP+zdhZZ6IjIzVy7vyl7IN6aMhlGpv/Fl3NtL6AH0y0dTffmHt
         2wXrLfwqvxq5JOszQxeBKxlFbR18S0k5/R3abtD2BEgSPGtmdXFn9KhSNY9PYvOQ//9f
         lULw==
X-Gm-Message-State: AOAM531R6xV/5vd8CYICPsFuuhYTxX7ACwyN8+siirTo6ZcH2lC6NYQA
        e5+b56oTLX4vwuI1k/WfvGj8rjBmEfBoE1B7cXy9clhTO6le+IafOEg=
X-Google-Smtp-Source: ABdhPJyNpcC8uWln79NGtVmSKYKI6we/nKuaJntLarInFL3acHDquTAhyp/H0NYR0Mv1MEzHIFxCvl9ItBXpq6gBDKc=
X-Received: by 2002:a05:6402:2373:: with SMTP id a19mr23118798eda.212.1606760189619;
 Mon, 30 Nov 2020 10:16:29 -0800 (PST)
MIME-Version: 1.0
References: <1606533966-22821-1-git-send-email-hemantk@codeaurora.org> <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
In-Reply-To: <1606533966-22821-5-git-send-email-hemantk@codeaurora.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Mon, 30 Nov 2020 19:22:44 +0100
Message-ID: <CAMZdPi8z+-qFqgZ7AFJcNAUMbDQtNN5Hz-geMBcp4azrUGm9iA@mail.gmail.com>
Subject: Re: [PATCH v13 4/4] bus: mhi: Add userspace client interface driver
To:     Hemant Kumar <hemantk@codeaurora.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 at 04:26, Hemant Kumar <hemantk@codeaurora.org> wrote:
>
> This MHI client driver allows userspace clients to transfer
> raw data between MHI device and host using standard file operations.
> Driver instantiates UCI device object which is associated to device
> file node. UCI device object instantiates UCI channel object when device
> file node is opened. UCI channel object is used to manage MHI channels
> by calling MHI core APIs for read and write operations. MHI channels
> are started as part of device open(). MHI channels remain in start
> state until last release() is called on UCI device file node. Device
> file node is created with format

[...]

> +struct uci_chan {
> +       struct uci_dev *udev;
> +       wait_queue_head_t ul_wq;
> +
> +       /* ul channel lock to synchronize multiple writes */
> +       struct mutex write_lock;
> +
> +       wait_queue_head_t dl_wq;
> +
> +       /* dl channel lock to synchronize multiple reads */
> +       struct mutex read_lock;
> +
> +       /*
> +        * protects pending list in bh context, channel release, read and
> +        * poll
> +        */
> +       spinlock_t dl_pending_lock;
> +
> +       struct list_head dl_pending;
> +       struct uci_buf *cur_buf;
> +       size_t dl_size;
> +       struct kref ref_count;
> +};

[...]

> + * struct uci_dev - MHI UCI device
> + * @minor: UCI device node minor number
> + * @mhi_dev: associated mhi device object
> + * @uchan: UCI uplink and downlink channel object
> + * @mtu: max TRE buffer length
> + * @enabled: Flag to track the state of the UCI device
> + * @lock: mutex lock to manage uchan object
> + * @ref_count: uci_dev reference count
> + */
> +struct uci_dev {
> +       unsigned int minor;
> +       struct mhi_device *mhi_dev;
> +       struct uci_chan *uchan;

Why a pointer to uci_chan and not just plainly integrating the
structure here, AFAIU uci_chan describes the channels and is just a
subpart of uci_dev. That would reduce the number of dynamic
allocations you manage and the extra kref. do you even need a separate
structure for this?

[...]

> +static int mhi_uci_dev_start_chan(struct uci_dev *udev)
> +{
> +       int ret = 0;
> +       struct uci_chan *uchan;
> +
> +       mutex_lock(&udev->lock);
> +       if (!udev->uchan || !kref_get_unless_zero(&udev->uchan->ref_count)) {

This test is suspicious,  kref_get_unless_zero should be enough to test, right?

if (kref_get_unless_zero(&udev->ref))
    goto skip_init;

> +               uchan = kzalloc(sizeof(*uchan), GFP_KERNEL);
> +               if (!uchan) {
> +                       ret = -ENOMEM;
> +                       goto error_chan_start;
> +               }
> +
> +               udev->uchan = uchan;
> +               uchan->udev = udev;
> +               init_waitqueue_head(&uchan->ul_wq);
> +               init_waitqueue_head(&uchan->dl_wq);
> +               mutex_init(&uchan->write_lock);
> +               mutex_init(&uchan->read_lock);
> +               spin_lock_init(&uchan->dl_pending_lock);
> +               INIT_LIST_HEAD(&uchan->dl_pending);
> +
> +               ret = mhi_prepare_for_transfer(udev->mhi_dev);
> +               if (ret) {
> +                       dev_err(&udev->mhi_dev->dev, "Error starting transfer channels\n");
> +                       goto error_chan_cleanup;
> +               }
> +
> +               ret = mhi_queue_inbound(udev);
> +               if (ret)
> +                       goto error_chan_cleanup;
> +
> +               kref_init(&uchan->ref_count);
> +       }
> +
> +       mutex_unlock(&udev->lock);
> +
> +       return 0;
> +
> +error_chan_cleanup:
> +       mhi_uci_dev_chan_release(&uchan->ref_count);
> +error_chan_start:
> +       mutex_unlock(&udev->lock);
> +       return ret;
> +}

Regards,
Loic
