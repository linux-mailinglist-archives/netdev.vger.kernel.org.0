Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 322E113DCEF
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgAPOFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:05:38 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:39400 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbgAPOFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 09:05:37 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B880875E1D42EA3BBE23;
        Thu, 16 Jan 2020 22:05:35 +0800 (CST)
Received: from [127.0.0.1] (10.74.221.148) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 Jan 2020
 22:05:29 +0800
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     David Miller <davem@davemloft.net>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jinyuqi@huawei.com>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>,
        <guoyang2@huawei.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <f7043d29-44ee-ea28-8d7c-61b46876a162@hisilicon.com>
Date:   Thu, 16 Jan 2020 22:05:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.1.1
MIME-Version: 1.0
In-Reply-To: <20200116.042722.153124126288244814.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.221.148]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 2020/1/16 20:27, David Miller wrote:
> From: Shaokun Zhang <zhangshaokun@hisilicon.com>
> Date: Wed, 15 Jan 2020 11:23:40 +0800
> 
>> From: Yuqi Jin <jinyuqi@huawei.com>
>>
>> atomic_try_cmpxchg is called instead of atomic_cmpxchg that can reduce
>> the access number of the global variable @p_id in the loop. Let's
>> optimize it for performance.
>>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
>> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
>> Cc: Eric Dumazet <edumazet@google.com>
>> Cc: Yang Guo <guoyang2@huawei.com>
>> Signed-off-by: Yuqi Jin <jinyuqi@huawei.com>
>> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> I doubt this makes any measurable improvement in performance.
> 
> If you can document a specific measurable improvement under
> a useful set of circumstances for real usage, then put those
> details into the commit message and resubmit.

Ok, I will do it and resubmit.

Thanks your reply,
Shaokun

> 
> Otherwise, I'm not applying this, sorry.
> 
> .
> 

