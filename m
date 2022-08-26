Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869995A1E20
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbiHZBZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244408AbiHZBZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:25:54 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6193433407;
        Thu, 25 Aug 2022 18:25:52 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MDMYh5pnyzGpqS;
        Fri, 26 Aug 2022 09:24:08 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 09:25:46 +0800
Message-ID: <fdca3c8d-42f6-1f2a-5b03-eaf3c394297d@huawei.com>
Date:   Fri, 26 Aug 2022 09:25:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net: sched: tbf: don't call qdisc_put() while
 holding tree lock
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <vladbu@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220826011248.323922-1-shaozhengchao@huawei.com>
 <20220825181305.773c9e64@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220825181305.773c9e64@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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



On 2022/8/26 9:13, Jakub Kicinski wrote:
> On Fri, 26 Aug 2022 09:12:48 +0800 Zhengchao Shao wrote:
>> The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
>> call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
>> holding sch tree spinlock, which results sleeping-while-atomic BUG.
>>
>> Fixes: c266f64dbfa2 ("net: sched: protect block state with mutex")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> If it's a bug fix for a commit already in Linus's main tree it should
> come with [PATCH net] in the subject (i.e. without the -next).
> Please repost.

Hi Jakub:
	Thank you for your reply. I will repost this patch.

Zhangchao Shao
