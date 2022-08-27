Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEBB5A3421
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 05:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243146AbiH0DRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 23:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345100AbiH0DQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 23:16:58 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2179180019;
        Fri, 26 Aug 2022 20:16:56 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MF1zM589VzGpHJ;
        Sat, 27 Aug 2022 11:15:11 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 27 Aug 2022 11:16:54 +0800
Message-ID: <3bee0773-dc81-79b8-bddd-852141e3258c@huawei.com>
Date:   Sat, 27 Aug 2022 11:16:53 +0800
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
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220826194052.7978b101@kernel.org>
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

On 2022/8/27 10:40, Jakub Kicinski wrote:
> On Thu, 25 Aug 2022 11:29:40 +0800 Zhengchao Shao wrote:
>> According to the description, "other" should be added when calling
>> qdisc_drop() to discard packets.
> 
> The fact that an old copy & pasted comment says something is not
> in itself a sufficient justification to make code changes.
> 
> qdisc_drop() already counts drops, duplicating the same information
> in another place seems like a waste of CPU cycles.

Hi Jakub:
	Thank you for your reply. It seems more appropriate to delete the other 
variable, if it is unused?

Zhengchao Shao
