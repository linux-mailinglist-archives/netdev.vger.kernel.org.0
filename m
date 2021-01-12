Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2AF2F29A3
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392217AbhALID1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:03:27 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:5588 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729208AbhALID1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:03:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610438606; x=1641974606;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=6Ch+R2DrlX2CjzbWKSII2OakiQx5DrtvKXaucWoyg84=;
  b=0aBtB7u4AjkAZoyiKtPFjZx5TindlxduxJmgiruCe4ME4/MhWtDAqw3/
   XJPWSxDsuCeDfUj5IpKXSOYFzwcOxjtbd7Q0apPgD0SpOhYd1WJsCAMWX
   g6Wlvf6OdWo1D32+S2m17QSBvf+FvantlJxQrk16N5I6nM5KGAklx+RXe
   CACJlycKxg1J4Y9VMyLrgeUbyA3yUyNl6jZPRy7W8O73rrOwn7OjCo2OO
   xvpvLNW3siR3i8oSbe8arvaI+uWPpBpQ1Xsta5O+ysb6Qjyz603ouTi6X
   4XJmw+2ph+qZYRmcqc8IBJnTfXmGKoMUvmuYJO/XdCwVAXrFRtGt2cMSR
   g==;
IronPort-SDR: szKoAiWQim5xE+FMgbg+DMNYV4H6tSuzZTUb3pkmifUsz9sLzhPcU9e1i6fU1LFY2iB/isQzIR
 tWxsht+CASKpgpBM91j8Pnnpgk02pq+olC8dAwCbWdW1Ju08o7P7rDki6zchqHgw9d4AVc3gyC
 c0l+tysw5sshm/D63bSVaxSxFfM92+YGHW6JLRpWI3J8XHAOLVrr31tdlaItlcjmFI8XPZO0hu
 aWkm80Rf1pJ/WOkVDCsrafQ6FzCvJbqobSQErrgTAQex1kslCeHwZi1SV0qK2/3urMSLAVYCNB
 v5E=
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="99766811"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2021 01:02:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 01:02:10 -0700
Received: from [10.171.246.70] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 12 Jan 2021 01:02:08 -0700
Subject: Re: [PATCH net v2] net: macb: Add default usrio config to default gem
 config
To:     Atish Patra <atish.patra@wdc.com>, <netdev@vger.kernel.org>
CC:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
References: <20210112014728.3788473-1-atish.patra@wdc.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <3e611151-7fd4-bfb7-91ad-76245bf7cdb1@microchip.com>
Date:   Tue, 12 Jan 2021 09:02:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210112014728.3788473-1-atish.patra@wdc.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/01/2021 at 02:47, Atish Patra wrote:
> There is no usrio config defined for default gem config leading to
> a kernel panic devices that don't define a data. This issue can be
> reproduced with microchip polar fire soc where compatible string
> is defined as "cdns,macb".
> 
> Fixes: edac63861db7 ("net: macb: Add default usrio config to default gem config")
> Signed-off-by: Atish Patra <atish.patra@wdc.com>

Indeed.
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks! Best regards,
   Nicolas

> ---
> Changes from v1->v2:
> 1. Fixed that fixes tag.
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 814a5b10141d..47ee72ab7002 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4590,6 +4590,7 @@ static const struct macb_config default_gem_config = {
>          .dma_burst_length = 16,
>          .clk_init = macb_clk_init,
>          .init = macb_init,
> +       .usrio = &macb_default_usrio,
>          .jumbo_max_len = 10240,
>   };
> 
> --
> 2.25.1
> 


-- 
Nicolas Ferre
