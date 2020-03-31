Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91A7198CD8
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 09:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgCaHVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 03:21:01 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35897 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgCaHVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 03:21:00 -0400
Received: from [192.168.2.10] ([46.9.234.233])
        by smtp-cloud7.xs4all.net with ESMTPA
        id JBCajz1YpLu1fJBCejHCjJ; Tue, 31 Mar 2020 09:20:58 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xs4all.nl; s=s1;
        t=1585639258; bh=vFLAFhFQyb8gbOSDxO/VdFf8CdbtbKDUC1VbJ0Ed4G8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type:From:
         Subject;
        b=gbPi5YAr5hxI+IP+zZ+HYziBEXN0T2iw9gDqp91WtQMjptvSTPRUZ4z0w/kZoiQVU
         nTPg0EUDN5XnbWKYt91gRC1SqYirOEb0PzZjNH8kmVbpHgjqc5fqvNZH+xv9oEHUrM
         8Fq74/BqVf9GvIrRHdZ6wd0PZqhwu189HWHwc0FeF0z/WJq3i9KM67H+d24/7YI05m
         ZRGhTqjpHabK7xpT7AGvDKqSkG70OMPqtVvDm8YmcP51AVqo24kMvAc4QLshzLPwyb
         mIK+1byC+17cml41lF5WeDYxpjB2Lyu1c1H0IDXjFO8VXNLEHIrNffAWkt7Cp6S5C4
         dBaiTUPDFMpwQ==
Subject: Re: [PATCH] Update my email address in various drivers
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        dri-devel@lists.freedesktop.org, etnaviv@lists.freedesktop.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <E1jIV26-0005X3-RS@rmk-PC.armlinux.org.uk>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <4362392b-132d-c316-3a54-e6cc05cab659@xs4all.nl>
Date:   Tue, 31 Mar 2020 09:20:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <E1jIV26-0005X3-RS@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfC+slg84mdYP89l6SxInCHeF3g0JtL9VqM18bDfdysIjAFPUT6OD/g1M51H/cR6bMpfTtDuuoFy2dHpRDp4BgyY7h7u/IYlu59Kzm59ciC0z0BN13Eck
 yvrPJVFXdzoYP9kSvXta9VQvTMgFCseEXD6rVcCWXpPZOQgglWaOkRsyeTyPEExASsJ0dsVWT5czOOo6QRfi98A61dWYBawRg5ZMBYvykkDfsKirYNYyFKiS
 QKu3aNNUfhNt4o/AVQIyaOrJW1dMLmCeEzSs9/6i8yuEm48Ujlgj4UFcrtKs/PoWFN9lhdpRpk0DsgNrRxH86vfJLfk8ZARnNOIHsVltDe1GpVhOmiWaLDVa
 JQOr1dWy9lf7MjKq4nytQgx0TC4zx3cCB50w2raxgFIwMCQpYGSv7Z7lCts2QwqZQbiycnNwIqPEl5Rcx2TpNJhThriuwOf78/PizDhwo+ONWCIPbnLy45bY
 GzB1iPXCx3Vx8bRwgISgeB76Au28GRYPu4vM9gSn/HCO3XgT5Y9sOoyvP3o9V/xvUWt9xD1I+mIRMWEPuqpM7K9rzChTmcSiFhDUL/4L7Q5+Y/thdbN2K9Yz
 QKIUh/odmDnuZrjkHboaA6eRZIhQMdXuX4X5hQmBf1Yxs/B3XJ1nuYfEVKWP7EFmTDAh2mv5OX8l4DFtS0gXCeCo6a/4WeJu75oCCCNw03x+8FHvapY1+4p/
 aK6S0f2dWLF2lwX7w1BCMa8wsjuxERLnsEIrkX8lhxzBaVsgA4N27FanHbO3RQHw48i7MvKZ9M/RDOgNkQLr4wt/J9fuPCJe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/29/20 12:19 PM, Russell King wrote:
> Globally update my email address in six files scattered through the
> tree.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

