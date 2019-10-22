Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D92DDFA1F
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730520AbfJVB2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:28:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56574 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728375AbfJVB2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 21:28:46 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 50F3582028846B661488;
        Tue, 22 Oct 2019 09:28:43 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 22 Oct 2019
 09:28:40 +0800
Subject: Re: [PATCH RFC] net: vlan: reverse 4 bytes of vlan header when
 setting initial MTU
To:     David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "mmanning@vyatta.att-mail.com" <mmanning@vyatta.att-mail.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "dcaratti@redhat.com" <dcaratti@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1571660763-117936-1-git-send-email-linyunsheng@huawei.com>
 <8f07f4aad98e44358b92e1e340df131f@AcuMS.aculab.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <710cc020-f411-38ad-a9c4-3f44957645f5@huawei.com>
Date:   Tue, 22 Oct 2019 09:28:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <8f07f4aad98e44358b92e1e340df131f@AcuMS.aculab.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/21 22:46, David Laight wrote:
> From: Yunsheng Lin
>> Sent: 21 October 2019 13:26
>> Currently the MTU of vlan netdevice is set to the same MTU
>> of the lower device, which requires the underlying device
>> to handle it as the comment has indicated:
>>
>> 	/* need 4 bytes for extra VLAN header info,
>> 	 * hope the underlying device can handle it.
>> 	 */
>> 	new_dev->mtu = real_dev->mtu;
>>
>> Currently most of the physical netdevs seems to handle above
>> by reversing 2 * VLAN_HLEN for L2 packet len.
> 
> s/reverse/reserve/g

Thanks.

> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
> 
> .
> 

