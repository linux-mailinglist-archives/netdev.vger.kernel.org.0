Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6608640F934
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbhIQNfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:35:17 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:2839 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbhIQNfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 09:35:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631885634; x=1663421634;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=x4RJssw+7dVIrPj9daSLbtKLXu4OSSZABqnVXRGzue0=;
  b=AxIUA2xuEdY6IXJEfRNEpRfUULHIoi6CfjlsCAUs51A8OD8Njyy772+n
   +eLSbkfJEnvXiJ3710uWnTipU/yxoe/7m5n8A1KieQVi2ZPFOOV9JLljg
   M5ZhIdxdVJoow1iSyWKdaRk1jwLX7BircwGvDvL4rCDXKQqMsmdBim8Gz
   w8D+erLbAOcpL3kpp2jKKOAKtKggabRMrQBWU1Z7z47yLehQ19VTAldVr
   YVN7+BWyFbSLHOpWllpjyowM3RvBUNEZY/8U+dXS+yG1Bp69oYS13a6Wd
   7/8AEuRBZWk0C4gNqm780kvQdFvi18NXAv3Z2BZ7jHe8xPa7i2rZGUgZe
   w==;
IronPort-SDR: 4so8ygShf00sLEeHrXAkq7g4tmqvZFemzMK02tq61NkwKt3Esg1hKx01I9Om80KlK9UVnBx/qp
 CWJPnm1mNCcuXOAkmTFraPlQUO6ssnz0sqO/aUsR8K2ddUU4H/ywOX7p2YSfBnwoooTiIoVQlS
 xZjxW/6mtmLi/rWBD2rFlckywM9EmqAfimnWzbBtWk1O0KQovEo3TmFXBxAxEFO+9YUw1kYpgJ
 fcMFuFPfp9D0uYX0S6fjecN2BnGiFwtHf4QWiQ3J9azBGFTRVnRkcsCSTOFAlVBCPk5PuFolEk
 fuHVDx1wk/flN/uJ939gH3Je
X-IronPort-AV: E=Sophos;i="5.85,301,1624345200"; 
   d="scan'208";a="132210814"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Sep 2021 06:33:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 17 Sep 2021 06:33:49 -0700
Received: from [10.171.246.21] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 17 Sep 2021 06:33:47 -0700
Subject: Re: [PATCH v2 4/4] net: macb: enable mii on rgmii for sama7g5
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210917132615.16183-1-claudiu.beznea@microchip.com>
 <20210917132615.16183-5-claudiu.beznea@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <216f6e40-0faa-027a-6a73-e516a02bb21b@microchip.com>
Date:   Fri, 17 Sep 2021 15:33:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210917132615.16183-5-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/09/2021 at 15:26, Claudiu Beznea wrote:
> Both MAC IPs available on SAMA7G5 support MII on RGMII feature.
> Enable these by adding proper capability to proper macb_config
> objects.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Yes:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Claudiu, best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index cdf3e35b5b33..e2730b3e1a57 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4597,7 +4597,8 @@ static const struct macb_config zynq_config = {
>   };
>   
>   static const struct macb_config sama7g5_gem_config = {
> -	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG,
> +	.caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_CLK_HW_CHG |
> +		MACB_CAPS_MIIONRGMII,
>   	.dma_burst_length = 16,
>   	.clk_init = macb_clk_init,
>   	.init = macb_init,
> @@ -4605,7 +4606,8 @@ static const struct macb_config sama7g5_gem_config = {
>   };
>   
>   static const struct macb_config sama7g5_emac_config = {
> -	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII | MACB_CAPS_USRIO_HAS_CLKEN,
> +	.caps = MACB_CAPS_USRIO_DEFAULT_IS_MII_GMII |
> +		MACB_CAPS_USRIO_HAS_CLKEN | MACB_CAPS_MIIONRGMII,
>   	.dma_burst_length = 16,
>   	.clk_init = macb_clk_init,
>   	.init = macb_init,
> 


-- 
Nicolas Ferre
