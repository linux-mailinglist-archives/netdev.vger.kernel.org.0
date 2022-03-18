Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 227AD4DDD5B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238314AbiCRP5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233652AbiCRP5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:57:10 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731B091543;
        Fri, 18 Mar 2022 08:55:51 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KKpVl3qb7z6802C;
        Fri, 18 Mar 2022 23:54:55 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Fri, 18 Mar 2022 16:55:47 +0100
Message-ID: <27876286-b52a-d2e3-cd62-34bafeb990ba@huawei.com>
Date:   Fri, 18 Mar 2022 18:55:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 00/15] Landlock LSM
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <c9333349-5e05-de95-85da-f6a0cd836162@digikod.net>
 <29244d4d-70cc-9c4f-6d0f-e3ce3beb2623@huawei.com>
 <ef128eed-65a3-1617-d630-275f3cfa8220@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <ef128eed-65a3-1617-d630-275f3cfa8220@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/17/2022 8:26 PM, Mickaël Salaün пишет:
> 
> On 17/03/2022 14:01, Konstantin Meskhidze wrote:
>>
>>
>> 3/15/2022 8:02 PM, Mickaël Salaün пишет:
>>> Hi Konstantin,
>>>
>>> This series looks good! Thanks for the split in multiple patches.
>>>
>>   Thanks. I follow your recommendations.
>>>
>>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>>> Hi,
>>>> This is a new V4 bunch of RFC patches related to Landlock LSM 
>>>> network confinement.
>>>> It brings deep refactirong and commit splitting of previous version V3.
>>>> Also added additional selftests.
>>>>
>>>> This patch series can be applied on top of v5.17-rc3.
>>>>
>>>> All test were run in QEMU evironment and compiled with
>>>>   -static flag.
>>>>   1. network_test: 9/9 tests passed.
>>>
>>> I get a kernel warning running the network tests.
>>
>>    What kind of warning? Can you provide it please?
> 
> You really need to get a setup that gives you such kernel warning. When 
> running network_test you should get:
> WARNING: CPU: 3 PID: 742 at security/landlock/ruleset.c:218 
> insert_rule+0x220/0x270
> 
> Before sending new patches, please make sure you're able to catch such 
> issues.
> 
   Thanks. I will check it.
> 
>>>
>>>>   2. base_test: 8/8 tests passed.
>>>>   3. fs_test: 46/46 tests passed.
>>>>   4. ptrace_test: 4/8 tests passed.
>>>
>>> Does your test machine use Yama? That would explain the 4/8. You can 
>>> disable it with the appropriate sysctl.
> 
> Can you answer this question?

   Sorry. I missed it.
   I checked config - Yama is supported now. I will disable it.
   Thanks for advice.
> 
> 
>>>
>>>>
>>>> Tests were also launched for Landlock version without
>>>> v4 patch:
>>>>   1. base_test: 8/8 tests passed.
>>>>   2. fs_test: 46/46 tests passed.
>>>>   3. ptrace_test: 4/8 tests passed.
>>>>
>>>> Could not provide test coverage cause had problems with tests
>>>> on VM (no -static flag the tests compiling, no v4 patch applied):
>>>
>>> You can build statically-linked tests with:
>>> make -C tools/testing/selftests/landlock CFLAGS=-static
>>
>>   Ok. I will try. Thanks.
>>>
>>>> 1. base_test: 7/8 tests passed.
>>>>   Error:
>>>>   # Starting 8 tests from 1 test cases.
>>>>   #  RUN           global.inconsistent_attr ...
>>>>   # base_test.c:51:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>>>
>>> This looks like a bug in the syscall argument checks.
>>
>>    This bug I just get when don't use -static option. With -static 
>> base test passes 8/8.
> 
> Weird, I'd like to know what is the cause of this issue. What disto and 
> version do you use as host and guest VM? Do you have some warning when 
> compiling?
   I run tests on host Ubuntu 20.04.3 LTS, kernel version  v5.17. I will 
check more carefuly for compiling warnings.
> .
