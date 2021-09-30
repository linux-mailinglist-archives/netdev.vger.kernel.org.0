Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0786C41D1AB
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 04:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347923AbhI3C7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 22:59:13 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24156 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346666AbhI3C7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 22:59:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKdD66dSPz1DHP3;
        Thu, 30 Sep 2021 10:56:06 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 10:57:26 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 30 Sep
 2021 10:57:26 +0800
Subject: Re: [RFCv2 net-next 000/167] net: extend the netdev_features_t
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20210929155334.12454-1-shenjian15@huawei.com>
 <YVSfSNyVeaIx6n8k@lunn.ch>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <9f9b5c06-f793-f660-0341-b5b666403573@huawei.com>
Date:   Thu, 30 Sep 2021 10:57:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YVSfSNyVeaIx6n8k@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/9/30 1:15, Andrew Lunn 写道:
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
> What you should of done is converted just one MAC driver. That gives
> us enough we can review the basic idea, etc, and not need to delete
> 130 nearly identical patches.
>
>     Andrew
> .
OK, I will refine it, make it more reviewable, thanks!

     shenjian

>

