Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91C4324872
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhBYBSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:18:48 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12572 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhBYBSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:18:48 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DmFGl4gJ1zMdsb;
        Thu, 25 Feb 2021 09:15:59 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 25 Feb 2021 09:17:59 +0800
Subject: Re: [PATCH] net: bridge: Fix jump_label config
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
References: <20210224153803.91194-1-wangkefeng.wang@huawei.com>
 <20210224105458.091842fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <82d81cc1-e83a-2ab1-246c-0424e2f3f11e@huawei.com>
Date:   Thu, 25 Feb 2021 09:17:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210224105458.091842fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/25 2:54, Jakub Kicinski wrote:
> On Wed, 24 Feb 2021 23:38:03 +0800 Kefeng Wang wrote:
>> HAVE_JUMP_LABLE is removed by commit e9666d10a567 ("jump_label: move
>> 'asm goto' support test to Kconfig"), use CONFIG_JUMP_LABLE instead
>> of HAVE_JUMP_LABLE.
>>
>> Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> You need to CC the authors of the commit you're blaming. Please make
> use of scripts/get_maintainers.pl and repost.

Yes, I use get_maintainers.pl, but only add maintainers to the list, 
thanks for your reminder,

cc the author Florian now.

