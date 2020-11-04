Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0EA2A6369
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729488AbgKDLh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:37:29 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:59316 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgKDLh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 06:37:29 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0A4Bb078112623;
        Wed, 4 Nov 2020 05:37:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1604489820;
        bh=AwkvLhaXrghbbWxPBS9gIMMUxlhuwRQE4R6mRTlyB9o=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=QTFiYGerDk7a4WxT3V88okZt7XVcgbDyg0GbDnVdxLdCZqBa6MEsbAT4AiPv6apPV
         7qJk7FJ0phcnU6QUAh1PmhpDNu8fM0zQmW+IYnNzKO/MeTjHhF4ScHS67mOqtE2MjD
         4cBFEasPU4S27u9gV//CX5B7yNFmLsiXCYdFwUlA=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0A4Bb02r013556
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Nov 2020 05:37:00 -0600
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 4 Nov
 2020 05:37:00 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 4 Nov 2020 05:37:00 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0A4Baw08092005;
        Wed, 4 Nov 2020 05:36:58 -0600
Subject: Re: [PATCH 07/12] net: ethernet: ti: am65-cpts: Document
 am65_cpts_rx_enable()'s 'en' parameter
To:     Lee Jones <lee.jones@linaro.org>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>, <netdev@vger.kernel.org>
References: <20201104090610.1446616-1-lee.jones@linaro.org>
 <20201104090610.1446616-8-lee.jones@linaro.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <dfddd6d2-6e71-775e-c121-981a21f97950@ti.com>
Date:   Wed, 4 Nov 2020 13:37:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201104090610.1446616-8-lee.jones@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/11/2020 11:06, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/net/ethernet/ti/am65-cpts.c:736: warning: Function parameter or member 'en' not described in 'am65_cpts_rx_enable'
>   drivers/net/ethernet/ti/am65-cpts.c:736: warning: Excess function parameter 'skb' description in 'am65_cpts_rx_enable'
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/net/ethernet/ti/am65-cpts.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpts.c b/drivers/net/ethernet/ti/am65-cpts.c
> index 75056c14b161b..bb2b8e4919feb 100644
> --- a/drivers/net/ethernet/ti/am65-cpts.c
> +++ b/drivers/net/ethernet/ti/am65-cpts.c
> @@ -727,7 +727,7 @@ static long am65_cpts_ts_work(struct ptp_clock_info *ptp)
>   /**
>    * am65_cpts_rx_enable - enable rx timestamping
>    * @cpts: cpts handle
> - * @skb: packet
> + * @en: enable
>    *
>    * This functions enables rx packets timestamping. The CPTS can timestamp all
>    * rx packets.
> 

Thank you.
Reviewed-by: Grygorii Strashko <grygorii.strashko@ti.com>

-- 
Best regards,
grygorii
