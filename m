Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD4D5281CB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiEPKWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242467AbiEPKWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:22:25 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25656DEF4;
        Mon, 16 May 2022 03:22:09 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L1wKT0QDXz67Zm5;
        Mon, 16 May 2022 18:22:05 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 16 May 2022 12:22:06 +0200
Message-ID: <c263544e-2ed7-dda0-845a-65a3f3bcd184@huawei.com>
Date:   Mon, 16 May 2022 13:22:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
 <78882640-70ff-9610-1eda-5917550f0ab8@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <78882640-70ff-9610-1eda-5917550f0ab8@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/16/2022 1:10 PM, Mickaël Salaün пишет:
> 
> On 01/04/2022 18:52, Mickaël Salaün wrote:
>> You need to update tools/testing/selftests/landlock/config to enable 
>> CONFIG_NET and CONFIG_INET.
>>
>>
>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>> Adds two selftests for bind socket action.
>>> The one is with no landlock restrictions:
>>>      - bind_no_restrictions;
>>> The second one is with mixed landlock rules:
>>>      - bind_with_restrictions;
>>
>> Some typos (that propagated to all selftest patches):
>>
>> selftest/landlock: Add tests for bind hook
> 
> I did some typo myself, it should be "selftests/landlock:"
> .

   Thanks, cause I was ready to send a patch V5. I will fix it.
