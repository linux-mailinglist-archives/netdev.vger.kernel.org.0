Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F4A25F3B3
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgIGHOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:14:42 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:20714 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgIGHOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 03:14:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599462878; x=1630998878;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Y7oDb5/FODXV7HHi1MpRdKuK+6Tp0mioP3P/5OGw8h4=;
  b=WBK3oy+T8FUxuvhF1v+iTxhvcyx3UX3Zw+v0FHF0UcEIr2Q3UaOVisBV
   /vn7gG2HGGNDA1BWXlQegyjj7/cIYpJKsGMzZxWKLQBXUTDFvvzH2m1cs
   M8FrJrVOmcUCbi9bLjp5gU3uIiMDPF6rCb6qH57C/Eno7MYzDLx0BIvmZ
   8vz7I/sYxDRSXucHNs+HAKxD9qciawivNvj16GLUTmLnkMhIAjmojEybs
   Khz4110hQ5lpDf0fNHOzvmvqt4yx3c9K7P2rPDc54pyKZfZaoHJnW9z0p
   wo9r7cPz5tUN/tgPobJrqgzWKYcAS7W1vUIE7TQ43GgT9hjPOOovL7d1y
   A==;
IronPort-SDR: z6t7A0mi6Bafol82XW8IuxqhJcFsNuIBKJe6uAoXwZpxlioNj+mUj8R5+BWt7DZChg5yaRcOw/
 2nQAEIUhDaNMnz60xaEs9g2DnmCW5mjY5qFQNkprga0f5VjfTC6zafIGgcMbYtyKH5jj83OiHs
 spFGRCVnVUrn7fFekQXCOsR9EwtKfeQBOlAcSZFbUcolpXUEtJgAGjHE6aeJrGM8mB0u947fDs
 QWlEgBYyT48QOJO+qSAevz+8w9fDuJy1Mp1IyMGJAtIfMFlLdd1CGZqtSBr2rFlJknRzgyLarR
 EnM=
X-IronPort-AV: E=Sophos;i="5.76,401,1592895600"; 
   d="scan'208";a="90045661"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Sep 2020 00:14:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Sep 2020 00:14:15 -0700
Received: from [10.171.246.27] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 7 Sep 2020 00:14:13 -0700
Subject: Re: [PATCH net] net: macb: fix for pause frame receive enable bit
To:     Parshuram Thombare <pthombar@cadence.com>,
        <alexandre.belloni@bootlin.com>
CC:     <claudiu.beznea@microchip.com>, <antoine.tenart@bootlin.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <f.fainelli@gmail.com>, <linux-kernel@vger.kernel.org>,
        <mparab@cadence.com>
References: <1599294093-30758-1-git-send-email-pthombar@cadence.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <6069131d-118e-0387-f312-25449a545c2a@microchip.com>
Date:   Mon, 7 Sep 2020 09:14:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1599294093-30758-1-git-send-email-pthombar@cadence.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/09/2020 at 10:21, Parshuram Thombare wrote:
> PAE bit of NCFGR register, when set, pauses transmission
> if a non-zero 802.3 classic pause frame is received.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>

For the record:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Parshuram for having found this issue.
Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 6761f40..9179f7b 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -647,8 +647,7 @@ static void macb_mac_link_up(struct phylink_config *config,
>                                  ctrl |= GEM_BIT(GBE);
>                  }
> 
> -               /* We do not support MLO_PAUSE_RX yet */
> -               if (tx_pause)
> +               if (rx_pause)
>                          ctrl |= MACB_BIT(PAE);
> 
>                  macb_set_tx_clk(bp->tx_clk, speed, ndev);
> --
> 1.7.1
> 


-- 
Nicolas Ferre
