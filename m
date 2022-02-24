Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F263D4C2B63
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 13:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234320AbiBXMEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 07:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiBXMEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 07:04:14 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CE721EBB7;
        Thu, 24 Feb 2022 04:03:44 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K4BP83WsNz6H6q1;
        Thu, 24 Feb 2022 20:02:52 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 24 Feb 2022 13:03:41 +0100
Message-ID: <7a538eb0-00e6-7b15-8409-a09165f72049@huawei.com>
Date:   Thu, 24 Feb 2022 15:03:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 2/2] landlock: selftests for bind and connect hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-3-konstantin.meskhidze@huawei.com>
 <4d54e3a9-8a26-d393-3c81-b01389f76f09@digikod.net>
 <a95b208c-5377-cf5c-0b4d-ce6b4e4b1b05@huawei.com>
 <b29b2049-a61b-31a0-c4b5-fc0e55ad7bf1@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <b29b2049-a61b-31a0-c4b5-fc0e55ad7bf1@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/24/2022 12:55 PM, Mickaël Salaün пишет:
> 
> On 24/02/2022 04:18, Konstantin Meskhidze wrote:
>>
>>
>> 2/1/2022 9:31 PM, Mickaël Salaün пишет:
>>>
>>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>>> Support 4 tests for bind and connect networks actions:
>>>
>>> Good to see such tests!
>>>
>>>
>>>> 1. bind() a socket with no landlock restrictions.
>>>> 2. bind() sockets with landllock restrictions.
>>>
>>> You can leverage the FIXTURE_VARIANT helpers to factor out this kind 
>>> of tests (see ptrace_test.c).
>>>
>>>
>>>> 3. connect() a socket to listening one with no landlock restricitons.
>>>> 4. connect() sockets with landlock restrictions.
>>>
>>> Same here, you can factor out code. I guess you could create helpers 
>>> for client and server parts.
>>>
>>> We also need to test with IPv4, IPv6 and the AF_UNSPEC tricks.
>>>
>>> Please provide the kernel test coverage and explain why the uncovered 
>>> code cannot be covered: 
>>> https://www.kernel.org/doc/html/latest/dev-tools/gcov.html
>>
>>   Hi Mickaёl!
>>   Could you please provide the example of your test coverage build
>>   process? Cause as I undersatand there is no need to get coverage data
>>   for the entire kernel, just for landlock files.
> 
> You just need to follow the documentation:
> - start the VM with the kernel appropriately configured for coverage;
> - run all the Landlock tests;
> - gather the coverage and shutdown the VM;
> - use lcov and genhtml to create the web pages;
> - look at the coverage for security/landlock/
> 
    Thank you so much!

    One more questuoin - Is it possible to run Landlock tests in QEMU and
    and gather coverage info or I need to change kernel for the whole VM?
>>>
>>> You'll probably see that there are a multiple parts of the kernel 
>>> that are not covered. For instance, it is important to test different 
>>> combinations of layered network rules (see layout1/ruleset_overlap, 
>>> layer_rule_unions, non_overlapping_accesses, 
>>> interleaved_masked_accesses… in fs_test.c). Tests in fs_test.c are 
>>> more complex because handling file system rules is more complex, but 
>>> you can get some inspiration in it, especially the edge cases.
>>>
>>> We also need to test invalid user space supplied data (see 
>>> layout1/inval test in fs_test.c).
> .
