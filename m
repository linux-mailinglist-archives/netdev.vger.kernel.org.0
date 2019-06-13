Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615A14455A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392837AbfFMQng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36592 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730456AbfFMGen (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 02:34:43 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 136856DBF8070409289A;
        Thu, 13 Jun 2019 14:34:39 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 13 Jun 2019
 14:34:37 +0800
Subject: Re: [PATCH net v2] tcp: avoid creating multiple req socks with the
 same tuples
To:     David Miller <davem@davemloft.net>
References: <20190612035715.166676-1-maowenan@huawei.com>
 <20190612.092507.915453305221203158.davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <edumazet@google.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <2d3d6b84-acaa-b98a-8454-96546fbe012d@huawei.com>
Date:   Thu, 13 Jun 2019 14:34:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190612.092507.915453305221203158.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/6/13 0:25, David Miller wrote:
> From: Mao Wenan <maowenan@huawei.com>
> Date: Wed, 12 Jun 2019 11:57:15 +0800
> 
>> diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
>> index c4503073248b..b6a1b5334565 100644
>> --- a/net/ipv4/inet_hashtables.c
>> +++ b/net/ipv4/inet_hashtables.c
>> @@ -477,6 +477,7 @@ bool inet_ehash_insert(struct sock *sk, struct sock *osk)
>>  	struct inet_ehash_bucket *head;
>>  	spinlock_t *lock;
>>  	bool ret = true;
>> +	struct sock *reqsk = NULL;
> 
> Please preserve the reverse christmas tree local variable ordering here.

ok, thanks.
> 
> Thank you.
> 
> .
> 

