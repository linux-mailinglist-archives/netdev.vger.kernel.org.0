Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7325A6267
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiH3LtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiH3LtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:49:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF57A924B;
        Tue, 30 Aug 2022 04:49:06 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MH57s5gXjzYcpF;
        Tue, 30 Aug 2022 19:44:41 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 30 Aug 2022 19:49:04 +0800
Message-ID: <562e0cf1-17f0-3bbd-7304-334a7edcd21a@huawei.com>
Date:   Tue, 30 Aug 2022 19:49:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next 0/3] net: sched: add other statistics when
 calling qdisc_drop()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20220825032943.34778-1-shaozhengchao@huawei.com>
 <20220826194052.7978b101@kernel.org>
 <3bee0773-dc81-79b8-bddd-852141e3258c@huawei.com>
 <20220829214846.3fbb41b1@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220829214846.3fbb41b1@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/8/30 12:48, Jakub Kicinski wrote:
> On Sat, 27 Aug 2022 11:16:53 +0800 shaozhengchao wrote:
>> On 2022/8/27 10:40, Jakub Kicinski wrote:
>>> On Thu, 25 Aug 2022 11:29:40 +0800 Zhengchao Shao wrote:
>>>> According to the description, "other" should be added when calling
>>>> qdisc_drop() to discard packets.
>>>
>>> The fact that an old copy & pasted comment says something is not
>>> in itself a sufficient justification to make code changes.
>>>
>>> qdisc_drop() already counts drops, duplicating the same information
>>> in another place seems like a waste of CPU cycles.
>>
>> Hi Jakub:
>> 	Thank you for your reply. It seems more appropriate to delete the other
>> variable, if it is unused?
> 
> Yes, removing it SGTM.

Hi Jakub:
	Thank you. I have send v3.

Zhengchao Shao
