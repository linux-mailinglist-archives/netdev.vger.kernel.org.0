Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64B25A8A30
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 03:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiIABEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 21:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiIABEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 21:04:30 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0EFEE6A1;
        Wed, 31 Aug 2022 18:04:29 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MJ2p75M8TzHnZw;
        Thu,  1 Sep 2022 09:02:39 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 1 Sep 2022 09:04:27 +0800
Message-ID: <d6a29d21-5c90-ca6d-8060-56088882a776@huawei.com>
Date:   Thu, 1 Sep 2022 09:04:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net/sched: cls_api: remove redundant 0 check in
 tcf_qevent_init()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20220829071720.211589-1-shaozhengchao@huawei.com>
 <20220831123014.18456fa9@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220831123014.18456fa9@kernel.org>
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



On 2022/9/1 3:30, Jakub Kicinski wrote:
> On Mon, 29 Aug 2022 15:17:20 +0800 Zhengchao Shao wrote:
>> tcf_qevent_parse_block_index() has been checked the value of block_index.
> 
> Please rephrase this:
> 
>    tcf_qevent_parse_block_index() never returns a zero block_index.
> 
> Took me a while to figure out what you mean.
> 
>> Therefore, it is unnecessary to check the value of block_index in
>> tcf_qevent_init().

Hi Jakub:
	Thank you for your reply. I will send v2.

Zhengchao Shao
