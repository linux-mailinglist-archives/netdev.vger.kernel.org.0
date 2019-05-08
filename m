Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B259617932
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 14:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfEHMNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 08:13:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56132 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728031AbfEHMNg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 08:13:36 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DAC28B007655174000B9;
        Wed,  8 May 2019 20:13:32 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 8 May 2019
 20:13:24 +0800
Subject: Re: [PATCH] net: hns3: remove redundant assignment of l2_hdr to
 itself
To:     Colin King <colin.king@canonical.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20190508105135.13170-1-colin.king@canonical.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e4627235-16a8-60be-4e7b-0a7e36df55c9@huawei.com>
Date:   Wed, 8 May 2019 20:13:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20190508105135.13170-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/8 18:51, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The pointer l2_hdr is being assigned to itself, this is redundant
> and can be removed.
> 
> Addresses-Coverity: ("Evaluation order violation")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 18711e0f9bdf..196a3d780dcf 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -810,7 +810,7 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
>  			   u8 il4_proto, u32 *type_cs_vlan_tso,
>  			   u32 *ol_type_vlan_len_msec)
>  {
> -	unsigned char *l2_hdr = l2_hdr = skb->data;
> +	unsigned char *l2_hdr = skb->data;

Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

Thanks.

>  	u32 l4_proto = ol4_proto;
>  	union l4_hdr_info l4;
>  	union l3_hdr_info l3;
> 

