Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D9021856C
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbgGHLCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:02:05 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:44055 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbgGHLCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:02:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594206124; x=1625742124;
  h=subject:to:references:from:message-id:date:mime-version:
   in-reply-to:content-transfer-encoding;
  bh=wmuV9psr/Peaq9G11JJtpKoYnlH6sHa9TFptgxN5frg=;
  b=YDVLL3qj/MXgPKgIcEVMX6jboJIgjc+0L/pxdz2MMXabjZNOaDc2/br9
   8BrOcJGqBA8ULFUasMsL79aJtVEMy5hiKEzujZUsXZGMj/TdkQ2xZufVZ
   ayluqStfJ8CxvfbeT+UaRDUi1Yx64T9eAH0jcgE88G0neL8mG8EXR74GA
   vsYEbpxzknlP6Dg9jpDZ7lMuYB4AgWhH4WJLj1A9VCUJ7EbdV6hH9E8FY
   xaCwgV94XZ8BPVgizhsFDU1QN6XSNbiCciQWtem4I1OgQzoP39mLU66l3
   Xgyq3PgAFcIMxOJQaNimrs775BO8luBMiKFc+b3w7FCWkBY4nZHDzUJp0
   A==;
IronPort-SDR: r4wtfuMLILFnSiHL3BRw2lBDOloCRi8JcohnL3jslrPsWmXnBZRgB24Ro0HHCIc4G8M7Zq5jsl
 zIKh98lObXs0nxGiLpA5erTlJ+fsaXNwEXPIe2vlAxsgs1/+LZzvrfg5NuH3zKVLmS6tJaHaq3
 1QI/YPIzeo7KIQ3P3bQ31h0B8Ky3++XiFIxgzVWmlzCztDcbQqRfFxvqOV5kKfFVRwu1EBXl7B
 7RSdrwBpybxJ3N7AqPwNyKB4mwgOdOv7bFPO+Kg760dMphyZPMJy1BIIzVlbGDq5hyv+6JPKr0
 xek=
X-IronPort-AV: E=Sophos;i="5.75,327,1589266800"; 
   d="scan'208";a="82267012"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2020 04:02:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 8 Jul 2020 04:01:36 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 8 Jul 2020 04:01:34 -0700
Subject: Re: [PATCH] Replace HTTP links with HTTPS ones: ATMEL MACB ETHERNET
 DRIVER
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200708103519.13915-1-grandmaster@al2klimov.de>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <caf7b073-a254-44a9-9466-b919b03596cf@microchip.com>
Date:   Wed, 8 Jul 2020 13:01:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200708103519.13915-1-grandmaster@al2klimov.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07/2020 at 12:35, Alexander A. Klimov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>    If not .svg:
>      For each line:
>        If doesn't contain `\bxmlns\b`:
>          For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>            If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>              If both the HTTP and HTTPS versions
>              return 200 OK and serve the same content:
>                Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

The links go to Cadence. If people from Cadence want to change 
something, don't hesitate to speak out. On my side:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   Continuing my work started at 93431e0607e5.
>   See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>   (Actually letting a shell for loop submit all this stuff for me.)
> 
>   If there are any URLs to be removed completely or at least not HTTPSified:
>   Just clearly say so and I'll *undo my change*.
>   See also: https://lkml.org/lkml/2020/6/27/64
> 
>   If there are any valid, but yet not changed URLs:
>   See: https://lkml.org/lkml/2020/6/26/837
> 
>   If you apply the patch, please let me know.
> 
> 
>   drivers/net/ethernet/cadence/macb_pci.c | 2 +-
>   drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
> index 617b3b728dd0..cd7d0332cba3 100644
> --- a/drivers/net/ethernet/cadence/macb_pci.c
> +++ b/drivers/net/ethernet/cadence/macb_pci.c
> @@ -2,7 +2,7 @@
>   /**
>    * Cadence GEM PCI wrapper.
>    *
> - * Copyright (C) 2016 Cadence Design Systems - http://www.cadence.com
> + * Copyright (C) 2016 Cadence Design Systems - https://www.cadence.com
>    *
>    * Authors: Rafal Ozieblo <rafalo@cadence.com>
>    *         Bartosz Folta <bfolta@cadence.com>
> diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethernet/cadence/macb_ptp.c
> index 43a3f0dbf857..31ebf3ee7ec0 100644
> --- a/drivers/net/ethernet/cadence/macb_ptp.c
> +++ b/drivers/net/ethernet/cadence/macb_ptp.c
> @@ -2,7 +2,7 @@
>   /**
>    * 1588 PTP support for Cadence GEM device.
>    *
> - * Copyright (C) 2017 Cadence Design Systems - http://www.cadence.com
> + * Copyright (C) 2017 Cadence Design Systems - https://www.cadence.com
>    *
>    * Authors: Rafal Ozieblo <rafalo@cadence.com>
>    *          Bartosz Folta <bfolta@cadence.com>
> --
> 2.27.0
> 


-- 
Nicolas Ferre
