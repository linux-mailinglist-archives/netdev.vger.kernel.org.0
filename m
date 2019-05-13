Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37A051B5CF
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfEMM0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:26:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49630 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728668AbfEMM0X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:26:23 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E5C052049939C1A05C5B;
        Mon, 13 May 2019 20:26:20 +0800 (CST)
Received: from [127.0.0.1] (10.177.216.125) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 13 May 2019
 20:26:20 +0800
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
To:     Michal Kubecek <mkubecek@suse.cz>, <netdev@vger.kernel.org>
References: <1557711193-7284-1-git-send-email-chenweilong@huawei.com>
 <20190513074928.GC22349@unicorn.suse.cz>
 <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
 <20190513114900.GD22349@unicorn.suse.cz>
 <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
 <20190513121145.GE22349@unicorn.suse.cz>
CC:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>
From:   Weilong Chen <chenweilong@huawei.com>
Message-ID: <0cbac950-70a3-aa5c-5e85-ce3c491f211d@huawei.com>
Date:   Mon, 13 May 2019 20:26:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <20190513121145.GE22349@unicorn.suse.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.216.125]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/5/13 20:11, Michal Kubecek wrote:
> On Mon, May 13, 2019 at 08:06:37PM +0800, Weilong Chen wrote:
>> On 2019/5/13 19:49, Michal Kubecek wrote:
>>> One idea is that there may be applications using current time as a seed
>>> for random number generator - but then such application is the real
>>> problem, not having correct time.
>>>
>> Yes, the target computer responded to an ICMP timestamp request. By
>> accurately determining the target's clock state, an attacker can more
>> effectively attack certain time-based pseudorandom number generators (PRNGs)
>> and the authentication systems that rely on them.
>>
>> So, the 'time' may become sensitive information. The OS should not leak it
>> out.
>
> So you are effectively saying that having correct time is a security
> vulnerability?
No, I mean that a server should not provide time to others if not necessary.

>
> I'm sorry but I cannot agree with that. Seeding PRNG with current time
> is known to be a bad practice and if some application does it, the
> solution is to fix the application, not obfuscating system time.
>
As I said, users can use Firewall to achieve the purpose. This patch 
just provide a simple way.

I can resubmit this patch and set default to 1, preserving current 
behaviour by default. Does that OK for you?

> Michal Kubecek
>
> .
>

