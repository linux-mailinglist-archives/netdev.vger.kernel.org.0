Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A225838CE6C
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 21:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhEUT54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 15:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhEUT5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 15:57:55 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624CAC0613CE
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 12:56:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y15so4300233pfn.13
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 12:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rHlyirjiPpVzC4/VbMR6TkrOP8A69ewulMyz7Ey78NA=;
        b=RuN0s45++svRab5mHtP/05OqXrbTu0kCtZXrW+mwIGtmwqC8rzumhDKUGRWMHO2Vgo
         CEmgd1K7/cbYb6l4JVIURDRWbp1LS5J09Coh/dfRNqyNHx0SR4F79K45e36fcZ0ARnyc
         W+oKFsW3MROgcBxGruny9nx950SMSi0fEDapoAvgVub0Z+IvTUubajf3eK9o1B4UuEfc
         umT+RrjqawYN+NepVmOZsgyscClsLCILT+4d/oEXK9Hk9wYaMun00ceuiwDBFvzXvbX1
         nXpfPjb2OORhz0suUOg6PfYdhpLbCTJqC30Q2yBT18kxgKwMjERugLME/MTGH7vOrBoV
         NCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rHlyirjiPpVzC4/VbMR6TkrOP8A69ewulMyz7Ey78NA=;
        b=Hma3YTZFwzsCt8b4gDAN8L+kMPmqsIa/mT32+gSiDUmP4WL+fXx9jDucKks/KLlHtp
         2Sr1addKLQokzs8VPIOp0CY3zkilh4uOh5Gb3veUnxA109V49nJSfW0lLX4tABLJrT+k
         LmZOBvR9LRztKG2DzLrwwmdvcflohTM3bxlJZs/U+GJhCzBNCNWq1ghaj/Yq2fH1/hrx
         GGPeu+Sqtsh3umeQpjLT1s0oTENMBhpk38ekvUaL9Tk8a/mp/Y86mmqZo0Pip/B3/In5
         JiRO/IwZQQgfJ+GpEB9aThmNv5pBKPTJjpO9cZ3Z8ucM653kCIY6FbWrXnzB3I1ggu4V
         bMBQ==
X-Gm-Message-State: AOAM533yVrDd0MtUut5NGakEJIgRMYHtuhuVd9nIOSGch12RycoseTtd
        m8SR60EUAUMUIfEc0DaxkhEUOfgAFyaJEpwY7j+r/g==
X-Google-Smtp-Source: ABdhPJxsSUdt7hA8GSkvedBroZX/C/VtTgWU3CCTDJnqx9/Q4Ev8qQNigMWYrZAoIaewpYOLxwhEX6bnsWNxSzkWP/0=
X-Received: by 2002:a63:1906:: with SMTP id z6mr379319pgl.173.1621626991433;
 Fri, 21 May 2021 12:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210520140158.10132-1-m.chetan.kumar@intel.com> <20210520140158.10132-16-m.chetan.kumar@intel.com>
In-Reply-To: <20210520140158.10132-16-m.chetan.kumar@intel.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 21 May 2021 21:55:55 +0200
Message-ID: <CAMZdPi-Xs00vMq-im_wHnNE5XkhXU1-mOgrNbGnExPbHYAL-rw@mail.gmail.com>
Subject: Re: [PATCH V3 15/16] net: iosm: net driver
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        krishna.c.sudi@intel.com, linuxwwan@intel.com,
        Dan Williams <dcbw@redhat.com>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chetan,

On Thu, 20 May 2021 at 16:09, M Chetan Kumar <m.chetan.kumar@intel.com> wrote:
>
> 1) Create net device & implement net operations for data/IP communication.
> 2) Bind IP Link to mux IP session for simultaneous IP traffic.
>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@intel.com>
> ---
> v3:
> * Clean-up DSS channel implementation.
> * Aligned ipc_ prefix for function name to be consistent across file.
> v2:
> * Removed Ethernet header & VLAN tag handling from wwan net driver.
> * Implement rtnet_link interface for IP traffic handling.
> ---
>  drivers/net/wwan/iosm/iosm_ipc_wwan.c | 439 ++++++++++++++++++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_wwan.h |  55 ++++
>  2 files changed, 494 insertions(+)
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.c
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.h
>
> diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> new file mode 100644
> index 000000000000..02c35bc86674
> --- /dev/null
> +++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
> @@ -0,0 +1,439 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020-21 Intel Corporation.
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/if_arp.h>
> +#include <linux/if_link.h>
> +#include <net/rtnetlink.h>
> +
> +#include "iosm_ipc_chnl_cfg.h"
> +#include "iosm_ipc_imem_ops.h"
> +#include "iosm_ipc_wwan.h"
> +
> +#define IOSM_IP_TYPE_MASK 0xF0
> +#define IOSM_IP_TYPE_IPV4 0x40
> +#define IOSM_IP_TYPE_IPV6 0x60

[...]

> +
> +static void ipc_netdev_setup(struct net_device *dev) {}
> +
> +struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
> +{
> +       static const struct net_device_ops iosm_wwandev_ops = {};
> +       struct iosm_wwan *ipc_wwan;
> +       struct net_device *netdev;
> +
> +       netdev = alloc_netdev(sizeof(*ipc_wwan), "wwan%d", NET_NAME_ENUM,
> +                             ipc_netdev_setup);
> +
> +       if (!netdev)
> +               return NULL;
> +
> +       ipc_wwan = netdev_priv(netdev);
> +
> +       ipc_wwan->dev = dev;
> +       ipc_wwan->netdev = netdev;
> +       ipc_wwan->is_registered = false;
> +
> +       ipc_wwan->ipc_imem = ipc_imem;
> +
> +       mutex_init(&ipc_wwan->if_mutex);
> +
> +       /* allocate random ethernet address */
> +       eth_random_addr(netdev->dev_addr);
> +       netdev->addr_assign_type = NET_ADDR_RANDOM;
> +
> +       netdev->netdev_ops = &iosm_wwandev_ops;
> +       netdev->flags |= IFF_NOARP;
> +
> +       SET_NETDEV_DEVTYPE(netdev, &wwan_type);
> +
> +       if (register_netdev(netdev)) {
> +               dev_err(ipc_wwan->dev, "register_netdev failed");
> +               goto reg_fail;
> +       }

So you register a no-op netdev which is only used to represent the
modem instance, and to be referenced for link creation over IOSM
rtnetlinks?
The new WWAN framework creates a logical WWAN device instance (e.g;
/sys/class/wwan0), I think it would make sense to use its index as
parameter when creating the new links, instead of relying on this
dummy netdev. Note that for now the wwan_device is private to
wwan_core and created implicitly on the WWAN control port
registration.
Moreover I wonder if it could also be possible to create a generic
WWAN link type instead of creating yet-another hw specific one, that
could benefit future WWAN drivers, and simplify user side integration,
with a common interface to create links and multiplex PDN (a bit like
wlan vif).

Regards,
Loic
