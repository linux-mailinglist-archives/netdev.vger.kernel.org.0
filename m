Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0749869640E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbjBNM6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:58:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbjBNM6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:58:07 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A97D171D;
        Tue, 14 Feb 2023 04:58:01 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4PGLmy4Qfpz6J9St;
        Tue, 14 Feb 2023 20:56:18 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Tue, 14 Feb 2023 12:57:58 +0000
Message-ID: <6d057ab4-8dfe-0977-d13a-323f05af38b8@huawei.com>
Date:   Tue, 14 Feb 2023 15:57:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v9 02/12] landlock: Allow filesystem layout changes for
 domains without such rule type
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-3-konstantin.meskhidze@huawei.com>
 <97ff3f0f-1704-3003-fe60-d7444579e0d7@digikod.net>
 <f60af74e-bfdc-8e4b-03dd-2355c648588a@huawei.com>
 <e4008258-aad3-02d2-86fa-9c8118dcbd9e@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <e4008258-aad3-02d2-86fa-9c8118dcbd9e@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/14/2023 3:07 PM, Mickaël Salaün пишет:
> 
> On 14/02/2023 09:51, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 2/10/2023 8:34 PM, Mickaël Salaün пишет:
>>> Hi Konstantin,
>>>
>>> I think this patch series is almost ready. Here is a first batch of
>>> review, I'll send more next week.
>>>
>>     Hi Mickaёl.
>>     thnaks for the review.
>> 
>>>
>>> I forgot to update the documentation. Can you please squash the
>>> following patch into this one?
>> 
>>     No problem. I will squash.
>>     Can I download this doc patch from your repo or I can use the diff below?
> 
> You can take the diff below.

   Ok. Will be done.
> 
>>>
>>>
>>> diff --git a/Documentation/userspace-api/landlock.rst
>>> b/Documentation/userspace-api/landlock.rst
>>> index 980558b879d6..fc2be89b423f 100644
>>> --- a/Documentation/userspace-api/landlock.rst
>>> +++ b/Documentation/userspace-api/landlock.rst
>>> @@ -416,9 +416,9 @@ Current limitations
>>>     Filesystem topology modification
>>>     --------------------------------
>>>
>>> -As for file renaming and linking, a sandboxed thread cannot modify its
>>> -filesystem topology, whether via :manpage:`mount(2)` or
>>> -:manpage:`pivot_root(2)`.  However, :manpage:`chroot(2)` calls are not
>>> denied.
>>> +Threads sandboxed with filesystem restrictions cannot modify filesystem
>>> +topology, whether via :manpage:`mount(2)` or :manpage:`pivot_root(2)`.
>>> +However, :manpage:`chroot(2)` calls are not denied.
>>>
>>>     Special filesystems
>>>     -------------------
>>>
>>>
>>> On 16/01/2023 09:58, Konstantin Meskhidze wrote:
>>>> From: Mickaël Salaün <mic@digikod.net>
>>>>
>>>> Allow mount point and root directory changes when there is no filesystem
>>>> rule tied to the current Landlock domain.  This doesn't change anything
>>>> for now because a domain must have at least a (filesystem) rule, but
>>>> this will change when other rule types will come.  For instance, a
>>>> domain only restricting the network should have no impact on filesystem
>>>> restrictions.
>>>>
>>>> Add a new get_current_fs_domain() helper to quickly check filesystem
>>>> rule existence for all filesystem LSM hooks.
>>>>
>>>> Remove unnecessary inlining.
>>>>
>>>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>>>> ---
>>>>
>>>> Changes since v8:
>>>> * Refactors get_handled_fs_accesses().
>>>> * Adds landlock_get_raw_fs_access_mask() helper.
>>>>
>>> .
> .
