Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB566ACC39
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjCFSPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjCFSOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:14:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2636618A2;
        Mon,  6 Mar 2023 10:14:09 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PVmsF0n1dz6J7MV;
        Tue,  7 Mar 2023 02:13:05 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 18:13:30 +0000
Message-ID: <562fbb68-936c-ca1d-ef4c-b94610a65ef9@huawei.com>
Date:   Mon, 6 Mar 2023 21:13:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 10/12] selftests/landlock: Add 10 new test suites
 dedicated to network
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-11-konstantin.meskhidze@huawei.com>
 <fa306757-2040-415b-99a7-ba40c100638a@digikod.net>
 <b324a6bc-0b0f-c299-72b9-903eede187e8@huawei.com>
 <0efdc745-2365-a8c2-43cb-ef3608586481@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <0efdc745-2365-a8c2-43cb-ef3608586481@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/6/2023 7:00 PM, Mickaël Salaün пишет:
> 
> On 06/03/2023 13:03, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 2/21/2023 9:05 PM, Mickaël Salaün пишет:
>>>
>>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>>> These test suites try to check edge cases for TCP sockets
>>>> bind() and connect() actions.
>>>>
>>>> socket:
>>>> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>>> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>>> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
>>>> for bind action with AF_UNSPEC socket family.
>>>> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
>>>> for connect action with AF_UNSPEC socket family.
>>>> * ruleset_overlap: Tests with overlapping rules for one port.
>>>> * ruleset_expanding: Tests with expanding rulesets in which rules are
>>>> gradually added one by one, restricting sockets' connections.
>>>> * inval: Tests with invalid user space supplied data:
>>>>       - out of range ruleset attribute;
>>>>       - unhandled allowed access;
>>>>       - zero port value;
>>>>       - zero access value;
>>>>       - legitimate access values;
>>>> * bind_connect_inval_addrlen: Tests with invalid address length
>>>> for ipv4/ipv6 sockets.
>>>> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets.
>>>>
>>>> layout1:
>>>> * with_net: Tests with network bind() socket action within
>>>> filesystem directory access test.
>>>>
>>>> Test coverage for security/landlock is 94.1% of 946 lines according
>>>> to gcc/gcov-11.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v8:
>>>> * Adds is_sandboxed const for FIXTURE_VARIANT(socket).
>>>> * Refactors AF_UNSPEC tests.
>>>> * Adds address length checking tests.
>>>> * Convert ports in all tests to __be16.
>>>> * Adds invalid port values tests.
>>>> * Minor fixes.
>>>>
>>>> Changes since v7:
>>>> * Squashes all selftest commits.
>>>> * Adds fs test with network bind() socket action.
>>>> * Minor fixes.
>>>>
>>>> ---
>>>>    tools/testing/selftests/landlock/config     |    4 +
>>>>    tools/testing/selftests/landlock/fs_test.c  |   65 ++
>>>>    tools/testing/selftests/landlock/net_test.c | 1157 +++++++++++++++++++
>>>>    3 files changed, 1226 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>>
>>>> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
>>>> index 0f0a65287bac..71f7e9a8a64c 100644
>>>> --- a/tools/testing/selftests/landlock/config
>>>> +++ b/tools/testing/selftests/landlock/config
> 
> [...]
> 
>>>> +static int bind_variant(const struct _fixture_variant_socket *const variant,
>>>> +			const int sockfd,
>>>> +			const struct _test_data_socket *const self,
>>>> +			const size_t index, const bool zero_size)
>>>> +
>>>
>>> Extra new line.
>> 
>>    Will be deleted. Thanks. >>
>>>> +{
>>>> +	if (variant->is_ipv4)
>>>> +		return bind(sockfd, &self->addr4[index],
>>>> +			    (zero_size ? 0 : sizeof(self->addr4[index])));
>>>
>>> Is the zero_size really useful? Do calling bind and connect with this
>>> argument reaches the Landlock code (check_addrlen) or is it caught by
>>> the network code beforehand?
>> 
>>     In __sys_bind() syscall security_socket_bind() function goes before
>>     sock->ops->bind() method. Selinux and Smacks provide such checks in
>>     bind()/connect() hooks, so I think Landlock should do the same.
>>     What do you think?
> 
> Yes, we should keep these checks. However, we should have a
> bind_variant() without the zero_size argument because it is only set to
> true once (in bind_connect_inval_addrlen). You can explicitly call
> bind() with a zero size in bind_connect_inval_addrlen().
> 
> Same for connect_variant().

  Ok. Will be fixed.
> 
> 
>>>
>>>
>>>> +	else
>>>> +		return bind(sockfd, &self->addr6[index],
>>>> +			    (zero_size ? 0 : sizeof(self->addr6[index])));
>>>> +}
>>>> +
>>>> +static int connect_variant(const struct _fixture_variant_socket *const variant,
>>>> +			   const int sockfd,
>>>> +			   const struct _test_data_socket *const self,
>>>> +			   const size_t index, const bool zero_size)
>>>> +{
>>>> +	if (variant->is_ipv4)
>>>> +		return connect(sockfd, &self->addr4[index],
>>>> +			       (zero_size ? 0 : sizeof(self->addr4[index])));
>>>> +	else
>>>> +		return connect(sockfd, &self->addr6[index],
>>>> +			       (zero_size ? 0 : sizeof(self->addr6[index])));
>>>> +}
> .
