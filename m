Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1F66D6ACB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 19:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbjDDRjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 13:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbjDDRi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 13:38:57 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B97B3592;
        Tue,  4 Apr 2023 10:38:41 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id w13so13400360oik.2;
        Tue, 04 Apr 2023 10:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680629918;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OUv6k2Uh5jkM5mEyXVNFaojehSiy7Y/RZcUma/KcnAI=;
        b=L6RgetY5tp5K6lYmzwW/7MJvwo/5T1uePiyIFZcILjfhglnNFulr+LY9Zloyy9Rc7M
         6WknythUOUv1dY9YEJcB/mIBXI2HxZyS0JxNZAb+rU4k1koOAgPdOOXGzomPBaBCDfma
         GgtjHXJpnvugkFUVDjSmLC1qt5QmTgZRMZME8T62clG6o5ep0OR1bVOJjjoOy1o08M3N
         9wEPoyHiTM89u/YFcMnd8lvitMqvspR9rDQrVCY1dr0V7RyoDyRIB8zge5K7Y+jYLQ5O
         9pLPlUAQBZ6k1jbfl41hDslKF7eDoRgd/c2IODP6xtq4LwQSsqOnCUyHnr7EzHB/wvuo
         b3mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680629918;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OUv6k2Uh5jkM5mEyXVNFaojehSiy7Y/RZcUma/KcnAI=;
        b=IVl3zJwgbTKpcH9j6kp1ybGXLp68RgEGJVeNPW9JiU6zm/n+OhpLSn/nnkG3MZNSCY
         2Rgw/vUUnfIHWNULSQvYNaXBN+7Pnl9lGuF/Y7kMPzhXRpIAPGQ1tc8PVvdg+49YQDNL
         HkaKJzp+P6CiPcmSldm3OlwjayfSHCuIWeOUS5hTYhMFmEnj8IpkAEPQbJBDeqGAJCyy
         fZcCSeavYd3rXQCYEg7rKuTPhKIbziiWvJpvizpZWIcpzY6xKxOAE4GsnlComha/i8zm
         1UO4exoof5jSf98eiimJnc1eFQRa36z2pGaj7myV+lwMbJovmoXG8cf7ytPHz7uCucLj
         UVlA==
X-Gm-Message-State: AAQBX9dvkegqBWW+6Vn94NHm7d+eNzUNir/U+vrFNEjSyOEunyYh2gHM
        F8f0c8YfPtGnQTPQoOFVnoA=
X-Google-Smtp-Source: AKy350bDFfS+JH2xVsSlK+yUFd8jbPMuZWYgyg2yHimyixwq4LOtyBL2VGad60yuV3R5s0hLaWcSjQ==
X-Received: by 2002:aca:3b07:0:b0:389:4ca4:6385 with SMTP id i7-20020aca3b07000000b003894ca46385mr58198oia.23.1680629917994;
        Tue, 04 Apr 2023 10:38:37 -0700 (PDT)
Received: from neuromancer. (76-244-6-13.lightspeed.rcsntx.sbcglobal.net. [76.244.6.13])
        by smtp.gmail.com with ESMTPSA id bf10-20020a0568700a0a00b0017264f96879sm4913861oac.17.2023.04.04.10.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 10:38:37 -0700 (PDT)
