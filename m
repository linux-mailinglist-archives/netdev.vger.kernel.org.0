Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF33525B84A
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbgICB0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:26:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48340 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726586AbgICB0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 21:26:15 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 76135247901511236D59;
        Thu,  3 Sep 2020 09:26:13 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Thu, 3 Sep 2020
 09:26:03 +0800
Subject: Re: [RFC net-next] udp: add a GSO type for UDPv6
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>
References: <1599048911-7923-1-git-send-email-tanhuazhong@huawei.com>
 <20200902.154344.13498608344678705.davem@davemloft.net>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <0139fae4-a359-813b-80e1-d2b60a72b08a@huawei.com>
Date:   Thu, 3 Sep 2020 09:26:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20200902.154344.13498608344678705.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020/9/3 6:43, David Miller wrote:
> From: Huazhong Tan <tanhuazhong@huawei.com>
> Date: Wed, 2 Sep 2020 20:15:11 +0800
> 
>> In some cases, for UDP GSO, UDPv4 and UDPv6 need to be handled
>> separately, for example, checksum offload, so add new GSO type
>> SKB_GSO_UDPV6_L4 for UDPv6, and the old SKB_GSO_UDP_L4 stands
>> for UDPv4.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
> Please submit this alongside something that needs to use it.
> 

will add in V2, thanks.

> Thank you.
> 
> .
> 

