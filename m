Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21346C9ED
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 02:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239127AbhLHBbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 20:31:10 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16343 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbhLHBbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 20:31:10 -0500
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J7zzR4hvwz91bv;
        Wed,  8 Dec 2021 09:26:59 +0800 (CST)
Received: from [10.67.77.175] (10.67.77.175) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Wed, 8 Dec
 2021 09:27:37 +0800
Subject: Re: [PATCH] net/mlx5: Remove the repeated declaration
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
 <Ya9WMysibKB7e5CF@unreal>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <83cb3b17-09a7-fefe-6310-8ec5b992a6a7@hisilicon.com>
Date:   Wed, 8 Dec 2021 09:27:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <Ya9WMysibKB7e5CF@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On 2021/12/7 20:40, Leon Romanovsky wrote:
> On Tue, Dec 07, 2021 at 08:35:15PM +0800, Shaokun Zhang wrote:
>> Function 'mlx5_esw_vport_match_metadata_supported' and
>> 'mlx5_esw_offloads_vport_metadata_set' are declared twice, so remove
>> the repeated declaration and blank line.
>>
>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>> Cc: Leon Romanovsky <leon@kernel.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 3 ---
>>  1 file changed, 3 deletions(-)
>>
> 
> Fixes: 4f4edcc2b84f ("net/mlx5: E-Switch, Add ovs internal port mapping to metadata support")
> 

Shall we need this tag since it is trivial cleanup patch?

> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Thanks your reply.

> .
> 
