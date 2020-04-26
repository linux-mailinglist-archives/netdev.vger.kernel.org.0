Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C551B8AD0
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 03:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDZB2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 21:28:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39162 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725931AbgDZB2z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Apr 2020 21:28:55 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4B3DA6AC6244B916A3CC;
        Sun, 26 Apr 2020 09:28:52 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 09:28:43 +0800
Subject: Re: [PATCH net-next 0/8] net: hns3: refactor for MAC table
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
References: <1587694993-25183-1-git-send-email-tanhuazhong@huawei.com>
 <20200424162325.4547ce9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <f1b6075a-4b83-4266-9a4a-01dac51881ff@huawei.com>
Date:   Sun, 26 Apr 2020 09:28:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200424162325.4547ce9c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/4/25 7:23, Jakub Kicinski wrote:
> On Fri, 24 Apr 2020 10:23:05 +0800 Huazhong Tan wrote:
>> This patchset refactors the MAC table management, configure
>> the MAC address asynchronously, instead of synchronously.
>> Base on this change, it also refines the handle of promisc
>> mode and filter table entries restoring after reset.
> 
> Looks like in patch 2 you could also remove the check if allocated_size
> is NULL if there is only once caller ;) But that's a nit, series seems
> okay:
> 
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 

Will send a V2 to remove it.
Thanks :)

> .
> 

