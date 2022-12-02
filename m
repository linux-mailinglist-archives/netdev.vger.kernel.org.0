Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5343163FE57
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiLBCvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiLBCvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:51:21 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD340B275D;
        Thu,  1 Dec 2022 18:51:19 -0800 (PST)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NNcnQ0Zdtz6855h;
        Fri,  2 Dec 2022 10:48:10 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Dec 2022 03:51:18 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 2 Dec 2022 02:51:17 +0000
Message-ID: <b53c6fe8-0c7a-ad99-5d43-49889d72c398@huawei.com>
Date:   Fri, 2 Dec 2022 05:51:16 +0300
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
 <1956e8c2-fd4c-898e-dd0f-22ad20a69740@huawei.com>
 <787e7546-25b9-4e32-6560-b6907cdd6401@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <787e7546-25b9-4e32-6560-b6907cdd6401@digikod.net>
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



11/28/2022 11:25 PM, Mickaël Salaün пишет:
> 
> On 28/11/2022 04:02, Konstantin Meskhidze (A) wrote:
>> 
>> 
>> 11/17/2022 9:55 PM, Mickaël Salaün пишет:
>>> Allow mount point and root directory changes when there is no filesystem
>>> rule tied to the current Landlock domain.  This doesn't change anything
>>> for now because a domain must have at least a (filesystem) rule, but
>>> this will change when other rule types will come.  For instance, a
>>> domain only restricting the network should have no impact on filesystem
>>> restrictions.
>>>
>>> Add a new get_current_fs_domain() helper to quickly check filesystem
>>> rule existence for all filesystem LSM hooks.
>> 
>>     Ok. I got it.
>>     Do I need also to add a new network helper:
>>     like landlock_get_raw_net_access_mask?
> 
> A get_raw helper would not be useful if there is not network access
> initially denied (like for FS_REFER).

  Ok.
> .
