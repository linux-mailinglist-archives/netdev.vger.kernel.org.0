Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4258440D3C0
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbhIPH1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:27:13 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:16768 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhIPH1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 03:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631777149; x=1663313149;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=+cB0Ekh8IpXQNeJaDPNfiBsWeb1pt6pnZjUTIg4exrk=;
  b=SMfISRg+f8NMfbxcTtYhrVORo1s8Q4KAl2JIFcDNsoC//RKFAvGoIIa+
   8Zck7Di8Msap/6++ng7do/0EiayQi8ZlpHX8gRj2K87xOchaE3uOUdGg9
   KTl0huPkz50YSn8Z1v/olVX1JujcS2G/4MDWklmFkVNOlHUhTF0r2LKub
   5WN7Flk8o+8ykFyCqq1xXD8SuQXdRlptOY0j+dSylj61zZHQ7r7l5cN1q
   ltujLSkwX+Q6N5WZ7tEGDSRAg2L2Uyk1GRJoovArrW7kXLF+E2Iljg9KU
   zYzG/x4Qg5S1hWqnKzNw1w2hazP6mumvY16NlVxwftt+JvqW4/ZA5PFeo
   Q==;
IronPort-SDR: Gf7KAlYbfeU97ZXiPz7s1LTH2P/EKuKZ5dd3bjr2IG7rAy9BuljZP6aXbiXTKxlFES0l6j98wy
 k2Bn5iKBlESO6tkTq47kSGU40RmjCGeQ5dLc4vtQI5w/DXkUhaBZuJJU94dFVzctdNj2PWngyY
 ltPbo0oco0lDzTNN45y7MmLSJCNH5L0vq6zi3hZ8b7Jfsplrksn/OjXugPYjN5yLDTRqmMTPLM
 WChDFNpWEvvVNXtsU2bWd1uNDhAkVZlNP7clCMpS4F9TksLPT1Poa77tLy+f7NHrCqZ5MEVVGR
 VcVItcthE/i+Pct3DH63uxZ9
X-IronPort-AV: E=Sophos;i="5.85,297,1624345200"; 
   d="scan'208";a="144332533"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2021 00:25:48 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 16 Sep 2021 00:25:48 -0700
Received: from [10.159.245.112] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 16 Sep 2021 00:25:46 -0700
Subject: Re: [PATCH] net: cadence: macb: Make use of the helper function
 dev_err_probe()
To:     Cai Huoqing <caihuoqing@baidu.com>
CC:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210915145804.7357-1-caihuoqing@baidu.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <9318f9be-88f3-5405-11fa-b51a8ada7c2c@microchip.com>
Date:   Thu, 16 Sep 2021 09:25:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210915145804.7357-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2021 at 16:58, Cai Huoqing wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.

Well, I don't see where the PROBE_DEFER error could be triggered by the 
call graph of this function: can you please point me to where this error 
could come from?

Best regards,
   Nicolas


> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>

NACK, for now.

> ---
>   drivers/net/ethernet/cadence/macb_pci.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
> index 8b7b59908a1a..d09c570a15ae 100644
> --- a/drivers/net/ethernet/cadence/macb_pci.c
> +++ b/drivers/net/ethernet/cadence/macb_pci.c
> @@ -35,10 +35,8 @@ static int macb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> 
>          /* enable pci device */
>          err = pcim_enable_device(pdev);
> -       if (err < 0) {
> -               dev_err(&pdev->dev, "Enabling PCI device has failed: %d", err);
> -               return err;
> -       }
> +       if (err < 0)
> +               return dev_err_probe(&pdev->dev, err, "Enabling PCI device has failed\n");
> 
>          pci_set_master(pdev);
> 
> --
> 2.25.1
> 


-- 
Nicolas Ferre
