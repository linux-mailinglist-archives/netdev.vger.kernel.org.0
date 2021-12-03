Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56467467658
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhLCLbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:31:06 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29151 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232921AbhLCLbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:31:03 -0500
Received: from kwepemi100008.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4J59VR5rq1zXdRJ;
        Fri,  3 Dec 2021 19:25:35 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100008.china.huawei.com (7.221.188.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 19:27:36 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Fri, 3 Dec
 2021 19:27:35 +0800
Subject: Re: [PATCH net-next 07/11] net: hns3: add void before function which
 don't receive ret
To:     Leon Romanovsky <leon@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20211203092059.24947-1-huangguangbin2@huawei.com>
 <20211203092059.24947-8-huangguangbin2@huawei.com> <Yan8VDXC0BtBRVGz@unreal>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <73861dd7-e766-f39f-1244-91012bf03983@huawei.com>
Date:   Fri, 3 Dec 2021 19:27:35 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <Yan8VDXC0BtBRVGz@unreal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/12/3 19:15, Leon Romanovsky wrote:
> On Fri, Dec 03, 2021 at 05:20:55PM +0800, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add void before function which don't receive ret to improve code
>> readability.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
>>   drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> NAK,
> 
> Please stop to do it and fix your static analyzer.
> https://lore.kernel.org/linux-rdma/20211119172830.GL876299@ziepe.ca/
> 
> We don't add (void) in the kernel and especially for the functions that
> already declared as void.
> 
>     void devlink_register(struct devlink *devlink)
> 
> Thanks
> 
Ok, I remove this patch.
Thanks
