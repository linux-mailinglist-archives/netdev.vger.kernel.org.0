Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492E31FF831
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 17:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbgFRPxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 11:53:07 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:65016 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729225AbgFRPxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 11:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592495585; x=1624031585;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=hTn4UBObJuaxDPv1HSr82vcMXBIjmYhw0RP1gEzZsnc=;
  b=YgO6FGYx0wBzSS1rjXTEEIA68pjV6Cctay+HqsJaabVVUY7CKhJf84uW
   jj3Xj7c35voRXqoB73rtIK906Oj+a/9iDaLyiETSfNhnLXoKQ4j7uYvrB
   Ai9aYMjHP3Nv3JQcy3bkQuK50CaD6ZwnN6T4ZFm4h9dsvD/DEnTAHXzMc
   OIu61ibUsmjW11nDRXB7RukqLbUySuY6rS6+4dua0Qni/sVTn8H9NOoQN
   F/uLogmjMn2BSorc58x/eGlimvJ0mOKAXGaHhQEY0jU1agNJndqG+77Qq
   56x6f4Y33pJehm3JY1AEmTvzJwHi6qmvJgZ4AEabcj9ICbFaiUOgxMp/c
   g==;
IronPort-SDR: XqZnv9pYBjMo8pNxkr9b5+VLjc4j16JDdC2Nla8S1JUE+141D1NfX+Vd5jANp7Eg2jgstZSqir
 j66huWWf7UhI7RpLfNHc3wChi35xBW+9QACem71qP8uNDMuIU4rCKp4oSn1smymtdbKLbpk1Bn
 fTbPyD4rbD2LoEMSBHHo3eWy5zHW0GNOMQJt4gAa84h5kILQO268CAEx8/NJNe3nANCuvvweZs
 dll0ixJicb4b2nNu/wmWveT4Gm/X6+y/GioaAaCJpI2mi3flJCDCbmKU0ogufG84ggpFj3MvQO
 KkQ=
X-IronPort-AV: E=Sophos;i="5.75,251,1589266800"; 
   d="scan'208";a="78976284"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jun 2020 08:53:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 18 Jun 2020 08:52:58 -0700
Received: from [10.171.246.49] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 18 Jun 2020 08:52:55 -0700
Subject: Re: [PATCH v2] net: macb: undo operations in case of failure
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <linux@armlinux.org.uk>
CC:     <antoine.tenart@bootlin.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1592469460-17825-1-git-send-email-claudiu.beznea@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <e1f5e65a-c670-f178-dcda-a630db424215@microchip.com>
Date:   Thu, 18 Jun 2020 17:53:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592469460-17825-1-git-send-email-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/06/2020 at 10:37, Claudiu Beznea wrote:
> Undo previously done operation in case macb_phylink_connect()
> fails. Since macb_reset_hw() is the 1st undo operation the
> napi_exit label was renamed to reset_hw.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Thanks Claudiu.

Regards,
   Nicolas

> ---
> 
> Changes in v2:
> - corrected fixes SHA1
> 
>   drivers/net/ethernet/cadence/macb_main.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 67933079aeea..257c4920cb88 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2558,7 +2558,7 @@ static int macb_open(struct net_device *dev)
>   
>   	err = macb_phylink_connect(bp);
>   	if (err)
> -		goto napi_exit;
> +		goto reset_hw;
>   
>   	netif_tx_start_all_queues(dev);
>   
> @@ -2567,9 +2567,11 @@ static int macb_open(struct net_device *dev)
>   
>   	return 0;
>   
> -napi_exit:
> +reset_hw:
> +	macb_reset_hw(bp);
>   	for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
>   		napi_disable(&queue->napi);
> +	macb_free_consistent(bp);
>   pm_exit:
>   	pm_runtime_put_sync(&bp->pdev->dev);
>   	return err;
> 


-- 
Nicolas Ferre