For media/cec files:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> ---
>  drivers/gpu/drm/armada/armada_drv.c                 | 2 +-
>  drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c | 2 +-
>  drivers/gpu/drm/etnaviv/etnaviv_drv.c               | 2 +-
>  drivers/media/cec/cec-notifier.c                    | 2 +-
>  drivers/net/phy/swphy.c                             | 2 +-
>  include/media/cec-notifier.h                        | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/armada/armada_drv.c b/drivers/gpu/drm/armada/armada_drv.c
> index 3df2dacf4c94..5a82a12cd105 100644
> --- a/drivers/gpu/drm/armada/armada_drv.c
> +++ b/drivers/gpu/drm/armada/armada_drv.c
> @@ -389,7 +389,7 @@ static void __exit armada_drm_exit(void)
>  }
>  module_exit(armada_drm_exit);
>  
> -MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
> +MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
>  MODULE_DESCRIPTION("Armada DRM Driver");
>  MODULE_LICENSE("GPL");
>  MODULE_ALIAS("platform:armada-drm");
> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
> index e8e3e9339ff9..f6f55776e43e 100644
> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.c
> @@ -698,7 +698,7 @@ static struct platform_driver snd_dw_hdmi_driver = {
>  
>  module_platform_driver(snd_dw_hdmi_driver);
>  
> -MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
> +MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
>  MODULE_DESCRIPTION("Synopsis Designware HDMI AHB ALSA interface");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS("platform:" DRIVER_NAME);
> diff --git a/drivers/gpu/drm/etnaviv/etnaviv_drv.c b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
> index 1f9c01be40d7..d6798f716b77 100644
> --- a/drivers/gpu/drm/etnaviv/etnaviv_drv.c
> +++ b/drivers/gpu/drm/etnaviv/etnaviv_drv.c
> @@ -739,7 +739,7 @@ static void __exit etnaviv_exit(void)
>  module_exit(etnaviv_exit);
>  
>  MODULE_AUTHOR("Christian Gmeiner <christian.gmeiner@gmail.com>");
> -MODULE_AUTHOR("Russell King <rmk+kernel@arm.linux.org.uk>");
> +MODULE_AUTHOR("Russell King <rmk+kernel@armlinux.org.uk>");
>  MODULE_AUTHOR("Lucas Stach <l.stach@pengutronix.de>");
>  MODULE_DESCRIPTION("etnaviv DRM Driver");
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/cec/cec-notifier.c b/drivers/media/cec/cec-notifier.c
> index 7cf42b133dbc..2d4f7dd7cef7 100644
> --- a/drivers/media/cec/cec-notifier.c
> +++ b/drivers/media/cec/cec-notifier.c
> @@ -2,7 +2,7 @@
>  /*
>   * cec-notifier.c - notify CEC drivers of physical address changes
>   *
> - * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
> + * Copyright 2016 Russell King.
>   * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>   */
>  
> diff --git a/drivers/net/phy/swphy.c b/drivers/net/phy/swphy.c
> index 53c214a22b95..774814714c82 100644
> --- a/drivers/net/phy/swphy.c
> +++ b/drivers/net/phy/swphy.c
> @@ -2,7 +2,7 @@
>  /*
>   * Software PHY emulation
>   *
> - * Code taken from fixed_phy.c by Russell King <rmk+kernel@arm.linux.org.uk>
> + * Code taken from fixed_phy.c by Russell King.
>   *
>   * Author: Vitaly Bordug <vbordug@ru.mvista.com>
>   *         Anton Vorontsov <avorontsov@ru.mvista.com>
> diff --git a/include/media/cec-notifier.h b/include/media/cec-notifier.h
> index 985afea1ee36..e2b1b894aae7 100644
> --- a/include/media/cec-notifier.h
> +++ b/include/media/cec-notifier.h
> @@ -2,7 +2,7 @@
>  /*
>   * cec-notifier.h - notify CEC drivers of physical address changes
>   *
> - * Copyright 2016 Russell King <rmk+kernel@arm.linux.org.uk>
> + * Copyright 2016 Russell King.
>   * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
>   */
>  
> 

