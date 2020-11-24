Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0102C22F9
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732024AbgKXKbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:31:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8577 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731908AbgKXKbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:31:09 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CgKzj4d65zLsSS;
        Tue, 24 Nov 2020 18:30:41 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 18:30:57 +0800
Subject: Re: [PATCH net-next v2 1/2] lockdep: Introduce in_softirq lockdep
 assert
To:     Peter Zijlstra <peterz@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <mingo@redhat.com>, <will@kernel.org>, <viro@zeniv.linux.org.uk>,
        <kyk.segfault@gmail.com>, <davem@davemloft.net>,
        <linmiaohe@huawei.com>, <martin.varghese@nokia.com>,
        <pabeni@redhat.com>, <pshelar@ovn.org>, <fw@strlen.de>,
        <gnault@redhat.com>, <steffen.klassert@secunet.com>,
        <vladimir.oltean@nxp.com>, <edumazet@google.com>,
        <saeed@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1605927976-232804-1-git-send-email-linyunsheng@huawei.com>
 <1605927976-232804-2-git-send-email-linyunsheng@huawei.com>
 <20201123142725.GQ3021@hirez.programming.kicks-ass.net>
 <20201123121259.312dcb82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124081112.GF2414@hirez.programming.kicks-ass.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c85ba51b-0904-0376-7896-2eeb0d1b3d30@huawei.com>
Date:   Tue, 24 Nov 2020 18:30:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201124081112.GF2414@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/24 16:11, Peter Zijlstra wrote:
> On Mon, Nov 23, 2020 at 12:12:59PM -0800, Jakub Kicinski wrote:
>> One liner would be:
>>
>> 	* Acceptable for protecting per-CPU resources accessed from BH
>> 	
>> We can add:
>>
>> 	* Much like in_softirq() - semantics are ambiguous, use carefully. *
>>
>>
>> IIUC we basically want to protect the nc array and counter here:
> 
> Works for me, thanks!

Will add the above comment in v3.

Thanks.

> .
> 
