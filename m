Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4601E2AE66F
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKKCcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:32:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7478 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgKKCcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 21:32:06 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CW7zL5gNwzhj1j;
        Wed, 11 Nov 2020 10:31:58 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Nov 2020
 10:31:56 +0800
Subject: Re: [PATCH V2 net-next 05/11] net: hns3: add support for dynamic
 interrupt moderation
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
 <1604892159-19990-6-git-send-email-tanhuazhong@huawei.com>
 <20201110172055.27ab308f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <7a7805e0-7d13-2b34-f15c-1fc7bda151ed@huawei.com>
Date:   Wed, 11 Nov 2020 10:31:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201110172055.27ab308f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/11 9:20, Jakub Kicinski wrote:
> On Mon, 9 Nov 2020 11:22:33 +0800 Huazhong Tan wrote:
>> Add dynamic interrupt moderation support for the HNS3 driver.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> I'm slightly confused here. What does the adaptive moderation do in
> your driver/device if you still need DIM on top of it?
> 

The driver's adaptive moderation and DIM are mutually-exclusive options,
and DIM is used by default. Since it is hard to verify all cases that
DIM can get a better result, so keep the adaptive moderation as an
option now, which can be swicthed by the ethtool priv-flag. If DIM is ok
for a long time, then we will send a separate patch to  remove the
adaptive moderation from the driver.

Thanks.
> 

