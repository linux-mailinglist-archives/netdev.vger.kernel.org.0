Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F4C1BEDB0
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 03:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgD3Bi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 21:38:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3343 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726180AbgD3Bi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 21:38:27 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 993BD23B206319219236;
        Thu, 30 Apr 2020 09:38:25 +0800 (CST)
Received: from [127.0.0.1] (10.166.212.180) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 30 Apr 2020
 09:38:21 +0800
Subject: Re: [PATCH -next v2] hinic: Use ARRAY_SIZE for nic_vf_cmd_msg_handler
To:     David Miller <davem@davemloft.net>
CC:     <aviad.krawczyk@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1588133860-55722-1-git-send-email-zou_wei@huawei.com>
 <20200429.114327.1585519928398105692.davem@davemloft.net>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <356fed7c-0983-4d33-df5b-e7b326a90833@huawei.com>
Date:   Thu, 30 Apr 2020 09:38:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200429.114327.1585519928398105692.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.212.180]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/4/30 2:43, David Miller wrote:
> From: Zou Wei <zou_wei@huawei.com>
> Date: Wed, 29 Apr 2020 12:17:40 +0800
> 
>> fix coccinelle warning, use ARRAY_SIZE
>>
>> drivers/net/ethernet/huawei/hinic/hinic_sriov.c:713:43-44: WARNING: Use ARRAY_SIZE
>>
>> ----------
> 
> Please don't put this "-------" here.
> 
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
>> index b24788e..af70cca 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
>> @@ -704,17 +704,15 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
>>   	struct hinic_hwdev *dev = hwdev;
>>   	struct hinic_func_to_io *nic_io;
>>   	struct hinic_pfhwdev *pfhwdev;
>> -	u32 i, cmd_number;
>> +	u32 i;
>>   	int err = 0;
> 
> Please preserve the reverse christmas tree ordering of local variables.
> 
> .
> 
Thanks，I will modify and send v3 patch

