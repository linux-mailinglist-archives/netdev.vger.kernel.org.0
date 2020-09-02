Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F121925A2B3
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 03:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgIBBoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 21:44:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55306 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbgIBBna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 21:43:30 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 54D2D8F0A8BC2F0A7D01;
        Wed,  2 Sep 2020 09:43:28 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Wed, 2 Sep 2020 09:43:22 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     David Miller <davem@davemloft.net>
CC:     <eric.dumazet@gmail.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <john.fastabend@gmail.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <2d93706f-3ba6-128b-738a-b063216eba6d@gmail.com>
 <2b60e7fd-a86a-89ab-2759-e7a83e0e28cd@huawei.com>
 <20200901.113445.1511774749622784918.davem@davemloft.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <70ac88f4-1c35-380d-591e-a5c81eaa2dab@huawei.com>
Date:   Wed, 2 Sep 2020 09:43:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20200901.113445.1511774749622784918.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/2 2:34, David Miller wrote:
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Tue, 1 Sep 2020 15:27:44 +0800
> 
>> On 2020/9/1 14:48, Eric Dumazet wrote:
>>> We request Fixes: tag for fixes in networking land.
>>
>> ok.
>>
>> Fixes: 6b3ba9146fe6 ("net: sched: allow qdiscs to handle locking")
> 
> You should repost the patch with the Fixes: tag in order to add it, you
> can't just mention it in this thread.
> 
> And the patch has to change anyways as you were also given other
> feedback from Eric to address as well.

Yes, thanks for the feedback:)

> 
> Thank you.
> .
> 
