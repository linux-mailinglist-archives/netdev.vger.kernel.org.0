Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBDDB4E66DD
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349304AbiCXQVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243598AbiCXQV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:21:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8589D5A0AC;
        Thu, 24 Mar 2022 09:19:55 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KPVk743BQz67xJk;
        Fri, 25 Mar 2022 00:17:35 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 24 Mar 2022 17:19:52 +0100
Message-ID: <9830cb55-d5c1-8ef7-349b-a0af247ad7b7@huawei.com>
Date:   Thu, 24 Mar 2022 19:19:50 +0300
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
 <b367c8c6-adfc-9ec1-a898-f9aa13815ca5@huawei.com>
 <59923702-3a1f-e018-c9b4-7a53f97b1791@digikod.net>
 <621efd5b-6f01-e616-8bb3-e8f0d31402a9@huawei.com>
 <3a33baf2-3de7-fecd-29d3-715500e3631f@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <3a33baf2-3de7-fecd-29d3-715500e3631f@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/24/2022 6:30 PM, Mickaël Salaün пишет:
> 
> 
> On 24/03/2022 14:34, Konstantin Meskhidze wrote:
>>
>>
>> 3/24/2022 3:27 PM, Mickaël Salaün пишет:
>>>
>>> On 23/03/2022 17:30, Konstantin Meskhidze wrote:
>>>>
>>>>
>>>> 3/17/2022 8:26 PM, Mickaël Salaün пишет:
>>>>>
>>>>> On 17/03/2022 14:01, Konstantin Meskhidze wrote:
>>>>>>
>>>>>>
>>>>>> 3/15/2022 8:02 PM, Mickaël Salaün пишет:
>>>>>>> Hi Konstantin,
>>>>>>>
>>>>>>> This series looks good! Thanks for the split in multiple patches.
>>>>>>>
>>>>>>   Thanks. I follow your recommendations.
>>>>>>>
>>>>>>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>>>>>>> Hi,
>>>>>>>> This is a new V4 bunch of RFC patches related to Landlock LSM 
>>>>>>>> network confinement.
>>>>>>>> It brings deep refactirong and commit splitting of previous 
>>>>>>>> version V3.
>>>>>>>> Also added additional selftests.
>>>>>>>>
>>>>>>>> This patch series can be applied on top of v5.17-rc3.
>>>>>>>>
>>>>>>>> All test were run in QEMU evironment and compiled with
>>>>>>>>   -static flag.
>>>>>>>>   1. network_test: 9/9 tests passed.
>>>>>>>
>>>>>>> I get a kernel warning running the network tests.
>>>>>>
>>>>>>    What kind of warning? Can you provide it please?
>>>>>
>>>>> You really need to get a setup that gives you such kernel warning. 
>>>>> When running network_test you should get:
>>>>> WARNING: CPU: 3 PID: 742 at security/landlock/ruleset.c:218 
>>>>> insert_rule+0x220/0x270
>>>>>
>>>>> Before sending new patches, please make sure you're able to catch 
>>>>> such issues.
>>>>>
>>>>>
>>>>>>>
>>>>>>>>   2. base_test: 8/8 tests passed.
>>>>>>>>   3. fs_test: 46/46 tests passed.
>>>>>>>>   4. ptrace_test: 4/8 tests passed.
>>>>>>>
>>>>>>> Does your test machine use Yama? That would explain the 4/8. You 
>>>>>>> can disable it with the appropriate sysctl.
>>>>>
>>>>> Can you answer this question?
>>>>>
>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> Tests were also launched for Landlock version without
>>>>>>>> v4 patch:
>>>>>>>>   1. base_test: 8/8 tests passed.
>>>>>>>>   2. fs_test: 46/46 tests passed.
>>>>>>>>   3. ptrace_test: 4/8 tests passed.
>>>>>>>>
>>>>>>>> Could not provide test coverage cause had problems with tests
>>>>>>>> on VM (no -static flag the tests compiling, no v4 patch applied):
>>>>>>>
>>>>     Hi, Mickaёl!
>>>>     I tried to get base test coverage without v4 patch applied.
>>>>
>>>>     1. Kernel configuration :
>>>>      - CONFIG_DEBUG_FS=y
>>>>      - CONFIG_GCOV_KERNEL=y
>>>>      - CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
>>>>     2. Added GCOV_PROFILE := y in security/landlock/Makefile
>>>
>>> I think this is useless because of 
>>> CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y. I don't add GCOV_PROFILE anyway.
>>>
>>>
>>>>     3. Compiled kernel  and rebooted VM with the new one.
>>>>     4. Run landlock selftests as root user:
>>>>      $ cd tools/testing/selftests/landlock
>>>>      $ ./base_test
>>>>      $ ./fs_test
>>>>      $ ./ptrace_test
>>>>     5. Copied GCOV data to some folder :
>>>>        $ cp -r 
>>>> /sys/kernel/debug/gcov/<source-dir>/linux/security/landlock/ 
>>>> /gcov-before
>>>>        $ cd /gcov-before
>>>>        $ lcov -c -d ./landlock -o lcov.info && genhtml -o html 
>>>> lcov.info
>>>
>>> I do this step on my host but that should work as long as you have 
>>> the kernel sources in the same directory. I guess this is not the 
>>> case. I think you also need GCC >= 4.8 .
>>>    I found the reason why .gcda files were not executed :
>>        "lcov -c -d ./landlock -o lcov.info && genhtml -o html 
>> lcov.info" was run not under ROOT user.
>>    Running lcov by ROOT one solved the issue. I will provide network test
>>    coverage in RFC patch V5.
>>    Thanks for help anyway.
> 
> I run lcov as a normal user with kernel source access.
> 
> I'll review the other patches soon. But for the next series, please 
> don't reuse "Landlock LSM" as a cover letter subject, something like 
> "Network support for Landlock" would fit better. ;)
> .
   No problem. Thanks.
