Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E156252070
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 03:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730196AbfFYBul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 21:50:41 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56798 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729450AbfFYBuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 21:50:40 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 611CCB0B67A108AFAE73;
        Tue, 25 Jun 2019 09:50:38 +0800 (CST)
Received: from [127.0.0.1] (10.184.16.119) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 25 Jun 2019
 09:50:28 +0800
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
To:     David Miller <davem@davemloft.net>
CC:     <tgraf@suug.ch>, <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        <liuzhiqiang26@huawei.com>, <wangxiaogang3@huawei.com>,
        <mingfangsen@huawei.com>, <zhoukang7@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
 <20190624.090325.163853495970223718.davem@davemloft.net>
From:   "Luoshijie (Poincare Lab)" <luoshijie1@huawei.com>
Message-ID: <4080e8ea-8e05-d0c7-8e4a-bab006bbb509@huawei.com>
Date:   Tue, 25 Jun 2019 09:50:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190624.090325.163853495970223718.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.16.119]
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

Thanks a lot, and I'm truly grateful for advice and help of David Ahern.

