Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C45F5FADDC
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 09:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiJKHzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 03:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJKHzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 03:55:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9319B40E2A;
        Tue, 11 Oct 2022 00:55:38 -0700 (PDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mmp3L6z7Sz67mY4;
        Tue, 11 Oct 2022 15:54:54 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 09:55:36 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 08:55:35 +0100
Message-ID: <4d97342e-0961-e691-40af-c007d02ea43c@huawei.com>
Date:   Tue, 11 Oct 2022 10:55:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 16/18] seltests/landlock: add invalid input data test
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-17-konstantin.meskhidze@huawei.com>
 <d91e3fcc-2320-e98c-7d54-458b749c87a8@digikod.net>
 <47ddb2ea-3bc7-533a-9b0d-2b2d3950644c@huawei.com>
 <36de86ad-460c-81d0-b5bd-4d54bd05d201@digikod.net>
 <b4b49d93-72a1-b7b4-68e4-2bd03034ee77@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <b4b49d93-72a1-b7b4-68e4-2bd03034ee77@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



10/10/2022 1:37 PM, Mickaël Salaün пишет:
> 
> On 12/09/2022 19:22, Mickaël Salaün wrote:
>> 
>> On 10/09/2022 22:51, Konstantin Meskhidze (A) wrote:
>>>
>>>
>>> 9/6/2022 11:09 AM, Mickaël Salaün пишет:
>>>>
>>>> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>>>>> This patch adds rules with invalid user space supplied data:
>>>>>        - out of range ruleset attribute;
>>>>>        - unhandled allowed access;
>>>>>        - zero port value;
>>>>>        - zero access value;
>>>>>
>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>> ---
>>>>>
>>>>> Changes since v6:
>>>>> * Adds invalid ruleset attribute test.
>>>>>
>>>>> Changes since v5:
>>>>> * Formats code with clang-format-14.
>>>>>
>>>>> Changes since v4:
>>>>> * Refactors code with self->port variable.
>>>>>
>>>>> Changes since v3:
>>>>> * Adds inval test.
>>>>>
>>>>> ---
>>>>>     tools/testing/selftests/landlock/net_test.c | 66 ++++++++++++++++++++-
>>>>>     1 file changed, 65 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>>>>> index a93224d1521b..067ba45f58a5 100644
>>>>> --- a/tools/testing/selftests/landlock/net_test.c
>>>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>>>> @@ -26,9 +26,12 @@
>>>>>
>>>>>     #define IP_ADDRESS "127.0.0.1"
>>>>>
>>>>> -/* Number pending connections queue to be hold */
>>>>> +/* Number pending connections queue to be hold. */
>>>>
>>>> Patch of a previous patch?
>>>>
>>>>
>>>>>     #define BACKLOG 10
>>>>>
>>>>> +/* Invalid attribute, out of landlock network access range. */
>>>>> +#define LANDLOCK_INVAL_ATTR 7
>>>>> +
>>>>>     FIXTURE(socket)
>>>>>     {
>>>>>     	uint port[MAX_SOCKET_NUM];
>>>>> @@ -719,4 +722,65 @@ TEST_F(socket, ruleset_expanding)
>>>>>     	/* Closes socket 1. */
>>>>>     	ASSERT_EQ(0, close(sockfd_1));
>>>>>     }
>>>>> +
>>>>> +TEST_F(socket, inval)
>>>>> +{
>>>>> +	struct landlock_ruleset_attr ruleset_attr = {
>>>>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP
>>>>> +	};
>>>>> +	struct landlock_ruleset_attr ruleset_attr_inval = {
>>>>> +		.handled_access_net = LANDLOCK_INVAL_ATTR
>>>>
>>>> Please add a test similar to TEST_F_FORK(layout1,
>>>> file_and_dir_access_rights) instead of explicitly defining and only
>>>> testing LANDLOCK_INVAL_ATTR.
>>>>
>>>      Do you want fs test to be in this commit or maybe its better to add
>>> it into "[PATCH v7 01/18] landlock: rename access mask" one.
> 
> Just to make it clear, I didn't suggested an FS test, but a new network
> test similar to layout1.file_and_dir_access_rights but only related to
> the network. It should replace/extend the content of this patch (16/18).
> 
  Ok. I will check out out "layout1.file_and_dir_access_rights" one.
But anyway we need some test like TEST_F_FORK(layout1, with_net) and
TEST_F_FORK(socket, with_fs) with mixed attributes as you suggested.

> 
>> 
>> You can squash all the new tests patches (except the "move helper
>> function").
> You should move most of your patch descriptions in a comment above the
> related tests. The commit message should list all the new tests and
> quickly explain which part of the kernel is covered (i.e. mostly the TCP
> part of Landlock). You can get some inspiration from
> https://git.kernel.org/mic/c/f4056b9266b571c63f30cda70c2d89f7b7e8bb7b
> 
> You need to rebase on top of my next branch (from today).

  Ok. Thank you. Sorry for the delay - I was under the snow with 
Business Trip to China preparings. So I've got out of 10 days quarantine 
now and continued working.
> .
