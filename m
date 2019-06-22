Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF3FB4F46B
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 10:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfFVIm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 04:42:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19057 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726114AbfFVIm0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Jun 2019 04:42:26 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CBE42D2710D1EC99A889;
        Sat, 22 Jun 2019 16:42:23 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Sat, 22 Jun 2019
 16:42:16 +0800
Subject: Re: [PATCH v2 0/3] fix bugs when enable route_localnet
To:     luoshijie <luoshijie1@huawei.com>, <davem@davemloft.net>,
        <tgraf@suug.ch>, <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <wangxiaogang3@huawei.com>,
        <mingfangsen@huawei.com>, <zhoukang7@huawei.com>
References: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <e52787a0-86fe-bf5f-28f4-3a29dd8ced7b@huawei.com>
Date:   Sat, 22 Jun 2019 16:41:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <1560870845-172395-1-git-send-email-luoshijie1@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Friendly ping ...


> From: Shijie Luo <luoshijie1@huawei.com>
> 
> When enable route_localnet, route of the 127/8 address is enabled.
> But in some situations like arp_announce=2, ARP requests or reply
> work abnormally.
> 
> This patchset fix some bugs when enable route_localnet. 
> 
> Change History:
> V2:
> - Change a single patch to a patchset.
> - Add bug fix for arp_ignore = 3.
> - Add a couple of test for enabling route_localnet in selftests.
> 
> Shijie Luo (3):
>   ipv4: fix inet_select_addr() when enable route_localnet
>   ipv4: fix confirm_addr_indev() when enable route_localnet
>   selftests: add route_localnet test script
> 
>  net/ipv4/devinet.c                            | 15 +++-
>  tools/testing/selftests/net/route_localnet.sh | 74 +++++++++++++++++++
>  2 files changed, 86 insertions(+), 3 deletions(-)
>  create mode 100755 tools/testing/selftests/net/route_localnet.sh
> 

