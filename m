Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7076F656699
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 02:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbiL0Brm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 20:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiL0Brl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 20:47:41 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E74CE9;
        Mon, 26 Dec 2022 17:47:38 -0800 (PST)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NgyCx1wsZz68Bmq;
        Tue, 27 Dec 2022 09:45:49 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 27 Dec 2022 01:47:35 +0000
Message-ID: <8fc20400-800b-4924-c1a4-7ae50fbf18b6@huawei.com>
Date:   Tue, 27 Dec 2022 04:47:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] landlock: Allow filesystem layout changes for domains
 without such rule type
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <artem.kuzin@huawei.com>, <gnoack3000@gmail.com>,
        <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>
References: <5c6c99f7-4218-1f79-477e-5d943c9809fd@digikod.net>
 <20221117185509.702361-1-mic@digikod.net>
 <fb9a288a-aa86-9192-e6d7-d6678d740297@digikod.net>
 <4b23de18-2ae9-e7e3-52a3-53151e8802f9@huawei.com>
 <fd4c0396-af56-732b-808b-887c150e5e6b@digikod.net>
 <dc0de995-00dc-9dd7-a783-f57b2c274cb2@huawei.com>
 <6a1c9471-6fb3-792d-1e9b-d78884162ef5@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <6a1c9471-6fb3-792d-1e9b-d78884162ef5@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



12/27/2022 12:24 AM, Mickaël Salaün пишет:
> 
> 
> On 24/12/2022 04:10, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/28/2022 11:23 PM, Mickaël Salaün пишет:
>>>
>>> On 28/11/2022 04:04, Konstantin Meskhidze (A) wrote:
>>>>
>>>>
>>>> 11/18/2022 12:16 PM, Mickaël Salaün пишет:
>>>>> Konstantin, this patch should apply cleanly just after "01/12 landlock:
>>>>> Make ruleset's access masks more generic". You can easily get this patch
>>>>> with https://git.kernel.org/pub/scm/utils/b4/b4.git/
>>>>> Some adjustments are needed for the following patches. Feel free to
>>>>> review this patch.
>>>        Do you have this patch online? Can I fetch it from your repo?
>>>
>>> You can cherry-pick from here: https://git.kernel.org/mic/c/439ea2d31e662
>> 
>> Hi Mickaёl.
>> 
>> Sorry for the delay. I was a bit busy with another task. Now I'm
>> preparing a new patch.
>> 
>> I tried to apply your one but I got an error opening this the link : Bad
>> object id: 439ea2d31e662.
>> 
>> Could please check it?
> 
> Try this link:
> https://git.kernel.org/mic/c/439ea2d31e662e586db659a9f01b7dd55848c035
> I pushed it to the landlock-net-v8.1 branch.

   Thank you so much!!
> .
