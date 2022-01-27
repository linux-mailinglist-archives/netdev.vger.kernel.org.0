Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDCF49DE3A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiA0JkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:40:04 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:32066 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiA0JkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:40:04 -0500
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JkwSk6KQ1z1FD6b;
        Thu, 27 Jan 2022 17:36:06 +0800 (CST)
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 27 Jan
 2022 17:40:02 +0800
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
To:     Leon Romanovsky <leon@kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <YfJi10IcxtYQ7Ttr@unreal>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <f49d8f3f-f9e9-574f-f41b-01d35a0a1b03@huawei.com>
Date:   Thu, 27 Jan 2022 17:40:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YfJi10IcxtYQ7Ttr@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/1/27 17:16, Leon Romanovsky 写道:
> On Wed, Sep 29, 2021 at 11:50:47PM +0800, Jian Shen wrote:
>> For the prototype of netdev_features_t is u64, and the number
>> of netdevice feature bits is 64 now. So there is no space to
>> introduce new feature bit.
>>
>> This patchset try to solve it by change the prototype of
>> netdev_features_t from u64 to bitmap. With this change,
>> it's necessary to introduce a set of bitmap operation helpers
>> for netdev features. Meanwhile, the functions which use
>> netdev_features_t as return value are also need to be changed,
>> return the result as an output parameter.
>>
>> With above changes, it will affect hundreds of files, and all the
>> nic drivers. To make it easy to be reviewed, split the changes
>> to 167 patches to 5 parts.
>>
>> patch 1~22: convert the prototype which use netdev_features_t
>> as return value
>> patch 24: introduce fake helpers for bitmap operation
>> patch 25~165: use netdev_feature_xxx helpers
>> patch 166: use macro __DECLARE_NETDEV_FEATURE_MASK to replace
>> netdev_feature_t declaration.
>> patch 167: change the type of netdev_features_t to bitmap,
>> and rewrite the bitmap helpers.
>>
>> Sorry to send a so huge patchset, I wanna to get more suggestions
>> to finish this work, to make it much more reviewable and feasible.
>>
>> The former discussing for the changes, see [1]
>> [1]. https://www.spinics.net/lists/netdev/msg753528.html
>>
> ------------------------------------------------
>
> Is anyone actively working on this task?
>
> Thanks
> .
Hi Leon,

I have sent RFCv4  [1] three months ago, and according Andrew' 
suggestion， I'm trying to
continue this work with semantic-patches, and waiting for more comments
for the scheme.
But I'm not familiar with it, and  busy with some other work recently, 
so it got delayed.

Sorry for this. I will speed up it.

[1] https://lore.kernel.org/netdev/YYvKyruLcemj6J+i@lunn.ch/T/

Thanks


