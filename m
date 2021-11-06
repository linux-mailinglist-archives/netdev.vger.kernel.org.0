Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC12446FAE
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:00:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhKFSDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbhKFSDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:03:09 -0400
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B73FC061570;
        Sat,  6 Nov 2021 11:00:28 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id bc10so6180351vkb.1;
        Sat, 06 Nov 2021 11:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TNJjVBAs4u5xx5H8BYXmfCpwXtZlLST2zUS4b84jUfM=;
        b=oAfsC2pnTNyIqDm1Wn/q0wS2VqDkZlcXtjUxJYSHYpXlVrmPdzfET/vHejmDE/4+GV
         MIxjpvRkR/IJlvfTlrHeaLnekuvwEtHLmoYaIhxLe8DuOgDFh8+8ESdx5jDchsSPm/HN
         RmzR/rENsFR3FvNoCyhAlu/MEB0rGZdA6DzJ2+JpvQivD1E3Gx7B7HskL/VbxHW7y8zI
         huboSSu8Zyn2tPu/JxP7i8Lq2iqRS4qyOsdWV8YMgA2m4m4ygL1J4bkV2avawzfvWQYz
         70xy3dZiDlpKqqGtF2mBUZY+xdUj3cBw9aJSV6JJFW96FfKEcvlEpvgPSYRZD/JQP+PX
         4bvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TNJjVBAs4u5xx5H8BYXmfCpwXtZlLST2zUS4b84jUfM=;
        b=ejfPyIdzMgZFwR4CW9vnVvlficQVVXrZVtcm02oQ3G4v3xEuvdjhKdJwyPpsbnYB4l
         itdDOhtW8j04dC0OywazQoEFI9/1zUJGBKgj0XRS5K4CC4XlVAXV6DbAZWbEpfUJt3ef
         V9uRTvU4xCFVfgjC6f80zbYimgPBkjTxUrEC0Qk1AHU83TquIvwC6w+O9PhdzxS0Vnwg
         qLBsacW0CzGGCee/MMaI4gi8c5tsKD/FD+VuiTQtLS3JvsvMBytn58xKsRgia3Fgc0bi
         WRg6dpl+d6zkkPbeASEgBYfqiKvXY9xIHftB5x2M+2xHg1dBoxsZboUAfYGww71EWNQq
         35qw==
X-Gm-Message-State: AOAM533l8bZzbXRwvhll6Rwpy3TzExgRjDtwxZo66MXYS46/0/ksX1l/
        iqE0pBLQK6g1FPSbWs7tK+qduyNMk5ePiETlHIw=
X-Google-Smtp-Source: ABdhPJyE6D0lr9GUMt2lTUvvTpVAQ1uh7SQXdyZlET/hCTZi2P7nbGO0krfi3o6KcvJxF4gnjLouk2cjQFxRr2kRRwM=
X-Received: by 2002:a05:6122:1797:: with SMTP id o23mr25013074vkf.3.1636221627224;
 Sat, 06 Nov 2021 11:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-3-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-3-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:01:30 +0300
Message-ID: <CAHNKnsSp5RXkX8v=uE5ZX1evLfTSMGSf9iAUhgpLzdvKiahNzg@mail.gmail.com>
Subject: Re: [PATCH v2 02/14] net: wwan: t7xx: Add control DMA interface
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        chandrashekar.devegowda@intel.com,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com,
        suresh.nagaraj@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 1, 2021 at 6:57 AM Ricardo Martinez
<ricardo.martinez@linux.intel.com> wrote:
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
>
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
>
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
>
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
>
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> ...
> +static struct cldma_ctrl *cldma_md_ctrl[CLDMA_NUM];

Place this pointers array to a private _device_ state structure.
Otherwise, with these global pointers, the driver will break as soon
as a second modem is connected to the host.

Also all corresponding functions should be reworked to be able to
accept a modem state container pointer.

> +static DEFINE_MUTEX(ctl_cfg_mutex); /* protects CLDMA late init config */

Place this mutex to a private device state structure as well to avoid
useless inter-device locking and possible deadlocks.

> +static enum cldma_queue_type rxq_type[CLDMA_RXQ_NUM];
> +static enum cldma_queue_type txq_type[CLDMA_TXQ_NUM];
> +static int rxq_buff_size[CLDMA_RXQ_NUM];
> +static int rxq_buff_num[CLDMA_RXQ_NUM];
> +static int txq_buff_num[CLDMA_TXQ_NUM];

If these arrays could be shared between modem instances (i.e. if this
is a some kind of static configuration) then initialize them
statically or in the module_init(). Otherwise, if these arrays are
part of the runtime state, then place them in a device state
container.

--
Sergey
