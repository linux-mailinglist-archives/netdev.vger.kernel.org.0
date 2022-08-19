Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935F059942B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 06:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346271AbiHSEVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 00:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346264AbiHSEVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 00:21:21 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ACADB07B;
        Thu, 18 Aug 2022 21:21:20 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4M87nW69sMzGpfJ;
        Fri, 19 Aug 2022 12:19:43 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 19 Aug 2022 12:21:17 +0800
Message-ID: <0ba453c4-6baa-7915-cf22-5953556e5b13@huawei.com>
Date:   Fri, 19 Aug 2022 12:21:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next] net: sched: remove duplicate check of user
 rights in qdisc
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20220818072500.278410-1-shaozhengchao@huawei.com>
 <20220818204408.3fcb12a0@kernel.org>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20220818204408.3fcb12a0@kernel.org>
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



On 2022/8/19 11:44, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 15:25:00 +0800 Zhengchao Shao wrote:
>> -	if ((n->nlmsg_type != RTM_GETACTION) &&
>> -	    !netlink_capable(skb, CAP_NET_ADMIN))
>> -		return -EPERM;
> 
> This check is not network namespace capable, right?
> 
> We're probably fine making it namespace aware but it needs to be a
> separate change.

Hi Jakub:
	Thank you for your reply. I will add the wrong deletion back in V2. And 
I will also consider to make checking namespace aware in action function.

Zhengchao Shao
