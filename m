Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C96463FE4A
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiLBCs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiLBCs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:48:56 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0B9B275D;
        Thu,  1 Dec 2022 18:48:55 -0800 (PST)
Received: from frapeml100004.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNcnh3fxZz684cK;
        Fri,  2 Dec 2022 10:48:24 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 frapeml100004.china.huawei.com (7.182.85.167) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 03:48:53 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 02:48:52 +0000
Message-ID: <a615fe4e-d371-3314-95ae-ef79edb09811@huawei.com>
Date:   Fri, 2 Dec 2022 05:48:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 11/12] samples/landlock: Add network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-12-konstantin.meskhidze@huawei.com>
 <2ff97355-18ef-e539-b4c1-720cd83daf1d@digikod.net>
 <a25b23f5-ad58-8374-249e-84ec0177e74a@huawei.com>
 <3e799f21-85f9-1b1d-c65e-3f9c7e4708aa@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <3e799f21-85f9-1b1d-c65e-3f9c7e4708aa@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/28/2022 11:26 PM, Mickaël Salaün пишет:
> 
> On 28/11/2022 03:49, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/16/2022 5:25 PM, Mickaël Salaün пишет:
>>>
>>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>>> This commit adds network demo. It's possible to allow a sandboxer to
>>>> bind/connect to a list of particular ports restricting network
>>>> actions to the rest of ports.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
> 
> [...]
> 
>>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_BIND_TCP;
>>>> +	}
>>>> +	/* Removes connect access attribute if not supported by a user. */
>>>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>>>> +	if (!env_port_name) {
>>>> +		access_net_tcp &= ~LANDLOCK_ACCESS_NET_CONNECT_TCP;
>>>> +	}
>>>> +	ruleset_attr.handled_access_net &= access_net_tcp;
>>>
>>> There is no need for access_net_tcp.
>> 
>>     Do you mean to delete this var?
> 
> Yes

   Got it.
> .
