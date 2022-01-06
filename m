Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E754864E0
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239312AbiAFNDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:03:42 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:52775 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239006AbiAFNDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:03:41 -0500
Received: by mail-wm1-f47.google.com with SMTP id v123so1713435wme.2;
        Thu, 06 Jan 2022 05:03:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vcYnekM26AwY1vgrHqt3niX4oXoouwaBi8z/zP8TK7s=;
        b=KK1AhbTgHQntIEoZKmY7mqNYMpCGMojc2X8jImMj3fsLPy0VObLXJbPoSky5LXsB55
         pkWPrF2QpkLlj81DfXgOMtzoyEDpPDJdIFHkN5fA/Opdi3tIw/Q5vnjcL2z6W1b6KdrP
         nMqNkVzzQ33L+9/rzOez7I2fji+61AG4J1x2IvN/pugkswXecJbkPEyRD9gcmk8cYHAe
         f/z+UYPG0Uu/fgG0sbcEB3nqh1mlzvIdcuXQh9rAJVaKHeYqeG31cETZSctu5hZCI4p7
         zyCORkBHBWlCDBpvq6rV+hMFKcEt7oTDU89KMSOrpkSz7pv6Qb6Wygg6DR1B+4+Z0x8j
         jU9g==
X-Gm-Message-State: AOAM533lyrJtN4u/Crz/ODPbUAJsH7z+yLMQR8Bcrx6H+P4/J8AqbGRR
        Qb3AofyHcL7S0v6Ai4aVYVk=
X-Google-Smtp-Source: ABdhPJxjG8n0y9ZGjhfUAQ/lARqGtAcsKv1amFfIs3NrZLQDMXO0cFdv3+3SKS6rfToX8YU5cknK9Q==
X-Received: by 2002:a05:600c:acf:: with SMTP id c15mr6826950wmr.7.1641474219848;
        Thu, 06 Jan 2022 05:03:39 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b6sm2089988wri.56.2022.01.06.05.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:03:39 -0800 (PST)
Date:   Thu, 6 Jan 2022 13:03:37 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org, shayagr@amazon.com, akiyano@amazon.com,
        darinzon@amazon.com, ndagan@amazon.com, saeedb@amazon.com,
        sgoutham@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        grygorii.strashko@ti.com, sameehj@amazon.com,
        chenhao288@hisilicon.com, moyufeng@huawei.com,
        linux-arm-kernel@lists.infradead.org, linux-hyperv@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 1/2] net: add includes masked by netdevice.h
 including uapi/bpf.h
Message-ID: <20220106130337.qtvjgffwlyzy7j2y@liuwe-devbox-debian-v2>
References: <20211230012742.770642-1-kuba@kernel.org>
 <20211230012742.770642-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230012742.770642-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 29, 2021 at 05:27:41PM -0800, Jakub Kicinski wrote:
> Add missing includes unmasked by the subsequent change.
> 
> Mostly network drivers missing an include for XDP_PACKET_HEADROOM.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[...]
>  drivers/net/ethernet/microsoft/mana/mana_en.c      | 2 ++

This seems trivially correct, so in case an ack is needed:

Acked-by: Wei Liu <wei.liu@kernel.org>

> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index c1d5a374b967..2ece9e90dc50 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1,6 +1,8 @@
>  // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>  /* Copyright (c) 2021, Microsoft Corporation. */
>  
> +#include <uapi/linux/bpf.h>
> +
>  #include <linux/inetdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/ethtool.h>
