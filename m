Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064EB6BD4BA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjCPQLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCPQLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:11:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08276C8897;
        Thu, 16 Mar 2023 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678983087; x=1710519087;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lKYhuaMzcKImp1yngB1J3IxPO+Zmeev4X0HIDMeMQDA=;
  b=X9H88HOatSNmnt1l3TXaEKl5+RAiqlBICC+IyVwMtjBJXv/+xj7CkWJ/
   7KsaVvrTALP2HLbTG6eQetv+x9N9mD0U3B6CIKKaQzEv79gmAHWjlzN0W
   2VYd8N3wvLYQnkdvoJQCAQZ4P5135KnG9fqhzvXA6UvGqBFvQh0w2Y9uA
   tTE7+QNSVwetYBuVchUNRdOI30aT6S1G0ux51BH72TzVWT59kPWMV7CQ8
   PKOQjYZYvjvJ6+h+8EaGoD4InbQcdjV+uJ8UgqG708nOul/G29oERjIb3
   6a/92/xrfeYFi6LnDj58IaE3jPyOp5iqoIZSEra92qadguXeHe2CQWKyO
   w==;
X-IronPort-AV: E=Sophos;i="5.98,265,1673938800"; 
   d="scan'208";a="202006481"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2023 09:11:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 09:11:19 -0700
Received: from [10.171.246.59] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 16 Mar 2023 09:11:16 -0700
Message-ID: <25bef3fc-a2f1-c121-ba27-c1824743d248@microchip.com>
Date:   Thu, 16 Mar 2023 17:11:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] net: macb: Set MDIO clock divisor for pclk higher than
 160MHz
To:     Bartosz Wawrzyniak <bwawrzyn@cisco.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xe-linux-external@cisco.com>, <danielwa@cisco.com>,
        <olicht@cisco.com>, <mawierzb@cisco.com>
References: <20230316100339.1302212-1-bwawrzyn@cisco.com>
Content-Language: en-US
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
In-Reply-To: <20230316100339.1302212-1-bwawrzyn@cisco.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2023 at 11:03, Bartosz Wawrzyniak wrote:
> Currently macb sets clock divisor for pclk up to 160 MHz.
> Function gem_mdc_clk_div was updated to enable divisor
> for higher values of pclk.
> 
> Signed-off-by: Bartosz Wawrzyniak <bwawrzyn@cisco.com>

Looks good to me:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks for your patch. Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb.h      | 2 ++
>   drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 14dfec4db8f9..c1fc91c97cee 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -692,6 +692,8 @@
>   #define GEM_CLK_DIV48                          3
>   #define GEM_CLK_DIV64                          4
>   #define GEM_CLK_DIV96                          5
> +#define GEM_CLK_DIV128                         6
> +#define GEM_CLK_DIV224                         7
> 
>   /* Constants for MAN register */
>   #define MACB_MAN_C22_SOF                       1
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 6e141a8bbf43..8708af6d25ed 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2641,8 +2641,12 @@ static u32 gem_mdc_clk_div(struct macb *bp)
>                  config = GEM_BF(CLK, GEM_CLK_DIV48);
>          else if (pclk_hz <= 160000000)
>                  config = GEM_BF(CLK, GEM_CLK_DIV64);
> -       else
> +       else if (pclk_hz <= 240000000)
>                  config = GEM_BF(CLK, GEM_CLK_DIV96);
> +       else if (pclk_hz <= 320000000)
> +               config = GEM_BF(CLK, GEM_CLK_DIV128);
> +       else
> +               config = GEM_BF(CLK, GEM_CLK_DIV224);
> 
>          return config;
>   }
> --
> 2.33.0
> 

-- 
Nicolas Ferre

