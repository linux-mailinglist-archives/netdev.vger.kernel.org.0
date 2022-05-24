Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C18E5325B0
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiEXIzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 04:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiEXIzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 04:55:48 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6826FD2C;
        Tue, 24 May 2022 01:55:47 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L6nyT6WKJz67bZ1;
        Tue, 24 May 2022 16:52:33 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Tue, 24 May 2022 10:55:43 +0200
Message-ID: <e83d9e6f-738f-a4b0-f556-8b162c5bd65d@huawei.com>
Date:   Tue, 24 May 2022 11:55:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 12/15] seltests/landlock: rules overlapping test
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-13-konstantin.meskhidze@huawei.com>
 <4806f5ed-41c0-f9f2-d7a1-2173c8494399@digikod.net>
 <09ab37e1-eba5-80be-8fb3-df2bde698fc6@huawei.com>
 <0958567e-cc91-f63f-402a-a6324a576da2@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <0958567e-cc91-f63f-402a-a6324a576da2@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/19/2022 6:04 PM, Mickaël Salaün пишет:
> 
> 
> On 19/05/2022 14:24, Konstantin Meskhidze wrote:
>>
>>
>> 5/16/2022 8:41 PM, Mickaël Salaün пишет:
> 
> [...]
> 
>>>> +
>>>> +    /* Makes connection to socket with port[0] */
>>>> +    ASSERT_EQ(0, connect(sockfd, (struct sockaddr *)&self->addr4[0],
>>>
>>> Can you please get rid of this (struct sockaddr *) type casting 
>>> please (without compiler warning)?
>>>
>>    Do you have a warning here? Cause I don't.
> 
> There is no warning but this kind of cast is useless.

   But addr4 is struct sockaddr_in type and connect/bind use struct 
sockaddr type. That's why casting is needed here.

> .
