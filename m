Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF6330EAEE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 04:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhBDDat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 22:30:49 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:3417 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbhBDDas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 22:30:48 -0500
Received: from dggeme711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4DWPCf33Qxz5Gkl;
        Thu,  4 Feb 2021 11:28:46 +0800 (CST)
Received: from [127.0.0.1] (10.69.26.252) by dggeme711-chm.china.huawei.com
 (10.1.199.107) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Thu, 4 Feb
 2021 11:30:05 +0800
Subject: Re: [PATCH net-next 2/7] net: hns3: RSS indirection table and key use
 device specifications
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <1612269593-18691-1-git-send-email-tanhuazhong@huawei.com>
 <1612269593-18691-3-git-send-email-tanhuazhong@huawei.com>
 <20210203165039.3bf2784d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <c5cb912f-c7a1-7420-9323-a9690e514b3b@huawei.com>
Date:   Thu, 4 Feb 2021 11:30:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210203165039.3bf2784d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggeme711-chm.china.huawei.com (10.1.199.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/4 8:50, Jakub Kicinski wrote:
> On Tue, 2 Feb 2021 20:39:48 +0800 Huazhong Tan wrote:
>>   struct hclgevf_rss_cfg {
>> -	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE]; /* user configured hash keys */
>> +	/* user configured hash keys */
>> +	u8  rss_hash_key[HCLGEVF_RSS_KEY_SIZE_MAX];
>>   	u32 hash_algo;
>>   	u32 rss_size;
>>   	u8 hw_tc_map;
>> -	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE]; /* shadow table */
>> +	/* shadow table */
>> +	u8  rss_indirection_tbl[HCLGEVF_RSS_IND_TBL_SIZE_MAX];
>>   	struct hclgevf_rss_tuple_cfg rss_tuple_sets;
>>   };
> What if the table sizes supported by the device grow beyond the
> .._SIZE_MAX constants? Are you handling that case?

Sorry for missing this case, will allocate these tables by the queried 
size instead

of this fixed one, Since some verification job is needed, so this patch 
will resend later.

thanks.
> .

