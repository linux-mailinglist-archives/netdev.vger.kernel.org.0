Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D295B48C9
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 22:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiIJU3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 16:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIJU3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 16:29:41 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BABCDDEAA;
        Sat, 10 Sep 2022 13:29:39 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MQ4FY2R5Hz67J0f;
        Sun, 11 Sep 2022 04:28:49 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 22:29:37 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 10 Sep 2022 21:29:36 +0100
Message-ID: <e3f09e66-3eb8-96d0-3cfd-f4aa1d0f332c@huawei.com>
Date:   Sat, 10 Sep 2022 23:29:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v7 10/18] seltests/landlock: move helper function
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <anton.sirazetdinov@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-11-konstantin.meskhidze@huawei.com>
 <c4505758-3129-f6b9-f769-ea78c5ced4e3@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <c4505758-3129-f6b9-f769-ea78c5ced4e3@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



9/6/2022 11:09 AM, Mickaël Salaün пишет:
> Please be a bit more specific in the subject: "selftests/landlock: Share
> enforce_ruleset()"

   Ok. Thanks.
> 
> BTW, as I already said, you need to replace all your "seltests" with
> "selftests".

  My mistake. Its a silly typo. I will fix it.
> 
> 
> 
> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>> This commit moves enforce_ruleset() helper function to common.h so that
>> to be used both by filesystem tests and network ones.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v6:
>> * None.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Moves enforce_ruleset helper into common.h
>> * Formats code with clang-format-14.
>> 
>> ---
>>   tools/testing/selftests/landlock/common.h  | 10 ++++++++++
>>   tools/testing/selftests/landlock/fs_test.c | 10 ----------
>>   2 files changed, 10 insertions(+), 10 deletions(-)
>> 
>> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
>> index 7ba18eb23783..48870afb054b 100644
>> --- a/tools/testing/selftests/landlock/common.h
>> +++ b/tools/testing/selftests/landlock/common.h
>> @@ -187,3 +187,13 @@ clear_cap(struct __test_metadata *const _metadata, const cap_value_t caps)
>>   {
>>   	_effective_cap(_metadata, caps, CAP_CLEAR);
>>   }
>> +
>> +__attribute__((__unused__)) static void
>> +enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
>> +{
>> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> +	{
>> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> +	}
>> +}
>> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
>> index debe2d9ea6cf..25a655891754 100644
>> --- a/tools/testing/selftests/landlock/fs_test.c
>> +++ b/tools/testing/selftests/landlock/fs_test.c
>> @@ -556,16 +556,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>>   	return ruleset_fd;
>>   }
>> 
>> -static void enforce_ruleset(struct __test_metadata *const _metadata,
>> -			    const int ruleset_fd)
>> -{
>> -	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> -	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> -	{
>> -		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> -	}
>> -}
>> -
>>   TEST_F_FORK(layout1, proc_nsfs)
>>   {
>>   	const struct rule rules[] = {
>> --
>> 2.25.1
>> 
> .
