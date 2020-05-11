Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF21CCED6
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 02:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgEKANT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 20:13:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4322 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729310AbgEKANT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 20:13:19 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4AFFEB1D39BFCAE86E6E;
        Mon, 11 May 2020 08:13:16 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Mon, 11 May 2020
 08:13:06 +0800
Subject: Re: [PATCH net-next 3/5] net: hns3: provide .get_cmdq_stat interface
 for the client
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1589016461-10130-1-git-send-email-tanhuazhong@huawei.com>
 <1589016461-10130-4-git-send-email-tanhuazhong@huawei.com>
 <20200509134816.534860ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <1b76cac7-b1cc-cbab-cef4-cefeaa25ac62@huawei.com>
Date:   Mon, 11 May 2020 08:13:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200509134816.534860ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/5/10 4:48, Jakub Kicinski wrote:
> On Sat, 9 May 2020 17:27:39 +0800 Huazhong Tan wrote:
>> This patch provides a new interface for the client to query
>> whether CMDQ is ready to work.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> index 5602bf2..7506cab 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
>> @@ -552,6 +552,7 @@ struct hnae3_ae_ops {
>>   	int (*set_vf_mac)(struct hnae3_handle *handle, int vf, u8 *p);
>>   	int (*get_module_eeprom)(struct hnae3_handle *handle, u32 offset,
>>   				 u32 len, u8 *data);
>> +	bool (*get_cmdq_stat)(struct hnae3_handle *handle);
>>   };
> 
> I don't see anything in this series using this new interface, why is it
> added now?
> 

Hi, Jakub.

This interface is needed by the roce client, whose patch will be
upstreamed to the rdma tree, it is other branch. So we provide this 
interface previously, then the rdma guy will upstream their patch later,
maybe linux-5.8-rc*.

Thanks.

> .
> 

