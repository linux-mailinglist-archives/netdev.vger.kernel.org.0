Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFF935FFE2
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 04:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhDOCNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 22:13:43 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3336 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDOCNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 22:13:43 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FLN836Bp3z14GFs;
        Thu, 15 Apr 2021 10:09:39 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Thu, 15 Apr 2021 10:13:18 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Thu, 15 Apr
 2021 10:13:18 +0800
Subject: Re: [PATCH net-next 1/2] net: hns3: PF add support for pushing link
 status to VFs
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Guangbin Huang <huangguangbin2@huawei.com>
References: <1618294621-41356-1-git-send-email-tanhuazhong@huawei.com>
 <1618294621-41356-2-git-send-email-tanhuazhong@huawei.com>
 <20210413101826.103b25fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2dac0fe0-cdcb-a3c5-0c72-7873857824fd@huawei.com>
 <20210414094230.64caf43e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ab9a508c-29f0-1ff5-bb95-fbae4a859d6b@huawei.com>
 <20210414185355.4080a93f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <d9981f41-a0b3-4907-1fd0-14f0ae5bf421@huawei.com>
Date:   Thu, 15 Apr 2021 10:13:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210414185355.4080a93f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/4/15 9:53, Jakub Kicinski wrote:
> On Thu, 15 Apr 2021 09:11:03 +0800 Huazhong Tan wrote:
>>>> They are in different contexts. here will be called to
>>>> update the link status of all VFs when the underlying
>>>> link status is changed, while the below one is called
>>>> when the admin set up the specific VF link status.
>>> I see.
>> So this error will be printed twice only if these two cases
>> happen at the same, do you mean to add some keyword to
>> distinguish them?
> No, it's fine but please repost - looks like the patches were
> removed from patchwork already.


Will resend it, thanks.


> .

