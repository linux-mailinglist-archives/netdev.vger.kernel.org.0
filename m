Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4938595370
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbiHPHI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiHPHIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:08:43 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752092D0FF3;
        Mon, 15 Aug 2022 20:32:08 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M6Gr862HpzGpZM;
        Tue, 16 Aug 2022 11:30:32 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 16 Aug 2022 11:32:03 +0800
Message-ID: <694f07e3-d5ad-1bc5-1cdb-ae814b1a12f7@huawei.com>
Date:   Tue, 16 Aug 2022 11:32:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next,0/3] cleanup of qdisc offload function
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20220816020423.323820-1-shaozhengchao@huawei.com>
 <20220815201038.4321b77e@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220815201038.4321b77e@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/8/16 11:10, Jakub Kicinski wrote:
> On Tue, 16 Aug 2022 10:04:20 +0800 Zhengchao Shao wrote:
>> Some qdiscs don't care return value of qdisc offload function, so make
>> function void.
> 
> How many of these patches do you have? Is there a goal you're working
> towards? I don't think the pure return value removals are worth the
> noise. They don't even save LoC:
> 
>   3 files changed, 9 insertions(+), 9 deletions(-)
Hi Jakub.
	Thank you for your reply. Recently I've been studying the kernel code 
related to qdisc, and my goal is to understand how qdisc works. If the 
code can be optimized, I do what I can to modify the optimization. Is it 
more appropriate to add warning to the offload return value? I look 
forward to your reply. Thank you.

Zhengchao Shao
