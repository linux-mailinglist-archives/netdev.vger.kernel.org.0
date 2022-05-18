Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE8B52B61E
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 11:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiERJQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 05:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiERJQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 05:16:09 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AFB12760;
        Wed, 18 May 2022 02:16:06 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L36ht4KJsz6H8WV;
        Wed, 18 May 2022 17:13:02 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 18 May 2022 11:16:03 +0200
Message-ID: <b88a7c31-2fcc-b750-c48c-360948655777@huawei.com>
Date:   Wed, 18 May 2022 12:16:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 01/15] landlock: access mask renaming
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-2-konstantin.meskhidze@huawei.com>
 <a6300c07-87f5-21a4-8998-facbecd63787@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <a6300c07-87f5-21a4-8998-facbecd63787@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/17/2022 11:12 AM, Mickaël Salaün пишет:
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> Currently Landlock supports filesystem
>> restrictions. To support network type rules,
>> this modification extends and renames
>> ruleset's access masks.
>> This patch adds filesystem helper functions
>> to set and get filesystem mask. Also the modification
>> adds a helper structure landlock_access_mask to
>> support managing multiple access mask.
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
> 
> [...]
> 
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index d43231b783e4..f27a79624962 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -20,6 +20,7 @@
>>   #include "object.h"
>>
>>   typedef u16 access_mask_t;
>> +
>>   /* Makes sure all filesystem access rights can be stored. */
> 
> Please don't add whitespaces.

  Ok. Sorry for silly mistakes. I will fix it.
> .
