Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D2452CF53
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 11:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236046AbiESJYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 05:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbiESJYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 05:24:45 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292FAA8887;
        Thu, 19 May 2022 02:24:37 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L3krC3YZMz6H8W3;
        Thu, 19 May 2022 17:21:31 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 19 May 2022 11:24:34 +0200
Message-ID: <1271b7e4-9c53-253c-9239-80349b61b01d@huawei.com>
Date:   Thu, 19 May 2022 12:24:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 05/15] landlock: landlock_add_rule syscall refactoring
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-6-konstantin.meskhidze@huawei.com>
 <9456ccf3-e2b3-bb65-f24f-e6d2761120e5@digikod.net>
 <ed56f8a3-5469-2b62-ea29-1f7164b0638a@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <ed56f8a3-5469-2b62-ea29-1f7164b0638a@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/17/2022 11:10 AM, Mickaël Salaün пишет:
> 
> On 17/05/2022 10:04, Mickaël Salaün wrote:
>> You can rename the subject to "landlock: Refactor landlock_add_rule()"
>>
>>
>> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
> 
> [...]
> 
>>> helper was added to support current filesystem rules. It is called
>>> by the switch case.
>>
>> You can rephrase (all commit messages) in the present form:
> present *tense*

  Ok. I got it. Thanks.
>>
>> Refactor the landlock_add_rule() syscall to easily support for a new 
>> rule type in a following commit. The new add_rule_path_beneath() 
>> helper supports current filesystem rules.
> .