Message-ID: <642c609d.050a0220.46d72.9a10@mx.google.com>
X-Google-Original-Message-ID: <ZCxgmwMVomTFm7wW@neuromancer.>
Date:   Tue, 4 Apr 2023 12:38:35 -0500
From:   Chris Morgan <macroalpha82@gmail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Subject: Re: [PATCH v4 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-10-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403202440.276757-10-martin.blumenstingl@googlemail.com>
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 10:24:40PM +0200, Martin Blumenstingl wrote:
> Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> well as the existing RTL8821C chipset code.
> 
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---

Unfortunately this version isn't working for me currently. When I try
to probe the driver I get an error of "mac power on failed". After some
debugging it looks like there are some SDIO bits in the
rtw_pwr_seq_parser() function that are missing, causing it to return
-EINVAL. I tried to add those specific bits back based on your latest
github, but then I get additonal errors like "failed to read efuse map"
and other errors. I'm wondering if there are bits that might be missing
for the rtl8821cs in this revision.

Thank you,
Chris Morgan.

> Changes since v3:
> - add Ping-Ke's reviewed-by
> 
> Changes since v2:
> - sort includes alphabetically as suggested by Ping-Ke
> - add missing #include "main.h" (after it has been removed from sdio.h
>   in patch 2 from this series)
> 
> Changes since v1:
> - use /* ... */ style for copyright comments
> 
> 
>  drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
>  drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
>  .../net/wireless/realtek/rtw88/rtw8821cs.c    | 36 +++++++++++++++++++
>  3 files changed, 50 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
> index 6b65da81127f..29eb2f8e0eb7 100644
> --- a/drivers/net/wireless/realtek/rtw88/Kconfig
> +++ b/drivers/net/wireless/realtek/rtw88/Kconfig
> @@ -133,6 +133,17 @@ config RTW88_8821CE
>  
>  	  802.11ac PCIe wireless network adapter
>  
> +config RTW88_8821CS
> +	tristate "Realtek 8821CS SDIO wireless network adapter"
> +	depends on MMC
> +	select RTW88_CORE
> +	select RTW88_SDIO
> +	select RTW88_8821C
> +	help
> +	  Select this option will enable support for 8821CS chipset
> +
> +	  802.11ac SDIO wireless network adapter
> +
>  config RTW88_8821CU
>  	tristate "Realtek 8821CU USB wireless network adapter"
>  	depends on USB
> diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
> index 6105c2745bda..82979b30ae8d 100644
> --- a/drivers/net/wireless/realtek/rtw88/Makefile
> +++ b/drivers/net/wireless/realtek/rtw88/Makefile
> @@ -59,6 +59,9 @@ rtw88_8821c-objs		:= rtw8821c.o rtw8821c_table.o
>  obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
>  rtw88_8821ce-objs		:= rtw8821ce.o
>  
> +obj-$(CONFIG_RTW88_8821CS)	+= rtw88_8821cs.o
> +rtw88_8821cs-objs		:= rtw8821cs.o
> +
>  obj-$(CONFIG_RTW88_8821CU)	+= rtw88_8821cu.o
>  rtw88_8821cu-objs		:= rtw8821cu.o
>  
> diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cs.c b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> new file mode 100644
> index 000000000000..a359413369a4
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/rtw8821cs.c
> @@ -0,0 +1,36 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright(c) Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> + */
> +
> +#include <linux/mmc/sdio_func.h>
> +#include <linux/mmc/sdio_ids.h>
> +#include <linux/module.h>
> +#include "main.h"
> +#include "rtw8821c.h"
> +#include "sdio.h"
> +
> +static const struct sdio_device_id rtw_8821cs_id_table[] =  {
> +	{
> +		SDIO_DEVICE(SDIO_VENDOR_ID_REALTEK,
> +			    SDIO_DEVICE_ID_REALTEK_RTW8821CS),
> +		.driver_data = (kernel_ulong_t)&rtw8821c_hw_spec,
> +	},
> +	{}
> +};
> +MODULE_DEVICE_TABLE(sdio, rtw_8821cs_id_table);
> +
> +static struct sdio_driver rtw_8821cs_driver = {
> +	.name = "rtw_8821cs",
> +	.probe = rtw_sdio_probe,
> +	.remove = rtw_sdio_remove,
> +	.id_table = rtw_8821cs_id_table,
> +	.drv = {
> +		.pm = &rtw_sdio_pm_ops,
> +		.shutdown = rtw_sdio_shutdown,
> +	}
> +};
> +module_sdio_driver(rtw_8821cs_driver);
> +
> +MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com>");
> +MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821cs driver");
> +MODULE_LICENSE("Dual BSD/GPL");
