Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1B197C7D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbfHUOVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:21:21 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38876 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfHUOVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 10:21:12 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x7LEKdOu103001;
        Wed, 21 Aug 2019 09:20:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1566397239;
        bh=+HM46ZHoTYeCIzkWA3/7GYFT9x7XR/6vN+mvTfJEuGM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=AwJp61CxMuh/qZ6Z+tt0Y3XIVJTR8NR/JOFGvkInTK8WHKNLAOblxPaZs1gbMHBH2
         gCViEdyiz7/J2xVKY8lN4o+Xa8KbtC902F1BRuwi8jLvYAvHa16J0Ztdj2cP50H5Sq
         64Fz7arbNcsJ5SyYImnG0oVRSWZomjS39rBK7wRM=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x7LEKd30088773
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Aug 2019 09:20:39 -0500
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 21
 Aug 2019 09:20:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 21 Aug 2019 09:20:38 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x7LEKZtD117153;
        Wed, 21 Aug 2019 09:20:36 -0500
Subject: Re: [PATCH net-next] net: ethernet: ti: use
 devm_platform_ioremap_resource() to simplify code
To:     YueHaibing <yuehaibing@huawei.com>, <davem@davemloft.net>,
        <ivan.khoronzhuk@linaro.org>, <andrew@lunn.ch>, <ynezz@true.cz>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
References: <20190821124850.9592-1-yuehaibing@huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <0a978de8-4b6e-d17d-7184-ce37aa7d1077@ti.com>
Date:   Wed, 21 Aug 2019 17:20:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821124850.9592-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/08/2019 15:48, YueHaibing wrote:
> Use devm_platform_ioremap_resource() to simplify the code a bit.
> This is detected by coccinelle.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/net/ethernet/ti/cpsw.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>

Thank you.
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
