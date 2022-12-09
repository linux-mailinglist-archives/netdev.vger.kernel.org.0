Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC3F647FA0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLII5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLII5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:57:02 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FF318B12;
        Fri,  9 Dec 2022 00:57:00 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NT4Yf1MyQzJp7F;
        Fri,  9 Dec 2022 16:53:26 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 9 Dec
 2022 16:56:58 +0800
Subject: Re: [PATCH net-next] net: tso: inline tso_count_descs()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20221208024303.11191-1-linyunsheng@huawei.com>
 <20221208195721.698f68b6@kernel.org> <20221208195950.1efe71db@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1975e8d8-d41d-b887-621e-b7081869a4d5@huawei.com>
Date:   Fri, 9 Dec 2022 16:56:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20221208195950.1efe71db@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/9 11:59, Jakub Kicinski wrote:
> On Thu, 8 Dec 2022 19:57:21 -0800 Jakub Kicinski wrote:
>> On Thu, 8 Dec 2022 10:43:03 +0800 Yunsheng Lin wrote:
>>> tso_count_descs() is a small function doing simple calculation,
>>> and tso_count_descs() is used in fast path, so inline it to
>>> reduce the overhead of calls.  
>>
>> TSO frames are large, the overhead is fine.
>> I'm open to other opinions but I'd rather keep the code as is than
>> deal with the influx with similar sloppily automated changes.
> 
> Oh, wait, you're not one of the bot people. Sorry, please just address
> my comments and post a v2.
> 

Sure.
My job has shifted a little bit in huawei, and has not contributed to the
community much as used to be.
but I still look for similar pattern in the kernel when dealing with
problem, when there is some improvement to the related code, I will
contribute back:)

> .
> 
