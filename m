Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14065103147
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 02:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfKTBsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 20:48:30 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6252 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727140AbfKTBsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 20:48:30 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3A98710A35CD555D8F51;
        Wed, 20 Nov 2019 09:48:26 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Wed, 20 Nov 2019
 09:48:18 +0800
Subject: Re: [PATCH V2 net] net: hns3: fix a wrong reset interrupt status mask
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
References: <1574214285-43543-1-git-send-email-tanhuazhong@huawei.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <6561cf1f-1af5-7852-8de7-1377b228f2a5@huawei.com>
Date:   Wed, 20 Nov 2019 09:48:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <1574214285-43543-1-git-send-email-tanhuazhong@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, please ignore this patch.
Will resend later.

On 2019/11/20 9:44, Huazhong Tan wrote:
> According to hardware user manual, bits5~7 in register
> HCLGE_MISC_VECTOR_INT_STS means reset interrupts status,
> but HCLGE_RESET_INT_M is defined as bits0~2 now. So it
> will make hclge_reset_err_handle() read the wrong reset
> interrupt status.
> 
> This patch fixes this wrong bit mask.
> 
> Fixes: 2336f19d7892 ("net: hns3: check reset interrupt status when reset fails")
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> ---
>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> index 59b8243..615cde1 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
> @@ -166,7 +166,7 @@ enum HLCGE_PORT_TYPE {
>   #define HCLGE_GLOBAL_RESET_BIT		0
>   #define HCLGE_CORE_RESET_BIT		1
>   #define HCLGE_IMP_RESET_BIT		2
> -#define HCLGE_RESET_INT_M		GENMASK(2, 0)
> +#define HCLGE_RESET_INT_M		GENMASK(7, 5)
>   #define HCLGE_FUN_RST_ING		0x20C00
>   #define HCLGE_FUN_RST_ING_B		0
>   
> 

