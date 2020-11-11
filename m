Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0BF2AE6EB
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgKKDQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:16:49 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7878 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgKKDQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 22:16:48 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CW8yr5jPjz75Xh;
        Wed, 11 Nov 2020 11:16:36 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Nov 2020
 11:16:37 +0800
Subject: Re: [PATCH V2 net-next 11/11] net: hns3: add debugfs support for
 interrupt coalesce
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
 <1604892159-19990-12-git-send-email-tanhuazhong@huawei.com>
 <20201110172858.5eddc276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <faf8854a-329d-8064-a832-02b08d3f5bad@huawei.com>
Date:   Wed, 11 Nov 2020 11:16:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20201110172858.5eddc276@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/11/11 9:28, Jakub Kicinski wrote:
> On Mon, 9 Nov 2020 11:22:39 +0800 Huazhong Tan wrote:
>> Since user may need to check the current configuration of the
>> interrupt coalesce, so add debugfs support for query this info,
>> which includes DIM profile, coalesce configuration of both software
>> and hardware.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Please create a file per vector so that users can just read it instead
> of dumping the info into the logs.
> 

This patch should be removed from this series right now. Since this new 
read method needs some adaptations and verifications, and there maybe 
another better ways to dump this info.

> Even better we should put as much of this information as possible into
> the ethtool API. dim state is hardly hardware-specific.
> 

Should the ethtool API used to dump the hardware info? Could you provide 
some hints to do it?

> .
> 

