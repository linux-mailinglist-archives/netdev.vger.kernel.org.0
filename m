Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44DB441274
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 04:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhKADqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 23:46:35 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26217 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbhKADqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 23:46:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HjJkw5k47z8ttn;
        Mon,  1 Nov 2021 11:42:32 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 11:43:43 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 1 Nov
 2021 11:43:41 +0800
Subject: Re: [PATCH V5 net-next 6/6] net: hns3: remove the way to set tx spare
 buf via module parameter
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
References: <20211030131001.38739-1-huangguangbin2@huawei.com>
 <20211030131001.38739-7-huangguangbin2@huawei.com> <YX2JhqOTKOiB/EPO@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <84f977be-d2df-0927-fb43-c7afae373bd1@huawei.com>
Date:   Mon, 1 Nov 2021 11:43:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YX2JhqOTKOiB/EPO@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/31 2:05, Andrew Lunn wrote:
> On Sat, Oct 30, 2021 at 09:10:01PM +0800, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> The way to set tx spare buf via module parameter is not such
>> convenient as the way to set it via ethtool.
>>
>> So,remove the way to set tx spare buf via module parameter.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +------
>>   1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> index 076631d7727d..032547a2ad2f 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
>> @@ -53,10 +53,6 @@ static int debug = -1;
>>   module_param(debug, int, 0);
>>   MODULE_PARM_DESC(debug, " Network interface message level setting");
>>   
>> -static unsigned int tx_spare_buf_size;
>> -module_param(tx_spare_buf_size, uint, 0400);
>> -MODULE_PARM_DESC(tx_spare_buf_size, "Size used to allocate tx spare buffer");
>> -
> 
> This might be considered ABI. By removing it, are you breaking users
> setup?
> 
> 	Andrew
> .
> 
Yes, patch 1/6 and 2/6 add support for ethtool to set tx spare(copybreak) buf size,
so remove the way to set it by module parameter.
