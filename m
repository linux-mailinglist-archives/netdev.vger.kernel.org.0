Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B925E5205A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbfFYB0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:26:15 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:37200 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727728AbfFYB0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 21:26:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CE528F0AD2256185A5BC;
        Tue, 25 Jun 2019 09:26:12 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 09:26:04 +0800
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
To:     David Miller <davem@davemloft.net>, <luoshijie1@huawei.com>
CC:     <tgraf@suug.ch>, <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        <wangxiaogang3@huawei.com>, <mingfangsen@huawei.com>,
        <zhoukang7@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
 <20190624.090325.163853495970223718.davem@davemloft.net>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <f32ee56e-ca4f-d7b2-c5e5-052416e062e8@huawei.com>
Date:   Tue, 25 Jun 2019 09:25:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190624.090325.163853495970223718.davem@davemloft.net>
Content-Type: text/plain; charset="gb18030"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/25 0:03, David Miller wrote:
> From: luoshijie <luoshijie1@huawei.com>
> Date: Tue, 18 Jun 2019 15:14:02 +0000
> 
>> From: Shijie Luo <luoshijie1@huawei.com>
>>
>> When enable route_localnet, route of the 127/8 address is enabled.
>> But in some situations like arp_announce=2, ARP requests or reply
>> work abnormally.
>>
>> This patchset fix some bugs when enable route_localnet. 
>>
>> Change History:
>> V2:
>> - Change a single patch to a patchset.
>> - Add bug fix for arp_ignore = 3.
>> - Add a couple of test for enabling route_localnet in selftests.
> 
> Series applied to net-next, thanks.
> 
Thanks again for you and David Ahern.

