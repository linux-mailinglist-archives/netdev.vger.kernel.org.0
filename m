Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAF2D39DE53
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 16:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFGOG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 10:06:58 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:41067 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhFGOG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 10:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623074707; x=1654610707;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=rk4evP7hJI2TbuMWBLbd1c2o/uWG+hPkZfrlX2ejnw4=;
  b=uPYZMz3cuVa+4pD6VVybVMY6De69Jmm1LQLjPqhSOOJ5hNEMjXjNK5y2
   JZzX1LZS4MowsMV0QsMktLGfpq+xx1QKfMo+jHoXSJbWY/3Ny7lGCC5zk
   xl8bqNzmCwASl7kWbS6UUA6nMH42Q6RUYdYFrBEtNcPpYc+LHcsJRwNDH
   rl53HysZUxR+GzFqXBV4KZNgqqW9Ebuy0Tsduq22jqMl79WNTqJm2NHuR
   TcXr3dnzlpaXvA67OENWCjmGdHoR+GcCqjMwUVgeuHZ9EjebvQnEk9bml
   FqjI1zg3adED5uk6xo4efm2n0leW7Pp1Fuw4JeG+zXtSC2PWFJCXQqluU
   Q==;
IronPort-SDR: qNqrwgp7bVsxPlymDuDbHYTP50xQwJKomXgoBPuyRY4TPoojnq+PPBlaLizYmBkK1h0/hmN/Q2
 Q82K6U8Kd/ycgCMrSD9XgjUx+sOCqjxPXjvbDy6/YmqYtGTT4rw8164wrrv3spJUCun0B3yueC
 2U6GENnbEISWx1Loy/PvjQs7jBCf/A9tdaCpSGi9L2GgH9e4yVa91xt7Y/14WOcz/k5NhvL1e1
 r10mEOoQ3CyHdKyfmj5VG7h3yquwwogM4F1NmqZNpMSsk+CvXdORvQH6bAvHPpX71PUlzT7Vxi
 mig=
X-IronPort-AV: E=Sophos;i="5.83,255,1616482800"; 
   d="scan'208";a="123789838"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Jun 2021 07:05:07 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 07:05:05 -0700
Received: from [10.12.74.44] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 7 Jun 2021 07:05:04 -0700
Subject: Re: [PATCH net-next] net: macb: Use
 devm_platform_get_and_ioremap_resource()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
References: <20210607134354.3582182-1-yangyingliang@huawei.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <9e2c68af-637b-daff-5793-2d537c188998@microchip.com>
Date:   Mon, 7 Jun 2021 16:05:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210607134354.3582182-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2021 at 15:43, Yang Yingliang wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index a0c7b1167dbb..7d2fe13a52f8 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -4655,8 +4655,7 @@ static int macb_probe(struct platform_device *pdev)
>          struct macb *bp;
>          int err, val;
> 
> -       regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       mem = devm_ioremap_resource(&pdev->dev, regs);
> +       mem = devm_platform_get_and_ioremap_resource(pdev, 0, &regs);
>          if (IS_ERR(mem))
>                  return PTR_ERR(mem);
> 
> --
> 2.25.1
> 


-- 
Nicolas Ferre
