Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772C850FAD2
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345543AbiDZKgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349039AbiDZKgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:36:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B93B7890D;
        Tue, 26 Apr 2022 03:17:17 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Knd6C69yQz68568;
        Tue, 26 Apr 2022 18:14:43 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 26 Apr 2022 12:17:13 +0200
Message-ID: <fbb03199-a953-90f0-451d-bce90b25c7fb@huawei.com>
Date:   Tue, 26 Apr 2022 13:17:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 07/15] landlock: user space API network support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-8-konstantin.meskhidze@huawei.com>
 <d4724117-167d-00b0-1f10-749b35bffc2f@digikod.net>
 <1b1c5aaa-9d9a-e38e-42b4-bb0509eba4b5@digikod.net>
 <6db0b12b-aeaa-12b6-bf50-33f138a52360@huawei.com>
 <dbe702e7-ee63-c665-a989-255b0c1212cc@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <dbe702e7-ee63-c665-a989-255b0c1212cc@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/12/2022 7:10 PM, Mickaël Salaün пишет:
> 
> On 12/04/2022 16:05, Konstantin Meskhidze wrote:
>>
>>
>> 4/12/2022 4:48 PM, Mickaël Salaün пишет:
>>>
>>> On 12/04/2022 13:21, Mickaël Salaün wrote:
>>>>
>>>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>>
>>> [...]
>>>
>>>>> @@ -184,7 +185,7 @@ SYSCALL_DEFINE3(landlock_create_ruleset,
>>>>>
>>>>>       /* Checks content (and 32-bits cast). */
>>>>>       if ((ruleset_attr.handled_access_fs | 
>>>>> LANDLOCK_MASK_ACCESS_FS) !=
>>>>> -            LANDLOCK_MASK_ACCESS_FS)
>>>>> +             LANDLOCK_MASK_ACCESS_FS)
>>>>
>>>> Don't add cosmetic changes. FYI, I'm relying on the way Vim does 
>>>> line cuts, which is mostly tabs. Please try to do the same.
>>>
>>> Well, let's make it simple and avoid tacit rules. I'll update most of 
>>> the existing Landlock code and tests to be formatted with 
>>> clang-format (-i *.[ch]), and I'll update the landlock-wip branch so 
>>> that you can base your next patch series on it. There should be some 
>>> exceptions that need customization but we'll see that in the next 
>>> series. Anyway, don't worry too much, just make sure you don't have 
>>> style-only changes in your patches.
>>
>>    I have already rebased my next patch series on your landlock-wip 
>> branch. So I will wait for your changes meanwhile refactoring my v5 
>> patch series according your comments.
> 
> Good.
> 
>>
>> Also I want to discuss adding demo in sandboxer.c to show how landlock
>> supports network sandboxing:
>>
>>      - Add additional args like "LL_NET_BIND=port1:...:portN"
>>      - Add additional args like "LL_NET_CONNECT=port1:...:portN"
>>      - execv 2 bash procceses:
>>          1. first bash listens in loop - $ nc -l -k -p <port1> -v
>>          2. second bash to connects the first one - $ nc <ip> <port>
>>
>> What do you think? its possible to present this demo in the next v5 
>> patch series.
> 
> This looks good! I think LL_TCP_BIND and LL_TCP_CONNECT would fit better 
> though.
>   Got it. Thanks
> I'm not sure if I already said that, but please remove the "RFC " part 
> for the next series.
   Ok.
> .
