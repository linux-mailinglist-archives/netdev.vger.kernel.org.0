Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D85C8DA2D5
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 02:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437337AbfJQAuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 20:50:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39210 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403879AbfJQAuY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 20:50:24 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D072254A568EF04DA520;
        Thu, 17 Oct 2019 08:50:22 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 17 Oct 2019
 08:50:15 +0800
Subject: Re: [PATCH net-next 08/12] net: hns3: introduce ring_to_netdev() in
 enet module
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
 <1571210231-29154-9-git-send-email-tanhuazhong@huawei.com>
 <20191016101023.21915feb@cakuba.netronome.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <3cf1c031-4809-11ec-c715-de3a839b9a03@huawei.com>
Date:   Thu, 17 Oct 2019 08:50:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20191016101023.21915feb@cakuba.netronome.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/10/17 1:10, Jakub Kicinski wrote:
> On Wed, 16 Oct 2019 15:17:07 +0800, Huazhong Tan wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> There are a few places that need to access the netdev of a ring
>> through ring->tqp->handle->kinfo.netdev, and ring->tqp is a struct
>> which both in enet and hclge modules, it is better to use the
>> struct that is only used in enet module.
>>
>> This patch adds the ring_to_netdev() to access the netdev of ring
>> through ring->tqp_vector->napi.dev.
>>
>> Also, struct hns3_enet_ring is a frequently used in critical data
>> path, so make it cacheline aligned as struct hns3_enet_tqp_vector.
> 
> That part seems logically separate, should it be a separate patch?
> 

ok, thanks.

>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> 

