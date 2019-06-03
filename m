Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6557C32636
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfFCBm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:42:28 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17646 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbfFCBm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 21:42:28 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DA7CE301CF5EBFE41DCA;
        Mon,  3 Jun 2019 09:42:25 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Mon, 3 Jun 2019
 09:42:15 +0800
Subject: Re: [PATCH net-next 00/12] code optimizations & bugfixes for HNS3
 driver
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>
References: <1559292898-64090-1-git-send-email-tanhuazhong@huawei.com>
 <20190531.171529.1003718945482922118.davem@davemloft.net>
 <20190531.171819.1461966494167760290.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <b0b2c1ce-9b2b-2db5-d703-870176be27b3@huawei.com>
Date:   Mon, 3 Jun 2019 09:42:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20190531.171819.1461966494167760290.davem@davemloft.net>
Content-Type: text/plain; charset="iso-8859-7"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/1 8:18, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Fri, 31 May 2019 17:15:29 -0700 (PDT)
> 
>> From: Huazhong Tan <tanhuazhong@huawei.com>
>> Date: Fri, 31 May 2019 16:54:46 +0800
>>
>>> This patch-set includes code optimizations and bugfixes for the HNS3
>>> ethernet controller driver.
>>>
>>> [patch 1/12] removes the redundant core reset type
>>>
>>> [patch 2/12 - 3/12] fixes two VLAN related issues
>>>
>>> [patch 4/12] fixes a TM issue
>>>
>>> [patch 5/12 - 12/12] includes some patches related to RAS & MSI-X error
>>
>> Series applied.
> 
> I reverted, you need to actually build test the infiniband side of your
> driver.
> 
> drivers/infiniband/hw/hns/hns_roce_hw_v2.c: In function ¡hns_roce_v2_msix_interrupt_abn¢:
> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:5032:14: warning: passing argument 2 of ¡ops->set_default_reset_request¢ makes pointer from integer without a cast [-Wint-conversion]
>                HNAE3_FUNC_RESET);
>                ^~~~~~~~~~~~~~~~
> drivers/infiniband/hw/hns/hns_roce_hw_v2.c:5032:14: note: expected ¡long unsigned int *¢ but argument is of type ¡int¢
>    C-c C-cmake[5]: *** Deleting file 'drivers/net/wireless/ath/carl9170/cmd.o'
> 

Sorry, I will remove [10/12 - 11/12] for V2, these two patches needs to 
modify HNS's infiniband driver at the same time, so they will be 
upstreamed later with the infiniband's one.

