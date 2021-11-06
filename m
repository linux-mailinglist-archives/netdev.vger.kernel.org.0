Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B816B446FB0
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 19:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhKFSHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 14:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbhKFSHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 14:07:10 -0400
Received: from mail-vk1-xa36.google.com (mail-vk1-xa36.google.com [IPv6:2607:f8b0:4864:20::a36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7305C061570;
        Sat,  6 Nov 2021 11:04:28 -0700 (PDT)
Received: by mail-vk1-xa36.google.com with SMTP id b125so6183868vkb.9;
        Sat, 06 Nov 2021 11:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BDNUfw/99io9lZL/NQHnFzSR0+HpAZNRMkhQEyLxC/0=;
        b=GrQRzt+4PtSNXHfFOo3QkiU+XT15ORFB0U/VZx7hhnTht8A9Lo1bQcmSapNl51STgZ
         yP0THXJ3z/wDvKGrrLN6T7ngyxneNY8tEOBTfkV8S0fMYcCdVXBiQ1fY68XZB769ixBX
         Ciigz5j/3ZmzBzOW+RoTaBKmJhImJyCzhRz5NJTH5tEPz679Xy0JQhkw5vBoPI/DoK8Y
         3BpVK+MsFRwFPUHU0pfYjV+tk/9eUsy1BpwD+MyiMQEWqqd3EGF5Z6YnbYV4IRX02nel
         LFfAwh7EPHlRAfWM3BpTRB0RNIh6eS6bwNVOs0FliL7n/q7acORAacRqiSnXOzi8oW30
         OgFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BDNUfw/99io9lZL/NQHnFzSR0+HpAZNRMkhQEyLxC/0=;
        b=zz3izro5zYy4WiWuA+7dmbw4mUh1dMpG8mHWKGDvi7s3GyjTN/LQEyJl1oXI+8uj4D
         P8Pku8dezob/vVf+HXTwX/BNJg97AigcrCb/h4yTNq2cTq9UJxzMRiP8KLhjpNxGwrlV
         T25g+AwZTKgXFzroCQKwWNAVmGutgvF8oSLvEm9d1yVkjDnH0kXpgZ/po0RLzBwMnPLn
         v+rpzltsPiwqznGOB7oKGVlg95wLJpMUAaPqiU9ggOasJgQt0Au+7S7NojzHOiaiVNWg
         Pp6Q29SAtDkWDrk64jYkjQvW+UJb5SLlCBxC80mSL2Wn571vxsiwoBmu3TJZO/9B+mA5
         brhw==
X-Gm-Message-State: AOAM533W8JWJ13GHZ1YBxWJH7fw03J65lh7D7UUVnpFiftbDEren81Ys
        jsE8uvz+u9o61AJVf9T2an5K3CMInadXvgHKXX4=
X-Google-Smtp-Source: ABdhPJw6qV+SQ8PJ6KEqYrii77ylAr5PvTkl/BH8baMy0X/didSlGJTeZAvHzZ5C6lExUpRq0Nd1rYQvduR0h2sPiQ0=
X-Received: by 2002:a05:6122:554:: with SMTP id y20mr25836015vko.21.1636221867615;
 Sat, 06 Nov 2021 11:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211101035635.26999-1-ricardo.martinez@linux.intel.com> <20211101035635.26999-4-ricardo.martinez@linux.intel.com>
In-Reply-To: <20211101035635.26999-4-ricardo.martinez@linux.intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 6 Nov 2021 21:05:30 +0300
Message-ID: <CAHNKnsTd0-AwXwmPmXy_oKjYJA5vGDHo7VJbn5NqTngmhSpmfw@mail.gmail.com>
Subject: Re: [PATCH v2 03/14] net: wwan: t7xx: Add core components
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
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
>
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.

[skipped]

>  drivers/net/wwan/t7xx/t7xx_monitor.h       | 144 +++++
> ...
>  drivers/net/wwan/t7xx/t7xx_state_monitor.c | 598 +++++++++++++++++++++

Out of curiosity, why is this file called t7xx_state_monitor.c, while
the corresponding header file is called simply t7xx_monitor.h? Are any
other monitors planed?

[skipped]

> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
> ...
> +config MTK_T7XX
> +       tristate "MediaTek PCIe 5G WWAN modem T7XX device"

As already suggested by Andy, using "T7xx" (lowercase x) in the title
to make it more readable.

> +       depends on PCI
> +       help
> +         Enables MediaTek PCIe based 5G WWAN modem (T700 series) device.

Maybe use the term "T7xx series" here too? Otherwise, it sounds like a
driver for the smartphone chipset only.

> +         Adapts WWAN framework and provides network interface like wwan0
> +         and tty interfaces like wwan0at0 (AT protocol), wwan0mbim0
> +         (MBIM protocol), etc.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_common.h b/drivers/net/wwan/t7xx/t7xx_common.h
> ...
> +struct ccci_header {
> +       /* do not assume data[1] is data length in rx */
> +       u32 data[2];

If these fields have different meaning on Tx and Rx you could define
them using a union. E.g.

        union {
                struct {
                       __le32 idx;
                       __le32 type;
                } rx;
                struct {
                       __le32 idx;
                      __le32 len;
                } tx;
        };
        __le32 status;

or even like this:

        __le32 idx;
        union {
                __le32 rx_type;
                __le32 tx_len;
        };
        __le32 status;

Such definition better documents code then the comment above the field.

> +       u32 status;
> +       u32 reserved;
> +};

All these fields should have a type of __le32 since the structure
passed to the modem as is.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
> ...
> +static int __init mtk_pci_init(void)
> +{
> +       return pci_register_driver(&mtk_pci_driver);
> +}
> +module_init(mtk_pci_init);
> +
> +static void __exit mtk_pci_cleanup(void)
> +{
> +       pci_unregister_driver(&mtk_pci_driver);
> +}
> +module_exit(mtk_pci_cleanup);

Since the module does not do anything specific on (de-)initialization
use the module_pci_driver() macro instead of this boilerplate code.

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_skb_util.c b/drivers/net/wwan/t7xx/t7xx_skb_util.c
> ...
> +static struct sk_buff *alloc_skb_from_pool(struct skb_pools *pools, size_t size)
> +{
> +       if (size > MTK_SKB_4K)
> +               return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_64k);
> +       else if (size > MTK_SKB_16)
> +               return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_4k);
> +       else if (size > 0)
> +               return ccci_skb_dequeue(pools->reload_work_queue, &pools->skb_pool_16);
> +
> +       return NULL;
> +}
> +
> +static struct sk_buff *alloc_skb_from_kernel(size_t size, gfp_t gfp_mask)
> +{
> +       if (size > MTK_SKB_4K)
> +               return __dev_alloc_skb(MTK_SKB_64K, gfp_mask);
> +       else if (size > MTK_SKB_1_5K)
> +               return __dev_alloc_skb(MTK_SKB_4K, gfp_mask);
> +       else if (size > MTK_SKB_16)
> +               return __dev_alloc_skb(MTK_SKB_1_5K, gfp_mask);
> +       else if (size > 0)
> +               return __dev_alloc_skb(MTK_SKB_16, gfp_mask);
> +
> +       return NULL;
> +}

I am wondering what performance gains have you achieved with these skb
pools? Can we see any numbers?

I do not think the control path performance is worth the complexity of
the multilayer skb allocation. In the data packet Rx path, you need to
allocate skb anyway as soon as the driver passes them to the stack. So
what is the gain?

[skipped]

> diff --git a/drivers/net/wwan/t7xx/t7xx_state_monitor.c b/drivers/net/wwan/t7xx/t7xx_state_monitor.c
> ...
> +static struct ccci_fsm_ctl *ccci_fsm_entry;

Place this pointer at least to the mtk_modem structure. Otherwise,
with this global pointer, the driver will break as soon as a second
modem will be connected to the host.

Also all functions in this file also should be reworked to be able to
accept modem state container pointer, e.g. mtk_modem or some other
related structure.

--
Sergey
