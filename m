Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CAF63FE63
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiLBCyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiLBCyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:54:05 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55649D7574;
        Thu,  1 Dec 2022 18:54:04 -0800 (PST)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNcrZ3xMKz6855h;
        Fri,  2 Dec 2022 10:50:54 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 03:54:02 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 02:54:01 +0000
Message-ID: <f1a93695-d9d8-a25b-72c6-2a4476807350@huawei.com>
Date:   Fri, 2 Dec 2022 05:54:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 07/12] landlock: Add network rules support
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>,
        Linux API <linux-api@vger.kernel.org>,
        "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-8-konstantin.meskhidze@huawei.com>
 <49391484-7401-e7c7-d909-3bd6bd024731@digikod.net>
 <ec43e2a7-72b7-54d2-4e8f-0e6553419a9a@huawei.com>
 <53a55630-c4db-a79d-7be5-dc6026f92673@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <53a55630-c4db-a79d-7be5-dc6026f92673@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
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
> On 28/11/2022 05:01, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/17/2022 9:43 PM, Mickaël Salaün пишет:
>>>
>>> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>>>> This commit adds network rules support in internal landlock functions
>>>> (presented in ruleset.c) and landlock_create_ruleset syscall.
>>>
>>> …in the ruleset management helpers and the landlock_create_ruleset syscall.
>>>
>>>
>>>> Refactors user space API to support network actions. Adds new network
>>>
>>> Refactor…
>>>
>>>> access flags, network rule and network attributes. Increments Landlock
>>>
>>> Increment…
>> 
>>     The commit's message will be fixed. Thank you!
>>>
>>>> ABI version.
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>> ---
>>>>
>>>> Changes since v7:
>>>> * Squashes commits.
>>>> * Increments ABI version to 4.
>>>> * Refactors commit message.
>>>> * Minor fixes.
>>>>
>>>> Changes since v6:
>>>> * Renames landlock_set_net_access_mask() to landlock_add_net_access_mask()
>>>>     because it OR values.
>>>> * Makes landlock_add_net_access_mask() more resilient incorrect values.
>>>> * Refactors landlock_get_net_access_mask().
>>>> * Renames LANDLOCK_MASK_SHIFT_NET to LANDLOCK_SHIFT_ACCESS_NET and use
>>>>     LANDLOCK_NUM_ACCESS_FS as value.
>>>> * Updates access_masks_t to u32 to support network access actions.
>>>> * Refactors landlock internal functions to support network actions with
>>>>     landlock_key/key_type/id types.
>>>>
>>>> Changes since v5:
>>>> * Gets rid of partial revert from landlock_add_rule
>>>> syscall.
>>>> * Formats code with clang-format-14.
>>>>
>>>> Changes since v4:
>>>> * Refactors landlock_create_ruleset() - splits ruleset and
>>>> masks checks.
>>>> * Refactors landlock_create_ruleset() and landlock mask
>>>> setters/getters to support two rule types.
>>>> * Refactors landlock_add_rule syscall add_rule_path_beneath
>>>> function by factoring out get_ruleset_from_fd() and
>>>> landlock_put_ruleset().
>>>>
>>>> Changes since v3:
>>>> * Splits commit.
>>>> * Adds network rule support for internal landlock functions.
>>>> * Adds set_mask and get_mask for network.
>>>> * Adds rb_root root_net_port.
>>>>
>>>> ---
>>>>    include/uapi/linux/landlock.h                | 49 ++++++++++++++
>>>>    security/landlock/limits.h                   |  6 +-
>>>>    security/landlock/ruleset.c                  | 55 ++++++++++++++--
>>>>    security/landlock/ruleset.h                  | 68 ++++++++++++++++----
>>>>    security/landlock/syscalls.c                 | 13 +++-
>>>>    tools/testing/selftests/landlock/base_test.c |  2 +-
>>>>    6 files changed, 170 insertions(+), 23 deletions(-)
>>>>
>>>> diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
>>>> index f3223f964691..096b683c6ff3 100644
>>>> --- a/include/uapi/linux/landlock.h
>>>> +++ b/include/uapi/linux/landlock.h
>>>> @@ -31,6 +31,13 @@ struct landlock_ruleset_attr {
>>>>    	 * this access right.
>>>>    	 */
>>>>    	__u64 handled_access_fs;
>>>> +
>>>> +	/**
>>>> +	 * @handled_access_net: Bitmask of actions (cf. `Network flags`_)
>>>> +	 * that is handled by this ruleset and should then be forbidden if no
>>>> +	 * rule explicitly allow them.
>>>> +	 */
>>>> +	__u64 handled_access_net;
>>>>    };
>>>>
>>>>    /*
>>>> @@ -54,6 +61,11 @@ enum landlock_rule_type {
>>>>    	 * landlock_path_beneath_attr .
>>>>    	 */
>>>>    	LANDLOCK_RULE_PATH_BENEATH = 1,
>>>> +	/**
>>>> +	 * @LANDLOCK_RULE_NET_SERVICE: Type of a &struct
>>>> +	 * landlock_net_service_attr .
>>>> +	 */
>>>> +	LANDLOCK_RULE_NET_SERVICE = 2,
>>>>    };
>>>>
>>>>    /**
>>>> @@ -79,6 +91,24 @@ struct landlock_path_beneath_attr {
>>>>    	 */
>>>>    } __attribute__((packed));
>>>>
>>>> +/**
>>>> + * struct landlock_net_service_attr - TCP subnet definition
>>>> + *
>>>> + * Argument of sys_landlock_add_rule().
>>>> + */
>>>> +struct landlock_net_service_attr {
>>>> +	/**
>>>> +	 * @allowed_access: Bitmask of allowed access network for services
>>>> +	 * (cf. `Network flags`_).
>>>> +	 */
>>>> +	__u64 allowed_access;
>>>> +	/**
>>>> +	 * @port: Network port.
>>>> +	 */
>>>> +	__u16 port;
>>>
>>>    From an UAPI point of view, I think the port field should be __be16, as
>>> for sockaddr_in->port and other network-related APIs. This will require
>>> some kernel changes to please sparse: make C=2 security/landlock/ must
>>> not print any warning.
>> 
>>     Is sparse a default checker?
> 
> You should be able to easily install it with your Linux distro.

  Ok. Thank you.
> .
